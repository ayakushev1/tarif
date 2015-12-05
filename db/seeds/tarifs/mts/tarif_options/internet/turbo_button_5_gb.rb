#Турбо-кнопка 5 Гб
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_turbo_button_5_gb, :name => 'Турбо-кнопка 5 Гб', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_phone/additionally_services/turbo/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
#      :turbobuttons => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb,
#        _mts_additional_internet_smart_mini, _mts_additional_internet_smart, _mts_additional_internet_smart_other,
#        _mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb],
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )
  

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

#All_russia_rouming, Internet
  category = {:name => '_sctcg_all_russia_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

@tc.add_tarif_class_categories

#TODO добавить порядок расчета опций и тарифов. Многие опции используются после исчерпания лимитов основного тарифа
#Эта опция должна считаться после тарифа

#Тарифная опция: Турбо-кнопка 500 Мб
#Квота трафика: 500 Мб
#Стоимость: 75 руб.
#Как подключить:
#наберите *167#;
#отправьте SMS с текстом 167 на номер 53401 .
#Отключение: автоматически.

#Тарифная опция: Турбо-кнопка 2 Гб
#Квота трафика: 2 Гб
#Стоимость: 200 руб.
#Как подключить:
#наберите *168#;
#отправьте SMS с текстом 168 на номер 53401
#Отключение: автоматически.

#Чтобы проверить остаток трафика, наберите *111*217# C

#Условия предоставления опций
#Опции может подключить абонент тарифов «Smart», «Smart+» и «ULTRA», использующий как базовые объемы Интернет-трафика, предоставляемые по тарифу, 
#так и имеющий дополнительно подключенные безлимитные Интернет-опции
#Плата за опции списывается в момент подключения.
#Опции действуют в течение 30 дней с момента подключения, либо до момента исчерпания включенной квоты трафика (какое событие наступит ранее).
#В период действия опций расходуемый трафик не учитывается в месячной квоте трафика по тарифу или в рамках подключенной интернет-опции 
#(в случае ее наличия).
#Точки доступа (APN): internet.mts.ru, wap.mts.ru.

#Зона действия опций
#Зона действия опций соответствует зоне действия объема Интернет-трафика, предоставляемого по тарифу, либо зоне действия подключенной интернет-опции (в случае ее наличия).
#На тарифном плане «Smart» при нахождении во внутрисетевом роуминге за пределами зоны действия объема Интернет-трафика по тарифу 
#(или зоны действия подключенной интернет-опции), трафик будет тарифицироваться по базовым тарифам внутрисетевого роуминга, при этом квота трафика, \
#начисленного в рамках подключенной опции «Турбо-кнопка 500 Мб» или «Турбо-кнопка 2 Гб», будет расходоваться

#Взаимодействие опций
#При одновременном подключении опций «Турбо-кнопка 500 Мб» и/или «Турбо-кнопка 2 Гб» (в любых комбинациях), квоты трафика суммируются. 
#Срок действия – 30 дней с момента подключения последней турбо-кнопки, либо до исчерпания суммированной квоты трафика 
#(какое событие наступит ранее).
#При одновременном подключении «Турбо-кнопки» и «Турбо-кнопки 500 Мб» и/или «Турбо-кнопки 2 Гб» приоритет имеет опция «Турбо-кнопка».
