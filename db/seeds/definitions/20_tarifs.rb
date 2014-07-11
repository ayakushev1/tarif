def access_methods_to_constant_tarifs
#tarid_ids
  #processed
_mts_red_energy = 200; _mts_smart = 201; _mts_smart_mini = 202; _mts_smart_plus = 203; _mts_ultra = 204; _mts_mts_connect_4 = 205; 
_mts_mayak = 206; _mts_your_country = 207; _mts_super_mts = 208; _mts_umnyi_dom = 210;
_mts_super_mts_star = 209; #тариф не забит (и его по-моему вообще уже нет)
  
  #unprocessed
  _mts_a_mobile = 211; 
  
#common_services_ids
_mts_own_country_rouming = 276; _mts_international_rouming = 277; _mts_own_country_rouming_internet = 312

#tarif option ids
  #calls
_mts_region = 328; _mts_95_cop_in_moscow_region = 329;
_mts_unlimited_calls = 330; _mts_call_free_to_mts_russia_100 = 331; _mts_zero_to_mts = 332;

  #calls_abroad
_mts_love_country = 281; _mts_love_country_all_world = 309; _mts_outcoming_calls_from_11_9_rur = 293;

  #country_rouming
_mts_everywhere_as_home = 294; _mts_everywhere_as_home_Ultra = 282; _mts_everywhere_as_home_smart = 283;
_mts_incoming_travelling_in_russia = 297;
_mts_additional_minutes_150 = 321; _mts_additional_minutes_300 = 322;

  #international_rouming
_mts_zero_without_limits = 288; _mts_bit_abroad = 289; _mts_maxi_bit_abroad = 290; _mts_super_bit_abroad = 291;
_mts_100mb_in_latvia_and_litva = 292; 

  #internet
_mts_internet_packet_200mb = 298; _mts_internet_packet_300mb = 299; _mts_internet_packet_450mb = 300; _mts_internet_packet_900mb = 301;#это архивные опции
_mts_bit = 302; _mts_super_bit = 303; _mts_mini_bit = 304;
_mts_additional_internet_500_mb =310; _mts_additional_internet_1_gb = 311;
_mts_turbo_button_500_mb = 313; _mts_turbo_button_2_gb = 314; 
_mts_internet_mini = 315; _mts_internet_maxi = 316; _mts_internet_super = 317; _mts_internet_vip = 318;  
_mts_mts_planshet = 340; _mts_mts_planshet_online = 341;
_mts_unlimited_internet_on_day = 342

  #mms
_mts_mms_packet_10 = 323; _mts_mms_packet_20 = 324; _mts_mms_packet_50 = 325; _mts_mms_discount_50_percent = 326;

  #service_to_country
_mts_rodnye_goroda = 280; 

  #sms
_mts_50_sms_travelling_in_russia = 295; _mts_100_sms_travelling_in_russia = 296; 
_mts_50_sms_in_europe = 305; _mts_100_sms_in_europe = 306; _mts_50_sms_travelling_in_all_world = 307; _mts_100_sms_travelling_in_all_world = 308;
_mts_onetime_sms_packet_50 = 333; _mts_onetime_sms_packet_150 = 334; _mts_onetime_sms_packet_300 = 335; 
_mts_monthly_sms_packet_100 = 336; _mts_monthly_sms_packet_300 = 337; _mts_monthly_sms_packet_500 = 338; _mts_monthly_sms_packet_1000 = 339;

#_mts_everywhere_as_home_smart_plus = 319; _mts_everywhere_as_home_smart_mini = 320

#correct_tarif_class_ids
  _correct_tarif_class_ids = []; _correct_tarif_list_ids = []  
#_all_loaded_tarifs = []
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_tarifs