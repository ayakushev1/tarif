def access_methods_to_constant_general_categories
#category constant definition
#0 locations
  _world = 1600; _europe = 1601; _asia = 1602; _noth_america = 1603; _south_america = 1604; _africa = 1605

  _russia = 1100; _ukraiun = 1500;  _great_britain = 1606; _germany = 1607; _france = 1608; _spain = 1609; _poland = 1610; _holand = 1611;
  _china = 1630; _india = 1631; _turkey = 1632; _abhazia = 1633; _azerbaigan = 1634; _armenia = 1635; _gruzia = 1636;
  _usa = 1700; _canada = 1701; _mexica = 1702; _cuba = 1703; _yamayka = 1704;
  _brasilia = 1750; _argentina = 1751; _chily = 1752; _bolivia = 1753;
  _egypt = 1780; _uae = 1781; _south_africa = 1782; _livia = 1783  

  _europe_countries = [_russia, _ukraiun, _great_britain, _germany, _france, _spain, _poland, _holand]
  _europe_countries_without_russia = [_ukraiun, _great_britain, _germany, _france, _spain, _poland, _holand]
  _asia_countries = [_china, _india, _turkey, _abhazia, _azerbaigan, _armenia, _gruzia]
  _noth_america_countries = [_usa, _canada, _mexica, _cuba, _yamayka]
  _south_america_countries = [_brasilia, _argentina, _chily, _bolivia]
  _africa_countries = [_egypt, _uae, _south_africa, _livia]
  _world_countries = _europe_countries + _asia_countries + _noth_america_countries + _south_america_countries + _africa_countries
  _world_countries_without_russia = _europe_countries_without_russia + _asia_countries + _noth_america_countries + _south_america_countries + _africa_countries

  _moscow = 1133; _moscow_region = 1109; _piter = 1134; _piter_region = 1123; _ekaterin = 1135; _ekaterin_region = 1125;
  _regions = [_moscow, _moscow_region, _piter, _piter_region, _ekaterin, _ekaterin_region]
  
#2 operators
  _russian_operators = 1018; _foreign_operators = 1019
  _beeline = 1025; _megafon = 1028; _mts = 1030; _mts_ukrain = 1031; _fixed_line_operator = 1034;
  _operator_great_britain = 1050; _operator_germany = 1051; _operator_france = 1052; _operator_spain = 1053; _operator_poland = 1054; _operator_holand = 1055;
  _operator_china = 1056; _operator_india = 1057; _operator_turkey = 1058; _operator_abhazia = 1059; _operator_azerbaigan = 1060; _operator_armenia = 1061; _operator_gruzia = 1062 
  _operator_usa = 1063; _operator_canada = 1064; _operator_mexica = 1065; _operator_cuba = 1066; _operator_yamayka = 1067; 
  _operator_brasilia = 1068; _operator_argentina = 1069;  _operator_chily = 1070; _operator_bolivia = 1071; 
  _operator_egypt = 1072; _operator_uae = 1073; _operator_south_africa = 1074; _operator_livia = 1075; 
     
  _operators = [_beeline, _megafon, _mts]
#3 
  _legal = 1, _person = 2
#4 standard services
  _tarif = 40; _rouming = 41; _special_service = 42; _tarif_option = 43;
#5 base_service
_calls = 50; _sms = 51; _mms = 52; _2g = 53; _3g = 54; _4g = 55; _cdma = 56; _wifi = 57; _periodic = 58; _one_time = 59; 
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
  _field = 150; _single_value = 151; _multiple_value = 152;
#18 service_category_type_id 
  _common = 160; _specific = 161;
#19 values for operator_type_id = 19
  _mobile = 170; _fixed_line = 171;
#20 user_service_status  
_subscribed = 175; _unsubscribed = 176; _expired = 177
#21 relation types
_operator_home_regions = 190; _operator_country_groups = 191; _main_operator_by_country = 192;
#22 phone usage patterns
_own_region_active_caller = 201; _own_region_active_sms = 202; _own_region_active_internet = 203; _own_region_no_activity = 204;
_home_region_active_caller = 211; _home_region_active_sms = 212; _home_region_active_internet = 213; _home_region_no_activity = 214;
_own_country_active_caller = 221; _own_country_active_sms = 222; _own_country_active_internet = 223; _own_country_no_activity = 224;
_abroad_active_caller = 231; _abroad_active_sms = 232; _abroad_active_internet = 233; _abroad_no_activity = 234;
#23 priority type
_general_priority = 300; _individual_priority = 301; _dependent_is_required_for_main = 302; _main_is_incompatible_with_dependent = 303;
#24 priority relation
_higher_priority = 310; _lower_priority = 311;

#service_priority
_tarif_class_priority = 0; _rouming_priority = 10; _special_service_priority = 20; _tarif_option_priority = 30;
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_general_categories