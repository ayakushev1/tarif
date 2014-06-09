def access_methods_to_constant_service_categories
#ServiceCategories
  #rouming
  _category_rouming = 0; _intra_net_rouming = 1; _own_region_rouming = 2; _home_region_rouming = 3; _own_country_rouming = 4; _all_world_rouming = 12;
  _sc_mts_europe_rouming = 13; _sc_mts_sic_rouming = 14; _sc_mts_sic_1_rouming = 15; _sc_mts_sic_2_rouming = 16; _sc_mts_sic_3_rouming = 17;
  _sc_mts_other_countries_rouming = 18;
  
  #география услуг
  _geography_services = 100;
  _service_to_own_region = 101; _service_to_home_region = 102; _service_to_own_country = 103; _service_to_group_of_countries = 104;
  _service_to_not_own_country = 105; 
  _service_to_mts_europe = 106; _service_to_mts_sic = 107; _service_to_mts_other_countries = 108;
  
  _sc_service_to_russia = 109; _sc_service_to_rouming_country = 110;  _sc_service_to_not_rouming_not_russia = 111;
  _sc_service_not_rouming_not_russia_to_sic = 112;  _sc_service_to_not_rouming_not_russia_not_sic = 113;

  #partner type
  _partner_operator_services = 190;
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
  
#Parameters
  #parameters from customer_calls
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
  _scg_all_local_incoming_calls_free = 0; _scg_all_home_region_incoming_calls_free = 1; _scg_all_own_country_intra_net_incoming_calls_free = 2;
  _scg_all_local_incoming_sms_free = 3; _scg_all_home_region_incoming_sms_free = 4; _scg_all_own_country_intra_net_incoming_sms_free = 5;
  _scg_all_local_incoming_mms_free = 6; _scg_all_home_region_incoming_mms_free = 7; _scg_all_own_country_intra_net_incoming_mms_free = 8;
  #real all operators
  _scg_free_sum_duration = 10; _scg_free_count_volume = 11; _scg_free_sum_volume = 12;
  _scg_free_group_sum_duration = 20; _scg_free_group_count_volume = 21; _scg_free_group_sum_volume = 22;

#PriceLists
  #real all operators
  _pl_free_sum_duration = 10; _pl_free_count_volume = 11; _pl_free_sum_volume = 12;
  _pl_free_group_sum_duration = 20; _pl_free_group_count_volume = 21; _pl_free_group_sum_volume = 22;

#PriceFormulas
  #real all operators
  _prf_free_sum_duration = 10; _prf_free_count_volume = 11; _prf_free_sum_volume = 12;
  _prf_free_group_sum_duration = 20; _prf_free_group_count_volume = 21; _prf_free_group_sum_volume = 22;

#StandardFormulas
  _stf_price_by_1_month = 0; _stf_price_by_30_day = 1; _stf_price_by_1_item = 2;
  
  _stf_zero_sum_duration_second = 10; _stf_zero_count_volume_item = 11;  _stf_zero_sum_volume_m_byte = 12;
  _stf_price_by_sum_duration_second = 13; _stf_price_by_count_volume_item = 14; _stf_price_by_sum_volume_m_byte = 15 
  _stf_price_by_sum_duration_minute = 16; 
  
  _stf_zero_group_sum_duration_second = 20; _stf_zero_group_count_volume_item = 21;  _stf_zero_group_sum_volume_m_byte = 22;
  _stf_price_by_group_sum_duration_second = 23; _stf_price_by_group_count_volume_item = 24; _stf_price_by_group_sum_volume_m_byte = 25 



  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_categories