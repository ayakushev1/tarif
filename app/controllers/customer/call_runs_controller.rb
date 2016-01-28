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
  
  add_breadcrumb I18n.t(:customer_call_runs_path), :customer_call_runs_path
  
  def show
    add_breadcrumb customer_call_run_form.model.try(:name), customer_call_run_path(params[:id])
  end
  
  def edit
    add_breadcrumb "Редактирование #{customer_call_run_form.model.try(:name)}", edit_customer_call_run_path(params[:id])
  end
  
  def call_stat
    customer_call_run = Customer::CallRun.where(:id => params[:id]).first
    add_breadcrumb customer_call_run.try(:name), customer_call_stat_path(params[:id])
  end

  def calculate_call_stat
    call_run.calculate_call_stat
    redirect_to customer_call_stat_path(params[:id]), :notice => "Статистика готова", status: :moved_permanently
  end

  
end
