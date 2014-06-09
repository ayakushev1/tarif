class ServiceHelper::TarifOptimizator
  attr_reader :tarif_list_generator, :stat_function_collector, :query_constructor, :max_formula_order,
              :tarif_results, :tarif_results_ord, :prev_service_call_ids, :service_slices, :operator_id
  attr_accessor :service_ids_to_calculate
  
  def initialize(options = {})
    self.extend Helper
    @fq_tarif_region_id = options[:user_region_id] || 1133    
    @tarif_list_generator = ServiceHelper::TarifListGenerator.new(options)
    @tarif_results_ord = {}
    @tarif_results = {}
    @prev_service_call_ids = {}
#    @service_ids_to_calculate = {:ids => [], :set_ids => []}
  end
  
  def calculate_all_operator_tarifs
    tarif_list_generator.operators.each_index { |operator_index| calculate_one_operator_tarifs(operator_index) }
  end
  
  def calculate_one_operator_tarifs(operator_index)
    init_input_for_one_operator_tarif_calculation(operator_index)    

    @service_slices = [tarif_list_generator.tarif_options_slices, tarif_list_generator.tarif_slices]
#    raise(StandardError, tarif_list_generator.tarif_slices)

    service_slices.each_index { |service_slice_index| calculate_tarif_results(operator_index, service_slice_index)}
  end
  
  def init_input_for_one_operator_tarif_calculation(operator_index)
    @fq_tarif_operator_id = tarif_list_generator.operators[operator_index]
    @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services[operator_index])
    @query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_list_generator.all_services[operator_index]} )
    @max_formula_order = ServiceHelper::MaxPriceFormulaOrderCollector.new(tarif_list_generator, operator_index)
    @operator_id = tarif_list_generator.operators[operator_index]
  end
  
  def calculate_tarif_results(operator_index, slice_option)
    service_slice_id = 0
    
    begin
      set_current_tarif_results(operator_index, service_slice_id, slice_option)

      (max_formula_order.max_order_by_operator + 1).times do |price_formula_order|
        sql = calculate_service_list_sql(service_ids_to_calculate[:ids], service_ids_to_calculate[:set_ids], price_formula_order)
        Customer::Call.find_by_sql(sql).each do |stat| 
          
          tarif_class_id = stat.attributes['tarif_class_id']
          tarif_set_id = stat['set_id']
          tarif_results_ord[tarif_set_id] ||= {}
          tarif_results_ord[tarif_set_id][tarif_class_id] ||= {}
          prev_service_call_ids[tarif_set_id][tarif_class_id] ||= [] 

          tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order] = stat.attributes
          tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['call_ids'] = 
            flatten_call_ids_as_string(tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['call_ids'])

          if price_formula_order == 0              
            tarif_results[tarif_set_id][tarif_class_id] = tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]            
          else
            tarif_results[tarif_set_id][tarif_class_id]['call_ids'] += tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['call_ids']
            tarif_results[tarif_set_id][tarif_class_id]['call_id_count'] += tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['call_id_count']
            tarif_results[tarif_set_id][tarif_class_id]['price_value'] += (tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['price_value'] || 0)             
          end
          
          prev_service_call_ids[tarif_set_id][tarif_class_id] += (tarif_results[tarif_set_id][tarif_class_id]['call_ids'] || [] )

        end unless sql.blank?
      end            
      service_slice_id += 1
    end while service_ids_to_calculate[:ids].count > 0
  end
  
  def set_current_tarif_results(operator_index, service_slice_id, slice_option)
    i = 0
    @service_ids_to_calculate = {:ids => [], :set_ids => []}
    
    service_slices[slice_option][operator_index][service_slice_id][:ids].each do |service_id|
      tarif_set_id = service_slices[slice_option][operator_index][service_slice_id][:set_ids][i]
      prev_tarif_set_id = service_slices[slice_option][operator_index][service_slice_id][:prev_set_ids][i]
      
      unless tarif_results[tarif_set_id]
        tarif_results[tarif_set_id] = {}
        tarif_results_ord[tarif_set_id] = {}
        prev_service_call_ids[tarif_set_id] = {}

        if tarif_results[prev_tarif_set_id]
          tarif_results[prev_tarif_set_id].each do |key, prev_tarif_result| 
            tarif_results[tarif_set_id][key] = prev_tarif_result
            prev_service_call_ids[tarif_set_id][key] = (tarif_results[prev_tarif_set_id][key]['call_ids'] || [] )
          end

          tarif_results_ord[prev_tarif_set_id].each do |key_ord, prev_tarif_results_ord_val|
            tarif_results_ord[tarif_set_id][key_ord] ||= {}
            prev_tarif_results_ord_val.each {|key, prev_tarif_result_ord| tarif_results_ord[tarif_set_id][key_ord][key] = prev_tarif_result_ord }
          end          
        end

