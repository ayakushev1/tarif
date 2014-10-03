@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_all_russia, :name => 'Вся Россия', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/allrus.html'},
  :dependency => {
    :incompatibility => {:intra_country_rouming => [_mgf_all_russia, _mgf_travel_without_worry, _mgf_everywhere_moscow_in_central_region]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => true
  } } )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0})  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})


#Own country, calls, incoming
  category = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})  

#Own country, calls, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})  

#Own country, sms, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_sms_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.0})  



@tc.add_tarif_class_categories

#–Действие опции начинается за пределами Домашнего региона (Домашним регионом является субъект РФ (область или республика), в котором был заключен договор на оказание услуг связи с ОАО «МегаФон».);
#–Опцию могут подключить абоненты всех коммерческих и корпоративных тарифных планов, кроме тарифного плана «Вокруг света»;
#–SMS-сообщения на номера контент-провайдеров и поставщиков прочих развлекательных услуг тарифицируются вне рамок Опции;
#–Срок действия Опций не ограничен. Опция действует до момента отключения услуги абонентом.
