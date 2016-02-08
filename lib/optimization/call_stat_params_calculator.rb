class Optimization::CallStatParamsCalculator
  attr_reader :options, :accounting_period, :call_run_id, :selected_service_categories, :service_ids, :operator_id
  attr_accessor :stat_params_by_uniq_service_category, :calls_count_by_parts
  attr_reader :optimizator
  
  def initialize(optimizator = nil, options = {})
    @optimizator = optimizator || Optimization::Runner.new().optimizator
    @options = @optimizator.options.deep_merge(:user_input => options)
    
    @operator_id = @options[:user_input][:operator_id] || 1030
    @accounting_period = @options[:user_input][:accounting_period]
    @call_run_id = @options[:user_input][:call_run_id]
    @service_ids = @options[:user_input][:service_ids] || @optimizator.tarif_list_generator.all_services_by_operator[@operator_id]
    @selected_service_categories = @options[:selected_service_categories]
    
    @stat_params_by_uniq_service_category = {}
  end
  
  def calculate_stat_params   
    calculate_stat_params_by_uniq_service_category
    
    @calls_count_by_parts = calls_stat_calculator.calculate_calls_count_by_parts(query_constructor, 
      tarif_list_generator.uniq_parts_by_operator[operator_id], tarif_list_generator.uniq_parts_criteria_by_operator[operator_id]) 
#    return
  end
  
  def calculate_stat_params_by_uniq_service_category 
    Customer::Call.find_by_sql(calculate_stat_params_sql).each do |item|
#      raise(StandardError, [item.attributes])
      stat_params_by_uniq_service_category[item["part"]] ||= {}
      stat_params_by_uniq_service_category[item["part"]][item["uniq_service_category"]] = item.attributes.except("id", "uniq_service_category")
    end
  end
  
  def calculate_stat_params_sql
    sql_arr = []
    stat_params_by_uniq_service_category_query.each do |item|
      service_category_ids = (item.uniq_service_category.split('_').map(&:to_i).compact - [-1])
      next if service_category_ids.blank?
      stat_params_by_group(item.arr_of_stat_params).each do |group, arr_of_stat_params|
        next if arr_of_stat_params.blank?
        extended_arr_of_stat_params = arr_of_stat_params + standard_stat_params + 
          ["'#{item.uniq_service_category}' as uniq_service_category", "'#{item.part}' as part"]
        sql_arr << base_stat_sql(service_category_ids).select(extended_arr_of_stat_params).group("description->>'#{group}'")
      end      
    end
    sql_arr.map{|sql| "( #{sql.to_sql} )"}.join(" union ")
  end
  
  def stat_params_by_group(arr_of_stat_params)
    result = {'day' => [], 'month' => []}
    arr_of_stat_params.each do |stat_params|
      stat_params.each do |name, desc|
        group = (desc["group_by"] and desc["group_by"] == 'day') ? 'day' : 'month'
        result[group] << "#{desc['formula']} as #{name}"
      end
    end
    result
  end
  
  def standard_stat_params
    ['count(*) as call_id_count'.freeze, "array_agg(distinct global_category_id) as global_category_ids".freeze]
  end

  def stat_params_by_uniq_service_category_query
    Service::CategoryGroup.where(:tarif_class_id => service_ids).
      joins(:service_category_tarif_classes, price_lists: [formulas: :standard_formula]).
      select(:uniq_service_category, "array_agg(stat_params) as arr_of_stat_params", "service_category_tarif_classes.conditions#>>'{parts, 0}' as part").
      group(:uniq_service_category, :part)
  end
  
  def update_calls_with_uniq_category_id(service_id) # for trial testing
    base_customer_call.each do |call|
      call.description['uniq_service_category'] = nil
      call.save
    end
    Service::CategoryGroup.where(:tarif_class_id => service_id).joins(:service_category_tarif_classes).select(:uniq_service_category).each do |item|
      service_category_ids = (item.uniq_service_category.split('_').map(&:to_i).compact - [-1])
      next if service_category_ids.blank?
      base_stat_sql(service_category_ids).each do |call|
        call.description['uniq_service_category'] ||= []
        call.description['uniq_service_category'] = [item.uniq_service_category] - call.description['uniq_service_category']
        call.save
      end
    end
  end

  def base_stat_sql(service_category_ids)
    base_customer_call.where(query_constructor.joined_service_categories_where_hash(service_category_ids))
  end
  
  def base_customer_call    
    Customer::Call.where(calls_stat_calculator.calculation_scope_where_hash).
      where(:call_run_id => call_run_id).where("description->>'accounting_period' = '#{accounting_period}'".freeze)
  end

  def tarif_list_generator
    optimizator.tarif_list_generator
  end
  
  def query_constructor
    optimizator.query_constructor
  end
  
  def calls_stat_calculator
    optimizator.calls_stat_calculator
  end
 

end
