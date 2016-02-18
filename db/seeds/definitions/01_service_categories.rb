def access_methods_to_constant_service_categories
#ServiceCategories
  #rouming
  _category_rouming = 0; _intra_net_rouming = 1; _own_region_rouming = 2; _home_region_rouming = 3; _own_country_rouming = 4; 
  _sc_other_operator_rouming = 10;  _sc_national_rouming = 11; _all_world_rouming = 12;
  _sc_mts_europe_rouming = 13; _sc_mts_sic_rouming = 14; _sc_mts_sic_1_rouming = 15; _sc_mts_sic_2_rouming = 16; 
  _sc_mts_sic_3_rouming = 17; _sc_mts_sic_2_1_rouming = 18; _sc_mts_sic_2_2_rouming = 19;
  _sc_mts_other_countries_rouming = 20; 
  _own_and_home_regions_rouming = 21;
  _sc_lithuania_and_latvia_rouming = 22;
  _sc_mts_rouming_in_11_9_option_countries_1 = 23; _sc_mts_rouming_in_11_9_option_countries_2 = 24;
  _sc_mts_rouming_in_bit_abrod_option_countries_1 = 25; _sc_mts_rouming_in_bit_abrod_option_countries_2 = 26;
  _sc_mts_rouming_in_bit_abrod_option_countries_3 = 27; _sc_mts_rouming_in_bit_abrod_option_countries_4 = 28;
  _all_russia_rouming = 29;
 
  _sc_mgf_rouming_in_option_around_world_1 = 30; _sc_mgf_rouming_in_option_around_world_2 = 31; _sc_mgf_rouming_in_option_around_world_3 = 32;
  _sc_mgf_rouming_in_50_sms_europe = 33; _sc_mgf_rouming_not_russia_not_in_50_sms_europe = 34;
  _sc_mgf_europe_international_rouming = 35; _sc_mgf_sic_international_rouming = 36; 
  _sc_mgf_other_countries_international_rouming = 37; _sc_mgf_extended_countries_international_rouming = 38;
  
  _sc_mgf_ukraine_internet_abroad = 39; _sc_mgf_europe_internet_abroad = 40; 
  _sc_mgf_popular_countries_internet_abroad = 41; _sc_mgf_other_countries_internet_abroad = 42;
  
  _sc_mgf_countries_vacation_online = 43;
  
  _sc_mgf_cenral_regions_not_own_and_home_region = 44; 
  
  _sc_mgf_discount_on_calls_to_russia_and_all_incoming = 45;
  
  _sc_bln_sic = 50; _sc_bln_other_world = 51;
  
  _sc_bln_my_planet_groups_1 = 52; _sc_bln_my_planet_groups_2 = 53;
  _sc_bln_the_best_internet_in_rouming_groups_1 = 54; _sc_bln_the_best_internet_in_rouming_groups_2 = 55;
  
  _sc_tele_own_country_rouming_1 = 60; _sc_tele_own_country_rouming_2 = 61;
  
  _sc_tele_sic_rouming = 65; _sc_tele_europe_rouming = 66; _sc_tele_asia_afr_aust_rouming = 67; _sc_tele_americas_rouming = 68; 
  
  _sc_rouming_mts_free_journey = 69; 
  _sc_rouming_mts_sic_abkhazia = 70; _sc_rouming_mts_sic_south_ossetia =  71;  _sc_rouming_mts_sic_135_to_other_countries = 81;
  _sc_rouming_mts_sic_109_to_sic = 82; _sc_rouming_mts_sic_14_for_40_internet = 83; _sc_rouming_mts_sic_12_for_40_internet = 84;
  _sc_rouming_mts_sic_30_for_40_internet = 85; _sc_rouming_mts_sic_45_to_russia = 86; _sc_rouming_mts_sic_65_to_russia = 87; 
  _sc_rouming_mts_sic_75_to_russia = 88; _sc_rouming_mts_sic_85_to_russia = 89; _sc_rouming_mts_sic_115_to_russia = 90; 
   
  _sc_rouming_mts_europe_countries_25_25_25_135 = 91; _sc_rouming_mts_europe_countries_30_30_30_135 = 92; _sc_rouming_mts_europe_countries_45_45_45_135 = 93;
  _sc_rouming_mts_europe_countries_50_50_50_135 = 94; _sc_rouming_mts_europe_countries_60_60_60_135 = 95; _sc_rouming_mts_europe_countries_65_65_65_135 = 96;
  _sc_rouming_mts_europe_countries_65_65_75_135 = 97; _sc_rouming_mts_europe_countries_99_99_99_135 = 98; _sc_rouming_mts_europe_countries_115_115_115_135 = 99;
  _sc_rouming_mts_europe_countries_155_155_155_155 = 500; _sc_rouming_mts_europe_countries_85_85_85_135 = 501;

  _sc_rouming_mts_other_countries_60_60_60_60 = 502; _sc_rouming_mts_other_countries_65_65_65_135 = 503; _sc_rouming_mts_other_countries_99_99_99_155 = 504;
  _sc_rouming_mts_other_countries_200_200_200_200 = 505; _sc_rouming_mts_other_countries_250_250_250_250 =  506; _sc_rouming_mts_other_countries_155_155_155_155 = 507; 

  _sc_rouming_bln_all_russia_except_some_regions_for_internet = 510; _sc_rouming_bln_bad_internet_regions = 511;
  _sc_rouming_bln_cenral_regions_not_moscow_regions = 512; _sc_rouming_bln_exept_for_cenral_regions_not_moscow_regions = 513;
  
 #география услуг
  _geography_services = 100;
  _service_to_own_region = 101; _service_to_home_region = 102; _service_to_own_country = 103; _service_to_group_of_countries = 104;
  _service_to_not_own_country = 105; 
  _service_to_mts_europe = 106; _service_to_mts_sic = 107; _service_to_mts_other_countries = 108;
  _service_to_own_and_home_regions = 185; _service_to_all_own_country_regions = 186; _service_to_rouming_region = 187;
  _service_to_not_own_and_home_region = 189;
  
  _sc_service_to_russia = 109; _sc_service_to_rouming_country = 110;  _sc_service_to_not_rouming_not_russia = 111;
  _sc_service_not_rouming_not_russia_to_sic = 112;  _sc_service_to_not_rouming_not_russia_not_sic = 113; _to_any_abroad_country = 114;

  _sc_service_to_mts_love_countries_4_9 = 115; _sc_service_to_mts_love_countries_5_5 = 116; _sc_service_to_mts_love_countries_5_9 = 117;
  _sc_service_to_mts_love_countries_6_9 = 118; _sc_service_to_mts_love_countries_7_9 = 119; _sc_service_to_mts_love_countries_8_9 = 120;
  _sc_service_to_mts_love_countries_9_9 = 121; _sc_service_to_mts_love_countries_11_5 = 122; _sc_service_to_mts_love_countries_12_9 = 123; 
  _sc_service_to_mts_love_countries_14_9 = 124; _sc_service_to_mts_love_countries_19_9 = 125; _sc_service_to_mts_love_countries_29_9 = 126;
  _sc_service_to_mts_love_countries_49_9 = 127;
  _sc_service_to_mts_your_country_1 = 128; _sc_service_to_mts_your_country_2 = 129; _sc_service_to_mts_your_country_3 = 130; _sc_service_to_mts_your_country_4 = 131;
  _sc_service_to_mts_your_country_5 = 132; _sc_service_to_mts_your_country_6 = 133; _sc_service_to_mts_your_country_7 = 134; _sc_service_to_mts_your_country_8 = 135;
  _sc_service_to_mts_your_country_9 = 136;
  
  _sc_service_to_mgf_sms_sic_plus = 140; _sc_service_to_mgf_sms_other_countries = 141
  _sc_service_to_mgf_country_group_1 = 142; _sc_service_to_mgf_country_group_2 = 143; _sc_service_to_mgf_country_group_3 = 144;
  _sc_service_to_mgf_country_group_4 = 145; _sc_service_to_mgf_country_group_5 = 146;

  _sc_service_to_mgf_warm_welcome_plus_1 = 147; _sc_service_to_mgf_warm_welcome_plus_2 = 148; _sc_service_to_mgf_warm_welcome_plus_3 = 149;
  _sc_service_to_mgf_warm_welcome_plus_4 = 150; _sc_service_to_mgf_warm_welcome_plus_5 = 151; _sc_service_to_mgf_warm_welcome_plus_6 = 152;
  
  _sc_mgf_around_world_countries_1 = 153; _sc_mgf_around_world_countries_2 = 154; _sc_mgf_around_world_countries_3 = 155;
  _sc_mgf_around_world_countries_4 = 156; _sc_mgf_around_world_countries_5 = 157;
  
  _sc_service_to_mgf_call_to_all_country_1 = 158; _sc_service_to_mgf_call_to_all_country_3_5 = 159; _sc_service_to_mgf_call_to_all_country_4 = 160;
  _sc_service_to_mgf_call_to_all_country_4_5 = 161; _sc_service_to_mgf_call_to_all_country_5 = 162; _sc_service_to_mgf_call_to_all_country_6 = 163;
  _sc_service_to_mgf_call_to_all_country_7 = 164; _sc_service_to_mgf_call_to_all_country_8 = 165; _sc_service_to_mgf_call_to_all_country_9 = 166;
  _sc_service_to_mgf_call_to_all_country_10 = 167; _sc_service_to_mgf_call_to_all_country_11 = 168; _sc_service_to_mgf_call_to_all_country_12 = 169;
  _sc_service_to_mgf_call_to_all_country_13 = 170; _sc_service_to_mgf_call_to_all_country_14 = 171; _sc_service_to_mgf_call_to_all_country_15 = 172;
  _sc_service_to_mgf_call_to_all_country_16 = 173; _sc_service_to_mgf_call_to_all_country_17 = 174; _sc_service_to_mgf_call_to_all_country_18 = 175;
  _sc_service_to_mgf_call_to_all_country_19 = 176; _sc_service_to_mgf_call_to_all_country_20 = 177; _sc_service_to_mgf_call_to_all_country_23 = 178;
  _sc_service_to_mgf_call_to_all_country_30 = 179;
  
  _sc_service_to_mgf_international_1 = 400; _sc_service_to_mgf_international_2 = 401; _sc_service_to_mgf_international_3 = 402;
  _sc_service_to_mgf_international_4 = 403; _sc_service_to_mgf_international_5 = 404;
  
  _sc_service_mgf_from_abroad_to_sic_plus = 406; _sc_service_mgf_from_abroad_to_other_countries = 407;
  
  _sc_service_to_bln_international_1 = 410; _sc_service_to_bln_international_2 = 411; _sc_service_to_bln_international_3 = 412;
  _sc_service_to_bln_international_4 = 413; _sc_service_to_bln_international_5 = 414; _sc_service_to_bln_international_6 = 416;
  _sc_service_to_bln_international_7 = 417; _sc_service_to_bln_international_8 = 418; _sc_service_to_bln_international_9 = 419;
  _sc_service_to_bln_international_10 = 420; _sc_service_to_bln_international_11 = 421; _sc_service_to_bln_international_12 = 422;
  _sc_service_to_bln_international_13 = 423;
  
  _sc_service_to_bln_welcome_1 = 430; _sc_service_to_bln_welcome_2 = 431; _sc_service_to_bln_welcome_3 = 432;
  _sc_service_to_bln_welcome_4 = 433; _sc_service_to_bln_welcome_5 = 434; _sc_service_to_bln_welcome_6 = 435;
  _sc_service_to_bln_welcome_7 = 436; _sc_service_to_bln_welcome_8 = 437; _sc_service_to_bln_welcome_9 = 438;
  _sc_service_to_bln_welcome_10 = 439; _sc_service_to_bln_welcome_11 = 440;
  
  _sc_bln_calls_to_other_countries_1 = 441; _sc_bln_calls_to_other_countries_2 = 442; _sc_bln_calls_to_other_countries_3 = 443; 
  
  _sc_service_to_tele_international_1 = 450; _sc_service_to_tele_international_2 = 451; _sc_service_to_tele_international_3 = 452; _sc_service_to_tele_international_4 = 453;
  _sc_service_to_tele_international_5 = 454; _sc_service_to_tele_international_6 = 455;

  _sc_service_to_tele_from_abroad_to_international_1 = 456; _sc_service_to_tele_from_abroad_to_international_2 = 457; 
  _sc_service_to_tele_from_abroad_to_international_5 = 458; _sc_service_to_tele_from_abroad_to_international_6 = 459;
  
  _sc_service_to_tele_sic_1 = 460; _sc_service_to_tele_sic_2 = 461; _sc_service_to_tele_sic_3 = 462;
  _sc_tele_service_to_uzbekistan = 463; _sc_tele_service_to_sic_not_uzbekistan = 464;

  _sc_service_to_bln_welcome_12 = 465; _sc_service_to_bln_welcome_13 = 466; _sc_service_to_bln_welcome_14 = 467;
  
  _sc_service_to_bln_my_abroad_countries_1 = 468; _sc_service_to_bln_my_abroad_countries_2 = 469; _sc_service_to_bln_my_abroad_countries_3 = 470;  
  
  #partner type
  _partner_operator_services = 190;
  _service_to_own_operator = 191; _service_to_not_own_operator = 192; _service_to_other_operator = 193; _service_to_fixed_line = 194;
  _service_to_russian_operators = 195; _service_to_sic_operators = 196; _service_to_other_operators = 197;
  
  _service_to_bln_partner_operator = 198; _service_to_not_bln_partner_operator = 199;
  
  _service_to_beeline = 230; _service_to_megafon = 231; _service_to_mts = 232; _service_to_tel = 233;
  
    
  # standard service types
  _sc_tarif_service = 200;
  _sc_phone_service = 300;
  _sc_calls = 301; _calls_in = 302; _calls_out = 303; _sc_sms = 310; _sms_in = 311; _sms_out = 312; _sc_mms = 320; _mms_in = 321; _mms_out = 322;
  _sc_mobile_connection = 330; _internet = 340; _wap_internet = 341; _gprs = 342;

  _two_side_services_both_way = [_calls_in, _calls_out, _sms_in, _sms_out, _mms_in, _mms_out]
  _two_side_services_out_way = [_calls_out, _sms_out, _mms_out]
  _two_side_services_in_way = [_calls_in, _sms_in, _mms_in]
  _one_side_services = [_gprs, _internet]
  
  #one time services
  _sc_onetime = 201; 
  _tarif_switch_on = 202;
   
  #periodic services
  _sc_periodic = 280;
  _periodic_monthly_fee = 281; _periodic_day_fee = 282;
  
