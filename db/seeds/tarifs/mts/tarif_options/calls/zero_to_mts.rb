#Ноль на МТС
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_zero_to_mts, :name => 'Ноль на МТС', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_number_mts/zero_mts/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_super_mts],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#calls included in tarif
scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls = @tc.add_service_category_group(
  {:name => 'scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls' }, 
  {:name => "price for scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls"}, 
  {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
    :formula => {:window_condition => "(100.0 >= sum_duration_minute)", :window_over => 'day'}, :price => 3.5, :description => '' }
  )
  
#own region rouming    
_sctcg_own_home_regions_calls_to_own_home_regions_to_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_fixed_line}
_sctcg_own_home_regions_calls_to_own_country_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}

#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_to_own_operator, scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls[:id])

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line, scg_mts_zero_to_mts_to_own_home_regions_included_in_tarif_calls[:id])

#Own region, calls, outcoming, to own country, to own opertor
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_country_own_operator, {}, 
  {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
    :formula => {:window_condition => "(100.0 >= sum_duration_minute)", :window_over => 'day'}, :price => 3.5, :description => '' }  )

@tc.add_tarif_class_categories

#С 9 июня 2014 года подключайте на архивных тарифных планах линейки «Супер Ноль» и линейки «Супер МТС» опцию «Ноль на МТС» и общайтесь со своими родными и близкими бесплатно!
#При подключении опции «Ноль на МТС» абоненту ежесуточно предоставляется 100 бесплатных минут в сутки на звонки абонентам МТС Москвы и Московской области и 
#городские телефоны г. Москва, а также 100 бесплатных минут в сутки на звонки на номера МТС России.

#Стоимость подключения — 3,50 руб.
#Ежесуточная плата — 3,50 руб.

#Как подключить / отключить
#Есть три способа подключить / отключить опцию «Ноль на МТС»:
#наберите на своем мобильном телефоне: *899# – для подключения;
#*111*899# – для подключения или отключения и выберите соответствующий пункт меню;
#отправьте SMS на номер 111 с текстом: 899 – для подключения;
#8990 – для отключения;
#воспользуйтесь Личным кабинетом.

#Сколько стоит
#Стоимость подключения — 3,50 руб
#Ежесуточная плата — 3,50 руб.
#Стоимость подключения входит в стоимость первого дня использования опции. Плата за опцию списывается (в полном объеме) в ночь за следующие сутки.
#Чтобы узнать о количестве оставшихся бесплатных минут (в сутки), воспользуйтесь Интернет-Помощником или наберите на своем мобильном телефоне *100*1#.

#Опция «Ноль на МТС» предоставляет скидку 100% на исходящие вызовы по направлению МТС Москвы и Московской области и городские номера Москвы, 
#совершенные в Москве и Московской области, в размере 100 минут в сутки и скидку 100% на исходящие вызовы на МТС России, 
#совершенные в Москве и Московской области, в размере 100 минут в сутки.
#При подключении опции «Ноль на МТС» бесплатные минуты, предоставляемые за пополнение счета, не действуют. 
#Бесплатные минуты, предоставляемые на вызовы на номера МТС Москвы и Московской области в рамках базовых условий тарифа, 
#не суммируются с минутами на номера МТС Москвы и Московской области, предоставляемых по опции «Ноль на МТС».
#Все цены указаны с учетом НДС.
