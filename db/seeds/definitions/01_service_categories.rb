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
  
  #география услуг
  _geography_services = 100;
  _service_to_own_region = 101; _service_to_home_region = 102; _service_to_own_country = 103; _service_to_group_of_countries = 104;
  _service_to_not_own_country = 105; 
  _service_to_mts_europe = 106; _service_to_mts_sic = 107; _service_to_mts_other_countries = 108;
  _service_to_own_and_home_regions = 185; _service_to_all_own_country_regions = 186; _service_to_rouming_region = 187;
  
  _sc_service_to_russia = 109; _sc_service_to_rouming_country = 110;  _sc_service_to_not_rouming_not_russia = 111;
  _sc_service_not_rouming_not_russia_to_sic = 112;  _sc_service_to_not_rouming_not_russia_not_sic = 113;

  _sc_service_to_mts_love_countries_4_9 = 115; _sc_service_to_mts_love_countries_5_5 = 116; _sc_service_to_mts_love_countries_5_9 = 117;
  _sc_service_to_mts_love_countries_6_9 = 118; _sc_service_to_mts_love_countries_7_9 = 119; _sc_service_to_mts_love_countries_8_9 = 120;
  _sc_service_to_mts_love_countries_9_9 = 121; _sc_service_to_mts_love_countries_11_5 = 122; _sc_service_to_mts_love_countries_12_9 = 123; 
  _sc_service_to_mts_love_countries_14_9 = 124; _sc_service_to_mts_love_countries_19_9 = 125; _sc_service_to_mts_love_countries_29_9 = 126;
  _sc_service_to_mts_love_countries_49_9 = 127;
  _sc_service_to_mts_your_country_1 = 128; _sc_service_to_mts_your_country_2 = 129; _sc_service_to_mts_your_country_3 = 130; _sc_service_to_mts_your_country_4 = 131;
  _sc_service_to_mts_your_country_5 = 132; _sc_service_to_mts_your_country_6 = 133; _sc_service_to_mts_your_country_7 = 134; _sc_service_to_mts_your_country_8 = 135;
  _sc_service_to_mts_your_country_9 = 136;

  #partner type
  _partner_operator_services = 190;
  _service_to_own_operator = 191; _service_to_not_own_operator = 192; _service_to_other_operator = 193; _service_to_fixed_line = 194;
    
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
  _stf_price_by_1_month = 0; _stf_price_by_1_item = 2;
  
  _stf_zero_sum_duration_second = 10; _stf_zero_count_volume_item = 11;  _stf_zero_sum_volume_m_byte = 12;
  _stf_price_by_sum_duration_second = 13; _stf_price_by_count_volume_item = 14; _stf_price_by_sum_volume_m_byte = 15; _stf_price_by_sum_volume_k_byte = 16 
  _stf_price_by_sum_duration_minute = 17; _stf_fixed_price_if_used_in_1_day_duration = 18; _stf_fixed_price_if_used_in_1_day_volume = 19;
  _stf_price_by_1_month_if_used = 20; _stf_price_by_1_item_if_used = 21;

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_categories