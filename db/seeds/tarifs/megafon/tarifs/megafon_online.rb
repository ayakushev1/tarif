@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_megafon_online, :name => 'Мегафон онлайн', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moscow.megafon.ru/internet/tariffs/megafon-online/megafon-online.html'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

  
#Own and home regions, Calls, Incoming
category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.5})

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.5 })

#Own and home regions, sms, incoming
category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.9})

#Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:name => '_sctcg_own_home_regions_sms_to_own_country_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.9})

#Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_sms_to_own_country_to_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.55})

#Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_home_regions_sms_to_sms_sic_plus_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.0})

#Own and home regions, sms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_home_regions_sms_to_sms_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.5})


#Own and home regions, mms, incoming
category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_mms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.0})

#Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_mms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.0})

#Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_home_regions_mms_sms_sic_plus_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.5})

#Own and home regions, mms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_home_regions_mms_to_sms_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.5})

#Own and home regions, Internet
category = {:name => '_sctcg_mgf_own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 1.9})  



#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 3.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_calls_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_and_home_region
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_home_regions', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0},
  :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.5},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_not_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.5 },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

 
#Central regions RF except for Own and home regions, sms, incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_sms_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_home_regions', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.9},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_country_to_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.9},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_country_not_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.55},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_country_to_sms_sic_plus_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, sms_other_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_sms_other_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.5},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_mms_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_own_home_regions', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_own_country', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_sms_sic_plus_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 8.5},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, sms_other_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_sms_other_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 8.5},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  




@tc.add_tarif_class_categories

