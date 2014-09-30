@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_in_russia_for_specific_options, :name => 'Интернет по России для определенных опций', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/inet.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_in_russia_for_specific_options => []}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})

#Own country, Internet
category = {:name => '_sctcg_mgf_own_country_rouming_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  



@tc.add_tarif_class_categories

#Опция начинает действовать через 10–15 минут после подключения.
#Опция доступна для абонентов, использующих тарифные планы «МегаФон-Логин Оптимальный», «МегаФон-Онлайн с модемом 4G+» и пакеты безлимитного интернета от «МегаФон».
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500.
#Опция действует в сетях 4G+/3G/2G по всей России, кроме Дальневосточного филиала ОАО «МегаФон», Таймырского муниципального района и г. Норильск, где тариф за 1 Мб составляет 9,9 руб., и Республики Крым и г. Севастополь, где тариф за 100 КБ составляет 19 руб.
#Отключение опции: *105*0042*0#.
