module TarifOptimizators::AllOptionsHelper
  include TarifOptimizators::SharedHelper
  include SavableInSession::Filtrable, SavableInSession::SessionInitializers

  def calculation_choices
    create_filtrable("calculation_choices")
  end
  
  def services_select
    create_filtrable("services_select")
  end
  
  def services_for_calculation_select
    create_filtrable("services_for_calculation_select")
  end

  def show_service_categories_select_tab
    session_filtr_params(calculation_choices)['calculate_with_limited_scope'] == 'true' ? true : false
  end
  
  def show_services_for_calculation_select_tab
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? true : false
  end

  def update_customer_infos
    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))
    Customer::Info::ServiceCategoriesSelect.update_info(current_or_guest_user_id, session_filtr_params(service_categories_select))

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_recalculation_count')
    else
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_optimization_count')      
    end
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
        :new_run_id => new_run_id,
        :user_id => current_or_guest_user_id,
        :user_region_id => nil,         
        :user_priority => user_priority,      
      }
    }
  end
  
  def services_by_operator
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? services_by_operator_for_calculate_with_fixed_services :  
      Customer::Info::ServiceChoices.services_from_session_to_optimization_format(Customer::Info::ServiceChoices.default_values(user_type))
  end
  
  def services_by_operator_for_calculate_with_fixed_services
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
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if session[:filtr]['calculation_choices_filtr'].blank?
      session[:filtr]['calculation_choices_filtr'] ||= {}
      session[:filtr]['calculation_choices_filtr']  = Customer::Info::CalculationChoices.info(current_or_guest_user_id).merge({'accounting_period' => accounting_period})
    end

    if !session[:filtr] or session[:filtr]['service_categories_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_categories_select_filtr'] ||= {}
      session[:filtr]['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.info(current_or_guest_user_id, user_type)
    end
    
#    raise(StandardError, )
  end

  def service_categories_select
    if params['service_categories_select_filtr']
      selected_services = Customer::Info::ServiceCategoriesSelect.selected_services_from_session_format(params['service_categories_select_filtr'], user_type)
      params['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.selected_services_to_session_format(selected_services)
    end
    create_filtrable("service_categories_select")
  end
  
  def selected_service_categories
#    return @selected_service_categories if @selected_service_categories    
    selected_services = Customer::Info::ServiceCategoriesSelect.selected_services_from_session_format(session_filtr_params(service_categories_select), user_type)
    @selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end
  
end
