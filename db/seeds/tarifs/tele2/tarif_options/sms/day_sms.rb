@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_day_sms, :name => 'День СМС', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/services/messaging/den-sms/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#sms included in tarif
  scg_tele_day_sms = @tc.add_service_category_group(
    {:name => 'scg_tele_day_sms' }, 
    {:name => "price for scg_tele_day_sms"}, 
    {:calculation_order => 0, :price => 5.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(100 >= count_volume)", :window_over => 'day',
       :stat_params => {:count_volume => "count(description->>'volume')"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
} } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 20.0})  

#Own and home regions, sms, to_own_country
category = {:name => '_sctcg_own_home_regions_sms_service_to_all_own_country_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_day_sms[:id])

@tc.add_tarif_class_categories
