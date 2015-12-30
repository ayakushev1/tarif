@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_option_city_connection, :name => 'опция Связь городов', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {
    :http => 'http://moscow.megafon.ru/tariffs/options/archive/svyaz_gorodov.html#21238',}, 
  :dependency => {
    :incompatibility => {:_mgf_call_to_russia => [_mgf_call_to_russia, _mgf_option_city_connection]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, _mgf_megafon_online,
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )


#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, 
    :formula => {:params => {:price => 350.0} } })

#Own country, calls, outcoming, to all own country regions
  category = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 350.0, :price => 0.0}, :window_over => 'month' } }
    )


@tc.add_tarif_class_categories

#Пакет действует только при нахождении в Московском регионе. Опция не распространяется на звонки в Республику Крым и г. Севастополь, тарификация вызовов в данном направлении осуществляется в соответствии с условиями действующего тарифного плана.
#Пакет не действует при переадресованных вызовах на номера других регионов России, а также при звонках по направлению 
#«Выделенные корпоративные сети».
#Абонентская плата списывается при подключении пакета и далее единовременно и в полном объеме первого числа каждого нового месяца. 
#В месяц подключения абонентская плата списывается в размере, пропорциональном количеству оставшихся до конца месяца дней. Объем пакета также рассчитывается в соответствии с количеством дней до конца месяца. 
#Пакет «Связь городов» доступен для подключения на тарифах линеек «Все мобильные», «МегаФон — Все включено», «МегаФон — Все включено 2012», «МегаФон-Онлайн», «О`Хард», «Переходи на НОЛЬ», «Подмосковный», «Свобода слова», «Твое время», «Твоя сеть», «Теплый прием», на тарифах «FIX», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Вокруг света», «Все просто», «Вызов L», «Вызов LX СИТИ», «Вызов Xtreme», «Вызов Нон-Стоп», «Гибкий», «Домашний», «Единый», «За Три», «Контакт», «МегаФон-Логин», «МегаФон-Модем Плюс», «Международный», «Мобильный», «О`Лайт», «Первый Федеральный», «Прием Частный СИТИ», «Просто», «Просто для общения», «Ринг-Динг», «Рублевый», «Своя сеть», «Смешарики», «Студенческий», «ФиксЛАЙТ», а также отдельных корпоративных тарифах.
