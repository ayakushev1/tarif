def access_methods_to_constant
#correct_tarif_class_ids
  _correct_tarif_class_ids = [203]  
  _correct_tarif_list_ids = []  
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

#operator_country_groups
_beeline_world = 10000; _beeline_europe = 10001; _beeline_asia = 10002; _beeline__noth_america = 10003; _beeline_south_america = 10004; _beeline_africa = 10005; _beeline_cis = 10006; 
_megafon_world = 10100; _megafon_europe = 10101; _megafon_asia = 10102; _megafon__noth_america = 10103; _megafon_south_america = 10104; _megafon_africa = 10105; _megafon_cis = 10106; 
_mts_world = 10200; _mts_europe = 10201; _mts_asia = 10202; _mts__noth_america = 10203; _mts_south_america = 10204; _mts_africa = 10205; _mts_cis = 10206; 


#ServiceCategories
  #rouming
  _own_region_rouming = 2; _own_home_rouming = 3; _own_country_rouming = 4; _all_world_rouming = 12;
  #география услуг
  _service_to_own_region = 101; _service_to_home_region = 102; _service_to_own_ountry = 103; _service_to_all_world = 105;
  #partner type
  _service_to_own_operator = 191; _service_to_other_operator = 192; _service_to_fixed_line = 193;  
  # standard service types
  _calls_in = 302; _calls_out = 303; _sms_in = 311; _sms_out = 312; _mms_in = 321; _mms_out = 322;
  _gprs = 330; _internet = 340; 

  _two_side_services_both_way = [_calls_in, _calls_out, _sms_in, _sms_out, _mms_in, _mms_out]
  _two_side_services_out_way = [_calls_out, _sms_out, _mms_out]
  _two_side_services_in_way = [_calls_in, _sms_in, _mms_in]
  _one_side_services = [_gprs, _internet]
  #one time services
  _tarif_switch_on = 202; 
  #periodic services
  _periodic_monthly_fee = 281; _periodic_day_fee = 282;
  #parameter_id
  _call_base_service_id =       0; _call_base_sub_service_id =       1;
  _call_own_phone_number =      2; _call_own_phone_operator_id =     3; _call_own_phone_region_id =            4; _call_own_phone_country_id =    5;
  _call_partner_phone_number =  6; _call_partner_phone_operator_id = 7; _call_partner_phone_operator_type_id = 8; _call_partner_phone_region_id = 9; _call_partner_phone_country_id = 10;
  _call_connect_operator_id =  11; _call_connect_region_id =        12; _call_connect_country_id =            13;
  _call_description_time =     14; _call_description_duration =     15; _call_description_volume =            16;
  
  #parameter from final query (fq) about user, his tarif and choosen services
  _fq_tarif_operator_id = 100; _fq_tarif_region_id = 101; _fq_tarif_home_region_ids = 102; _fq_tarif_country_id = 103;
  #parameter from operator home regions (operator_home_region: id, operator_id, region_ids)
  #_operator_home_region = 
  
  #Parameters from Category operator_type_id = 19: - номер = 30 + category_type_id
  _category_operator_type_id = 49
  #parameter from operator groups of countries (operator_country_group: id, group_name, operator_id, country_ids)

#StandardCategoryGroups
_scg_all_local_incoming_free = 0; _scg_all_home_region_incoming_free = 1; _scg_own_country_intra_net_incoming_free = 2;

#StandardFormulas
_stf_zero_sum_duration_second = 0; _stf_zero_count_volume_item = 1; _stf_price_by_sum_duration_second = 2; _stf_price_by_count_volume_item = 3; 
_stf_price_by_sum_volume_m_byte = 4; _stf_price_by_1_month = 5; _stf_price_by_30_day = 6; _stf_price_by_1_item = 7 

#  _operator_country_group_operator_id = 200; _operator_country_group_countries_ids = 201;
  
