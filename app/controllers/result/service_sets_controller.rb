class Result::ServiceSetsController < ApplicationController
  include Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter
  helper Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter

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
  
end
