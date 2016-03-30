class Result::ServiceSetsController < ApplicationController
  include Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter
  helper Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter

  before_filter :check_before_freindly_url, only: [:result, :detailed_results]

  before_action :set_back_path, only: [:results, :result]
  before_action :set_initial_breadcrumb_for_service_sets_result, only: [:result, :compare, :detailed_results]
  before_action :set_initial_breadcrumb_for_service_sets_detailed_result, only: [:detailed_results]
  
  def compare
    add_breadcrumb "Сравнение тарифов", result_compare_path
  end
  
  def results
    add_breadcrumb "Сохраненные результаты подбора", result_service_sets_results_path
    add_breadcrumb result_service_sets.model.first.try(:run).try(:name), result_service_sets_results_path
  end
  
  def result
    add_breadcrumb "Результаты подбора"
  end
  
  def detailed_results
    add_breadcrumb results_service_set.try(:full_name), result_service_sets_detailed_results_path(results_service_set.try(:run))
  end

  def check_before_freindly_url
    @runn = Result::Run.friendly.find(params[:result_run_id])
    if @runn and request.path != path_from_action(action_name.to_sym, @runn)
      redirect_to path_from_action(action_name.to_sym, @runn), :status => :moved_permanently
    end if params[:result_run_id]
  end
  
  def path_from_action(action, object)
    case action
    when :result; result_service_sets_result_path(object)
    when :detailed_results; result_service_sets_detailed_results_path(object)
    end
  end
  
end
