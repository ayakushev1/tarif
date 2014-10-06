class Customer::OptimizationResultsController < ApplicationController
#  def show_results; end
#  def show_customer_results; end
#  def show_additional_info; end
  
  def customer_service_sets
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_service_sets_array)
  end
  
  def customer_tarif_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']))
  end

  def customer_tarif_detail_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_detail_results_array(
      session[:current_id]['service_sets_id'], session[:current_id]['service_id']))
  end
  
  def service_sets
    ArrayOfHashable.new(self, optimization_result_presenter.service_sets_array)
  end
  
  def tarif_results
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']))
  end
  
  def tarif_results_details
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_class_id']))
  end
  
  def calls_stat_options
    Filtrable.new(self, "calls_stat_options")
  end
  
  def calls_stat
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    ArrayOfHashable.new(self, minor_result_presenter.calls_stat_array(calls_stat_options) )
  end
  
  def performance_results
    ArrayOfHashable.new(self, minor_result_presenter.performance_results )    
  end
  
  def service_packs_by_parts
    ArrayOfHashable.new(self, minor_result_presenter.service_packs_by_parts_array )    
  end
  
  def memory_used
    ArrayOfHashable.new(self, minor_result_presenter.used_memory_by_output )    
  end
  
  def current_tarif_set_calculation_history
    ArrayOfHashable.new(self, minor_result_presenter.current_tarif_set_calculation_history )   
  end

  def what_format_of_results
    optimization_params_session_info['what_format_of_results'] || 'results_by_services'
  end
    
  
  def optimization_result_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :service_set_based_on_tarif_sets_or_tarif_results => optimization_params.session_filtr_params['service_set_based_on_tarif_sets_or_tarif_results'],
      :show_zero_tarif_result_by_parts => optimization_params.session_filtr_params['show_zero_tarif_result_by_parts'],
      :use_price_comparison_in_current_tarif_set_calculation => optimization_params.session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
      :max_tarif_set_count_per_tarif => optimization_params.session_filtr_params['max_tarif_set_count_per_tarif'],
      }
    @optimization_result_presenter ||= ServiceHelper::OptimizationResultPresenter.new(options)
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :show_zero_tarif_result_by_parts => (optimization_params_session_info['show_zero_tarif_result_by_parts'] || 'false'),
      }
    @optimization_result_presenter ||= ServiceHelper::FinalTarifResultsPresenter.new(options)
  end
  
  def minor_result_presenter
    @minor_result_presenter ||= ServiceHelper::AdditionalOptimizationInfoPresenter.new({:user_id=> (current_user ? current_user.id.to_i : nil) })
  end   
  
  def optimization_params_session_info
    (session[:filtr] and session[:filtr]['optimization_params_filtr']) ? session[:filtr]['optimization_params_filtr'] : {}
  end

end
