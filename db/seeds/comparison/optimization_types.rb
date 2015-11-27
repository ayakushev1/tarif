Comparison::OptimizationType.find_or_create_by(:id => 0).update(
  :name => 'all_operators_tarifs_only_own_and_home_regions', :for_service_categories => {
  :country_roming => true, :intern_roming => true, :mms => true, :internet => true}, :for_services_by_operator => [])
