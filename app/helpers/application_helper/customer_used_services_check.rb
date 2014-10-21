module ApplicationHelper::CustomerUsedServicesCheck

  def redirect_to_make_payment_invitation_page_if_no_free_trials_left
    if fobidden_to_visit_customer_with_no_free_trials(controller_name) and !customer_has_free_trials?(controller_name)
      trial_message = case controller_name
      when 'calls'
          "моделирования звонков"
      when 'history_parsers'
        "загрузки звонков"
      else
        "подбора тарифа"
      end
      redirect_to(root_path, alert: "У вас нет доступных попыток #{trial_message}. Можете перевести деньги для получения новых")
    end      
  end
  
  def customer_has_free_trials?(controller_name_1 = controller_name)
    free_trials = Customer::Info::ServicesUsed.info(current_user) || {}
    case 
    when['calls', 'history_parsers'].include?(controller_name)
      (free_trials['calls_modelling_count'] < 1 or free_trials['calls_parsing_count'] < 1) ? false : true
    when controller_name_1 == 'tarif_optimizators'
      (free_trials['tarif_optimization_count'] < 1) ? false : true
    when controller_name_1 == 'optimization_steps'
      (free_trials['tarif_optimization_count'] < 1) ? false : true
    when controller_name_1 == 'optimization_steps'
      (free_trials['optimization_steps'] < 1 and free_trials['calls_parsing_count'] < 1 and free_trials['tarif_optimization_count'] < 1) ? false : true
    else
      true
    end
  end
  
  protected
  
  def fobidden_to_visit_customer_with_no_free_trials(controller_name_1 = controller_name)
    ['optimization_steps', 'calls', 'history_parsers', 'tarif_optimizators'].include?(controller_name_1)
  end

end
