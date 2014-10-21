class ServiceHelper::TarifOptimizationStarter
  
  def start_calculate_all_operator_tarifs(options)
    ServiceHelper::TarifOptimizator.new(options).calculate_all_operator_tarifs    
  end
  
end
