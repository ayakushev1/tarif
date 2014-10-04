class ServiceHelper::TarifOptimizationSqlBuilder
  attr_reader :tarif_optimizator, :performance_checker, :options, :user_id, :accounting_period

  def initialize(tarif_optimizator, options = {})
    self.extend Helper
    @options = options
    @user_id = options[:user_id] || 0
    @accounting_period = options[:accounting_period]
    @tarif_optimizator = tarif_optimizator
#    raise(StandardError)
  end
  
# параметры из ServiceHelper::CurrentTarifOptimizationResults
  def tarif_results; current_tarif_optimization_results.tarif_results; end
  
  def prev_service_call_ids_by_parts; current_tarif_optimization_results.prev_service_call_ids_by_parts; end
  def calls_count_by_parts; tarif_optimizator.calls_count_by_parts; end
  def calculation_scope ; tarif_optimizator.calls_stat_calculator.calculation_scope; end
  
# optimization params from ServiceHelper::TarifOptimizator
  def check_sql_before_running; tarif_optimizator.check_sql_before_running; end
  def execute_additional_sql; tarif_optimizator.execute_additional_sql; end

# optimization classes from ServiceHelper::TarifOptimizator
  def current_tarif_optimization_results; tarif_optimizator.current_tarif_optimization_results; end
  def tarif_list_generator; tarif_optimizator.tarif_list_generator; end
  def stat_function_collector; tarif_optimizator.stat_function_collector; end
  def query_constructor; tarif_optimizator.query_constructor; end
  def max_formula_order_collector; tarif_optimizator.max_formula_order_collector; end
  def performance_checker; tarif_optimizator.performance_checker; end
  
  def calculate_service_part_sql(service_list, price_formula_order)
    sql = calculate_service_list_sql(service_list, price_formula_order) 

    fields = [
      'part', 
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      '(price_values::json) as price_values',
      'set_id'
    ]
    
    sql = "with calculate_service_list_sql as (#{sql}) select #{fields.join(', ')} from calculate_service_list_sql" unless sql.blank?

    check_sql(sql, price_formula_order)
    sql
  end
  
  def calculate_service_list_sql(service_list, price_formula_order)
    sql = service_list.collect do |service_list_item| 
      service_id = service_list_item[:ids]
      next if !service_id 
      part = service_list_item[:parts]
#    raise(StandardError, 1) if part == "own-country-rouming/calls"# and service_id == 276
      set_id = service_list_item[:set_ids]
      next if !max_formula_order_collector.max_order_by_service_and_part[part] or !max_formula_order_collector.max_order_by_service_and_part[part][service_id]
      next if price_formula_order > max_formula_order_collector.max_order_by_service_and_part[part][service_id]
      next if !tarif_list_generator.parts_by_service[service_id].include?(part)
      prev_call_ids_count = 0 
      tarif_results[set_id][part].each do |service_id_1, tarif_results_value |  
        prev_call_ids_count += tarif_results_value['call_id_count'] 
      end
      
#TODO подумать чтобы убрать !(calls_count_by_parts[part] == 0)
      if !(calls_count_by_parts[part] == 0) and prev_call_ids_count == calls_count_by_parts[part]
        empty_service_cost_sql(service_id, set_id, price_formula_order, part)
      else
        sql_1 = service_cost_sql(service_id, set_id, price_formula_order, part)
        sql_1 unless sql_1.blank?      
      end 
    end.compact.join(' union ')

#    raise(StandardError, [sql])
    check_sql(sql, price_formula_order)
    execute_additional_sql_to_check_performance(sql, 'calculate_service_list_sql', 6)
    sql
  end
  
  def empty_service_cost_sql(service_id, set_id, price_formula_order, part)
    fields = [
      "'#{part}'::text as part", 
      "#{service_id} as tarif_class_id", 
      "('{}')::text as call_ids", 
      '0.0 as price_value',
      '0 as call_id_count',
      "('[{\"call_id_count\":0}]')::text as price_values",
      "'#{set_id || -1}' as set_id"
    ]    
    "(select #{fields.join(',')})"
  end
  
  def service_cost_sql(service_id, set_id = nil, price_formula_order, part)
    raise(StandardError, [stat_function_collector.tarif_class_parts[service_id]]) unless part
    fields = [
      "'#{part}'::text as part", 
      'tarif_class_id', 
      'json_agg(call_ids)::text as call_ids', 
      'sum(price_value) as price_value',
      'sum(call_id_count) as call_id_count',
      '(json_agg(row_to_json(service_categories_cost_sql_result)))::text as price_values',
      "'#{set_id || -1}' as set_id"
    ]    
    sql = service_categories_cost_sql(service_id, set_id, price_formula_order, part)    
    sql = "(select #{fields.join(', ')} from (#{sql}) as service_categories_cost_sql_result group by tarif_class_id, set_id)"  unless sql.blank?
