class Result::RunsController < ApplicationController
  include Result::RunsHelper
  
  def results
#    @result_service_set = Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id).order(:price).
#      paginate(page: 1, :per_page => 10)
  end

end
