@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_beeline_post, :name => 'Мой Билайн (постоплатная)', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moy-beeline/'},
  :dependency => {
    :incompatibility => {:sms_options => [_bln_sms_without_borders, _bln_my_sms, _bln_my_sms_post]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_bln_my_intracity], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
      _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post], :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
  #calls included in tarif
  scg_bln_my_beeline_post_calls = @tc.add_service_category_group(
    {:name => 'scg_bln_my_beeline_post_calls' }, 
    {:name => "price for scg_bln_my_beeline_post_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 3000.0, :price => 0.0}, :window_over => 'month' } }
    )

#Подключение
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 0.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 210.0} } })


#Own and home regions, Calls, Outcoming, to_own_and_home_regions, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_and_home_regions_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_my_beeline_post_calls[:id])
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_my_beeline_post_calls[:id])
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })



@tc.add_tarif_class_categories



#При подключении опции «Мой Билайн» автоматически отключаются услуги: «Безлимит внутри сети», «Безлимит внутри сети+», «Безлимит на номера «Билайн» России», «Безлимит внутри сети со скидкой», «Разговоры издалека». 
#Если одновременно подключены опции «Мой межгород» и «Мой Билайн»: 
#• звонки абонентам «Билайн» России рассчитываются согласно опции «Мой Билайн»
#• звонки остальным абонентам – согласно опции «Мой межгород»
#При подключении опции «Мой Билайн» автоматически отключаются услуги: «Безлимит внутри сети», «Безлимит внутри сети+», «Безлимит на номера «Билайн» России», «Безлимит внутри сети со скидкой», «Разговоры издалека».  
#Максимальная длительность разговоров с абонентами «Билайн» России при подключении опции:
#- 100 мин/сутки для тарифов предоплатной системы расчетов;
#- 3000 мин/месяц для постоплатной системы расчетов. 
#Количество соединений в сутки и длительность каждого соединения не ограниченны.
#Опция действует бессрочно. Предложение действует при нахождении абонента в домашней сети.
#При нахождении абонента в роуминге ежедневная плата за опцию «Мой Билайн» списывается в соответствии с указанными условиями, при этом минуты местных и междугородных вызовов на номера Билайн по цене 0 рублей за минуту не предоставляется, тарификация звонков осуществляется в соответствии с тарифным планом.
#При подключении опции «Мой Билайн» автоматически отключаются услуги «Безлимит внутри сети», «Безлимит внутри сети+», «Безлимит на номера «Билайн» России», «Безлимит внутри сети со скидкой», «Разговоры издалека».
#Абонентская плата для тарифов предоплатной системы расчетов списывается посуточно (ночью). Если на момент списания средств на счету не достаточно, скидка в этот день не действует. 
#Абонентская плата для тарифов постоплатной системы расчетов помесячная.
#Абонентская плата, если она предусмотрена тарифом абонента, после подключения услуги сохраняется.
#Услуга доступна абонентам — физическим лицам Московского региона предоплатной системы расчетов (кроме тарифов линейки «ВСЁ!» и «Всё включено»), а также физическим и юридическим лицам Московского региона постоплатной системы расчетов (кроме тарифов: «Всё за 600», «Всё за 1200", «Всё за 1450», «Всё за 2050», «Всё за 2700», «Всё за 3550», «Всё включено XL», «Всё включено Максимум», «Всё включено Супер», «Все включено Супер 2013».)
