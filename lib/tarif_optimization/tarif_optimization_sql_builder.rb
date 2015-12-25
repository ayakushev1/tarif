class TarifOptimization::TarifOptimizationSqlBuilder
  include TarifOptimization::TarifOptimizationSqlBuilder2
  attr_reader :tarif_optimizator, :performance_checker, :options, :user_id, :accounting_period, :call_run_id

  def initialize(tarif_optimizator, options = {})
    self.extend Helper
    @options = options
    @user_id = options[:user_id] || 0
    @accounting_period = options[:accounting_period]
    @call_run_id = options[:call_run_id]
    @tarif_optimizator = tarif_optimizator
#    raise(StandardError)
  end
  
# параметры из TarifOptimization::CurrentTarifOptimizationResults
  def tarif_results; current_tarif_optimization_results.tarif_results; end
  
  def prev_service_call_ids_by_parts; current_tarif_optimization_results.prev_service_call_ids_by_parts; end
  def calls_count_by_parts; tarif_optimizator.calls_count_by_parts; end
  def calculation_scope ; tarif_optimizator.calls_stat_calculator.calculation_scope; end
  
# optimization params from TarifOptimization::TarifOptimizator
  def check_sql_before_running; tarif_optimizator.check_sql_before_running; end
  def execute_additional_sql; tarif_optimizator.execute_additional_sql; end

# optimization classes from TarifOptimization::TarifOptimizator
  def current_tarif_optimization_results; tarif_optimizator.current_tarif_optimization_results; end
  def tarif_list_generator; tarif_optimizator.tarif_list_generator; end
  def stat_function_collector; tarif_optimizator.stat_function_collector; end
  def query_constructor; tarif_optimizator.query_constructor; end
  def max_formula_order_collector; tarif_optimizator.max_formula_order_collector; end
  def performance_checker; tarif_optimizator.performance_checker; end
  
  def inject_for_processing(str)
    yield str
  end
  
  def calculate_service_part_sql(service_list, price_formula_order)
    inject_for_processing(calculate_service_list_sql(service_list, price_formula_order)) do |sql|
      fields = [
        'part'.freeze, 
        'tarif_class_id'.freeze, 
        'call_ids'.freeze, 
        'categ_ids'.freeze, 
        'price_value'.freeze,
        'call_id_count'.freeze,
        '(price_values::json) as price_values'.freeze,
        'set_id'.freeze
      ]

      sql.blank? ? sql : "with calculate_service_list_sql as (#{sql}) select #{fields.join(', '.freeze)} from calculate_service_list_sql"
    end
  end
  
  def calculate_service_list_sql(service_list, price_formula_order)
    service_list.collect do |service_list_item| 
      service_id = service_list_item[:ids]
      next if !service_id 
      part = service_list_item[:parts]
      set_id = service_list_item[:set_ids]
      
#      raise(StandardError, [tarif_list_generator.tarif_sets, service_list]) if part == "periodic" and service_id == 484# and set_id == "484_443"
      
      next if !max_formula_order_collector.max_order_by_service_and_part[part] or !max_formula_order_collector.max_order_by_service_and_part[part][service_id]
      next if price_formula_order > max_formula_order_collector.max_order_by_service_and_part[part][service_id]
      next if !tarif_list_generator.parts_by_service[service_id].include?(part)
      prev_call_ids_count = 0 
      tarif_results[set_id][part].each do |service_id_1, tarif_results_value |  
        prev_call_ids_count += tarif_results_value['call_id_count'.freeze] 
      end
      
      next if (calls_count_by_parts[part] == 0) and !['periodic'.freeze, 'onetime'.freeze].include?(part)
#TODO подумать чтобы убрать !(calls_count_by_parts[part] == 0)
      if !(calls_count_by_parts[part] == 0) and prev_call_ids_count == calls_count_by_parts[part]
        empty_service_cost_sql(service_id, set_id, price_formula_order, part)
      else
        sql_1 = service_cost_sql(service_id, set_id, price_formula_order, part)
        sql_1 unless sql_1.blank?      
      end 
    end.compact.join(' union '.freeze)
  end
  
  def empty_service_cost_sql(service_id, set_id, price_formula_order, part)
    fields = [
      "'#{part}'::text as part".freeze, 
      "#{service_id} as tarif_class_id".freeze, 
      "('{}')::text as call_ids".freeze, 
      "('{}')::text as categ_ids".freeze, 
      '0.0 as price_value'.freeze,
      '0 as call_id_count'.freeze,
      "('[{\"call_id_count\":0}]')::text as price_values".freeze,
      "'#{set_id || -1}' as set_id"
    ]    
    "(select #{fields.join(',')})"
  end
  
  def service_cost_sql(service_id, set_id = nil, price_formula_order, part)
