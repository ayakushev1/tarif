@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_call_to_russia, :name => 'Звони по России', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/far_calls/call_on_russia.html#29093'},
  :dependency => {
    :incompatibility => {:_mgf_call_to_russia => [_mgf_option_city_connection]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_city_connection], :to_serve => []},
    :multiple_use => false
  } } )


#Own country, calls, outcoming, to all own country regions
  category = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 15.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:count_calls => "count(((description->>'duration')::float) > 0.0)",
                      :sum_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * count_calls + 2.5 * sum_duration_minute_more_10'}, } )



@tc.add_tarif_class_categories

#Опция «Звони по России» действует только на территории Московского региона.
#Внимание: Опцию невозможно подключить, если абонент пользуется опцией «Супермежгород», «50% на межгород», «Мой МегаФон», «Связь городов» или «Час на межгород».
#Опция доступна для подключения на всех тарифных планах за исключением тарифного плана «Связь городов».
