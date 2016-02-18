#Звони бесплатно на МТС России 100
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_call_free_to_mts_russia_100, :name => 'Звони бесплатно на МТС России 100', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_number_mts/free_call_100/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:zero_to_mts => [_mts_call_free_to_mts_russia_100, _mts_zero_to_mts]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [_mts_super_mts],
    :multiple_use => false
  } } ) 

#calls included in tarif
scg_mts_zero_to_mts_russia_100_included_in_tarif_calls = @tc.add_service_category_group(
  {:name => 'scg_mts_zero_to_mts_russia_100_included_in_tarif_calls' }, 
  {:name => "price for scg_mts_zero_to_mts_russia_100_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 80.0, :price => 0.0}, :window_over => 'day' } }
    )
  
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 3.5} } })  

#Плата за использование
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 105.0} } })


#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator, 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_zero_to_mts_russia_100_included_in_tarif_calls[:id])

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_fixed_line, 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::FixedlineOperator] }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_zero_to_mts_russia_100_included_in_tarif_calls[:id])

#Own region, calls, outcoming, to own country, to own operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator, 
  :filtr => {:to_operators => {:in => [Category::Operator::Const::Mts] }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 0.0}, :window_over => 'day' } } )

@tc.add_tarif_class_categories

#Звони бесплатно на МТС России 100
#С 14 апреля 2014 года абоненты нового тарифного плана «Супер МТС» могут воспользоваться опцией «Звони бесплатно на МТС России 100» и 
#бесплатно общаться со своими родными и близкими.
#При подключении опции «Звони бесплатно на МТС России 100» абонентам тарифного плана «Супер МТС» ежесуточно предоставляется 100 бесплатных минут в сутки 
#на звонки абонентам МТС г. Москвы и Московской области и городские номера Москвы, а также 100 бесплатных минут в сутки на звонки абонентам МТС всей России.

#Как подключить / отключить 
#Есть три способа подключить / отключить опцию «Звони бесплатно на МТС России 100»:
#отправьте SMS на номер 111 с текстом: 868 – для подключения;
#8680 – для отключения;
#наберите на своем мобильном телефоне: *868# – для подключения;
#*111*868# – для подключения или отключения и выберите соответствующий пункт меню;
#воспользуйтесь Личным кабинетом.

#Сколько стоит
#Стоимость подключения — 2 руб.
#Ежесуточная плата — 2 руб.
#Стоимость подключения входит в стоимость первого дня пользования опцией. Плата за опцию списывается (в полном объеме) в ночь за следующие сутки.

#Чтобы узнать о количестве оставшихся бесплатных минут (в сутки), воспользуйтесь Интернет-Помощником или наберите на своем мобильном телефоне *100*1#.
#Опция «Звони бесплатно на МТС России 100» предоставляет скидку 100% на исходящие вызовы по направлению МТС России, совершенные в г. Москве и Московской области, 
#в размере 100 минут в сутки.
#Опция также увеличивает количество бесплатных минут на вызовы абонентам МТС г. Москвы и Московской области и городские номера Москвы 
#(предоставляемых по опции «Звони бесплатно на МТС»), совершенных в домашнем регионе, на 80 минут в сутки, 
#т.е. ежесуточно предоставляется 100=20+80 минут на вызовы абонентам МТС домашнего региона и городские номера Москвы.

#Все цены указаны с учетом НДС
