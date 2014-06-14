#Везде как дома
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({:name => 'Везде как дома'})

_sctcg_own_home_regions_calls_to_own_country = {:name => '_sctcg_own_home_regions_calls_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
_sctcg_own_country_calls_incoming = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
_sctcg_own_country_calls_to_all_own_country_regions = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_price_by_30_day, :price => 5.0})

#Own and home regions, Calls, Outcoming, to_own_country, to_all_operators
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own country, Calls, Incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_incoming, _scg_free_sum_duration)

#Own country, Calls, Outcoming, to_all_own_country_regions, to_all_operators
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_all_own_country_regions, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

  
#  @tc.load_repositories