#    raise(StandardError, [sql]) if sql.blank?
    
    check_sql(sql, service_id, set_id, price_formula_order)    
    execute_additional_sql_to_check_performance(sql, 'service_cost_sql', 7)
    sql
  end
  
  def service_categories_cost_sql(service_id, set_id = nil, price_formula_order, part)  
    result = service_categories_cost_sql_from_service_category_groups(service_id, set_id, price_formula_order, part)
    result += service_categories_cost_sql_from_service_categories(service_id, set_id, price_formula_order, part)
    sql = result.compact.join(' union ')
    sql = "with united_service_categories_cost_sql as (#{sql} ) select *, all_stat::json as all_stat from united_service_categories_cost_sql" unless sql.blank?

    check_sql(sql, service_id, set_id, price_formula_order)
    execute_additional_sql_to_check_performance(sql, 'service_categories_cost_sql', 8)
    show_bad_performing_sql(sql, 'service_categories_cost_sql', 110.01)
    sql
  end
  
  def service_categories_cost_sql_from_service_category_groups(service_id, set_id = nil, price_formula_order, part)
    result = [] 
    stat_function_collector.service_group_ids[part][price_formula_order][service_id].each do |service_category_group_id|        
      stat_details = stat_function_collector.service_group_stat[part][price_formula_order][service_category_group_id]      
      
      if price_formula_order < (max_formula_order_collector.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)  
#TODO проверить нужно ли применять  service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true
        service_category_tarif_class_ids = calculate_service_category_ids_for_category_group_and_set_id(service_category_group_id, set_id, price_formula_order, part)
        service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(service_category_tarif_class_ids, set_id)
      
        prev_group_call_ids = current_tarif_optimization_results.find_prev_group_call_ids(set_id, part, service_category_group_id)
        prev_stat_values_string = current_tarif_optimization_results.prev_stat_function_values(stat_details[:price_formula_id], set_id, part, service_category_group_id)

        result << service_category_cost_sql(
          calculate_base_stat_sql(service_category_tarif_class_ids, part), service_category_tarif_class_ids[0], service_category_group_id, 
          stat_details[:price_formula_id], service_id, set_id, part, prev_group_call_ids, prev_stat_values_string)
      end
    end if stat_function_collector.service_group_ids[part] and stat_function_collector.service_group_ids[part][price_formula_order] and stat_function_collector.service_group_ids[part][price_formula_order][service_id]
    result
  end  

  def service_categories_cost_sql_from_service_categories(service_id, set_id = nil, price_formula_order, part)
    result = [] 
    stat_function_collector.service_stat[part][price_formula_order][service_id].each do |stat_details_key, stat_details|

     raise(StandardError, stat_details[:service_category_tarif_class_ids]) if service_id == 294 and part == 'periodic_'

      if price_formula_order < (max_formula_order_collector.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)
        service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(stat_details[:service_category_tarif_class_ids], set_id)
        service_category_tarif_class_id = service_category_tarif_class_ids[0]
        next if service_category_tarif_class_ids.blank?

        service_category_tarif_class_ids_for_base_stat_sql = service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true(
          service_category_tarif_class_ids, stat_details, service_id, part)
#        service_category_tarif_class_ids_for_base_stat_sql = service_category_tarif_class_ids_after_condition_if_tarif_option_included(
#          service_category_tarif_class_ids_for_base_stat_sql, set_id)
          
#        raise(StandardError, [stat_details[:service_category_tarif_class_ids]]) if service_category_tarif_class_ids.blank?
        
#TODO проверить правильно ли работает исключение предыдущих ids
        prev_group_call_ids = current_tarif_optimization_results.find_prev_group_call_ids(set_id, part, -1)
        prev_stat_values_string = current_tarif_optimization_results.prev_stat_function_values(stat_details[:price_formula_id], set_id, part, -1)

