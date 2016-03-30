def access_methods_to_constant_general_categories
#category constant definition
#1 locations - regions
#3 
  _legal = 1, _person = 2
#4 standard services
#TODO надо удалить определения строчкой ниже
  _tarif = 40; _rouming = 41; _special_service = 42; _tarif_option = 43; 
  _tarif = 40; _common_service = 41; _special_service = 42; _option_of_tarif = 43; _test_tarif = 44; _special_purpose_tarif = 45;
#5 base_service
_calls = 50; _sms = 51; _mms = 52; _2g = 53; _3g = 54; _4g = 55; _cdma = 56; _wifi = 57; _periodic = 58; _one_time = 59; _wap = 60;
#6 service_direction
_outbound = 70; _inbound = 71; _unspecified_direction = 72;
#7 field type 
  _boolean = 3; _integer = 4; _string = 5; _text = 6; _decimal = 7; _list = 8; _reference = 9; _datetime = 10; _json = 11; _array = 12;
#9 volume unit ids   
  _byte = 80; _k_byte = 81; _m_byte = 82; _g_byte = 83;
  _rur = 90; _usd = 91; _eur = 92; _grivna = 93; _gbp = 94;
  _second = 95; _minute = 96; _hour = 97; _day = 98; _week = 99; _month = 100; _year = 101;
  _k_b_sec = 110; _m_b_sec = 111; _g_b_sec = 112;
  _item = 115;
#14 comparison_operator_id   
  _equal = 120; _not_equal = 121; _less = 122; _less_or_eq = 123; _more = 124; _more_or_eq = 125; _in_array = 126; _not_in_array = 127
#15 source_type_id
  _call_data = 130; _intermediate_data = 131; _input_data = 132;
#16 display type
  _value = 135; _list = 136; _table = 137; _string = 138; _query = 139;
#17 value_choose_option_id 
  _field = 150; _single_value = 151; _multiple_value = 152; _value_param_is_criterium_param = 153
#18 service_category_type_id 
  _common = 160; _specific = 161;
#19 values for operator_type_id = 19
  _mobile = 170; _fixed_line = 171;
#20 user_service_status  
_subscribed = 175; _unsubscribed = 176; _expired = 177
#21 relation types
_operator_home_regions = 190; _operator_country_groups = 191; _main_operator_by_country = 192; _operator_region_groups = 193;
_operator_partner_groups = 194;

#22 phone usage patterns
_own_region_active_caller = 201; _own_region_active_sms = 202; _own_region_active_internet = 203; _own_region_no_activity = 204;
_home_region_active_caller = 211; _home_region_active_sms = 212; _home_region_active_internet = 213; _home_region_no_activity = 214;
_own_country_active_caller = 221; _own_country_active_sms = 222; _own_country_active_internet = 223; _own_country_no_activity = 224;
_abroad_active_caller = 231; _abroad_active_sms = 232; _abroad_active_internet = 233; _abroad_no_activity = 234;
_general_home_sitter = 241; _general_home_region_sitter = 242; _general_active_russia_traveller = 243; _general_active_foreign_traveller = 244;
#23 priority type
_general_priority = 300; _individual_priority = 301; _dependent_is_required_for_main = 302; _main_is_incompatible_with_dependent = 303;
#24 priority relation
_higher_priority = 310; _lower_priority = 311;
#25 general_priority
_gp_tarif_option = 320; _gp_tarif_without_limits = 321; _gp_tarif_with_limits = 322; _gp_tarif_option_with_limits =323; _gp_common_service = 324; _gp_tarif_option_without_limits = 320;
#26 tarif_class_general_service_categories
_tcgsc_calls = 330; _tcgsc_sms = 331; _tcgsc_mms = 332; _tcgsc_internet = 333; 

#service_priority
_tarif_class_priority = 0; _rouming_priority = 10; _special_service_priority = 20; _tarif_option_priority = 30;
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_general_categories