module ApplicationHelper::CustomerUsedServicesCheck

  def redirect_to_make_payment_invitation_page_if_no_free_trials_left
    if fobidden_to_visit_customer_with_no_free_trials and !customer_has_free_trials?
      redirect_to(root_path, alert: 'У вас нет доступных попыток подбора тарифа. Можете перевести деньги для получения новых')
    end      
  end
  
  def customer_has_free_trials?
    Customer::Info.has_free_trials?(current_user)
  end
  
  protected
  
  def fobidden_to_visit_customer_with_no_free_trials
    ['optimization_steps', 'calls', 'history_parser', 'tarif_optimizator'].include?(controller_name)
  end

end
