module ApplicationHelper::CustomerUsedServicesCheck

  def is_user_calculating_now
    Delayed::Job.where(:queue => "tarif_optimization", :attempts => 0, :reference_id => current_or_guest_user_id, :reference_type => 'user').exists?
  end

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
    return true
    case 
    when controller_name_1 == 'calls'
      customer_has_free_calls_modelling_trials?
    when controller_name_1 == 'history_parsers'
      customer_has_free_history_parsing_trials?
    when controller_name_1 == 'tarif_optimizators'
      (customer_has_free_tarif_optimization_trials? or customer_has_free_tarif_recalculation_trials?)
    when controller_name_1 == 'optimization_steps'
      customer_has_free_calls_modelling_trials? and customer_has_free_history_parsing_trials? and 
        (customer_has_free_tarif_optimization_trials? or customer_has_free_tarif_recalculation_trials?)
    else
      false
    end
  end

  def customer_has_free_calls_modelling_trials?
    return true
    return false if !current_or_guest_user
    (customer_info and customer_info['calls_modelling_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_history_parsing_trials?
    return true
    return false if !current_or_guest_user
    (customer_info and customer_info['calls_parsing_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_tarif_optimization_trials?
    return true
    return false if !current_or_guest_user
    (customer_info and customer_info['tarif_optimization_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_tarif_recalculation_trials?
    return true
    return false if !current_or_guest_user
    (customer_info and (customer_info['tarif_recalculation_count'] || 0) < 1 ) ? false : true
  end
  
  def customer_has_calls_loaded?
    return false if !current_or_guest_user
    (customer_info and customer_info['has_calls_loaded'] == true ) ? true : false
  end
  
  def customer_has_tarif_optimized?
    return false if !current_or_guest_user
#    raise(StandardError)
    (customer_info and customer_info['has_tarif_optimized'] == true ) ? true : false
  end
  
  def customer_paid_trials?
    return false if !current_or_guest_user
    (customer_info and customer_info['paid_trials'] == true ) ? true : false
  end
      
  protected
  
  def customer_info
#    @customer_info ||= 
    Customer::Info::ServicesUsed.info(current_or_guest_user.id)
  end
  
  def fobidden_to_visit_customer_with_no_free_trials(controller_name_1 = controller_name)
    ['optimization_steps', 'calls', 'history_parsers', 'tarif_optimizators'].include?(controller_name_1)
  end

end
