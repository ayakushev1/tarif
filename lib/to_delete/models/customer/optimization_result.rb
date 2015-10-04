class Customer::OptimizationResult1 < ActiveType::Object
  attribute :current_user_id, :integer, default: proc {@controller.current_user.id}
  attribute :customer_service_sets, default: proc {
    options = {:base_name => 'service_sets', :current_id_name => 'service_sets_id', :id_name => 'service_sets_id'}
    controller.create_array_of_hashable(final_tarif_results_presenter.customer_service_sets_array, options)}
  attribute :customer_tarif_results, default: proc {
        options = {:base_name => 'service_results', :current_id_name => 'service_id', :id_name => 'service_id'}
        controller.create_array_of_hashable(final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']), options)}
  attribute :customer_tarif_detail_results, default: proc {
    options = {:base_name => 'tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name'}
    controller.create_array_of_hashable(final_tarif_results_presenter.customer_tarif_detail_results_array(session[:current_id]['service_sets_id'], session[:current_id]['service_id']), options)}
  attribute :service_sets, default: proc {
    options = {:base_name => 'service_sets', :current_id_name => 'service_sets_id', :id_name => 'service_sets_id'}
    controller.create_array_of_hashable(optimization_result_presenter.service_sets_array, options)}
  attribute :tarif_results, default: proc {
    options = {:base_name => 'tarif_results', :current_id_name => 'tarif_results_id', :id_name => 'tarif_results_id'}
    controller.create_array_of_hashable(optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']), options)}
  attribute :tarif_results_details, default: proc {
    options = {:base_name => 'tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name'}
    controller.create_array_of_hashable(optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_results_id']), options)}

  attribute :performance_results, default: proc {
    options = {:base_name => 'performace_results', :current_id_name => 'check_point', :id_name => 'check_point'}
    controller.create_array_of_hashable(minor_result_presenter.performance_results, options)}
  attribute :service_packs_by_parts, default: proc {
    options = {:base_name => 'service_packs_by_parts', :current_id_name => 'tarif', :id_name => 'tarif'}
    controller.create_array_of_hashable(minor_result_presenter.service_packs_by_parts_array, options)}
  attribute :memory_used, default: proc {
    options = {:base_name => 'memory_used', :current_id_name => 'objects', :id_name => 'objects'}
    controller.create_array_of_hashable(minor_result_presenter.used_memory_by_output, options)}
  attribute :current_tarif_set_calculation_history, default: proc {
    options = {:base_name => 'current_tarif_set_calculation_history', :current_id_name => 'count', :id_name => 'count'}
    controller.create_array_of_hashable(minor_result_presenter.current_tarif_set_calculation_history, options)}
  attribute :calls_stat, default: proc {
    filtr = controller.session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category'}
    controller.create_array_of_hashable(minor_result_presenter.calls_stat_array(calls_stat_options), options )
  }  
  attribute :optimization_params, default: proc {controller.create_filtrable("optimization_params")}
  attribute :calls_stat_options, default: proc {controller.create_filtrable("calls_stat_options")}
  attr_reader :controller

  def initialize(controller, init_values = {})
    super init_values
    @controller = controller
  end 

  def what_format_of_results
    optimization_params_session_info['what_format_of_results'] || 'results_by_services'
  end
    
  def optimization_result_presenter
    optimization_params_session_filtr_params = controller.session_filtr_params(optimization_params)
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

