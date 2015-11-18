class Customer::CallRunsController < ApplicationController
  include SavableInSession::Tableable
  include Crudable
  crudable_actions :all
  
  before_action :check_if_allowed_new_call_run, only: [:new, :create]
  before_action :check_if_allowed_delete_call_run, only: [:destroy]
  
  def customer_call_runs
    create_tableable(Customer::CallRun.where(:user_id => current_or_guest_user_id))
  end
  
  def check_if_allowed_new_call_run
    message = "Вам не разрешено создавать более #{allowed_new_call_run(user_type)}  описаний"
    redirect_to( customer_call_runs_path, alert: message) if !is_allowed_new_call_run?
  end
  
  def check_if_allowed_delete_call_run
    message = "Нельзя удалять последнее описание"
    redirect_to( customer_call_runs_path, alert: message) if customer_call_runs_count < (Customer::CallRun.min_new_call_run(user_type) + 1)
  end
  
  def is_allowed_new_call_run?
    customer_call_runs_count < allowed_new_call_run(user_type) ? true : false
  end
  
  def customer_call_runs_count
    Customer::CallRun.where(:user_id => current_or_guest_user_id).count
  end
  
  def allowed_new_call_run(user_type = :guest)
    Customer::CallRun.allowed_new_call_run(user_type)
  end
  
end
