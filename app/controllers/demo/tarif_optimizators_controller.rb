class Demo::TarifOptimizatorsController < Customer::TarifOptimizatorsController

  after_action :track_recalculate, only: :recalculate
  after_action :track_index, only: :index
  
  private
  
  def track_recalculate
#    raise(StandardError, customer_tarif_optimizator.optimization_params)
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
#      'optimization_params' => customer_tarif_optimizator.optimization_params,
#      'service_choices' => customer_tarif_optimizator.service_choices,
#      'services_select' => customer_tarif_optimizator.services_select,
#      'service_categories_select' => customer_tarif_optimizator.service_categories_select,
    })
  end

  def track_index
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end


   
end