#    raise(StandardError, service_category_tarif_class_ids_for_base_stat_sql) if service_id == 294 and part == 'periodic'

        result << service_category_cost_sql(calculate_base_stat_sql(service_category_tarif_class_ids_for_base_stat_sql, part), 
          service_category_tarif_class_id, -1, stat_details[:price_formula_id], service_id, set_id,
          part, prev_group_call_ids, prev_stat_values_string)
      end
    end if stat_function_collector.service_stat[part] and stat_function_collector.service_stat[part][price_formula_order] and stat_function_collector.service_stat[part][price_formula_order][service_id]
    result
  end  
  
  def service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true(service_category_tarif_class_ids, stat_details, service_id, part)
    price_formula_id = stat_details[:price_formula_id]
    price_formula_details = stat_function_collector.price_formula(price_formula_id) if price_formula_id
    formula_tarif_condition = price_formula_details["tarif_condition"] if price_formula_details
    if formula_tarif_condition.blank? #and !['periodic', 'onetime'].include?(part)
      service_category_tarif_class_ids
    else
      query_constructor.tarif_class_categories_by_tarif_class[service_id]
    end 
  end 

  def calculate_service_category_ids_for_category_group_and_set_id(service_category_group_id, set_id = nil, price_formula_order, part)
    service_category_tarif_class_ids = []

    service_category_by_group_and_service_id = stat_function_collector.service_category_by_group_and_service_id[part][price_formula_order][service_category_group_id]
    group_tarif_class_ids = (service_category_by_group_and_service_id.keys & set_id.split('_').collect{|i| i.to_i} )
    
    group_tarif_class_ids.each do |group_tarif_class_id|
      service_category_tarif_class_ids += (service_category_by_group_and_service_id[group_tarif_class_id] + [])
    end        
    service_category_tarif_class_ids = [-1] if service_category_tarif_class_ids.blank?
    service_category_tarif_class_ids        
  end

  def service_category_tarif_class_ids_after_condition_if_tarif_option_included(service_category_tarif_class_ids, set_id)
    result = []
    service_category_tarif_class_ids.each do |service_category_tarif_class_id|
      next if service_category_tarif_class_id == -1
      raise(StandardError, [set_id, service_category_tarif_class_id]) if !query_constructor.tarif_class_categories[service_category_tarif_class_id]
      condition_field = query_constructor.tarif_class_categories[service_category_tarif_class_id].conditions  
      if condition_field and condition_field['tarif_set_must_include_tarif_options'] and 
        (condition_field['tarif_set_must_include_tarif_options'] & set_id.split('_').map{|s| s.to_i}).count == 0
      else
        result << service_category_tarif_class_id
      end
    end
    raise(StandardError, [service_category_tarif_class_ids, result]) if set_id == "203__"
    result
  end
  
  def calculate_base_stat_sql(service_category_tarif_class_ids, part)
    result = Customer::Call.where(calculation_scope_where_hash(part)).
      where(:user_id => user_id).where("description->>'accounting_period' = '#{accounting_period}'").
      where(query_constructor.joined_tarif_classes_category_where_hash(service_category_tarif_class_ids))
