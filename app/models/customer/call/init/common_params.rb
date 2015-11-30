module Customer::Call::Init
  CommonParams = {
    "country_id"=>1100, 
    "region_id"=>1238, 
#    "operator_id"=>1030, 
    "privacy_id"=>2, 
    :own_region=> {
#      "phone_usage_type_id"=>201, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=>1238,
      "region_for_region_calls_ids"=>1255, 
      "country_for_international_calls_ids"=>1632, 
    },  
    :home_region=> {
#      "phone_usage_type_id"=>211, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=>1127,
    }, 
    :own_country=>{
#      "phone_usage_type_id"=>221, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=>1255,
    }, 
    :abroad=>{
#      "phone_usage_type_id"=>234, 
      "continent_id"=>1591, 
      "roumin_country_id"=>1500,
    } 
  }

end

