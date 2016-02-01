class Result::RunsController < ApplicationController
  include Result::RunsHelper
  helper Result::RunsHelper
  include SavableInSession::Tableable
  include Crudable
  crudable_actions :all
  
#  before_filter :check_before_freindly_url, only: [:show]

  before_action :create_result_run_if_not_exists, only: [:index]
#  before_action :check_if_allowed_new_result_run, only: [:new, :create]
  before_action :check_if_allowed_delete_result_run, only: [:destroy]
#  before_action :set_run_id, only: :index
  before_action :set_back_path, only: [:index]
  
  add_breadcrumb I18n.t(:result_runs_path), :result_runs_path
  
  def show
    add_breadcrumb result_run_form.model.try(:name), result_run_path(params[:id])
  end
  
  def edit
    add_breadcrumb "Редактирование #{result_run_form.model.try(:name)}", edit_result_run_path(params[:id])
  end
  
  def check_before_freindly_url
    @runn = Result::Run.where(:id => params[:id]).first
    if @runn and request.path != result_run_path(@runn)
      redirect_to result_run_path(@runn), :status => :moved_permanently
    end if params[:id]
  end

end
