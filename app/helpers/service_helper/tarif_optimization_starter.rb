class ServiceHelper::TarifOptimizationStarter
  
  def start_calculate_all_operator_tarifs(options)
    ServiceHelper::TarifOptimizator.new(options).calculate_all_operator_tarifs    
  end
  
  def start_prepare_final_tarif_results(options)
    ServiceHelper::TarifOptimizator.new(options).tarif_optimizator.prepare_and_save_final_tarif_results
  end

  def start_update_minor_results(options)
    operator = options[:operator]
    tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
    tarif_optimizator.init_input_for_one_operator_calculation(operator)
    tarif_optimizator.update_minor_results
    tarif_optimizator.calculate_and_save_final_tarif_sets
  end  
  
end
