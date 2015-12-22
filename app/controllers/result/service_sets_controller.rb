class Result::ServiceSetsController < ApplicationController
  include Result::ServiceSetsHelper
  helper Result::ServiceSetsHelper

  before_action :set_back_path, only: [:results, :result]
  
end
