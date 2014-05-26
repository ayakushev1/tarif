def access_methods_to_constant_service_categories
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
_scg_all_local_incoming_calls_free = 0; _scg_all_home_region_incoming_calls_free = 1; _scg_all_own_country_intra_net_incoming_calls_free = 2;
_scg_all_local_incoming_sms_free = 3; _scg_all_home_region_incoming_sms_free = 4; _scg_all_own_country_intra_net_incoming_sms_free = 5;
_scg_all_local_incoming_mms_free = 6; _scg_all_home_region_incoming_mms_free = 7; _scg_all_own_country_intra_net_incoming_mms_free = 8;
_scg_free_sum_duration = 9; _scg_free_count_volume = 10; _scg_free_sum_volume = 11;

#PriceLists
_pl_free_sum_duration = 10; _pl_free_count_volume = 11; _pl_free_sum_volume = 12;

#PriceFormulas
_prf_free_sum_duration = 10; _prf_free_count_volume = 11; _prf_free_sum_volume = 12;

#StandardFormulas
_stf_zero_sum_duration_second = 0; _stf_zero_count_volume_item = 1; _stf_price_by_sum_duration_second = 2; _stf_price_by_count_volume_item = 3; 
_stf_price_by_sum_volume_m_byte = 4; _stf_price_by_1_month = 5; _stf_price_by_30_day = 6; _stf_price_by_1_item = 7; _stf_zero_sum_volume_m_byte = 8 

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_categories