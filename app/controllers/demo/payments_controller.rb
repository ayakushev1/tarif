class Demo::PaymentsController < ApplicationController
  before_action :build_payment_instruction, only: [:new, :create]

  def create    
    if @payment_instruction.valid?        
      redirect_to @payment_instruction.url_to_yandex(current_user)
    else
      render 'new'
    end
  end
  
  def wait_for_payment_being_processed
    if customer_has_free_trials?('optimization_steps')
      redirect_to demo_optimization_steps_choose_load_calls_options_path
    end
  end
  
  def process_payment
    Demo::PaymentConfirmation.new(params).process_payment(current_user)    
    respond_to do |format|
      format.all {render nothing: true, status: 200}
    end
  end
  
  private
  
    def build_payment_instruction      
      if params[:demo_payment]
        @payment_instruction = Demo::Payment.new(params[:demo_payment].permit!)
      else
        @payment_instruction = Demo::Payment.new()
      end
      
    end
    
end

