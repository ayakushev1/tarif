module Customer::OptimizationResultsHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::ProgressBarable, SavableInSession::SessionInitializers
  
  def current_user_id
    current_user.id
  end
  
  def customer_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_sets_id', :id_name => 'service_sets_id'}
    result = create_array_of_hashable(final_tarif_results_presenter.customer_service_sets_array, options)
#    raise(StandardError)
  end
  
  def customer_tarif_results
    options = {:base_name => 'service_results', :current_id_name => 'service_id', :id_name => 'service_id'}
    create_array_of_hashable(final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']), options)
  end
  
  def customer_tarif_detail_results
    options = {:base_name => 'tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name'}
    create_array_of_hashable(final_tarif_results_presenter.customer_tarif_detail_results_array(session[:current_id]['service_sets_id'], session[:current_id]['service_id']), options)
  end
  
  def service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_sets_id', :id_name => 'service_sets_id'}
    create_array_of_hashable(optimization_result_presenter.service_sets_array, options)
  end
  
  def tarif_results
    options = {:base_name => 'tarif_results', :current_id_name => 'tarif_results_id', :id_name => 'tarif_results_id'}
    create_array_of_hashable(optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']), options)
  end
  
  def tarif_results_details
    options = {:base_name => 'tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name'}
    create_array_of_hashable(optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_results_id']), options)
  end

  def performance_results
    options = {:base_name => 'performace_results', :current_id_name => 'check_point', :id_name => 'check_point'}
    create_array_of_hashable(minor_result_presenter.performance_results, options)
  end
  
  def service_packs_by_parts
    options = {:base_name => 'service_packs_by_parts', :current_id_name => 'tarif', :id_name => 'tarif'}
    create_array_of_hashable(minor_result_presenter.service_packs_by_parts_array, options)
  end
  
  def memory_used
    options = {:base_name => 'memory_used', :current_id_name => 'objects', :id_name => 'objects'}
    create_array_of_hashable(minor_result_presenter.used_memory_by_output, options)
  end
  
  def current_tarif_set_calculation_history
    options = {:base_name => 'current_tarif_set_calculation_history', :current_id_name => 'count', :id_name => 'count'}
    create_array_of_hashable(minor_result_presenter.current_tarif_set_calculation_history, options)
  end
  
  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category'}
    create_array_of_hashable(minor_result_presenter.calls_stat_array(calls_stat_options), options )
  end
   
  def optimization_params
    create_filtrable("optimization_params")
  end
  
  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def what_format_of_results
    optimization_params_session_info['what_format_of_results'] || 'results_by_services'
  end
    
  def optimization_result_presenter
    optimization_params_session_filtr_params = session_filtr_params(optimization_params)
    options = {
      :user_id=> current_user_id,
      :service_set_based_on_tarif_sets_or_tarif_results => optimization_params_session_filtr_params['service_set_based_on_tarif_sets_or_tarif_results'],
      :show_zero_tarif_result_by_parts => optimization_params_session_filtr_params['show_zero_tarif_result_by_parts'],
      :use_price_comparison_in_current_tarif_set_calculation => optimization_params_session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
      :max_tarif_set_count_per_tarif => optimization_params_session_filtr_params['max_tarif_set_count_per_tarif'],
      }
    @optimization_result_presenter ||= Customers::OptimizationResultPresenter.new(options)
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> current_user_id,
      :show_zero_tarif_result_by_parts => (optimization_params_session_info['show_zero_tarif_result_by_parts'] || 'false'),
      }
    @optimization_result_presenter ||= Customers::FinalTarifResultsPresenter.new(options)
  end
  
  def minor_result_presenter
    @minor_result_presenter ||= Customers::AdditionalOptimizationInfoPresenter.new({:user_id=> current_user_id })
  end   
  
  def optimization_params_session_info
    (session[:filtr] and session[:filtr]['optimization_params_filtr']) ? session[:filtr]['optimization_params_filtr'] : {}
  end
end