#        raise(StandardError, [tarif_set_id, prev_service_call_ids.keys, prev_service_call_ids[tarif_set_id] ]) if service_id == 276 and tarif_set_id == '276_277_293' 

        service_ids_to_calculate[:ids] << service_id
        service_ids_to_calculate[:set_ids] << tarif_set_id
      end
      i += 1
    end  if service_slices[slice_option][operator_index][service_slice_id]    
  end
  
  def calculate_service_list_sql(service_list, set_id_list = [], price_formula_order)
    i = -1
    result = service_list.collect do |service_id| 
      i += 1 
      raise(StandardError, [service_id, max_formula_order.max_order_by_service]) unless max_formula_order.max_order_by_service[service_id]
      next if price_formula_order > (max_formula_order.max_order_by_service[service_id] )

      combined_prev_service_call_ids = []
      prev_service_call_ids[set_id_list[i]].each {|key, prev_service_call_ids_for_prev_service_id| combined_prev_service_call_ids +=  prev_service_call_ids_for_prev_service_id}

#TODO рассчитать combined_prev_service_call_ids заранее
#      raise(StandardError, [set_id_list[i], service_id, price_formula_order, prev_service_call_ids[set_id_list[i] ] ]) if service_id == 276 and price_formula_order == 0 and !prev_service_call_ids[set_id_list[i]][service_id]
      service_cost_sql(service_id, set_id_list[i], combined_prev_service_call_ids, price_formula_order) unless service_id.blank?
    end
    begin
      Customer::Call.find_by_sql(sql).first
    rescue
#      raise(StandardError, result.count)  
    end
     
    result.compact.join(' union ')  
  end
  
  def service_cost_sql(service_id, set_id = nil, excluded_call_ids = [], price_formula_order)
#    raise(StandardError, [set_id, service_id, price_formula_order, excluded_call_ids]) if service_id == 276 and price_formula_order == 0 and !excluded_call_ids
    fields = [
      'tarif_class_id', 
      'json_agg(call_ids)::text as call_ids', 
      'sum(price_value) as price_value',
      'sum(call_id_count) as call_id_count',
      '(json_agg(row_to_json(service_categories_cost_sql)))::text as price_values',
      "'#{set_id || -1}' as set_id"
    ]
    
    service_categories_cost_sql_result = service_categories_cost_sql(service_id, excluded_call_ids, price_formula_order)
    service_categories_cost_sql_result = service_categories_cost_sql_result.compact if service_categories_cost_sql_result
    
    sql = [
      "select #{fields.join(', ')} from",
      "(#{service_categories_cost_sql_result.compact.join(' union ')}) as service_categories_cost_sql",
      "group by tarif_class_id, set_id"
    ].join(' ') unless service_categories_cost_sql_result.blank?
    
    fields = [
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      '(price_values::json) as price_values',
      'set_id'
    ]
    
    sql = [
      "with service_cost_sql as (#{sql})",
      "select #{fields.join(', ')} from service_cost_sql",      
    ].join(' ') unless service_categories_cost_sql_result.blank?
    "(#{sql})" if sql
  end
  
  def service_categories_cost_sql(service_id, excluded_call_ids = [], price_formula_order)   
    stat_function_collector.service_stat[price_formula_order][service_id].collect do |stat_details|
      if price_formula_order < (max_formula_order.max_order_by_price_list[stat_details[:price_lists_id]] + 1)        
        service_category_cost_sql(service_id, stat_details, excluded_call_ids, price_formula_order)
      end
    end if stat_function_collector.service_stat[price_formula_order] and stat_function_collector.service_stat[price_formula_order][service_id]
  end
  
  def service_category_cost_sql(service_id, stat_details, excluded_call_ids = [], price_formula_order)
    
    fields = if stat_details[:service_category_group_id] > 0
      ["sctc_2.tarif_class_id", "price_lists.service_category_group_id", "-1 as service_category_tarif_class_id", "service_category_groups.name as service_category_name"]
    else
      ["sctc_1.tarif_class_id", "-1 as service_category_group_id", 
        "case when sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} then sctc_1.id else sctc_3.id end as service_category_tarif_class_id",
        "case when sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} then sctc_1.name else sctc_3.name end as service_category_name",]
#        "COALESCE(sctc_1.id, sctc_1.id) as service_category_tarif_class_id", "COALESCE(sctc_1.name, sctc_1.name) as service_category_name"]
    end
      
    fields = (fields + [       
      "call_ids", "call_id_count", 
      "price_formula_id", 
      "price_formula_calculation_order",
      "#{stat_function_collector.price_formula_string(stat_details[:price_formula_id])} as price_value",
      "#{price_formula_order} as price_formula_order",
      "row_to_json(stat_sql)::text as all_stat"      
    ]).join(', ')
    
    stat_window_condition = stat_function_collector.price_formula_window_condition(stat_details[:price_formula_id])
    stat_group_condition = stat_function_collector.price_formula_group_condition(stat_details[:price_formula_id])
    
    stat_sql = if stat_window_condition
      service_category_accumulated_stat_sql(service_id, stat_details, stat_window_condition, excluded_call_ids)
