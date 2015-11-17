module TarifOptimizators::FixedServicesHelper
  include TarifOptimizators::SharedHelper
  include SavableInSession::Filtrable, SavableInSession::SessionInitializers
  
  def services_for_calculation_select
    create_filtrable("services_for_calculation_select")
  end

  def update_customer_infos
    update_result_run_on_calculation(options)
    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))

    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_recalculation_count')
  end

  def options
    session_filtr_params_services_select = Customer::Info::ServicesSelect.default_values(user_type) #just in case for future
    {
      :optimization_params => Customer::Info::TarifOptimizationParams.default_values,
#      :service_choices => session_filtr_params(service_choices),
      :calculation_choices => session_filtr_params(calculation_choices),
      :selected_service_categories => selected_service_categories,
      :services_by_operator => services_by_operator,
      :temp_value => {
        :user_id => current_or_guest_user_id,
        :user_region_id => nil,         
        :user_priority => user_priority,      
      }
    }
  end
  
  def services_by_operator
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    operator_id = services_for_calculation_select_session_filtr_params['operator_id'].to_i
    {
      :operators => [operator_id], 
      :tarifs => {operator_id => [services_for_calculation_select_session_filtr_params['tarif_to_calculate'].to_i]}, 
      :tarif_options => {operator_id => services_for_calculation_select_session_filtr_params['tarif_options_to_calculate'].map(&:to_i) - [0]}, 
      :common_services => {operator_id => Customer::Info::ServiceChoices.common_services[operator_id]},
     }
  end
  
  def check_if_optimization_options_are_in_session
    if session[:filtr]['calculation_choices_filtr'].blank?
      session[:filtr]['calculation_choices_filtr'] ||= {}
      session[:filtr]['calculation_choices_filtr']  = Customer::Info::CalculationChoices.info(current_or_guest_user_id).
        merge({'call_run_id' => customer_call_run_id, 'accounting_period' => accounting_period})
    end

  end
  def selected_service_categories
#    return @selected_service_categories if @selected_service_categories    
    selected_services = Customer::Info::ServiceCategoriesSelect.default_selected_categories(user_type)
    @selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end
  
end
