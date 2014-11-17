class Demo::PaymentsController < ApplicationController
  before_action :build_payment_instruction, only: [:new, :create]
  attr_reader :payment_confirmation
  after_action :track_new, only: :new
  after_action :track_create, only: :create
  after_action :track_process_payment, only: :process_payment

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
    @payment_confirmation = Demo::PaymentConfirmation.new(params)
    payment_confirmation.process_payment    
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

  def track_new
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
      'params' => params,
    })
  end

  def track_create
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
      'params' => params,
      'valid' => @payment_instruction.valid?,
      'yandex_params' => @payment_instruction.url_to_yandex(current_user),
    })
  end

  def track_process_payment
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
      'params' => params,
    })
  end

    
end

