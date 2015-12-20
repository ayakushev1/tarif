@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_intra_countries_services, :name => 'Международные вызовы', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://megafon.ru'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  

#Own and home regions, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_country_group_1', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})

#Own and home regions, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_country_group_2', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 55.0})

#Own and home regions, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_country_group_3', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})

#Own and home regions, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_country_group_4', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})

#Own and home regions, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_country_group_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})


#Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_home_regions_sms_to_sms_sic_plus_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0  })

#Own and home regions, sms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_home_regions_sms_to_sms_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0})


#Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_home_regions_mms_sms_sic_plus_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 10.0})

#Own and home regions, mms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_home_regions_mms_to_sms_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 20.0})


#Own country, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:name => '_sctcg_own_country_calls_to_mgf_country_group_1', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})

#Own country, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:name => '_sctcg_own_country_calls_to_mgf_country_group_2', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 55.0})

#Own country, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:name => '_sctcg_own_country_calls_to_mgf_country_group_3', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})

#Own country, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:name => '_sctcg_own_country_calls_to_mgf_country_group_4', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})

#Own country, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:name => '_sctcg_own_country_calls_to_mgf_country_group_5', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0})


#Own country, sms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_country_sms_to_sms_sic_plus_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0  })

#Own country, sms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_country_sms_to_sms_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0})


#Own country, mms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_own_country_mms_sms_sic_plus_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 10.0})

#Own country, mms, Outcoming, sms_other_countries
category = {:name => '_sctcg_own_country_mms_to_sms_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 20.0})




#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_any, :price => 3.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_1 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_mgf_country_group_1', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_2 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_mgf_country_group_2', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 55.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_3 (Австралия и Океания)
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_mgf_country_group_3', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_4 (Азия)
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_mgf_country_group_4', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_mgf_country_group_5 (Остальные страны)
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_mgf_country_group_5', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_country_group_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 75.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_sms_sic_plus_countriesy', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, sms_other_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_sms_other_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, Outcoming, to sms_sic_plus_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_sms_sic_plus_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_sic_plus}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 13.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, sms_other_countries
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_sms_other_countries', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_mgf_sms_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 23.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  




@tc.add_tarif_class_categories

