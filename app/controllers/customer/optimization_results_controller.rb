class Customer::OptimizationResultsController < ApplicationController
  helper_method :customer_optimization_result

  def customer_optimization_result
    @customer_optimization_result ||= Customer::OptimizationResult.new(self)
  end
  
end