#    raise(StandardError, [stat_function_collector.tarif_class_parts[service_id]]) unless part
    inject_for_processing(service_categories_cost_sql(service_id, set_id, price_formula_order, part)) do |sql|
      fields = [
        "'#{part}'::text as part".freeze, 
        'tarif_class_id'.freeze, 
        'json_agg(call_ids)::text as call_ids'.freeze, 
        'json_agg(categ_ids)::text as categ_ids'.freeze, 
        'sum(price_value) as price_value'.freeze,
        'sum(call_id_count) as call_id_count'.freeze,
        '(json_agg(row_to_json(service_categories_cost_sql_result)))::text as price_values'.freeze,
        "'#{set_id || -1}' as set_id"
      ]    
#      sql = "(select #{fields.join(', '.freeze)} from (#{sql}) as service_categories_cost_sql_result group by tarif_class_id, set_id)"  unless sql.blank?      
#      check_sql(sql, service_id, set_id, price_formula_order) if check_sql_before_running    
#      sql
      sql.blank? ? sql : "(select #{fields.join(', '.freeze)} from (#{sql}) as service_categories_cost_sql_result group by tarif_class_id, set_id)"
    end
  end
  
  def service_categories_cost_sql(service_id, set_id = nil, price_formula_order, part)  
    inject_for_processing( (service_categories_cost_sql_from_service_category_groups(service_id, set_id, price_formula_order, part) + 
      service_categories_cost_sql_from_service_categories(service_id, set_id, price_formula_order, part)).compact.join(' union ') ) do |sql|
        
        sql.blank? ? sql : "with base_stat_by_part as (#{calculate_base_stat_by_part_sql(part)}), \ 
          united_service_categories_cost_sql as (#{sql} ) select *, all_stat::json as all_stat from united_service_categories_cost_sql"
    end
  end
  
  def calculate_base_stat_by_part_sql(part)
#    result = 
    Customer::Call.where(calculation_scope_where_hash(part)).
      where(:call_run_id => call_run_id).where("description->>'accounting_period' = '#{accounting_period}'".freeze).to_sql
#    raise(StandardError, calculation_scope_where_hash(part))   
#    result
  end
  
  def service_categories_cost_sql_from_service_category_groups(service_id, set_id = nil, price_formula_order, part)
    inject_for_processing([]) do |result| 
      stat_function_collector.service_group_ids[part][price_formula_order][service_id].each do |service_category_group_id|        
        stat_details = stat_function_collector.service_group_stat[part][price_formula_order][service_category_group_id]      
        
        if price_formula_order < (max_formula_order_collector.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)  
          service_category_tarif_class_ids_from_group = calculate_service_category_ids_for_category_group_and_set_id(service_category_group_id, set_id, price_formula_order, part)

          service_category_tarif_class_ids_from_tarif = service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true(
            service_category_tarif_class_ids_from_group, stat_details, service_id, part)

          service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(service_category_tarif_class_ids_from_tarif, set_id)
        
          raise(StandardError, [
            "",
            "set_id #{set_id}",
            "service_id #{service_id}",
            "part #{part}",
            "price_formula_order #{price_formula_order}",
            "service_category_tarif_class_ids_from_group #{service_category_tarif_class_ids_from_group}",
            "service_category_tarif_class_ids_from_tarif #{service_category_tarif_class_ids_from_tarif}",
            "service_category_tarif_class_ids #{service_category_tarif_class_ids}",
            "service_category_tarif_class_ids[0] #{service_category_tarif_class_ids[0]}",
            "tarif_list_generator #{tarif_list_generator.tarif_sets}",
            ""
          ].join("\n\n")) if false and service_category_group_id == 32363 and set_id.split("_").include?("443")

          next if (service_category_tarif_class_ids_from_group & service_category_tarif_class_ids).blank?

          prev_group_call_ids = current_tarif_optimization_results.find_prev_group_call_ids(set_id, part, service_category_group_id)
          prev_stat_values_string = current_tarif_optimization_results.prev_stat_function_values(stat_details[:price_formula_id], set_id, part, service_category_group_id)
          
          result << service_category_cost_sql(
            calculate_base_stat_sql(service_category_tarif_class_ids, part), service_category_tarif_class_ids[0], service_category_group_id, 
            stat_details[:price_formula_id], service_id, set_id, part, prev_group_call_ids, prev_stat_values_string)
        end
      end if stat_function_collector.service_group_ids[part] and stat_function_collector.service_group_ids[part][price_formula_order] and stat_function_collector.service_group_ids[part][price_formula_order][service_id]
      result
    end
  end  

  def service_categories_cost_sql_from_service_categories(service_id, set_id = nil, price_formula_order, part)
    inject_for_processing([]) do |result| 
      stat_function_collector.service_stat[part][price_formula_order][service_id].each do |stat_details_key, stat_details|
        if price_formula_order < (max_formula_order_collector.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)
          service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(stat_details[:service_category_tarif_class_ids], set_id)
          service_category_tarif_class_id = service_category_tarif_class_ids[0]
          next if service_category_tarif_class_ids.blank?
  
          service_category_tarif_class_ids_for_base_stat_sql = service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true(
            service_category_tarif_class_ids, stat_details, service_id, part)

          raise(StandardError, [
            "",
            "set_id #{set_id}",
            "service_id #{service_id}",
            "part #{part}",
            "price_formula_order #{price_formula_order}",
            "service_category_tarif_class_ids #{service_category_tarif_class_ids}",
            "service_category_tarif_class_ids_for_base_stat_sql #{service_category_tarif_class_ids_for_base_stat_sql}",
            ""
          ].join("\n\n")) if false #(service_category_tarif_class_ids).include?(392146)

          prev_group_call_ids = current_tarif_optimization_results.find_prev_group_call_ids(set_id, part, -1)
          prev_stat_values_string = current_tarif_optimization_results.prev_stat_function_values(stat_details[:price_formula_id], set_id, part, -1)

          result << service_category_cost_sql(calculate_base_stat_sql(service_category_tarif_class_ids_for_base_stat_sql, part), 
            service_category_tarif_class_id, -1, stat_details[:price_formula_id], service_id, set_id,
            part, prev_group_call_ids, prev_stat_values_string)
        end
      end if stat_function_collector.service_stat[part] and stat_function_collector.service_stat[part][price_formula_order] and stat_function_collector.service_stat[part][price_formula_order][service_id]
      result
    end
  end  
  
  def service_category_tarif_class_ids_after_condition_if_formula_tarif_condition_is_true(service_category_tarif_class_ids, stat_details, service_id, part)
    price_formula_id = stat_details[:price_formula_id]
    price_formula_details = stat_function_collector.price_formula(price_formula_id) if price_formula_id
    formula_tarif_condition = price_formula_details["tarif_condition".freeze] if price_formula_details

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
    inject_for_processing([]) do |result| 
      service_category_tarif_class_ids.each do |service_category_tarif_class_id|
        next if service_category_tarif_class_id == -1
        raise(StandardError, [set_id, service_category_tarif_class_id]) if !query_constructor.tarif_class_categories[service_category_tarif_class_id]
        condition_field = query_constructor.tarif_class_categories[service_category_tarif_class_id]['conditions'.freeze]  
        if condition_field and condition_field['tarif_set_must_include_tarif_options'.freeze] and 
          (condition_field['tarif_set_must_include_tarif_options'.freeze] & set_id.split('_').map{|s| s.to_i}).count == 0
        else
          result << service_category_tarif_class_id
        end
      end
      raise(StandardError, [service_category_tarif_class_ids, result]) if set_id == "203__"
      result
    end
  end
  
  def calculate_base_stat_sql(service_category_tarif_class_ids, part)
#    result = Customer::Call.where(calculation_scope_where_hash(part)).
#      where(:call_run_id => call_run_id).where("description->>'accounting_period' = '#{accounting_period}'").
#      where(query_constructor.joined_tarif_classes_category_where_hash(service_category_tarif_class_ids))
#    raise(StandardError, calculation_scope_where_hash(part))   
#    sql = "(select * from base_stat_by_part customer_calls where #{query_constructor.joined_tarif_classes_category_where_hash(service_category_tarif_class_ids)}) customer_calls"
#    result = Customer::Call.from(sql)
#    result
    Customer::Call.from("(select * from base_stat_by_part customer_calls where #{query_constructor.joined_tarif_classes_category_where_hash(service_category_tarif_class_ids)}) customer_calls")
  end
  
  def calculation_scope_where_hash(part)
    calculation_scope[:where_hash][part.to_s] || false
  end
  
  def service_category_cost_sql(base_stat_sql, service_category_tarif_class_id, service_category_group_id, price_formula_id, service_id, set_id,
      part, prev_group_call_ids, prev_stat_values_string)#, excluded_group_call_ids_by_part = [])
    
#    raise(StandardError) if service_category_group_id == 32540
    price_formula = stat_function_collector.price_formula(price_formula_id)
    
    stat_sql_fields = ["coalesce(month, -1)::integer as month".freeze, "coalesce(call_ids, '{}') as call_ids".freeze,
                       "coalesce(categ_ids, '{}') as categ_ids".freeze, "coalesce(call_id_count, 0) as call_id_count".freeze,]
    price_formula['stat_params'.freeze].each { |stat_key, stat_function| stat_sql_fields << "coalesce(#{stat_key}, 0) as #{stat_key}" } if price_formula['stat_params'.freeze]
    
    fields = if service_category_group_id > -1
      ["sctc_2.tarif_class_id".freeze, "price_lists.service_category_group_id".freeze, "-1 as service_category_tarif_class_id".freeze, "service_category_groups.name as service_category_name".freeze]
    else
      ["sctc_1.tarif_class_id".freeze, "-1 as service_category_group_id".freeze, "sctc_1.id as service_category_tarif_class_id".freeze, "sctc_1.name as service_category_name".freeze,]
    end
      
    fields = (fields + [       
      "month".freeze, "call_ids".freeze, "categ_ids".freeze, "call_id_count".freeze, 
      "#{price_formula_id} as price_formula_id".freeze, 
#      "#{price_formula_order} as price_formula_calculation_order",
      "#{stat_function_collector.price_formula_string(price_formula_id)} as price_value".freeze,
#      "#{price_formula_order} as price_formula_order",
      "row_to_json(stat_sql)::text as all_stat".freeze      
    ]).join(', '.freeze)
    
    distinct_fields = [
      "price_lists.service_category_group_id".freeze, "month".freeze, "price_formula_id".freeze, "price_lists.service_category_tarif_class_id".freeze
    ].join(', '.freeze)
    
    service_category_choice_sql = service_category_choice_sql(base_stat_sql, price_formula_id, set_id, part, prev_group_call_ids, prev_stat_values_string)

    sql = [
      "with".freeze,
      "fixed_input as ( select 1 ),".freeze,
      "service_category_choice_sql as ( #{service_category_choice_sql} ),",
      "stat_sql as ( select #{stat_sql_fields.join(', '.freeze)} from fixed_input left outer join service_category_choice_sql on true )",
#TODO проверить как правильно использовать distinct (здесь он используется для удаления дублирующих записей возникающих при расчета service_category_groups)
#TODO можно использовать exists instead of distinct (select * from a where exist (select 'any' from a where conditions))
      "select distinct on (#{distinct_fields}) #{fields}".freeze,
#      "select distinct #{fields}",
      "from stat_sql, price_formulas".freeze,
      "LEFT OUTER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id".freeze,
     
      "LEFT OUTER JOIN price_lists ON price_lists.id = price_formulas.price_list_id".freeze,
      "LEFT OUTER JOIN service_category_tarif_classes sctc_1 ON sctc_1.id = price_lists.service_category_tarif_class_id".freeze,

      "LEFT OUTER JOIN service_category_groups ON service_category_groups.id = price_lists.service_category_group_id".freeze,
      "LEFT OUTER JOIN service_category_tarif_classes sctc_2 ON sctc_2.as_standard_category_group_id = service_category_groups.id".freeze,

      "where".freeze,
      "price_formulas.id = #{price_formula_id} and ",
#      "price_formulas.calculation_order = #{price_formula_order} and",
      "price_lists.tarif_list_id is null and".freeze,
      "(".freeze,
      "(sctc_2.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id = #{ service_category_group_id } ) or",      
      "(sctc_1.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ service_category_tarif_class_id || -1} )",
      ")",# limit 1",  
    ].join(' ')
    sql = "(#{sql})"
  end

  def service_category_choice_sql(base_stat_sql, price_formula_id, set_id, part, prev_group_call_ids, prev_stat_values_string)
    excluded_call_ids_by_part = prev_service_call_ids_by_parts[set_id][part] 

    if !stat_function_collector.price_formula(price_formula_id)['window_condition'.freeze].blank?
      service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :window, prev_group_call_ids, prev_stat_values_string)
    elsif !stat_function_collector.price_formula(price_formula_id)['tarif_condition'.freeze].blank?
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :tarif)
    else
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, :group)
    end
  end 

  def service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part = {}, check_out_call_ids, prev_group_call_ids, prev_stat_values_string) 
