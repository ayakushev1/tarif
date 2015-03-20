#Везде как дома
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_everywhere_as_home, :name => 'Везде как дома', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/n_roaming/discounts/kakdoma/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:everywhere_as_home => [_mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [_mts_rodnye_goroda, _mts_love_country], :higher => [_mts_love_country_all_world]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})

#Own and home regions, Calls, Outcoming, to_own_country, to_all_operators
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own country, Calls, Incoming
  category = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own country, Calls, Outcoming, to_all_own_country_regions, to_all_operators
  category = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

@tc.add_tarif_class_categories

#наберите на своем телефоне команду *111*3333#вызов
#отправьте SMS на номер 111 с текстом 3333 для подключения / с текстом 33330 для отключения опции

#Как узнать, подключена ли опция - отправьте любое SMS на номер 8111

#TODO#абоненты всех тарифных планов МТС за исключением «Бизнес без границ» и «Бизнес без границ для корпоративных клиентов».

#опции «Супер 0 на МТС России», «Любимая страна. Весь мир» имеют приоритет перед опцией «Везде как дома». При этом в случае наличия одновременно подключенных опций «Любимая страна. 
#Весь мир», «Везде как дома» и подключаемых пакетов минут на междугородные звонки, пакеты минут не действуют (согласно условиям услуги «Любимая страна.Весь мир») 
#опции «Пакеты минут на межгород 50 (100, 300,1000)» имеют приоритет перед опцией «Везде как дома»; по завершении пакета действует стоимость в рамках опции «Везде как дома».
 
#опция «Везде как дома» взаимоисключается с опциями «Родные города», «Любимая страна Россия», «Выгодный межгород» — при подключении опции «Везде как дома», 
#опции «Любимая страна Россия», «Выгодный межгород», автоматически отключаются 
#при нахождении во внутрисетевом роуминге

#опция «Единая страна» имеет приоритет перед опцией «Везде как дома». 
#опция «Везде как дома» является взаимоисключающей с опциями «Все регионы МТС России», «Соседние регионы», опциями «Любимый регион» и «Любимый регион+».

#Особенности тарификации, действующие в г. Москве и Московской области:
#если условиями тарифного плана предусмотрены безлимитные вызовы по направлениям, на которые распространяется действие опции «Везде как дома», 
#тарификация производится в соответствии с условиями тарифного плана. 
#если условия тарифного плана предусматривают пакет минут по направлениям, на которые распространяется действие опции «Везде как дома», 
#сначала расходуется пакет минут, а после его завершения тарификация производится в соответствии с параметрами опции «Везде как дома». 
#если по условиям тарифного плана стоимость первой минуты вызовов на МТС России или междугородные номера, 
#а также вызовов на номера России в поездках по России в сети МТС без подключенных опций меньше, чем стоимость при подключенной опции «Везде как дома», 
#то вызовы по указанному направлению тарифицируются по домашнему тарифу по условиям тарифного плана. 

#Порядок списания ежесуточной платы за услугу:
#плата за опцию (ежедневная плата) списывается один раз в сутки (полностью за каждые полные или неполные сутки), независимо от местонахождения абонента