#_beeline_GO = 0; _beeline_ALL_FOR_1200 = 1; _beeline_national_rouming = 72; _beeline_international_rouming = 73; _beeline_MY_INTRACITY = 80;
#_megafon_AroundWorld = 100; _megafon_All_Simple = 101; _megafon_national_rouming = 176; _megafon_international_rouming = 177;
#_mts_RED_Energy = 200; _mts_Smart = 201; _mts_national_rouming = 276; _mts_international_rouming = 277; _mts_ULTRA = 282; _mts_SMART = 283 

#_beeline_tarif_classes = [_beeline_GO, _beeline_ALL_FOR_1200, _beeline_national_rouming, _beeline_international_rouming, _beeline_MY_INTRACITY]     
#_megafon_tarif_classes = [_megafon_AroundWorld, _megafon_All_Simple, _megafon_national_rouming, _megafon_international_rouming]
#_mts_tarif_classes = [_mts_RED_Energy, _mts_Smart, _mts_national_rouming, _mts_international_rouming, _mts_ULTRA, _mts_SMART]

  #TarifClass
  _tarif_classes = {
    :Beeline => {
      :private => {
        :tarif => (0..2),#(0..12),
        :operator_rouming => (75..75),
        :country_rouming => (93..93),
        :world_rouming => (77..77),
        :services => (80..92),
      }, 
      :corporate => {
        :tarif => (50..51),#(50..55),
        :operator_rouming => (71..71),
        :country_rouming => (72..72),
        :world_rouming => (73..73),
        :services => (),
      }
    },
    :Megafon => {
      :private => {
        :tarif => (100..101),#(100..113),
        :operator_rouming => (175..175),
        :country_rouming => (176..176),
        :world_rouming => (177..177),
        :services => (),
      }, 
      :corporate => {
        :tarif => (150..151),#(150..160),
        :operator_rouming => (171..171),
        :country_rouming => (172..172),
        :world_rouming => (173..173),
        :services => (),
      }
    },
    :MTS => {
      :private => {
        :tarif => (200..201),#(200..210),
        :operator_rouming => (275..275),
        :country_rouming => (276..276),
        :world_rouming => (277..277),
        :services => (280..292),
      }, 
      :corporate => {
        :tarif => (250..251),#(250..260),
        :operator_rouming => (271..271),
        :country_rouming => (272..272),
        :world_rouming => (273..273),
        :services => (),
      }
    },  
  }

_all_loaded_tarifs = []
_tarif_classes.each do |operator, privacies|
  privacies.each do |privacy, tarif_range_collection| 
    tarif_range_collection.each do |name, tarif_range|
      tarif_range.each {|tarif| _all_loaded_tarifs << tarif} if tarif_range 
    end
  end 
end
  
  #Standard Category blocks
  _stand_cat = {
    :local => {
      :one_time => [_tarif_switch_on],
      :periodic => [_periodic_monthly_fee],
      :rouming_id => _own_region_rouming, 
      :service_type => {
        :one_side => { :stan_serv => _one_side_services},
        :two_side_in => { :stan_serv => _two_side_services_in_way},
        :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_ountry, _service_to_all_world], 
                           :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
      }
    },
    :home_region => {
      :one_time => [_tarif_switch_on],
      :periodic => [_periodic_monthly_fee],
      :rouming_id => _own_home_rouming, 
      :service_type => {
        :one_side => { :stan_serv => _one_side_services },
        :two_side_in => { :stan_serv => _two_side_services_in_way},
        :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_ountry, _service_to_all_world], 
                           :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
      }
    },  
    :home_country => {
      :one_time => [_tarif_switch_on],
      :periodic => [_periodic_monthly_fee],
      :rouming_id => _own_country_rouming, 
      :service_type => {
        :one_side => { :stan_serv => _one_side_services },
        :two_side_in => { :stan_serv => _two_side_services_in_way},
        :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_ountry, _service_to_all_world], 
                           :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
      }
    },  
    :world => {
      :one_time => [_tarif_switch_on],
      :periodic => [_periodic_monthly_fee],
      :rouming_id => _all_world_rouming, 
      :service_type => {
        :one_side => { :stan_serv => _one_side_services },
        :two_side_in => { :stan_serv => _two_side_services_in_way},
        :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_ountry, _service_to_all_world], 
                           :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
      }
    },  
  }
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant