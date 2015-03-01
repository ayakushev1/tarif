class Customer::OptimizationResultMoversController < ApplicationController
  before_action :build_optimization_result_mover, only: [:new, :move]

  def move
    if @optimization_result_mover.valid?        
      @optimization_result_mover.copy
      redirect_to({:action => :new}, :alert => 'Данные перемещены')
#      raise(StandardError, flash[:alert])
    else
      render 'new'
    end
    
  end

  private
  
    def build_optimization_result_mover      
#      raise(StandardError, params)
      if params[:customer_optimization_result_mover]
        @optimization_result_mover = Customer::OptimizationResultMover.new(params[:customer_optimization_result_mover].permit!)
      else
        @optimization_result_mover = Customer::OptimizationResultMover.new()
      end
      
    end

end
