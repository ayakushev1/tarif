@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_unlimited_communication, :name => 'Безлимитное общение', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {
    :http => 'http://moscow.megafon.ru/tariffs/options/megafon_calls/bezlimitnoe_obschenie.html#price',
    :closed_to_switch_on => true}, 
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip,], :to_serve => []},
    :multiple_use => false
  } } )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 10.0})
  
#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(100.0 >= sum_duration_minute)", :window_over => 'day'}, :price => 0.0, :description => '' }
    )

@tc.add_tarif_class_categories

#Опция «Безлимитное общение» недоступна на тарифных планах: «МегаФон — Все включено S», «МегаФон — Все включено М», «МегаФон — Все включено L», «МегаФон — Все включено VIP».
#Внимание: «Безлимитное общение» невозможно подключить, если абонент пользуется опцией: «Беззаботные выходные», «Безлимитные выходные», «Белые ночи», «МегаЗвонки», «МегаЗвонки +», «МегаРоссия», «МегаРоссия +», «Своя сеть», «Своя сеть’» или «Час на МегаФон».
#При осуществлении абонентом нескольких исходящих вызовов одновременно (конференц-связь) пакет расходуется на каждое соединение.
#Возможность заказа тарифной опции будущей датой не предоставляется.
#Действие тарифной опции прекращается в момент ее отключения.
#После исчерпания суточного объема минут до начала новых суток действуют тарифы согласно тарифному плану абонента.
#При отключении опции неиспользованный объем минут не сохраняется и не компенсируется.

#Сутки считаются с 00:00:00 до 23:59:59.
#Чтобы начал действовать пакет нетарифицируемых минут нового дня, необходимо прерывание вызова в 23:59:59.
#Опция «Безлимитное общение» действует на территории Домашнего региона.
#Подключение ТО происходит только при наличии необходимой суммы на счете абонента. Если необходимая сумма (размер платы за подключение ТО и абонентской платы за ТО) отсутствует — то подключение не происходит. Плата за подключение и абонентская плата начисляются в момент подключения тарифной опции. 
#В рамках тарифной опции указана стоимость всех платных вызовов по направлениям, указанным выше, кроме платных переадресованных вызовов (а также переадресации на голосовую почту) и платных вызовов по приему и передаче факсов и данных.
