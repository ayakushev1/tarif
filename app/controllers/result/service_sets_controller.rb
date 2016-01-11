class Result::ServiceSetsController < ApplicationController
  include Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter
  helper Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter

  before_action :set_back_path, only: [:results, :result]
  
end
