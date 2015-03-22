class Customer::OptimizationResultsController < ApplicationController
  after_action :track_show_customer_results, only: :show_customer_results

  helper_method :customer_optimization_result

  def customer_optimization_result
#    @customer_optimization_result ||= 
    Customer::OptimizationResult.new(self)
  end
  
  private
  
  def track_show_customer_results
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end

end
