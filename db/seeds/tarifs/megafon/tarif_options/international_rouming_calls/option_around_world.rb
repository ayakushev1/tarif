#International rouming
@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_option_around_world, :name => 'опция Вокруг света', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/aworld.html'},
  :dependency => {
    :incompatibility => {
      :international_calls_options => [
        _mgf_all_world, _mgf_minute_packs_25_europe, _mgf_minute_packs_50_europe, _mgf_minute_packs_25_world, _mgf_minute_packs_50_world, 
        _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 15.0})  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 9.0})


#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, incoming
category = {:name => '_sctcg_mgf_option_around_world_1_calls_incoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_1, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 13.0})  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_option_around_world_1_calls_to_russia', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 13.0})  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_option_around_world_1_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 13.0})  

#Страны Европы и СНГ, Турция, Абхазия, Южная Осетия, sms, outcoming
category = {:name => '_sctcg_mgf_option_around_world_1_sms_outcoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_1, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 11.0})  


#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, incoming
category = {:name => '_sctcg_mgf_option_around_world_2_calls_incoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_2, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0})  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_option_around_world_2_calls_to_russia', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0})  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_option_around_world_2_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 19.0})  

#Виргинские о-ва (США), Вьетнам, Гонконг, Египет, Израиль, Корея, Корея Южная, ОАЭ, Пуэрто-Рико, США, Таиланд, Япония, sms, incoming
category = {:name => '_sctcg_mgf_option_around_world_2_sms_outcoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_2, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 14.0})  


#Китай и остальные страны, calls, incoming
category = {:name => '_sctcg_mgf_option_around_world_3_calls_incoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_3, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 43.0})  

#Китай и остальные страны, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_option_around_world_3_calls_to_russia', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_3, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 43.0})  

#Китай и остальные страны, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_option_around_world_3_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_3, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 43.0})  

#Китай и остальные страны, sms, outcoming
category = {:name => '_sctcg_mgf_option_around_world_3_sms_outcoming', :service_category_rouming_id => _sc_mgf_rouming_in_option_around_world_3, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 14.0})  


@tc.add_tarif_class_categories

#–Для корректной работы опции, после ее подключения, необходимо выключить и включить ваше мобильное устройство.
#–Если абонент, подключивший опцию, находится в стране, где местное время отстает от московского, то скидка начнет действовать только тогда, когда местное время совпадет со временем подключения опции по Москве.
#–Стоимость услуг связи по тарифной опции не распространяется на вызовы, которые совершаются через сети спутниковой связи с помощью специального оборудования.
#–Опция «Вокруг света» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон», кроме «Вокруг света», «Интернет старт», «Командировочный», «МегаФон-Логин», «МегаФон-Логин Безлимитный» и «МегаФон-Логин Оптимальный».
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500. 

