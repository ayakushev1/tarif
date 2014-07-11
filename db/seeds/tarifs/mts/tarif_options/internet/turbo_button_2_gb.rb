#Турбо-кнопка 2 Гб
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_turbo_button_2_gb, :name => 'Турбо-кнопка 2 Гб', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_smart, _mts_smart_plus, _mts_ultra],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )
  
#Добавление новых service_category_group
  #internet included in tarif
scg_mts_additional_internet_2_gb_for_smart = @tc.add_service_category_group(
    {:name => 'scg_mts_additional_internet_2_gb_for_smart' }, 
    {:name => "price for scg_mts_additional_internet_2_gb_for_smart"}, 
    {:calculation_order => 0, :price => 200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_additional_internet_2_gb_for_smart', :description => '', 
     :formula => {
       :window_condition => "(2000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 2000.0)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_additional_internet_2_gb_for_smart[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_additional_internet_2_gb_for_smart[:id], 
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )
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
