class Customer::CallRunsController < ApplicationController
  include Crudable
  crudable_actions :all
  include SavableInSession::Tableable
  include Customer::CallRunHelper
  helper Customer::CallRunHelper
#  before_action :init_call_run, only: :calculate_call_stat
  
  before_action :create_call_run_if_not_exists, only: [:index]
  before_action :check_if_allowed_new_call_run, only: [:new, :create]
  before_action :check_if_allowed_delete_call_run, only: [:destroy]
  
  def calculate_call_stat
    call_run.calculate_call_stat
    redirect_to customer_call_stat_path(params[:id]), :notice => "Статистика готова"
  end

  
end
