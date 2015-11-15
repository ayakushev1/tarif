module TarifOptimizators::FixedOperatorsHelper
  include SavableInSession::Filtrable, SavableInSession::SessionInitializers

  def calculation_choices
    create_filtrable("calculation_choices")
  end
  
  def services_select
    create_filtrable("services_select")
  end
  
  def update_customer_infos
    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))

    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_optimization_count')      
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
  
  def user_priority
    Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
  end

  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end

  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_or_guest_user_id).select("description->>'accounting_period' as accounting_period").uniq
  end

  def services_by_operator
    result = Customer::Info::ServiceChoices.
      services_from_session_to_optimization_format(Customer::Info::ServiceChoices.default_values(user_type))
    result[:operators] = operators_from_services_select
    result
  end
 
   def operators_from_services_select
     session_filtr_params_services_select = session_filtr_params(services_select)
     result = []    
     {'tel' => 1023, 'bln' => 1025, 'mgf' => 1028, 'mts' => 1030}.each do |operator_name, operator_id|
       result << operator_id if session_filtr_params_services_select[operator_name] ==  "true"
     end
#    raise(StandardError, [session_filtr_params_services_select, result])
    result 
  end
 
  def check_if_optimization_options_are_in_session
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if session[:filtr]['calculation_choices_filtr'].blank?
      session[:filtr]['calculation_choices_filtr'] ||= {}
      session[:filtr]['calculation_choices_filtr']  = Customer::Info::CalculationChoices.info(current_or_guest_user_id).merge({'accounting_period' => accounting_period})
    end

    if session[:filtr]['services_select_filtr'].blank?
      session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = {'tel' => false, 'bln' => false, 'mgf' => false, 'mts' => false}
    end

  end

  def selected_service_categories
#    return @selected_service_categories if @selected_service_categories    
    selected_services = Customer::Info::ServiceCategoriesSelect.default_selected_categories(user_type)
    @selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end
  
end
