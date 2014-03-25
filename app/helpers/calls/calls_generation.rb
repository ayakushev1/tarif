module Calls::CallsGeneration
  def generate_calls(params_to_search_optimal_tarif)
    prms = params_to_search_optimal_tarif
    initials = set_initial_inputs(prms)
    calls = []
    Call.delete_all
    
# Set calls        
    (0..initials["number_of_days_in_call_list"]).each do |day|
      (0..(prms["number_of_day_calls"]).to_i).each do |i|
# Set constant data            
      call = set_default_call(initials)
            
# Set calls by operator
        case rand
        when 0..initials["share_of_calls_to_own_mobile"]
          call[:partner_phone][:operator_id] = initials["own_operator_id"]
        when initials["share_of_calls_to_own_mobile"]..initials["share_of_calls_to_others_mobile"]
          call[:partner_phone][:operator_id] = initials["others_operator_id"]
        when initials["share_of_calls_to_others_mobile"]..1
          call[:partner_phone][:operator_id] = initials["fixed_operator_id"]
        end
      
# Set calls by region
        case rand
        when 0..initials["share_of_local_calls"]
          call[:partner_phone][:region_id] = initials["own_region_id"]
        when initials["share_of_local_calls"]..initials["share_of_international_calls"]
          call[:partner_phone][:region_id] = initials["region_for_region_calls_id"]
        when initials["share_of_international_calls"]..1
          call[:partner_phone][:operator_id] = initials["others_operator_id"]
          call[:partner_phone][:region_id] = initials["region_for_international_calls_id"]
        end

# Set calls description
        call[:description][:time] = initials["start_date"].
          change(:start => initials["start_date"], :day => (day + 1), :hour => rand(24), :minute => rand(60), :sec => rand(60))
        call[:description][:duration] = initials["max_duration_of_call"] * 
          random(initials["average_duration_of_call"] / initials["max_duration_of_call"]) 
        
        calls.push(call)
      end
    end
    ActiveRecord::Base.transaction do
      Call.create(calls)
    end
  end
      
  def set_default_call(initials)
    {
      :base_service_id => 50, #(звонок)
      :base_subservice_id => 70, #(входящий)
      :user_id => initials["user_id"],
      :own_phone => {:number => initials["own_phone_number"],
                     :operator_id => initials["own_operator_id"],
                     :region_id => initials["own_region_id"]  
                    },
      :partner_phone => {:number => initials["others_phone_number"]}, 
      :connect => {:operator_id => initials["connection_operator_when_home_id"],
                   :region_id => initials["own_region_id"]  
                    },
      :description => {:time => nil,
                       :duration => nil ,
                       :volume => nil,
                       :volume_unit_id => nil  
                    }
     }
  end
  
  def set_initial_inputs(params_to_search_optimal_tarif)
    prms = params_to_search_optimal_tarif
    result = {}

    result["start_date"] = DateTime.civil_from_format(:local, 2014, 1, 1)
    result["number_of_days_in_call_list"] = 30
    d = prms["duration_of_calls"].to_f
    result["average_duration_of_call"] = (d > 0.1) ?  d : 0.1 
    result["max_duration_of_call"] = 60

    result["user_id"] = 11
    result["own_phone_number"] = '+7 000 000000' 
    result["others_phone_number"] = '+7 999 9999999'

    result["own_operator_id"] = prms["operator_id"] 
    result["fixed_operator_id"] = 1034 
    if result["own_operator_id"] == 1030
      result["others_operator_id"] = 1025
    else
      result["others_operator_id"] = 1030
    end

    result["own_region_id"] = prms["region_id"]
    if result["own_region_id"] == 1109
      result["region_for_region_calls_id"] = 1123
    else
      result["region_for_region_calls_id"] = 1109
    end
    result["region_for_international_calls_id"] = 1501

    result["connection_operator_when_home_id"] = result["own_operator_id"]
    result["connection_operator_when_in_region_id"] = result["own_operator_id"]
    result["connection_operator_when_abroad_id"] = 1031
    
    result["share_of_calls_to_own_mobile"] = 1 - prms["share_of_calls_to_other_mobile"].to_f - prms["share_of_calls_to_fix_line"].to_f
    result["share_of_calls_to_others_mobile"] = 1 - prms["share_of_calls_to_other_mobile"].to_f
    
    result["share_of_local_calls"] = 1 - prms["share_of_regional_calls"].to_f - prms["share_of_international_calls"].to_f
    result["share_of_international_calls"] = 1 - prms["share_of_regional_calls"].to_f

    result
  end

  def default_calls_generation_params
    {"country_id" => 1100,
     "region_id" => 1109, 
     "operator_id" => 1030, 
     "privacy_id" => 2,
     "number_of_day_calls" => 10,
     "duration_of_calls" => 5,# мин
     "share_of_calls_to_other_mobile" => 0.7,
     "share_of_calls_to_fix_line" => 0.1,
     "share_of_regional_calls" => 0.1,
     "share_of_international_calls" => 0.05,
     "number_of_sms_per_day" => 5,
     "number_of_mms_per_day" => 2,
     "internet_trafic_per_month" => 2 #Гб
     } 
  end

  def random(average)
    x = rand
    pi = 3.1415926535897932384626433832#BigMath.PI(10)
    if x < 0.25
      Math.sin(x * average * pi) * average
    else
      average * 5.0 + Math.sin((x - 3.0/4.0) * pi) * average * 4.0
    end
  end
  
end
