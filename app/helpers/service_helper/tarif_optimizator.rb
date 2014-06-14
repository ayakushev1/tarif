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
    
    save_tarif_results(operator_index)
  end
  
  def save_tarif_results(operator_index)
    output = []
    output << { 
      :result => { 
        :operator_index => operator_index,
        :tarif_results => tarif_results,
        :tarif_results_ord => tarif_results_ord,
        :prev_service_call_ids => prev_service_call_ids,
        :max_tarif_slice => tarif_list_generator.max_tarif_slice[operator_index],
        :tarif_slices => tarif_list_generator.tarif_slices,      
      }#.to_json
    } 
#    raise(StandardError, [output[0][:result] ])#.join("\n\n") )
    Customer::Stat.delete_all
    Customer::Stat.transaction do
      Customer::Stat.create(output[0])
    end
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
          prev_service_call_ids[tarif_set_id][tarif_class_id].uniq!
          prev_service_call_ids[tarif_set_id][:ids] += prev_service_call_ids[tarif_set_id][tarif_class_id]
          prev_service_call_ids[tarif_set_id][:ids].uniq!
          dup = prev_service_call_ids[tarif_set_id][:ids] - prev_service_call_ids[tarif_set_id][:ids].uniq
          raise(StandardError, dup) if dup.count > 0
          
          tarif_results_ord[tarif_set_id][tarif_class_id][price_formula_order]['price_values'].each do |price_value|            
            category_group_id = price_value['service_category_group_id']
            raise(StandardError, [price_value.keys] ) unless category_group_id
            if category_group_id > -1
              prev_service_call_ids[tarif_set_id][:category_groups][category_group_id] ||= {}
              prev_service_call_ids[tarif_set_id][:category_groups][category_group_id]['call_ids'] ||= []
              prev_service_call_ids[tarif_set_id][:category_groups][category_group_id]['call_ids'] += (price_value['call_ids'] || [] )
              prev_service_call_ids[tarif_set_id][:category_groups][category_group_id]['call_ids'].uniq!
              stat_function_collector.service_stat[price_formula_order][:category_groups][:groups][category_group_id][:stat_params].each  do |stat_key, stat_function| 
                prev_service_call_ids[tarif_set_id][:category_groups][category_group_id][stat_key] ||= 0
                 stat.attributes["price_values"].each do |price_values_item|
                   prev_service_call_ids[tarif_set_id][:category_groups][category_group_id][stat_key] += price_values_item["all_stat"][stat_key] if price_values_item["all_stat"][stat_key]
                 end
              end if stat_function_collector.service_stat[price_formula_order][:category_groups][:groups][category_group_id][:stat_params]
            end
          end

#          raise(StandardError, [tarif_set_id, stat.attributes ]) if stat.attributes['service_category_tarif_class_id'] == nil 
#         raise(StandardError, [prev_service_call_ids].join("\n")) if price_formula_order == 0 and tarif_class_id == 283

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
        prev_service_call_ids[tarif_set_id] = {:category_groups => {}, :ids => []}

        if tarif_results[prev_tarif_set_id]
          tarif_results[prev_tarif_set_id].each do |key, prev_tarif_result| 
            tarif_results[tarif_set_id][key] = prev_tarif_result
            prev_service_call_ids[tarif_set_id][key] = (tarif_results[prev_tarif_set_id][key]['call_ids'] || [] )
            prev_service_call_ids[tarif_set_id][:ids] += prev_service_call_ids[tarif_set_id][key]
          end
          prev_service_call_ids[tarif_set_id][:category_groups] = (prev_service_call_ids[prev_tarif_set_id][:category_groups] || [])

          tarif_results_ord[prev_tarif_set_id].each do |key_ord, prev_tarif_results_ord_val|
            tarif_results_ord[tarif_set_id][key_ord] ||= {}
            prev_tarif_results_ord_val.each {|key, prev_tarif_result_ord| tarif_results_ord[tarif_set_id][key_ord][key] = prev_tarif_result_ord }
          end          
        end

#        raise(StandardError, [prev_service_call_ids ]) if service_id == 277 and tarif_set_id == '277_203_283' 
#        raise(StandardError, [tarif_set_id, prev_service_call_ids.keys, prev_service_call_ids[tarif_set_id] ]) if service_id == 276 and tarif_set_id == '276_277_293' 

        service_ids_to_calculate[:ids] << service_id
        service_ids_to_calculate[:set_ids] << tarif_set_id
      end
      i += 1
    end  if service_slices[slice_option][operator_index][service_slice_id]    
  end
  
  def calculate_service_list_sql(service_list, set_id_list = [], price_formula_order)
    i = -1
    sql = service_list.collect do |service_id| 
      i += 1 
      next if price_formula_order > (max_formula_order.max_order_by_service[service_id] )
      service_cost_sql(service_id, set_id_list[i], prev_service_call_ids[set_id_list[i]], price_formula_order) unless service_id.blank?
    end.compact.join(' union ')

    fields = [
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      '(price_values::json) as price_values',
      'set_id'
    ]
    
    if sql.blank?
      nil
    else
      sql = [
        "with service_cost_sql as (#{sql})",
        "select #{fields.join(', ')} from service_cost_sql",      
      ].join(' ') 
      "(#{sql})"      
    end

  end
  
  def service_cost_sql(service_id, set_id = nil, excluded_call_ids = [], price_formula_order)
