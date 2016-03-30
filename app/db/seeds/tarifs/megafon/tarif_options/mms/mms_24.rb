@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_mms_24, :name => 'MMS 24', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/mms-marafon.html'},
  :dependency => {
    :incompatibility => {:mms_pakets => [_mgf_paket_mms_10, _mgf_paket_mms_50, _mgf_mms_24]}, 
    :general_priority => _gp_tarif_option_without_limits, #_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, 
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 30.0} } })  

#Own and home regions, mms, Outcoming
category = {:name => '_sctcg_own_home_regions_mms_outcoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 4.0}, :window_over => 'day' } } )

@tc.add_tarif_class_categories

#Опция действует только при нахождении в Московском регионе.
#Опция действует ежедневно, за исключением 31 декабря и 1 января.
#В рамках опции предоставляются 100 бесплатных MMS-сообщений в сутки. Сообщения, отправленные сверх данного объёма, а также на номера других стран, оплачиваются согласно вашему тарифному плану.
#Опция не действует при отправке MMS-сообщений на короткие номера.
#Опция «MMS 24» доступна для подключения на тарифах линеек «Все мобильные», «Вызов», «МегаФон – Все включено», «МегаФон – Все включено 2012», «О`Хард», «Переходи на НОЛЬ», «Подмосковный», «Свобода слова», «Твоё время», «Твоя сеть», «Тёплый приём», на тарифах «FIX», «Безлимитный 3», «Безлимитный», «Безлимитный Премиум», «Ветеран», «Вокруг света», «Все просто», «Гибкий», «Домашний», «Единый», «За Три», «Контакт», «Международный», «Мобильный», «О`Лайт», «Первый Федеральный», «Приём Частный СИТИ», «Просто», «Просто для общения», «Ринг-Динг», «₽вый», «Своя сеть», «Связь городов», «Смешарики», «Студенческий», «ФиксЛАЙТ», а также отдельных корпоративных тарифах.
