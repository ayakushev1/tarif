module Comparison::Optimization::Init
  def self.base_params(options)
    services_by_operator = Customer::Info::ServiceChoices.services_for_comparison(options[:operators], options[:for_services_by_operator])
    selected_categories_from_input = Customer::Info::ServiceCategoriesSelect.default_selected_categories(nil, options[:for_service_categories])
    selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_categories_from_input)
    
#    raise(StandardError, services_by_operator)    
    result = {
      :optimization_params => Customer::Info::TarifOptimizationParams.default_values,
      :calculation_choices => {
          "calculate_only_chosen_services"=>"false", 
          "calculate_with_limited_scope"=>"true", 
          "calculate_with_fixed_services"=>"false", 
          "call_run_id"=>options[:call_run_id], 
          "accounting_period"=>options[:accounting_period], 
          "result_run_id"=>options[:result_run_id]
      },
      :selected_service_categories => selected_service_categories,
      :services_by_operator => services_by_operator,
      :temp_value => {
        :user_id => nil,
        :user_region_id => nil,         
        :user_priority => 100,   
      }   
    }
    result
  end
end

=begin
options = {
  :call_run_id => ,
  :accounting_period => ,
  :result_run_id => ,
  :for_service_categories => {
      :country_roming => false,
      :intern_roming => false,
      :mms => false,
      :internet => false,
    
  },
  :for_services_by_operator => [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet],
  :operators => [1023, 1025, 1028, 1030],
} 
  
=end