#    raise(StandardError, [set_id, service_id, price_formula_order, excluded_call_ids]) if service_id == 276 and price_formula_order == 0 and !excluded_call_ids
    fields = [
      'tarif_class_id', 
      'json_agg(call_ids)::text as call_ids', 
      'sum(price_value) as price_value',
      'sum(call_id_count) as call_id_count',
      '(json_agg(row_to_json(service_categories_cost_sql_result)))::text as price_values',
      "'#{set_id || -1}' as set_id"
    ]
    
    service_categories_cost_sql_result = service_categories_cost_sql(service_id, set_id, excluded_call_ids, price_formula_order)
    
    sql = [
      "select #{fields.join(', ')} from",
      "(#{  service_categories_cost_sql_result  }) as service_categories_cost_sql_result",
      "group by tarif_class_id, set_id"
    ].join(' ') unless service_categories_cost_sql_result.blank?

#    raise(StandardError, [sql].join("\n") ) if set_id == '293'# and service_id == 203 and price_formula_order == 0
    "(#{sql})" if sql
  end
  
  def service_categories_cost_sql(service_id, set_id = nil, excluded_call_ids = [], price_formula_order)  
    result = []; result_2 = []; result_3 = [] 
    
    stat_function_collector.service_stat[price_formula_order][:category_groups][:services][service_id].each do |service_category_tarif_class_ids, stat_details_1|
      stat_details_1[:service_category_group_ids].each do |service_category_group_id|
        stat_details = stat_function_collector.service_stat[price_formula_order][:category_groups][:groups][service_category_group_id]

        service_category_tarif_class_ids = []
        group_tarif_class_ids = (stat_details[:service_category_tarif_class_ids_by_service_id].keys)
        group_tarif_class_ids = (stat_details[:service_category_tarif_class_ids_by_service_id].keys & set_id.split('_').collect{|i| i.to_i} )
        group_tarif_class_ids.each do |id|
          service_category_tarif_class_ids += (stat_details[:service_category_tarif_class_ids_by_service_id][id] + [])
        end
#        raise(StandardError, [service_category_tarif_class_ids, stat_details, 
#          stat_details[:service_category_tarif_class_ids_by_service_id].keys, set_id.split('_')]) if service_category_group_id == 55
        
        service_category_tarif_class_ids = [-1] if service_category_tarif_class_ids.blank?

        stat_details[:service_category_tarif_class_ids] = service_category_tarif_class_ids
        if price_formula_order < (max_formula_order.max_order_by_price_list[stat_details[:price_lists_id]] + 1)
          result << service_category_cost_sql(service_id, stat_details, set_id, excluded_call_ids, price_formula_order, group_tarif_class_ids)
        end
      end
    end if stat_function_collector.service_stat[price_formula_order] and stat_function_collector.service_stat[price_formula_order][:category_groups][:services][service_id]

    stat_function_collector.service_stat[price_formula_order][:categories][service_id].each do |stat_details_key, stat_details|
      if price_formula_order < (max_formula_order.max_order_by_price_list[stat_details[:price_lists_id]] + 1)        
        result << service_category_cost_sql(service_id, stat_details, set_id, excluded_call_ids, price_formula_order, [service_id])
      end
    end if stat_function_collector.service_stat[price_formula_order] and stat_function_collector.service_stat[price_formula_order][:categories][service_id]

    
#    raise(StandardError, [result_2.compact.join(' union '), nil, result_3.compact.join(' union ')])
    sql = result.compact.join(' union ')
    
    sql = [
      "with united_service_categories_cost_sql as (#{sql} )",
      "select *, all_stat::json as all_stat from united_service_categories_cost_sql"
     ].join(' ') if sql
     
#    raise(StandardError, [sql].join("\n") ) if service_id == 293 and price_formula_order == 0
    "(#{sql})" if sql    
    
  end
  
  def service_category_cost_sql(service_id, stat_details, set_id = nil, excluded_call_ids = [], price_formula_order, group_tarif_class_ids)
    set_ids_string = "'{#{service_id } }'" #"'{#{group_tarif_class_ids.join(', ') } }'" #.collect{|id| id.to_i}
    
    fields = if stat_details[:service_category_group_id] > -1
      ["sctc_2.tarif_class_id", "price_lists.service_category_group_id", "-1 as service_category_tarif_class_id", "service_category_groups.name as service_category_name"]
    else
      ["sctc_1.tarif_class_id", "-1 as service_category_group_id", 
        "case when sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} then sctc_1.id else sctc_3.id end as service_category_tarif_class_id",
        "case when sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} then sctc_1.name else sctc_3.name end as service_category_name",]
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
      service_category_accumulated_stat_sql(service_id, stat_details, stat_window_condition, set_id, excluded_call_ids, group_tarif_class_ids)
