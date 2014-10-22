Customer::Info.delete_all
User.all.each do |user|
  user.send(:create_customer_infos_services_used_if_it_not_exists)
end
