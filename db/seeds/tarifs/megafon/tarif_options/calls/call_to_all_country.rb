@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_call_to_all_country, :name => 'Звони во все страны', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/far_calls/all_countries.html#feature'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_be_as_home]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )



#Own and home regions, calls, outcoming, to mgf_call_to_all_country_1
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_1', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_3_5
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_3_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_3_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.5})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_4
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_4', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_4_5
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_4_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_4_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_5
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_6
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_6', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 6.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_7
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_7', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 7.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_8
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_8', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_9
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_9', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_10
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_10', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_10}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 10.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_11
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_11', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_11}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 11.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_12
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_12', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_12}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 12.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_13
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_13', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_13}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 13.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_14
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_14', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_14}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_15
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_15', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_15}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 15.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_16
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_16', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_16}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 16.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_17
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_17', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_17}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_18
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_18', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_18}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 18.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_19
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_19', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_19}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_20
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_20', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_20}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 20.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_23
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_23', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_23}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 23.0})

#Own and home regions, calls, outcoming, to mgf_call_to_all_country_30
category = {:name => '_sctcg_own_home_regions_calls_to_mgf_call_to_all_country_30', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_30}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 30.0})

#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 15.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_1
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_1', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_3_5
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_3_5', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_3_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.5},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_4
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_4', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_4_5
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_4_5', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_4_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_5
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_5', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_6
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_6', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 6.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_7
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_7', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 7.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_8
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_8', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_9
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_9', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_10
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_10', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_10}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 10.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_11
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_11', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_11}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 11.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_12
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_12', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_12}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 12.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_13
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_13', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_13}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 13.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_14
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_14', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_14}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_15
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_15', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_15}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 15.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_16
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_16', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_16}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 16.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_17
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_17', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_17}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_18
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_18', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_18}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 18.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_19
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_19', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_19}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_20
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_20', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_20}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 20.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_23
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_23', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_23}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 23.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Own country, calls, outcoming, to mgf_call_to_all_country_30
category = {:name => '_sctcg_own_country_calls_to_mgf_call_to_all_country_30', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mgf_call_to_all_country_30}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  


@tc.add_tarif_class_categories

#Опция «Звони во все страны» действует на исходящие звонки на любые мобильные и городские номера других стран.
#Опция доступна на всех тарифах, на которых предоставляется услуга международной связи.
#Внимание: Опцию «Звони во все страны» невозможно подключить, если абонент пользуется скидкой «МегаФон-MLT». 
#Опция действует на территории Московского региона.
