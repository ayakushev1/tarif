#Интернет на день
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_unlimited_internet_on_day, :name => 'Интернет на день', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_comp/additionally_services/unlim_day/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit, _mts_bit], :higher => [_mts_mts_planshet, _mts_bit, _mts_super_bit, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip]},
    :prerequisites => [_mts_mts_connect_4],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 50.0})  

#Own and home regions rouming, internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 50.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_unlimited_internet_on_day', :description => '', 
     :formula => {
       :window_condition => "(500.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",

       :auto_turbo_buttons  => {
         :group_by => 'day',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_option => "ceil(sum((description->>'volume')::float) / 500.0)",
           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 500.0) / 500.0)",
           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 500.0) / 2000.0)"},
       :method => "price_formulas.price * count_of_usage_of_option + case when count_of_usage_of_500 > 2.66667 then count_of_usage_of_2000 * 200.0 when count_of_usage_of_500 > 0.0 then count_of_usage_of_500 * 75.0 else 0.0 end",
       } } } )    

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 50.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_unlimited_internet_on_day', :description => '', 
     :formula => {
       :window_condition => "(500.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",

       :auto_turbo_buttons  => {
         :group_by => 'day',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_option => "ceil(sum((description->>'volume')::float) / 500.0)",
           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 500.0) / 500.0)",
           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 500.0) / 2000.0)"},
       :method => "price_formulas.price * count_of_usage_of_option + case when count_of_usage_of_500 > 2.66667 then count_of_usage_of_2000 * 200.0 when count_of_usage_of_500 > 0.0 then count_of_usage_of_500 * 75.0 else 0.0 end",
       } } } )    

@tc.add_tarif_class_categories


#Есть три способа подключения/отключения опции «Интернет на день»:
#наберите на своем мобильном телефоне ;
#отправьте на номер 111 SMS с текстом: 67 — для подключения;
#670 — для отключения;
#воспользуйтесь Интернет-Помощником.
#Стоимость исходящего SMS на номера 111 - 0 руб. при нахождении на территории Российской Федерации в сети МТС и в международном роуминге.

#Кто может подключить 
#Тарифные планы, на которых доступно подключение/отключение опции:
#«МТС Коннект-4», «МТС Коннект.нетбук».
#Если же у вас тарифный план «МТС Коннект-1», «МТС Коннект-2», «МТС Коннект-3» то вы можете бесплатно перейти на тариф «МТС Коннект-4» 
#через Интернет-Помощник

#Сколько стоит
#Стоимость опции «Интернет на день»
#Подключение опции – 50 руб.
#Ежемесячная плата за опцию – 0 руб.
#Стоимость одного дня использования опции, при нахождении в г. Москва и Московской области - 50 руб.
#Стоимость одного дня использования опции, при нахождении во внутрисетевом роуминге – 50 руб.
#Интернет-трафик в период и в зоне действия опции – 0 руб./Мбайт.
#Отключение тарифной опции — бесплатно.

#Действие опции распространяется на точку доступа (APN) internet.mts.ru, wap.mts.ru.
#Плата за использование опции списывается единовременно в момент первого выхода в Интернет и далее за каждые сутки использования опции. 
#Под сутками понимается период времени с 03:00 до 03:00 следующих суток. Факт выхода в Интернет определяется установкой абонентским оборудованием 
#соединения с сетью Интернет.
#Списание платы за каждые сутки пользования опцией отображается в детализации и счетах как Internet_Category_IND («Выход в Интернет_Интернет на день» ) или Internet_Category_IND_roam («Выход в Интернет_Интернет на день_роуминг»).
#*взимается в случае выхода в Интернет
#Стоимость исходящего SMS на номер 111 - 0 руб. при нахождении на территории Российской Федерации в сети МТС и в международном роуминге.
#Все цены указаны с учетом НДС.

#Условия предоставления
#Опция «Интернет на день » действует для абонентов сети мобильной связи МТС г. Москвы и Московской области при нахождении на территории России.
#При превышении суточной квоты трафика 500 Мб для опции «Интернет на день » доступ в Интернет приостанавливается до конца текущих суток 
#(сутки рассчитываются от 03:00 до 03:00 следующих суток) или до момента активации турбо-кнопки. Фактическая скорость может отличаться от 
#заявленной и зависит от технических параметров сети мобильной связи МТС и от других обстоятельств, влияющих на качество связи.
#Квота для домашнего региона расходуется только в домашнем регионе и не расходуется в роуминге. 
#Аналогично квота для внутрисетевого роуминга не расходуется в домашнем регионе.
#Действие и параметры опции «Интернет на день » распространяется только на трафик через точку доступа (АPN) internet.mts.ru, wap.mts.ru 
#(трафик через АPN internet.mts.ru, wap.mts.ru тарифицируется по стоимости 0 руб.) и не распространяется на трафик через остальные АPN 
#(realip.msk, корпоративные АPN и пр.).
#Стоимость интернет-трафика - 0 руб./Мб.
#Учет интернет-трафика в суточной квоте трафика – покилобайтный.

#Опция «Интернет на день » взаимодействует с опциями «Безлимит-Mini/Maxi/Super/VIP», «Интернет-Mini/Maxi/Super/VIP», 
#«МТС Планшет» и всеми их модификациями, с пакетами «Коннект-100», «Коннект-250», «Коннект-500», «Коннект-1000», «Коннект-3000» 
#«Бонусный Коннект-200» и их модификациями. При одновременном использовании опции «Интернет на день» с любой из перечисленных опций, 
#приоритетнее условия «Безлимит-Mini» и т.п., т.е. тарификация и учет трафика производятся по условиям этих опций, при этом стоимость за 
#каждые сутки пользования в рамках опции «Интернет на день » не списывается.
#В случае одновременно подключенных опций «Интернет на день» и «WAP по цене Internet» весь трафик учитывается и тарифицируется по условиям 
#опции «Интернет на день».
#Опции «Интернет на день» и «Безлимит на день по России» являются взаимоисключающими. Если у абонента одновременно подключены опции 
#«Интернет на день 2013» и «Безлимит на день по России» действуют условия опции «Безлимит на день по России», т. е. 
#ограничение скорости в этом случае наступит при превышении суммарного объема 2048 Мбайт трафика в период действия услуги.
