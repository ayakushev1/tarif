class Demo::PaymentsController < ApplicationController

  before_action :init_payment_instruction, only: :fill_payment_form
  
  def send_payment_form
    @payment_instruction = Demo::PaymentInstructionToYandex.new(payment_params)
    if @payment_instruction.valid?        
        
      transaction_id = current_user.customer_transactions_cash.create(:status => {}, :description => {}, :made_at => Time.zone.now)
      instruction_params = @payment_instruction.to_yandex_params(:label => transaction_id)
      current_user.customer_transactions_cash.find(transaction_id).update(:description => instruction_params)
      
      redirect_to url_to_yandex(instruction_params)
#      raise(StandardError)
    else
      #raise(StandardError)
      render :fill_payment_form#, :alert => @payment_instruction.errors.full_messages
    end
  end
  
  def wait_for_payment_being_processed
    if customer_has_free_trials?
      redirect_to demo_optimization_steps_choose_load_calls_options_path
    end
  end
  
  def process_payment
    payment_confirmation = Demo::PaymentConfirmationFromYandex.new(params)
    
    UserMailer.send_mail_to_admin_that_something_wrong_with_confirmation(payment_confirmation) if !payment_confirmation.valid?
    UserMailer.send_mail_to_admin_that_something_wrong_with_confirmation(payment_confirmation) if !payment_confirmation.check_hash

    transaction_id = payment_confirmation.label
    user_id = Customer::Transaction.where(:id => transaction_id).first.user_id if Customer::Transaction.where(:id => transaction_id).exists?
    User.transaction do
      Customer::Info.update_free_trials_by_cash_amount(user_id, payment_confirmation.amount)
      Customer::Transaction.services_used.where(:user_id => user_id).create(:status => {}, :description => payment_confirmation.to_json, :made_at => Time.zone.now)
    end

    respond_to do |format|
      format.yandex_payment_notification {render nothing: true, status: 200}
      format.html {render nothing: true, status: 200}
    end
  end
  
  def payment_instruction_form
    Formable.new(self, @payment_instruction)
  end

  private
    def url_to_yandex(instruction_params)
      "https://money.yandex.ru/quickpay/confirm.xml?#{instruction_params.to_param}" #ERB::Util.url_encode() 
    end
    
    def init_payment_instruction
      @payment_instruction = Demo::PaymentInstructionToYandex.new()
    end
  
    def payment_params
      params.require(:payment_instruction).permit!
    end
    
end

