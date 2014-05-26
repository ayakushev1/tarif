class ServiceHelper::TarifOptimizator
  attr_reader :tarif_list_generator, :stat_function_collector, :query_constructor, :tarif_option_results,
              :tarif_results, :prev_service_call_ids
  def initialize(options)
    self.extend Helper
    @fq_tarif_region_id = options[:user_region_id] || 1133    
    @tarif_list_generator = ServiceHelper::TarifListGenerator.new
    @tarif_option_results = {}
    @tarif_results = {}
    @prev_service_call_ids = {}
    
  end
  
  def calculate_all_operator_tarifs
    tarif_list_generator.operators.each_index { |operator_index| calculate_one_operator_tarifs(operator_index) }
  end
  
  def calculate_one_operator_tarifs(operator_index)
    init_input_for_one_operator_tarif_calculation(operator_index)    
    calculate_tarif_options_results(operator_index)    
    calculate_tarif_results(operator_index)
  end
  
  def init_input_for_one_operator_tarif_calculation(operator_index)
    @fq_tarif_operator_id = tarif_list_generator.operators[operator_index]
    @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services[operator_index])
    @query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_list_generator.all_services[operator_index]} )
  end
  
  def calculate_tarif_results(operator_index)
    set_initial_tarif_results(operator_index)
    service_ids_to_calculate = set_service_ids_to_calculate(operator_index)
    
    service_slice_id = 1
    while service_ids_to_calculate[:ids].count > 0
      sql = calculate_service_list_sql(service_ids_to_calculate[:ids], service_ids_to_calculate[:set_ids])
      Customer::Call.find_by_sql(sql).each do |stat| 
        tarif_class_id = stat.attributes['tarif_class_id'].to_s
        tarif_results[stat['set_id']][tarif_class_id] = stat.attributes
        tarif_results[stat['set_id']][tarif_class_id]['call_ids'] = flatten_call_ids_as_string(tarif_results[stat['set_id']][tarif_class_id]['call_ids'])
        tarif_results[stat['set_id']][:to_calculate] = false
      end unless sql.blank?
      set_next_tarif_results(operator_index, service_slice_id)
      service_ids_to_calculate = set_service_ids_to_calculate(operator_index)
      service_slice_id += 1
    end
  end
  
  def set_service_ids_to_calculate(operator_index)
    service_ids_to_calculate = {:ids => [], :set_ids => []}
    tarif_results.each do |key, tarif_result|
      if tarif_result[:to_calculate]
        service_ids_to_calculate[:ids] << tarif_result[:service_id_to_calculate]
        service_ids_to_calculate[:set_ids] << key
      end
    end
    service_ids_to_calculate
  end
  
  def set_next_tarif_results(operator_index, service_slice_id)
    i = 0
    tarif_list_generator.tarif_slices[operator_index][service_slice_id][:prev_ids].each do |prev_service_set|
      current_service_id = tarif_list_generator.tarif_slices[operator_index][service_slice_id][:ids][i].to_s
      tarif_set_id = tarif_list_generator.tarif_set_id(([current_service_id] + prev_service_set))
      prev_tarif_set_id = tarif_list_generator.tarif_set_id(prev_service_set).to_s
      last_prev_tarif_set_id = prev_service_set[0].to_s
      
      if tarif_set_id and !tarif_results[tarif_set_id]
        tarif_results[tarif_set_id] = {}

        prev_service_call_ids[tarif_set_id] = (prev_service_call_ids[prev_tarif_set_id] + tarif_results[prev_tarif_set_id][last_prev_tarif_set_id]['call_ids']).uniq
        
        tarif_results[prev_tarif_set_id].each {|key, prev_tarif_result| tarif_results[tarif_set_id][key] = prev_tarif_result }
        tarif_results[tarif_set_id][:to_calculate] = true
        tarif_results[tarif_set_id][:service_id_to_calculate] = current_service_id

      end
      i += 1
    end if tarif_list_generator.tarif_slices[operator_index][service_slice_id]
  end
  
  def set_initial_tarif_results(operator_index)
    i = 0
    tarif_list_generator.tarif_slices[operator_index][0][:prev_ids].each do |prev_service_set|
      current_service_id = tarif_list_generator.tarif_slices[operator_index][0][:ids][i].to_s
      tarif_set_id = tarif_list_generator.tarif_set_id(([current_service_id] + prev_service_set))
      if tarif_set_id and !tarif_results[tarif_set_id]
        tarif_results[tarif_set_id] = {}
        prev_service_call_ids[tarif_set_id] = []
        prev_service_set.compact.reverse.each do |tarif_option_id|
          raise( StandardError, tarif_option_id) unless tarif_option_results[tarif_option_id.to_s] 
          prev_service_call_ids[tarif_set_id] += tarif_option_results[tarif_option_id.to_s]['call_ids']
          prev_service_call_ids[tarif_set_id] = prev_service_call_ids[tarif_set_id].uniq
          tarif_results[tarif_set_id][tarif_option_id.to_s] = tarif_option_results[tarif_option_id.to_s]
        end
        tarif_results[tarif_set_id][:to_calculate] = true
        tarif_results[tarif_set_id][:service_id_to_calculate] = current_service_id
      end
      i += 1
    end
  end
  
  def calculate_tarif_options_results(operator_index)
    sql = calculate_service_list_sql(tarif_list_generator.all_tarif_options[operator_index])
    Customer::Call.find_by_sql(sql).collect do |stat| 
      tarif_option_results[stat['tarif_class_id'].to_s] = stat.attributes 
      tarif_option_results[stat['tarif_class_id'].to_s]['call_ids'] = flatten_call_ids_as_string( tarif_option_results[stat['tarif_class_id'].to_s]['call_ids'] ) 
    end unless sql.blank?
  end
  
  def calculate_service_list_sql(service_list, set_id_list = [])
    i = -1
    service_list.collect do |service_id| 
      i += 1 
      service_cost_sql(service_id, set_id_list[i], prev_service_call_ids[service_id.to_s]) if service_id
    end.join(' union ')  
  end
  
  def service_cost_sql(service_id, set_id = nil, excluded_call_ids = [])
    fields = ['tarif_class_id', 'json_agg(call_ids)::text as call_ids', 'sum(price_value) as price_value',
      'sum(call_id_count) as call_id_count',
      '(json_agg(row_to_json(service_categories_cost_sql)))::text as price_values',
      "'#{set_id || -1}' as set_id"
    ].join(', ')
    sql = [
      "select #{fields} from",
      "(#{service_categories_cost_sql(service_id, excluded_call_ids).join(' union ')}) as service_categories_cost_sql",
      "group by tarif_class_id, set_id"
    ].join(' ')
    "(#{sql})"
  end
  
  def service_categories_cost_sql(tarif_option_id, excluded_call_ids = [])    
    stat_function_collector.service_stat[tarif_option_id.to_s].collect do |stat_details|
      service_category_cost_sql(tarif_option_id, stat_details, excluded_call_ids)
    end if stat_function_collector.service_stat[tarif_option_id.to_s]
  end
  
  def service_category_cost_sql(tarif_option_id, stat_details, excluded_call_ids = [])
    fields = if stat_details[:service_category_group_id] > 0
      ["price_lists.service_category_group_id", "-1 as service_category_tarif_class_id"]
    else
      ["-1 as service_category_group_id", "price_lists.service_category_tarif_class_id"]
    end
    fields = (fields + [
      "price_lists.tarif_class_id", "call_ids", "call_id_count, price_formula_id",
      "#{ stat_function_collector.price_formula_string(stat_details[:price_formula_id]) } as price_value"      
    ]).join(', ')
    
    stat_condition = stat_function_collector.price_formula_condition(stat_details[:price_formula_id])
    
    stat_sql = if stat_condition
      service_category_accumulated_stat_sql(tarif_option_id, stat_details, stat_condition, excluded_call_ids)
    else
      service_category_stat_sql(tarif_option_id, stat_details, excluded_call_ids)
    end
    
    sql = [
     "with stat_sql as (#{ stat_sql })",
     "select #{fields}",
     "from stat_sql, price_formulas",
     "INNER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id",
     "INNER JOIN price_lists ON price_lists.id = price_formulas.price_list_id",
     "where",
     "price_lists.tarif_class_id = #{tarif_option_id} and",
     "( ( price_lists.tarif_list_id is null and",
     "price_lists.service_category_group_id = #{ stat_details[:service_category_group_id] } ) or",      
     "( price_lists.service_category_group_id is null and",
     "price_lists.service_category_tarif_class_id = #{ stat_details[:service_category_tarif_class_ids][0]} ) )",      
    ].join(' ')
    
    "(#{sql})"
  end

  def service_category_stat_sql(tarif_option_id, stat_details, excluded_call_ids = [])    
    stat_string = ["#{tarif_option_id} as tarif_option_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id", 
                   "#{stat_details[:price_formula_id]} as price_formula_id",
                   "array_agg(id) as call_ids",
                   "count(id) as call_id_count", 
                   ]
    stat_details[:stat_params].each do |stat_param|
      stat_param.each {|stat_key, stat_function| stat_string << "#{stat_function} as #{stat_key}" } if stat_details[:stat_params]
    end
    stat_string = stat_string.join(', ')
    
    Customer::Call.
      select(stat_string).
      where(query_constructor.joined_tarif_classes_category_where_hash(stat_details[:service_category_tarif_class_ids])).
      where.not(:id => excluded_call_ids).
      to_sql
  end

  def service_category_accumulated_stat_sql(tarif_option_id, stat_details, stat_condition, excluded_call_ids = [])    
    stat_string = ["#{tarif_option_id} as tarif_option_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id",
                   "#{stat_details[:price_formula_id]} as price_formula_id",
                   "array_agg(id) over w as call_ids",
                   "count(id) over w as call_id_count",
                   "*"
#                   "(description->>'time')::timestamp as service_time"
                   ]
    stat_details[:stat_params].each do |stat_param|      
      stat_param.each {|stat_key, stat_function| stat_string << "#{stat_function} over w as #{stat_key}" } if stat_details[:stat_params] 
    end
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