#      raise(StandardError, [stat_window_condition, stat_group_condition, stat_function_collector.price_formulas[stat_details[:price_formula_id]].formula['window_condition'] ])# if stat_details[:price_formula_id] == 2234
    else
      service_category_stat_sql(service_id, stat_details, stat_group_condition, set_id, excluded_call_ids)
    end
    
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
     "price_formulas.id = price_formula_id and ",
     "price_formulas.calculation_order = price_formula_calculation_order and",
     "price_lists.tarif_list_id is null and",
      "(",
     "(sctc_2.tarif_class_id = any(#{set_ids_string}) and sctc_2.as_standard_category_group_id = #{ stat_details[:service_category_group_id] } ) or",      
     "(sctc_1.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ stat_details[:service_category_tarif_class_ids][0]} ) or ",
     "(sctc_3.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_3.id = #{ stat_details[:service_category_tarif_class_ids][0]} )",
     ")",  
    ].join(' ')

#    raise(StandardError, [stat_details[:service_category_tarif_class_ids], excluded_call_ids, sql]) if stat_details[:service_category_tarif_class_ids].include?(1000) and 
#    service_id == 203 and stat_details[:service_category_group_id] == -1

#    raise(StandardError, [sql].join("\n") ) if stat_details[:service_category_group_id] == -1 and service_id == 283 and price_formula_order == 0

#    raise(StandardError, Customer::Call.find_by_sql(sql).first.attributes) if stat_details[:service_category_group_id] == 64 and service_id == 203
    
    "(#{sql})"
  end

  def service_category_stat_sql(service_id, stat_details, stat_condition, set_id = nil, excluded_call_ids = [])    
    stat_string = ["#{service_id} as tarif_class_id", 
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
      where.not(:id => excluded_call_ids[:ids]).
#      having(stat_condition).
      to_sql
  end

  def service_category_accumulated_stat_sql(service_id, stat_details, stat_condition, set_id = nil, excluded_call_ids = [], group_tarif_class_ids)    
    stat_string_1 = ["*", "array_agg(id) over w as group_call_ids"]
    stat_string_2 = ["*"]
    stat_string_3 = ["group_call_ids"]

    stat_details[:stat_params].each do |stat_key, stat_function| 
      prev_stat_fun_value = excluded_call_ids[:category_groups][stat_details[:service_category_group_id] ][stat_key] if excluded_call_ids[:category_groups][stat_details[:service_category_group_id] ]             
      stat_string_1 << "#{prev_stat_fun_value} as prev_#{stat_key}" if prev_stat_fun_value
      stat_string_1 << "#{stat_function} over w as current_#{stat_key}"

      if prev_stat_fun_value
        stat_string_2 << "current_#{stat_key} + prev_#{stat_key} as #{stat_key}"
      else
        stat_string_2 << "current_#{stat_key} as #{stat_key}" 
      end

      stat_string_3 << "#{stat_key}"
    end if stat_details[:stat_params]
    
    prev_group_call_ids = []
    prev_group_call_ids = excluded_call_ids[:category_groups][stat_details[:service_category_group_id] ]['call_ids'] if excluded_call_ids[:category_groups][stat_details[:service_category_group_id] ]
     
    sql_1 = Customer::Call.
      select("#{stat_string_1.join(', ')}").
      where(query_constructor.joined_tarif_classes_category_where_hash(stat_details[:service_category_tarif_class_ids])).
      where.not(:id => (excluded_call_ids[:ids] - prev_group_call_ids )).
      to_sql

    sql_1 = "#{sql_1} WINDOW w as ( order by (customer_calls.description->>'time')::timestamp )"
    sql_1 = [
      "with service_category_accumulated_ids_sql_1 as ( #{sql_1} ),",
      "service_category_accumulated_ids_sql_2 as (select #{stat_string_2.join(', ')} from service_category_accumulated_ids_sql_1 )",
      "select #{stat_string_3.join(', ')} from service_category_accumulated_ids_sql_2 where #{stat_condition} order by (description->>'time')::timestamp desc, id desc limit 1"
    ].join(' ')
       
    stat_string = ["#{service_id} as tarif_class_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id",
                   "#{stat_details[:price_formula_id]} as price_formula_id",
                   "#{stat_details[:price_formula_calculation_order]} as price_formula_calculation_order",
                   "array_agg(customer_calls.id) as call_ids",
                   "count(customer_calls.id) as call_id_count", 
                   ]

    stat_details[:stat_params].each {|stat_key, stat_function| stat_string << "#{stat_function} as #{stat_key}" } if stat_details[:stat_params] 
    stat_string = stat_string.join(', ')
    
#    raise(StandardError, [stat_details[:service_category_tarif_class_ids], excluded_call_ids ]) if stat_details[:service_category_group_id] == 71 and service_id == 203

    sql = [
      "with service_category_accumulated_stat_sql as ( #{sql_1} )",
      "select #{stat_string} from customer_calls, service_category_accumulated_stat_sql",
       "where customer_calls.id != all('{#{excluded_call_ids[:ids].join(', ')}}') and customer_calls.id = any(group_call_ids)",
    ].join(' ')
    
#  rescue
#    raise(StandardError, excluded_call_ids[:category_groups])
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
