#    options_for_comparison = [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet]
Comparison::OptimizationType.find_or_create_by(:id => 0).update(
  :name => 'all_operators_no_tarif_options_only_own_and_home_regions_rouming', :for_service_categories => {
  :country_roming => false, :intern_roming => false, :mms => false, :internet => false}, :for_services_by_operator => [])

Comparison::OptimizationType.find_or_create_by(:id => 1).update(
  :name => 'all_operators_all_tarif_optionss_all_rouming', :for_service_categories => {
  :country_roming => true, :intern_roming => true, :mms => true, :internet => true}, :for_services_by_operator => [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet])

Comparison::OptimizationType.find_or_create_by(:id => 2).update(
  :name => 'all_operators_all_tarif_optionss_only_internet_own_region', :for_service_categories => {
  :country_roming => false, :intern_roming => false, :mms => false, :internet => true}, :for_services_by_operator => [:country_rouming, :calls, :internet])

Comparison::OptimizationType.find_or_create_by(:id => 3).update(
  :name => 'all_operators_all_tarif_optionss_only_internet_own_region_and_own_country', :for_service_categories => {
  :country_roming => true, :intern_roming => false, :mms => false, :internet => true}, :for_services_by_operator => [:country_rouming, :calls, :internet])
