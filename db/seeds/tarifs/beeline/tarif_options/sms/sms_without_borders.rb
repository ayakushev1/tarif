@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_sms_without_borders, :name => 'СМС без границ', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/sms-bez-granic/'},
  :dependency => {
    :incompatibility => {:sms_options => [_bln_sms_without_borders, _bln_my_sms, _bln_my_sms_post]}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_bln_all_for_200, _bln_all_for_400, 
      _bln_all_for_600, _bln_all_for_600_post, _bln_all_for_900, _bln_all_for_900_post,
      _bln_all_for_1500, _bln_all_for_1500_post, _bln_all_for_2700, _bln_all_for_2700_post, _bln_total_all_post,
      _bln_go, _bln_welcome, _bln_mobile_pencioner, _bln_co_communication], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Периодическая плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.0} } })


@tc.add_tarif_class_categories


#Цены указаны с учетом НДС.
#Услуга действует только при отправке SMS-сообщений на номера абонентов г. Москвы и Московской области. Услуга не доступна в роуминге.
#Предложение не доступно на тарифных планах:
#Предоплатная система расчетов - группа тарифов «ВСЁ!», группа тарифов «Все включено» (кроме «Все включено M»), группа тарифов «Живи легко», «Go2012», «Go2013», «Стандарт 1», «Со-общение», «Доктрина 77», «Мобильный пенсионер», группа тарифов для модемов и планшетов, «Яблочный фреш»;
#Постоплатная система расчетов - группа тарифов «ВСЁ!», группа тарифов «Все включено», «Безлимитный», «Свободный стиль», «Легкий безлимит», «Семья», «Яблочный фреш», «Страна на связи», «Хочу сказать», «Мир билайн 2011», «Страна на связи 06», «Свободный стиль 06».
#Более подробную информацию вы сможет узнать по телефону: 060615.
