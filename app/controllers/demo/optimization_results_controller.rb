class Demo::OptimizationResultsController < Customer::OptimizationResultsController

  after_action :track_show_customer_results, only: :show_customer_results
  
  private
  
  def track_show_customer_results
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end

end
