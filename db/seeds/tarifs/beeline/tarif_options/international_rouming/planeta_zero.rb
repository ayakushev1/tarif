@tc = ServiceHelper::TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_planeta_zero, :name => 'Планета Ноль', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/planeta-nol/'},
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_planet, _bln_planeta_zero]}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 25.0})  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

#all_world_rouming, calls, incoming
category = {:name => '_sctcg_bln_all_world_rouming_calls_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {},  
  {:calculation_order => 0, :price => 19.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration_minute_more_10 => "sum(case when ((description->>'duration')::float) > 600.0 then ((description->>'duration')::float) - 10.0 else 0.0 end)",
                      :count_calls => "count(((description->>'duration')::float) > 0.0)",                      
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (count_calls + sum_duration_minute_more_10)'}, } )

#all_world_rouming, sms, outcoming
category = {:name => '_sctcg_bln_all_world_rouming_sms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 10.0})  




@tc.add_tarif_class_categories


#Услуга доступна к подключению физическим и юридическим лицам предоплатной системы расчетов во всех регионах России.
#Услуга действует до самостоятельного отключения абонентом.
#Услуга действует во всех странах международного роуминга «Билайн».
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки в международном роуминге тарифицируются с первой секунды. Стоимость входящих вызовов указана за каждый разговор.
#При подключении услуги «Планета Ноль» услуга «Моя планета» не предоставляется и будет автоматически отключена, если была подключена ранее. 
#Услуга недоступна на тарифном плане «Мир Билайн 2011».
#Цены указаны с учетом НДС