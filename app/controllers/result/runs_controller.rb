class Result::RunsController < ApplicationController
  include Result::RunsHelper
  include SavableInSession::Tableable
  include Crudable
  crudable_actions :all
  
  before_action :create_result_run_if_not_exists, only: [:index]
  before_action :check_if_allowed_new_result_run, only: [:new, :create]
  before_action :check_if_allowed_delete_result_run, only: [:destroy]
  
  
end