#    raise(StandardError, [accounting_period, result.to_sql])   
    execute_additional_sql_to_check_performance(result.to_sql, 'calculate_base_stat_sql', 9)
    result
  end
  
  def calculation_scope_where_hash(part)
    calculation_scope[:where_hash][part.to_s] || false
  end
  
  def service_category_cost_sql(base_stat_sql, service_category_tarif_class_id, service_category_group_id, price_formula_id, service_id, set_id,
      part, prev_group_call_ids, prev_stat_values_string)#, excluded_group_call_ids_by_part = [])
        
    price_formula = stat_function_collector.price_formula(price_formula_id)
    
    stat_sql_fields = ["coalesce(month, -1)::integer as month", "coalesce(call_ids, '{}') as call_ids", "coalesce(call_id_count, 0) as call_id_count",]
    price_formula['stat_params'].each { |stat_key, stat_function| stat_sql_fields << "coalesce(#{stat_key}, 0) as #{stat_key}" } if price_formula['stat_params']
    
    fields = if service_category_group_id > -1
      ["sctc_2.tarif_class_id", "price_lists.service_category_group_id", "-1 as service_category_tarif_class_id", "service_category_groups.name as service_category_name"]
    else
      ["sctc_1.tarif_class_id", "-1 as service_category_group_id", 
        "case when sctc_1.id = #{ service_category_tarif_class_id} then sctc_1.id else sctc_3.id end as service_category_tarif_class_id",
        "case when sctc_1.id = #{ service_category_tarif_class_id} then sctc_1.name else sctc_3.name end as service_category_name",]
    end
      
    fields = (fields + [       
      "month", "call_ids", "call_id_count", 
      "#{price_formula_id} as price_formula_id", 
#      "#{price_formula_order} as price_formula_calculation_order",
      "#{stat_function_collector.price_formula_string(price_formula_id)} as price_value",
#      "#{price_formula_order} as price_formula_order",
      "row_to_json(stat_sql)::text as all_stat"      
    ]).join(', ')
    
    distinct_fields = [
      "price_lists.service_category_group_id", "month", "price_formula_id", "price_lists.service_category_tarif_class_id"
    ].join(', ')
    
    service_category_choice_sql = service_category_choice_sql(base_stat_sql, price_formula_id, set_id, part, prev_group_call_ids, prev_stat_values_string)

    sql = [
      "with",
      "fixed_input as ( select 1 ),",
      "service_category_choice_sql as ( #{service_category_choice_sql} ),",
      "stat_sql as ( select #{stat_sql_fields.join(', ')} from fixed_input left outer join service_category_choice_sql on true )",
#TODO проверить как правильно использовать distinct (здесь он используется для удаления дублирующих записей возникающих при расчета service_category_groups)
      "select distinct on (#{distinct_fields}) #{fields}",
#      "select distinct #{fields}",
      "from stat_sql, price_formulas",
      "LEFT OUTER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id",
     
      "LEFT OUTER JOIN price_lists ON price_lists.id = price_formulas.price_list_id",
      "LEFT OUTER JOIN service_category_tarif_classes sctc_1 ON sctc_1.id = price_lists.service_category_tarif_class_id",

      "LEFT OUTER JOIN service_category_tarif_classes sctc_3 ON sctc_3.as_tarif_class_service_category_id = sctc_1.id",

      "LEFT OUTER JOIN service_category_groups ON service_category_groups.id = price_lists.service_category_group_id",
      "LEFT OUTER JOIN service_category_tarif_classes sctc_2 ON sctc_2.as_standard_category_group_id = service_category_groups.id",

      "where",
      "price_formulas.id = #{price_formula_id} and ",
#      "price_formulas.calculation_order = #{price_formula_order} and",
      "price_lists.tarif_list_id is null and",
      "(",
      "(sctc_2.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id = #{ service_category_group_id } ) or",      
      "(sctc_1.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ service_category_tarif_class_id || -1} ) or ",
      "(sctc_3.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_3.id = #{ service_category_tarif_class_id || -1} )",
      ")",  
    ].join(' ')
    sql = "(#{sql})"

    check_sql(sql, service_id, service_category_tarif_class_id, service_category_group_id, price_formula_id, service_id, set_id,
      part, prev_group_call_ids, prev_stat_values_string)
    execute_additional_sql_to_check_performance(sql, 'service_category_cost_sql', 9)
    show_bad_performing_sql(sql, 'service_category_cost_sql', 110.01)
#    raise(StandardError, stat_function_collector.price_formula_string(price_formula_id)) if service_id == 294 and part == 'periodic'
    sql
  end

  def service_category_choice_sql(base_stat_sql, price_formula_id, set_id, part, prev_group_call_ids, prev_stat_values_string)
    excluded_call_ids_by_part = prev_service_call_ids_by_parts[set_id][part] 

    sql = if !stat_function_collector.price_formula(price_formula_id)['window_condition'].blank?
      service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :window, prev_group_call_ids, prev_stat_values_string)
    elsif !stat_function_collector.price_formula(price_formula_id)['tarif_condition'].blank?
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :tarif)
    else
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :group)
    end

    check_sql(sql, price_formula_id)
    execute_additional_sql_to_check_performance(sql, 'service_category_choice_sql', 10)
    sql
  end 

  def service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part = {}, check_out_call_ids, prev_group_call_ids, prev_stat_values_string) 
