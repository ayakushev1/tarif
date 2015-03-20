@tc = TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_my_planet, :name => 'Моя планета', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moya-planeta/'},
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_planet, _bln_planeta_zero]}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})


#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, incoming
category = {:name => '_sctcg_bln_my_planet_groups_1_calls_incoming', :service_category_rouming_id => _sc_bln_my_planet_groups_1, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 7.0})  

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), calls, outcoming, 
category = {:name => '_sctcg_bln_my_planet_groups_1_calls', :service_category_rouming_id => _sc_bln_my_planet_groups_1, :service_category_calls_id => _calls_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})  

#bln_my_planet_groups_1 (Европа, СНГ и популярные страны), sms, outcoming
category = {:name => '_sctcg_bln_my_planet_groups_1_sms_outcoming', :service_category_rouming_id => _sc_bln_my_planet_groups_1, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 5.0})  


#bln_my_planet_groups_2 (остальные страны), calls, incoming
category = {:name => '_sctcg_bln_my_planet_groups_2_calls_incoming', :service_category_rouming_id => _sc_bln_my_planet_groups_2, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0})  

#bln_my_planet_groups_2 (остальные страны), calls, outcoming, 
category = {:name => '_sctcg_bln_my_planet_groups_2_calls', :service_category_rouming_id => _sc_bln_my_planet_groups_2, :service_category_calls_id => _calls_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#bln_my_planet_groups_2 (остальные страны), sms, outcoming
category = {:name => '_sctcg_bln_my_planet_groups_2_sms_outcoming', :service_category_rouming_id => _sc_bln_my_planet_groups_2, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 9.0})  


@tc.add_tarif_class_categories


#Пожалуйста, подключайте роуминговые опции заранее. Если вы абонент постоплатной системы расчётов и подключили опцию, находясь в стране, где местное время отстаёт от московского, опция начнет действовать, когда местное время в стране пребывания совпадет с московским.
#Услуга доступна к подключению физическим и юридическим лицам предоплатной и постоплатной системы расчетов во всех регионах России.
#Услуга действует до момента самостоятельного отключения абонентом.
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки в международном роуминге тарифицируются с первой секунды. Исходящие вызовы на номера спутниковых систем связи тарифицируются по стандартным тарифам.
#При подключении услуги «Моя Планета», услуги «Планета Ноль» и «Мультипасс» не предоставляются и будут автоматически отключены, если были подключены ранее.
#Услуга недоступна на всех тарифных планах для USB-модемов и планшетов.
#Цена указаны с учетом НДС.
