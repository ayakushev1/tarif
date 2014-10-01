@tc = ServiceHelper::TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_my_sms_post, :name => 'Мои СМС (постоплатная)', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moi-sms/'},
  :dependency => {
    :incompatibility => {:sms_options => [_bln_sms_without_borders, _bln_my_sms, _bln_my_sms_post]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_600_post, _bln_all_for_900_post, _bln_total_all_post,],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 25.0})  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 150.0})


#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item,
   :formula => {:window_condition => "(100.0 >= count_volume)", :window_over => 'day'} } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.0})


@tc.add_tarif_class_categories


#Подключив опцию «Мои SMS», вы получаете возможность отправлять больше SMS  на любые местные номера по выгодной цене.
#Опция действует при нахождении абонента в домашней сети
#Опции «SMS мания», «SMS без границ», «SMS-пакеты», «Лёгкий смешанный пакет», «Средний смешанный пакет», «Тяжёлый смешанный пакет», «Полуночники», «SMS-движение», «SMS скидка», «SMS свобода»:
#отключаются автоматически, если вы подключаете опцию «Мои SMS» по номеру 067471 или на сайте
#должны быть отключены заранее – до подключения опции «Мои SMS», если вы подключаете ее в Личном кабинете
#Если опция «Мои SMS» подключена вместе с другими пакетными SMS-опциями, местные SMS не суммируются. В этом случае вы можете отправить максимум 100 местных SMS в сутки по цене 0 рублей для тарифов предоплатной системы расчетов и 3000 местных SMS в месяц по цене 0 рублей для тарифов постоплатной системы расчетов. 
#Опция доступна всем абонентам предоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Go 2012», «Всe включено. Мир», «Всё включено L +», «Всё включено L 2013», «Всё включено L Люкс», «Все включено LTE», «Всё включено M 2013», «Всё включено XL», «Всё включено XXL +», «Все включено XXL 2011», «Всё включено XXL 2013», «Всё включено XXL Городской», «Всё включено XXL Люкс», «Всё включено Голд», «Всё включено.Максимум», «Всё за 600», «Всё за 1200», «Всё за 2700», «Доктрина 77», «Простая логика». 
#Опция доступна всем абонентам постоплатной системы расчётов, на всех тарифных планах, за исключением тарифов «Все включено XXL 2011», «Всё включено L 2013», «Всё включено XXL 2013», «Всё включено L *», «Всё включено XXL *», «Всё за 600», «Всё за 1450», «Всё включено XL», «Всё включено Максимум», «Всё за 1200», «Всё за 2700», «Всё за 2050», «Всё за 3550».  
