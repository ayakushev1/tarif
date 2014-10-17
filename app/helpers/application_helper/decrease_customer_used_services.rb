module ApplicationHelper::DecreaseCustomerUsedServices

#  protected
  
  def decrease_customer_allowed_services_count(service_used)
    User.transaction do
      Customer::Info.decrease_one_free_trials_by_one(current_user.id, service_used.to_s)
      current_user.customer_transactions_services_used.create(:status => {}, :description => {:operation => "decrease #{service_used} by 1"}, :made_at => Time.zone.now)
    end    
  end
end
