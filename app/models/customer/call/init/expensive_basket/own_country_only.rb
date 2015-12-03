#:categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_europe, :operator => _service_to_not_own_operator}},

module Customer::Call::Init::ExpensiveBasket
  OwnCountryOnly = { 
    :general=> {
#    "phone_usage_type_id"=>243, 
      "share_of_time_in_own_region"=>0.9, 
      "share_of_time_in_home_region"=>0.0, 
      "share_of_time_in_own_country"=>0.1, 
      "share_of_time_abroad"=>0.0
    }.merge(Customer::Call::Init::CommonParams.slice("country_id", "region_id", "privacy_id")), 
    :own_region=> {
      "number_of_day_calls"=>20, 
      "duration_of_calls"=>2.01, 
      "share_of_calls_to_other_mobile"=>0.38, 
      "share_of_calls_to_fix_line"=>0.15, 
      "share_of_regional_calls"=>0.0, 
      "share_of_international_calls"=>0.0, 
      "number_of_sms_per_day"=>15, 
      "number_of_mms_per_day"=>0, 
      "internet_trafic_per_month"=>3.0, 
      "share_of_incoming_calls"=>0.5, 
      "share_of_incoming_calls_from_own_mobile"=>0.47
     }, 
    :home_region=> {
      "number_of_day_calls"=>20, 
      "duration_of_calls"=>2.01, 
      "share_of_calls_to_other_mobile"=>0.38, 
      "share_of_calls_to_fix_line"=>0.15, 
      "share_of_regional_calls"=>0.0, 
      "share_of_international_calls"=>0.0, 
      "number_of_sms_per_day"=>15, 
      "number_of_mms_per_day"=>0, 
      "internet_trafic_per_month"=>3.0, 
      "share_of_incoming_calls"=>0.5, 
      "share_of_incoming_calls_from_own_mobile"=>0.47
    }, 
    :own_country=>{
      "number_of_day_calls"=>20, 
      "duration_of_calls"=>2.01, 
      "share_of_calls_to_other_mobile"=>0.38, 
      "share_of_calls_to_fix_line"=>0.15, 
      "share_of_regional_calls"=>0.0, 
      "share_of_international_calls"=>0.0, 
      "number_of_sms_per_day"=>15, 
      "number_of_mms_per_day"=>0, 
      "internet_trafic_per_month"=>3.0, 
      "share_of_incoming_calls"=>0.5, 
      "share_of_incoming_calls_from_own_mobile"=>0.47
    }, 
    :abroad=>{
      "number_of_day_calls"=>20, 
      "duration_of_calls"=>2.01, 
      "share_of_calls_to_other_mobile"=>0.38, 
      "share_of_calls_to_fix_line"=>0.15, 
      "share_of_regional_calls"=>0.0, 
      "share_of_international_calls"=>0.0, 
      "number_of_sms_per_day"=>15, 
      "number_of_mms_per_day"=>0, 
      "internet_trafic_per_month"=>3.0, 
      "share_of_incoming_calls"=>0.5, 
      "share_of_incoming_calls_from_own_mobile"=>0.47
    },
  }.deep_merge(Customer::Call::Init::CommonParams.slice(:own_region, :home_region, :own_country, :abroad))

end