#В запросах дальше поле 'month' выступает как название периода по которому идут расчеты       
    price_formula = stat_function_collector.price_formula(price_formula_id)#.formula

    stat_string_2 = ["first_stat_sql.*"]
    stat_string_4 = ["month", "array_agg(id) as call_ids", "count(id) as call_id_count", ]
    
    price_formula['stat_params'].each do |stat_key, stat_function| 
      stat_string_2 << "current_#{stat_key} + coalesce(prev_#{stat_key}, 0) as #{stat_key}"
      stat_string_4 << "#{stat_function} as #{stat_key}"
    end if price_formula['stat_params']

    sql = [
      "with",
      "prev_sql (#{prev_service_category_accumulated_stat_sql(price_formula_id, prev_stat_values_string)} ),",
      "first_stat_sql as ( #{first_stat_sql(base_stat_sql, price_formula_id, (excluded_call_ids_by_part - prev_group_call_ids ), check_out_call_ids)} ),",
      
      "service_category_accumulated_ids_sql_2 as (select #{stat_string_2.join(', ')} from first_stat_sql",
      "left outer join prev_sql on first_stat_sql.month = prev_sql.month), ",
      
      "service_category_accumulated_stat_sql_3 as ",
      "(select array_agg(id) as group_call_ids, month from service_category_accumulated_ids_sql_2 where #{price_formula['window_condition']} group by month)",
      
      "select #{stat_string_4.join(', ')} from customer_calls, service_category_accumulated_stat_sql_3",
      "where id != all('{#{excluded_call_ids_by_part.join(', ')}}') and id = any(group_call_ids)",
      "group by month",
    ].join(' ')

    check_sql(sql, price_formula_id, prev_group_call_ids, prev_stat_values_string)
    execute_additional_sql_to_check_performance(sql, 'service_category_accumulated_stat_sql', 11)
    sql
  end
  
  def first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, check_out_call_ids)
    price_formula = stat_function_collector.price_formula(price_formula_id)
    group_by = "extract(#{price_formula['group_by'] || 'month'} from (description->>'time')::timestamp)"
    case check_out_call_ids
    when :window
      fields = ["id", "extract(#{price_formula['window_over'] || 'month'} from (description->>'time')::timestamp) as month"]
      price_formula['stat_params'].each { |stat_key, stat_function| fields << "#{stat_function} over m as current_#{stat_key}" } if price_formula['stat_params']
    when :group
      fields = ["#{group_by} as month", "array_agg(id) as call_ids", "count(id) as call_id_count",]
      price_formula['stat_params'].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}" } if price_formula['stat_params']    
    when :tarif
      fields = ["#{group_by} as month", "'{}'::int[] as call_ids", "0 as call_id_count",]
      price_formula['stat_params'].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}" } if price_formula['stat_params']    
    else
      raise(StandardError, 'wrong check_out_call_ids in first_stat_sql')
    end

    sql = base_stat_sql.select("#{fields.join(', ')}").where.not(:id => excluded_call_ids_by_part)
      
    sql = if price_formula['window_over']
      "#{sql.to_sql} WINDOW m as (partition by extract(#{price_formula['window_over'] || 'month'} from (description->>'time')::timestamp) order by (description->>'time')::timestamp )"    
    else
      sql.group("month").to_sql
    end  
#    raise(StandardError) #if price_formula['standard_formula_id'] == 18
    check_sql(sql, price_formula_id)
    execute_additional_sql_to_check_performance(sql, 'first_stat_sql', 12)
    show_bad_performing_sql(sql, 'first_stat_sql', 0.01)
    sql
  end

  def prev_service_category_accumulated_stat_sql(price_formula_id, prev_stat_values_string) 
    price_formula = stat_function_collector.price_formula(price_formula_id)
    stat_string_0 = ["month", "prev_month_ids"]
    
    price_formula['stat_params'].each { |stat_key, stat_function| stat_string_0 << "prev_#{stat_key}" } if price_formula['stat_params']
    
    "#{stat_string_0.join(', ')} ) as (values #{prev_stat_values_string.join(', ')}"
  end
      
  module Helper
    def check_sql(sql, *params_to_show)
      begin
        Customer::Call.connection.execute(sql) if !sql.blank? and check_sql_before_running
      rescue => e
        raise(StandardError, params_to_show + ["#{sql}", e])
      end
      sql
    end
    
    def execute_additional_sql_to_check_performance(sql, checkpoint_name, checkpoint_level)
      if execute_additional_sql
        performance_checker.run_check_point(checkpoint_name, checkpoint_level) do
          Customer::Call.connection.execute(sql)
        end
      end
    end
    
    def show_bad_performing_sql(sql, checkpoint_name, time_limit, *params_to_show)
      if execute_additional_sql and performance_checker.results[checkpoint_name]['duration'] > time_limit
        raise(StandardError, (params_to_show + [nil, checkpoint_name, sql, performance_checker.show_stat]).join("\n\n") ) 
      end
    end
  
  end
      
end

