class ServiceHelper::TarifOptimizator
  attr_reader :tarif_list_generator, :stat_function_collector, :query_constructor, :tarif_option_stat_results
  def initialize(options)
    @fq_tarif_region_id = options[:user_region_id] || 1133    
    @tarif_list_generator = ServiceHelper::TarifListGenerator.new
    @tarif_option_results = {}
  end
  
  def calculate_all_operator_tarifs
    tarif_list_generator.operators.each_index { |operator_index| calculate_one_operator_tarifs(operator_index) }
  end
  
  def calculate_one_operator_tarifs(operator_index)
    init_input_for_one_operator_tarif_calculation(operator_index)
    
    @tarif_option_stat_results = Customer::Call.find_by_sql(calculate_tarif_options_sql(operator_index)).collect { |stat| stat.attributes }
#    @tarif_option_stat_results = calculate_tarif_options_sql(operator_index)
    
#    calculate_tarif_option_results
  end
  
  def init_input_for_one_operator_tarif_calculation(operator_index)
    @fq_tarif_operator_id = tarif_list_generator.operators[operator_index]
    @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services[operator_index])
    @query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_list_generator.all_services[operator_index]} )
  end
  
  def calculate_tarif_options_sql(operator_index)
    tarif_list_generator.all_tarif_options[operator_index].collect do |tarif_option_id| 
      (calculate_tarif_option_for_service_category_tarif_classes_sql(tarif_option_id) || []) + 
      (calculate_tarif_option_for_service_category_groups_sql(tarif_option_id) || [])
    end.join(' union ')  
  end
  
  def calculate_tarif_option_for_service_category_tarif_classes_sql(tarif_option_id)    
    stat_function_collector.stat_for_service_category_tarif_classes[tarif_option_id.to_s].collect do |stat_details|
#      calculate_stat_for_one_service_category_tarif_classes_final_sql(tarif_option_id, stat_details)
      calculate_stat_for_one_service_category_group_final_sql(tarif_option_id, stat_details)
    end if stat_function_collector.stat_for_service_category_tarif_classes[tarif_option_id.to_s]      
  end

  def calculate_tarif_option_for_service_category_groups_sql(tarif_option_id)    
    stat_function_collector.stat_for_service_category_groups[tarif_option_id.to_s].collect do |stat_details|
      calculate_stat_for_one_service_category_group_final_sql(tarif_option_id, stat_details)
    end if stat_function_collector.stat_for_service_category_groups[tarif_option_id.to_s]
  end
  
  def calculate_stat_for_one_service_category_group_final_sql(tarif_option_id, stat_details)
    fields = if stat_details[:service_category_group_id] > 0
      ["price_lists.service_category_group_id", "-1 as service_category_tarif_class_id"]
    else
      ["-1 as service_category_group_id", "price_lists.service_category_tarif_class_id"]
    end
    fields = (fields + [
      "price_lists.tarif_class_id", 
      "call_ids", "call_id_count",
      "#{ stat_function_collector.price_formulas_string_for_price_list(stat_details[:price_formula_ids]) } as price_value"      
    ]).join(', ')
    
    sql = [
     "with stat_sql as (#{ calculate_stat_for_one_service_category_first_sql(tarif_option_id, stat_details) })",
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

  def calculate_stat_for_one_service_category_tarif_classes_final_sql(tarif_option_id, stat_details)
    fields = [
      "price_lists.tarif_class_id", 
      "price_lists.service_category_tarif_class_id", 
      "call_ids", "call_id_count",
      "#{ stat_function_collector.price_formulas_string_for_price_list(stat_details[:price_formula_ids]) } as price_value"      
    ].join(', ')
    
    sql = [
     "with stat_sql as (#{ calculate_stat_for_one_service_category_first_sql(tarif_option_id, stat_details) })",
     "select #{fields}",
     "from stat_sql, price_formulas",
     "INNER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id",
     "INNER JOIN price_lists ON price_lists.id = price_formulas.price_list_id",
     "where",
     "price_lists.tarif_class_id = #{tarif_option_id} and",
     "price_lists.tarif_list_id is null and",
     "price_lists.service_category_group_id is null and",
     "price_lists.service_category_tarif_class_id = #{ stat_details[:service_category_tarif_class_ids][0]}",      
#     "price_lists.service_category_tarif_class_id = any('{#{ stat_details[:service_category_tarif_class_ids].join(', ') }}')",      
    ].join(' ')
    
    "(#{sql})"
  end

  def calculate_stat_for_one_service_category_first_sql(tarif_option_id, stat_details)    
    stat_string = ["#{tarif_option_id} as tarif_option_id", 
                   "array#{stat_details[:service_category_tarif_class_ids]} as service_category_tarif_class_ids",
                   "#{stat_details[:service_category_group_id]} as service_category_group_id", 
                   "array_agg(id) as call_ids",
                   "count(id) as call_id_count", 
#                   "array#{sctc[:price_formula_ids]} as price_formula_ids"
                   ]
    stat_details[:stat_params].each do |stat_param|
      stat_param.each {|stat_key, stat_function| stat_string << "#{stat_function} as #{stat_key}" } if stat_details[:stat_params]
    end
    stat_string = stat_string.join(', ')
    
    Customer::Call.select(stat_string).where(query_constructor.joined_tarif_classes_category_where_hash(stat_details[:service_category_tarif_class_ids])).to_sql
  end

    
end
