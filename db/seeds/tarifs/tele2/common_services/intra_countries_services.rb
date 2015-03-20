@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_intra_countries_services, :name => 'Звонки за границу', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://spb.tele2.ru/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )


#Own and home regions, calls, outcoming, to sic
  category = {:name => '_sctcg_own_home_regions_calls_to_sic', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 20.0})  

#Own and home regions, calls, outcoming, to Europe
  category = {:name => '_sctcg_own_home_regions_calls_to_europe', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Own and home regions, calls, outcoming, to USA and Canada
  category = {:name => '_sctcg_own_home_regions_calls_to_usa_canada', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Own and home regionsIC, calls, outcoming, to other countries
  category = {:name => '_sctcg_own_home_regions_calls_to_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  


#Own and home regions, sms, outcoming
  category = {:name => '_sctcg_own_home_regions_sms_outcoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.00})  

@tc.add_tarif_class_categories

