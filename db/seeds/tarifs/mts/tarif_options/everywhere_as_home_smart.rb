#Smart+, only grouped calls, sms and internet, with option "Везде как дома"
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class({:name => 'Везде как дома SMART'})
#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_plus_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :formula => {:window_condition => "(1000.0 >= sum_duration_minute)"}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_plus_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, :formula => {:window_condition => "(1000.0 >= count_volume)"}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_plus_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, :formula => {:window_condition => "(3000.0 >= sum_volume)"}, :price => 0.0, :description => '' }
    )

_sctcg_own_home_regions_calls_to_own_home_regions = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
_sctcg_own_home_regions_sms_to_own_home_regions = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
_sctcg_own_home_regions_internet = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
_sctcg_own_country_calls_to_own_country_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_not_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
_sctcg_own_country_calls_to_own_country_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_internet = {:name => '_sctcg_own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
 
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 100.0})
 
#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_all_operators
#  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
#  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator, _sctcg_own_home_regions_calls_to_own_home_regions)

#Own and home regions, sms, Outcoming, to_own_home_regions
#  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_sms_to_own_home_regions, scg_mts_smart_plus_included_in_tarif_sms[:id])

#Own and home regions, Internet
#  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_internet, scg_mts_smart_plus_included_in_tarif_internet[:id])


#Own country, Calls, Outcoming, to_own_home_regions, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0000000000})

#Own country, Calls, Outcoming, to_own_home_regions, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_not_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_not_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0000000000})

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0000000000})

#Own country, Internet
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_internet, scg_mts_smart_plus_included_in_tarif_internet[:id])
#  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_internet, _sctcg_own_home_regions_internet)

_sctcg_own_country_calls_to_own_country_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_not_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
_sctcg_own_country_calls_to_own_country_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_internet = {:name => '_sctcg_own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}

  
#  @tc.load_repositories