#Parameters
  #parameters from customer_calls
  _call_base_service_id =       0; _call_base_sub_service_id =       1;
  _call_own_phone_number =      2; _call_own_phone_operator_id =     3; _call_own_phone_region_id =            4; _call_own_phone_country_id =    5;
  _call_partner_phone_number =  6; _call_partner_phone_operator_id = 7; _call_partner_phone_operator_type_id = 8; _call_partner_phone_region_id = 9; _call_partner_phone_country_id = 10;
  _call_connect_operator_id =  11; _call_connect_region_id =        12; _call_connect_country_id =            13;
  _call_description_time =     14; _call_description_duration =     15; _call_description_volume =            16;
  
  #parameter from final query (fq) about user, his tarif and choosen services
  _fq_tarif_operator_id = 100; _fq_tarif_region_id = 101; _fq_tarif_home_region_ids = 102; _fq_tarif_own_and_home_region_ids = 103; _fq_tarif_country_id = 104;

  #parameter from operator home regions (operator_home_region: id, operator_id, region_ids)
  #_operator_home_region = 
  
  #Parameters from Category operator_type_id = 19: - номер = 30 + category_type_id
  _category_operator_type_id = 49
  #parameter from operator groups of countries (operator_country_group: id, group_name, operator_id, country_ids)

