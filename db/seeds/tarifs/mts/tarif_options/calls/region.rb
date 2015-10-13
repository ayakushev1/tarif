#Область
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_region, :name => 'Область', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_all_numbers/oblast/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {:home_region_rouming_calls => [_mts_95_cop_in_moscow_region, _mts_region]}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => [_mts_unlimited_calls]},
  #TODO опция доступна только для архивных тарифов которые я еще не вбил, исправить после добавления архивных тарифов
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [-1], 
    :multiple_use => false 
  } } )

#TODO добавить разную тарификацию для разных регионов. В Московской области - 1 руб, а в Ленинградской - 47 коп.
  
#own region rouming    
_sctcg_home_region_calls_to_own_home_regions = {:name => '_sctcg_home_region_calls_to_own_home_regions', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
 
 
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 35.0})  

#Плата за использование
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 3.5})

#Own region, Calls, outcoming, to own and home regions, to all opertors
  @tc.add_one_service_category_tarif_class(_sctcg_home_region_calls_to_own_home_regions, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.0})

@tc.add_tarif_class_categories

#Тарифная опция «Область»
#Если Вы живете в Московской области или часто выезжаете в Подмосковье – то воспользуйтесь специальной тарифной опцией «Область». Опция «Область» - это 1 рубль за минуту вызова всем абонентам г. Москвы и Московской области при нахождении в области*.

#Кому доступна
#Опция «Область» доступна на тарифных планах «Первый», «МЫ», «RED», «RED_text», «RED New», «RED Energy2011», «RED Energy 2013», «RED Energy», 
#«Супер Первый», «Свободный», «Супер Ноль 2011», «Длинные разговоры», «Много звонков», «Много звонков +», «Много звонков на все сети», «Подружки», «Заботливый», 
#«Один.ру», «Классный» и тарифы линейки «Гостевой».

#Предложение действует с 15 апреля 2010 года.

#Сколько стоит
#Стоимость подключения опции – 35 рублей. Ежедневная плата – 3,50 рубля.
#Цены указаны с учетом налогов

#Как подключить/отключить
#Для подключения/отключения:
#отправьте SMS** с кодом 2189 (с кодом 21890 для отключения) на номер 111;
#наберите команду *111*2189#;
#воспользуйтесь сервисом «Интернет-Помощник».

#С 14 апреля 2011 года абоненты тарифного плана «Red Energy», «Red Energy2011» и «RED Energy 2013»  не могут подключать опцию «Область».

#Подробная информация.
#Если Вы находитесь на территории тарифной зоны «Область», то при включенном информационном канале на Вашем телефоне будет отображаться надпись «OBLAST»
#** Отправка SMS-сообщения для подключения услуги бесплатна при нахождении в г. Москве и Московской области, при отправке SMS в роуминге действует стоимость согласно роуминговым тарифам.

#Как работает с другими опциями

#Особенности предоставления и взаимодействие с другими тарифными опциями
#1. Специальная стоимость минуты с тарифной опцией «Область» для абонентов тарифных планов с разной стоимостью минуты вызова в рамках одного разговора 
#будет единой – 1 рубль за каждую минуту вызова, в том числе по номеру 0885.

#2. С опцией «Область» вызовы участникам групп «Вместе лучше», «Дуэт», «Для двоих» тарифицируются по стоимости, установленной для соответствующей группы, 
#остальные вызовы тарифицируются согласно опции «Область».

#3. Вызовы внутри линейки «RED», участникам «Группы Мы»,на «Льготный городской номер» на тарифе «Мы», вызовы с опцией «Выгодный баланс», 
#а также вызовы с подключенной услугой «19 копеек на все номера» на тарифе «Много звонков», «Единая цена на все сети» на тарифе «Много звонков+» тарифицируются по стоимости, 
#установленной для опции «Область».

#4. При одновременно подключенных тарифных опциях «Самые любимые»и «Область» вызовы на «любимые» номера тарифицируются в соответствии 
#с условиями предоставления опции «Самые любимые», остальные вызовы – в соответствии с условиями предоставления опции «Область».

#5. На специальную цену 1 рубль, действующую с опцией «Область», не распространяется скидка в рамках кампаний «Скидки постоянным клиентам», 
#«Ноль при платеже», скидка по опции «Номера МТС», «Свободное время» кроме тарифов «Много звонков» и «Много звонков+».

#6. На специальную цену 1 рубль, действующую с опцией «Область», распространяется скидка по опции «Любимые номера».

#7. При одновременно подключенных опциях «Область» и «Безлимитные звонки» на тарифе «RED Energy» вызовы абонентам МТС г. Москвы и Московской области 
#будут тарифицироваться по опции «Безлимитные звонки», остальные вызовы - в соответствии с опцией «Область».

#8. Для участников акции «Твой паспорт в год молодежи» при подключенной опции «Область» вызовы на «любимые» номера тарифицируются по условиям акции «Твой паспорт в год молодежи», 
#остальные вызовы – по опции «Область».

#9. Абонент может одновременно подключить опцию «Область» и «RED_Zone»
#Специальные тарифы по каждой опции будет действовать при нахождении в соответствующей зоне тарификации.

#10. В случае перехода на тариф, на котором опция «Область» предоставляется, она сохраняется. В случае перехода на тариф, на котором не доступно использование опции «Область», 
#она прекращает действовать.

#11. Опции «Область» и «95 копеек в Московской области» на тарифе «RED Energy», «RED Energy2011»  и «RED Energy 2013» взаимоисключаемые. 
#Т.е., при подключении опции «95 копеек в Московской области» опция «Область» автоматически отключится.

#12. Вызовы по направлениям, не указанным в настоящих условиях, а также вызовы, совершенные абонентом при нахождении вне тарифной зоны «Область», 
#тарифицируются согласно условиям тарифного плана, на котором обслуживается абонент.

#13. Вызовы, переадресованные из тарифной зоны «Столица» и «Область», тарифицируются по тарифам вызовов из тарифной зоны «Столица».

#В связи с особенностями распространения радиоволн и рельефом местности граница тарифной зоны «Область» является примерной. 
#Тарификация вызова осуществляется по местонахождению той базовой станции, которая обслуживала данный вызов на момент соединения