#В запросах дальше поле 'month' выступает как название периода по которому идут расчеты       
    price_formula = stat_function_collector.price_formula(price_formula_id)#.formula

    stat_string_2 = ["first_stat_sql.*".freeze]
    stat_string_4 = ["month".freeze, "array_agg(id) as call_ids".freeze, "array_agg(global_category_id) as categ_ids".freeze, "count(id) as call_id_count".freeze, ]
    
    price_formula['stat_params'.freeze].each do |stat_key, stat_function| 
      stat_string_2 << "current_#{stat_key} + coalesce(prev_#{stat_key}, 0) as #{stat_key}"
      stat_string_4 << "#{stat_function} as #{stat_key}"
    end if price_formula['stat_params'.freeze]

    [
      "with".freeze,
      "prev_sql (#{prev_service_category_accumulated_stat_sql(price_formula_id, prev_stat_values_string)} ),",
      "first_stat_sql as ( #{first_stat_sql(base_stat_sql, price_formula_id, (excluded_call_ids_by_part - prev_group_call_ids ), check_out_call_ids)} ),",
      
      "service_category_accumulated_ids_sql_2 as (select #{stat_string_2.join(', ')} from first_stat_sql",
      "left outer join prev_sql on first_stat_sql.month = prev_sql.month), ".freeze,
      
      "service_category_accumulated_stat_sql_3 as ".freeze,
      "(select array_agg(id) as group_call_ids, month from service_category_accumulated_ids_sql_2 where #{price_formula['window_condition']} group by month)",
      
      "select #{stat_string_4.join(', ')} from customer_calls, service_category_accumulated_stat_sql_3",
      "where id != all('{#{excluded_call_ids_by_part.join(', ')}}') and id = any(group_call_ids)",
      "group by month".freeze,
    ].join(' ')
  end
  
  def first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids_by_part, check_out_call_ids)
    price_formula = stat_function_collector.price_formula(price_formula_id)
    group_by = "extract(#{price_formula['group_by'.freeze] || 'month'.freeze} from (description->>'time')::timestamp)".freeze
    case check_out_call_ids
    when :window
      fields = ["id".freeze, "global_category_id".freeze, "extract(#{price_formula['window_over'.freeze] || 'month'.freeze} from (description->>'time')::timestamp) as month"]
      price_formula['stat_params'.freeze].each { |stat_key, stat_function| fields << "#{stat_function} over m as current_#{stat_key}" } if price_formula['stat_params'.freeze]
    when :group
      fields = ["#{group_by} as month".freeze, "array_agg(id) as call_ids", "array_agg(global_category_id) as categ_ids".freeze, "count(id) as call_id_count".freeze,]
      price_formula['stat_params'.freeze].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}".freeze } if price_formula['stat_params'.freeze]    
    when :tarif
      fields = ["#{group_by} as month".freeze, "'{}'::int[] as call_ids".freeze, "'{}'::int[] as categ_ids".freeze, "0 as call_id_count".freeze,]
      price_formula['stat_params'.freeze].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}".freeze } if price_formula['stat_params'.freeze]    
    else
      raise(StandardError, 'wrong check_out_call_ids in first_stat_sql')
    end

    sql = base_stat_sql.select("#{fields.join(', '.freeze)}").where.not(:id => excluded_call_ids_by_part)
      
    if price_formula['window_over'.freeze]
      "#{sql.to_sql} WINDOW m as (partition by extract(#{price_formula['window_over'] || 'month'} from (description->>'time')::timestamp) order by (description->>'time')::timestamp )"    
    else
      sql.group("month".freeze).to_sql
    end  
  end

  def prev_service_category_accumulated_stat_sql(price_formula_id, prev_stat_values_string) 
    price_formula = stat_function_collector.price_formula(price_formula_id)
    stat_string_0 = ["month".freeze, "prev_month_ids".freeze]
    
    price_formula['stat_params'.freeze].each { |stat_key, stat_function| stat_string_0 << "prev_#{stat_key}".freeze } if price_formula['stat_params'.freeze]
    
    "#{stat_string_0.join(', '.freeze)} ) as (values #{prev_stat_values_string.join(', '.freeze)}"
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
    
    def execute_additional_sql_to_check_performance(sql)
      Customer::Call.connection.execute(sql)
    end
    
    def show_bad_performing_sql(sql, checkpoint_name, time_limit, *params_to_show)
      if execute_additional_sql and performance_checker and performance_checker.results[checkpoint_name]['duration'] > time_limit
        raise(StandardError, (params_to_show + [nil, checkpoint_name, sql, performance_checker.show_stat]).join("\n\n") ) 
      end
    end
  
  end
      
end

