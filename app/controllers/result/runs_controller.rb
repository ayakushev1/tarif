class Result::RunsController < ApplicationController
  include Result::RunsHelper
  include SavableInSession::Tableable
  include Crudable
  crudable_actions :all
  
  before_action :check_if_allowed_new_result_run, only: [:new, :create]
  before_action :check_if_allowed_delete_result_run, only: [:destroy]
  
  
end
