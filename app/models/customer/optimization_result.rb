class Customer::OptimizationResult < ActiveType::Object
  attribute :current_user_id, :integer, default: proc {@controller.current_user.id}
  attribute :customer_service_sets, default: proc {ArrayOfHashable.new(controller, final_tarif_results_presenter.customer_service_sets_array)}
  attribute :customer_tarif_results, default: proc {ArrayOfHashable.new(controller, final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']))}
  attribute :customer_tarif_detail_results, default: proc {ArrayOfHashable.new(controller, final_tarif_results_presenter.customer_tarif_detail_results_array(session[:current_id]['service_sets_id'], session[:current_id]['service_id']))}
  attribute :service_sets, default: proc {ArrayOfHashable.new(controller, optimization_result_presenter.service_sets_array)}
  attribute :tarif_results, default: proc {ArrayOfHashable.new(controller, optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']))}
  attribute :tarif_results_details, default: proc {ArrayOfHashable.new(controller, optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_class_id']))}

  attribute :performance_results, default: proc {ArrayOfHashable.new(controller, minor_result_presenter.performance_results )}
  attribute :service_packs_by_parts, default: proc {ArrayOfHashable.new(controller, minor_result_presenter.service_packs_by_parts_array )}
  attribute :memory_used, default: proc {ArrayOfHashable.new(controller, minor_result_presenter.used_memory_by_output )}
  attribute :current_tarif_set_calculation_history, default: proc {ArrayOfHashable.new(controller, minor_result_presenter.current_tarif_set_calculation_history )}
  attribute :calls_stat, default: proc {
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    ArrayOfHashable.new(controller, minor_result_presenter.calls_stat_array(calls_stat_options) )
  }  
  attribute :optimization_params, default: proc {Filtrable.new(controller, "optimization_params")}
  attribute :calls_stat_options, default: proc {Filtrable.new(controller, "calls_stat_options")}
  attr_reader :controller

  def initialize(controller, init_values = {})
    super init_values
    @controller = controller
  end 

  def what_format_of_results
    optimization_params_session_info['what_format_of_results'] || 'results_by_services'
  end
    
  def optimization_result_presenter
    options = {
      :user_id=> current_user_id,
      :service_set_based_on_tarif_sets_or_tarif_results => optimization_params.session_filtr_params['service_set_based_on_tarif_sets_or_tarif_results'],
      :show_zero_tarif_result_by_parts => optimization_params.session_filtr_params['show_zero_tarif_result_by_parts'],
      :use_price_comparison_in_current_tarif_set_calculation => optimization_params.session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
      :max_tarif_set_count_per_tarif => optimization_params.session_filtr_params['max_tarif_set_count_per_tarif'],
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
  
  def user_session
    controller.user_session
  end
  
  def session
    controller.session
  end
  
  def persisted?
    false
  end  
end

