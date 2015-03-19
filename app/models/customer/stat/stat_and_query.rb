class Customer::Stat::StatAndQuery #ServiceHelper::StatAndQuerySaver
  def self.save_stat_function_collector(operators = nil, all_services_by_operator = nil, region_id = nil, optimization_params = nil)
    operators ||= Customer::Info::ServiceChoices.operators
    all_services_by_operator ||= Customer::Info::ServiceChoices.all_services_by_operator
    region_id ||= 1238
    optimization_params = optimization_params || {:common => ['multiple_use_of_tarif_option', 'auto_turbo_buttons'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['multiple_use_of_tarif_option']}
    
    stat_function_collector_saver = Customer::Stat::OptimizationResult.new('preloaded_calculations', 'stat_function_collector', nil)
    stat_function_collector_saver.clean_output_results
    query_constructor_saver = Customer::Stat::OptimizationResult.new('preloaded_calculations', 'query_constructor', nil)
    query_constructor_saver.clean_output_results
    operators.each do |operator| 
      @fq_tarif_operator_id = operator
      @fq_tarif_region_id = region_id
      stat_function_collector = ServiceHelper::StatFunctionCollector.new(all_services_by_operator[operator], optimization_params, operator, region_id, false)

      stat_function_collector_saver.save({:operator_id => operator.to_i, :tarif_id => region_id.to_i, :result => {
        'service_stat' => stat_function_collector.service_stat,
        'service_group_stat' => stat_function_collector.service_group_stat,
        'service_group_ids' => stat_function_collector.service_group_ids,
        'service_category_by_group_and_service_id' => stat_function_collector.service_category_by_group_and_service_id,
        'price_formulas' => stat_function_collector.price_formulas, 
        'price_standard_formulas' => stat_function_collector.price_standard_formulas, 
        'tarif_class_parts' => stat_function_collector.tarif_class_parts,
      } }) #.to_json

      query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => all_services_by_operator[operator]}, operator, region_id, false )
      query_constructor_saver.save({:operator_id => operator.to_i, :tarif_id => region_id.to_i, :result => {
        'comparison_operators' => query_constructor.comparison_operators,
        'categories' => query_constructor.categories,
        'categories_as_hash' => query_constructor.categories_as_hash,
        'childs_category' => query_constructor.childs_category,
        'tarif_class_categories' => query_constructor.tarif_class_categories,
        'category_groups' => query_constructor.category_groups,
        'criterium_ids' => query_constructor.criterium_ids,
        'category_ids' => query_constructor.category_ids,
      
        'parameters' => query_constructor.parameters,
        'criteria_where_hash' => query_constructor.criteria_where_hash,
        'criteria_category' => query_constructor.criteria_category,
        'categories_where_hash' => query_constructor.categories_where_hash,
        'tarif_classes_categories_where_hash' => query_constructor.tarif_classes_categories_where_hash,
      
        'tarif_class_categories_by_tarif_class' => query_constructor.tarif_class_categories_by_tarif_class,
        'tarif_class_categories_by_category_group' => query_constructor.tarif_class_categories_by_category_group,
        'service_category_group_ids_by_tarif_class' => query_constructor.service_category_group_ids_by_tarif_class,
      } }) #.to_json

    end
  end
end

