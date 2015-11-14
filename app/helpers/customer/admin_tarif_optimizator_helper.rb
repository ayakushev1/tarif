module Customer::AdminTarifOptimizatorHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def optimization_params
    create_filtrable("optimization_params")
  end
  
  def service_choices
    create_filtrable("service_choices")
  end
  
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
    Customer::Info::ServicesSelect.update_info(current_or_guest_user_id, session_filtr_params(services_select)) if user_type == :admin
    Customer::Info::ServiceChoices.update_info(current_or_guest_user_id, session_filtr_params(service_choices)) if user_type == :admin
    Customer::Info::TarifOptimizationParams.update_info(current_or_guest_user_id, session_filtr_params(optimization_params)) if user_type == :admin

    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))
    Customer::Info::ServiceCategoriesSelect.update_info(current_or_guest_user_id, session_filtr_params(service_categories_select))

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_recalculation_count')
    else
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_optimization_count')      
    end
  end

  def options
    session_filtr_params_services_select = user_type == :admin ? session_filtr_params(services_select) : Customer::Info::ServicesSelect.default_values(user_type) #just in case for future
    {
      :optimization_params => session_filtr_params_optimization_params,
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
  
  def user_priority
    Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
  end

  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end

  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_or_guest_user_id).select("description->>'accounting_period' as accounting_period").uniq
  end

#  def operator
#    optimization_params_session_filtr_params = session_filtr_params(optimization_params)
#    optimization_params_session_filtr_params['operator_id'].blank? ? 1030 : optimization_params_session_filtr_params['operator_id'].to_i
#  end
  
  def session_filtr_params_optimization_params
    user_type == :admin ? session_filtr_params(optimization_params) : Customer::Info::TarifOptimizationParams.default_values
  end

  def services_by_operator
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? services_by_operator_for_calculate_with_fixed_services :  services_by_operator_for_calculate_with_all_services
  end
  
  def services_by_operator_for_calculate_with_fixed_services
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    operator_id = services_for_calculation_select_session_filtr_params['operator_id'].to_i
    {
      :operators => [operator_id], 
      :tarifs => {services_for_calculation_select_session_filtr_params['operator_id'].to_i => [services_for_calculation_select_session_filtr_params['tarif_to_calculate'].to_i]}, 
      :tarif_options => {services_for_calculation_select_session_filtr_params['operator_id'].to_i => services_for_calculation_select_session_filtr_params['tarif_options_to_calculate'].map(&:to_i) - [0]}, 
      :common_services => Customer::Info::ServiceChoices.common_services[operator_id],
     }
  end
  
  def services_by_operator_for_calculate_with_all_services
    service_choices_session_filtr_params = user_type == :admin ? session_filtr_params(service_choices) : Customer::Info::ServiceChoices.default_values(user_type)
    Customer::Info::ServiceChoices.services_from_session_to_optimization_format(service_choices_session_filtr_params)
  end

  def validate_tarifs
    params['service_choices_filtr'].merge!(Customer::Info::ServiceChoices.validate_tarifs(params['service_choices_filtr'])) if params['service_choices_filtr']
  end
  
  def check_if_optimization_options_are_in_session
    if session[:filtr]['service_choices_filtr'].blank? and user_type == :admin
      session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = Customer::Info::ServiceChoices.info(current_or_guest_user_id)
    end

    if session[:filtr]['services_select_filtr'].blank? and user_type == :admin
      session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = Customer::Info::ServicesSelect.info(current_or_guest_user_id)
    end
    
    if session[:filtr]['optimization_params_filtr'].blank? and user_type == :admin
      session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = Customer::Info::TarifOptimizationParams.info(current_or_guest_user_id)
    end
    
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