#StandardCategoryGroups
  #real all operators
#  _scg_free_sum_duration = 0; _scg_free_count_volume = 1; _scg_free_sum_volume = 2;

#PriceLists
  #real all operators
#  _pl_free_sum_duration = 0; _pl_free_count_volume = 1; _pl_free_sum_volume = 2;

#PriceFormulas
  #real all operators
#  _prf_free_sum_duration = 0; _prf_free_count_volume = 1; _prf_free_sum_volume = 2;

#StandardFormulas
#  _stf_price_by_1_month = 0; _stf_price_by_1_item = 2;
  
#  _stf_zero_count_volume_item = 11;  
#  _stf_zero_sum_volume_m_byte = 12;
#  _stf_price_by_sum_duration_second = 13;
#   _stf_price_by_count_volume_item = 14;
#    _stf_price_by_sum_volume_m_byte = 15; 
#    _stf_price_by_sum_volume_k_byte = 16 
 # _stf_price_by_sum_duration_minute = 17; 
#  _stf_fixed_price_if_used_in_1_day_duration = 18; 
#  _stf_fixed_price_if_used_in_1_day_volume = 19;
#  _stf_price_by_1_month_if_used = 20; 
#  _stf_price_by_1_item_if_used = 21; 
#  _stf_fixed_price_if_used_in_1_day_any = 22;
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_categories