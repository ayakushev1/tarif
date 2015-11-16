class Customer::CallRunsController < ApplicationController
  include SavableInSession::Tableable
  include Crudable
  crudable_actions :all
  
  before_action :check_if_allowed_new_call_run, only: [:new, :create]
  
  def customer_call_runs
    create_tableable(Customer::CallRun.where(:user_id => current_or_guest_user_id))
  end
  
  def check_if_allowed_new_call_run
    message = "Вам не разрешено создавать более #{allowed_new_call_run(user_type)}  описаний"
    redirect_to customer_call_runs_path, alert: message
  end
  
  def is_allowed_new_call_run?
    existed_count = Customer::CallRun.where(:user_id => current_or_guest_user_id).count
    existed_count < allowed_new_call_run(user_type) ? true : false
  end
  
  def allowed_new_call_run(user_type = :guest)
    {:guest => 2, :trial => 5, :user => 10, :admin => 100000}[user_type]
  end
  
end