#      raise(StandardError, [stat_window_condition, stat_group_condition, stat_function_collector.price_formulas[stat_details[:price_formula_id]].formula['window_condition'] ])# if stat_details[:price_formula_id] == 2234
    else
      service_category_stat_sql(service_id, stat_details, stat_group_condition, excluded_call_ids)
    end
    
#    raise(StandardError, [stat_sql ]) if stat_details[:price_formula_id] == 2313
    
    sql = [
     "with stat_sql as (#{ stat_sql })",
     "select #{fields}",
     "from stat_sql, price_formulas",
     "LEFT OUTER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id",
     
     "LEFT OUTER JOIN price_lists ON price_lists.id = price_formulas.price_list_id",
     "LEFT OUTER JOIN service_category_tarif_classes sctc_1 ON sctc_1.id = price_lists.service_category_tarif_class_id",

     "LEFT OUTER JOIN service_category_tarif_classes sctc_3 ON sctc_3.as_tarif_class_service_category_id = sctc_1.id",

     "LEFT OUTER JOIN service_category_groups ON service_category_groups.id = price_lists.service_category_group_id",
     "LEFT OUTER JOIN service_category_tarif_classes sctc_2 ON sctc_2.as_standard_category_group_id = service_category_groups.id",

     "where",
     "(sctc_1.tarif_class_id = #{service_id} or sctc_2.tarif_class_id = #{service_id} or sctc_3.tarif_class_id = #{service_id} ) and ",
     "price_formulas.id = price_formula_id and ",
     "price_formulas.calculation_order = price_formula_calculation_order and",
     "price_lists.tarif_list_id is null and",
      "(",
#     "(service_category_groups.tarif_class_id is not null and sctc_2.as_standard_category_group_id = #{ stat_details[:service_category_group_id] } ) or",      
#     "(service_category_groups.tarif_class_id is null and sctc_2.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id = #{ stat_details[:service_category_group_id] } ) or",      
#     "(sctc_1.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} ) or ",
#     "(sctc_3.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_3.id = #{ stat_details[:service_category_tarif_class_ids][0]} )",
     "(sctc_2.as_standard_category_group_id = #{ stat_details[:service_category_group_id] } ) or",      
     "(sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} ) or ",
     "(sctc_2.as_standard_category_group_id is null and sctc_3.id = #{ stat_details[:service_category_tarif_class_ids][0]} )",
#     "(price_lists.service_category_group_id is null and sctc_3.id = #{ stat_details[:service_category_tarif_class_ids][0]} )",
     ")",  
#     "order by service_category_tarif_class_id, service_category_group_id"    
    ].join(' ')

#    raise(StandardError, sql) if stat_details[:service_category_group_id] > 0
    
    "(#{sql})"
  end

  def service_category_stat_sql(service_id, stat_details, stat_condition, excluded_call_ids = [])    
    stat_string = ["#{service_id} as service_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id", 
                   "#{stat_details[:price_formula_calculation_order]} as price_formula_calculation_order",
                   "#{stat_details[:price_formula_id]} as price_formula_id",
                   "array_agg(id) as call_ids",
                   "count(id) as call_id_count", 
                   ]

    stat_details[:stat_params].each {|stat_key, stat_function| stat_string << "#{stat_function} as #{stat_key}" } if stat_details[:stat_params]    
    stat_string = stat_string.join(', ')

    Customer::Call.
      select(stat_string).
      where(query_constructor.joined_tarif_classes_category_where_hash(stat_details[:service_category_tarif_class_ids])).
      where.not(:id => excluded_call_ids).
#      having(stat_condition).
      to_sql
  end

  def service_category_accumulated_stat_sql(service_id, stat_details, stat_condition, excluded_call_ids = [])    
    stat_string = ["#{service_id} as service_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id",
                   "#{stat_details[:price_formula_id]} as price_formula_id",
                   "#{stat_details[:price_formula_calculation_order]} as price_formula_calculation_order",
                   "array_agg(id) over w as call_ids",
                   "count(id) over w as call_id_count",
                   "*"
#                   "(description->>'time')::timestamp as service_time"
                   ]

    stat_details[:stat_params].each {|stat_key, stat_function| stat_string << "#{stat_function} over w as #{stat_key}" } if stat_details[:stat_params] 
    stat_string = stat_string.join(', ')
    
    sql = Customer::Call.
      select(stat_string).
      where(query_constructor.joined_tarif_classes_category_where_hash(stat_details[:service_category_tarif_class_ids])).
      where.not(:id => excluded_call_ids).
      to_sql

    sql = "#{sql} WINDOW w as ( order by (description->>'time')::timestamp )"
    [
      "with service_category_accumulated_stat_sql as ( #{sql} )",
      "select * from service_category_accumulated_stat_sql where #{stat_condition} order by (description->>'time')::timestamp desc, id desc limit 1"
    ].join(' ')
    
  end

  module Helper
    def array_of_hashes_to_hash(array_of_hashes, index_key)
      array_of_hashes.collect {|a| {a[index_key] => a } }
    end
  end

  def flatten_call_ids_as_string(call_ids_as_string)
    null = nil
    eval(call_ids_as_string).flatten.compact unless call_ids_as_string.blank?
  end
      
end
