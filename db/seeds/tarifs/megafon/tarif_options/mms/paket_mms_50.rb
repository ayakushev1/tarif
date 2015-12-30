@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_paket_mms_50, :name => 'Пакет MMS-50', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/mms_packs.html#21265'},
  :dependency => {
    :incompatibility => {:mms_pakets => [_mgf_paket_mms_10, _mgf_paket_mms_50, _mgf_mms_24]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, _mgf_megafon_online,
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => true
  } } )

#mms included in tarif
  scg_mgf_paket_mms_50 = @tc.add_service_category_group(
    {:name => 'scg_mgf_paket_mms_50' }, 
    {:name => "price for scg_mgf_paket_mms_50"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 50.0, :price => 235.0}, :window_over => 'month' } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 20.0} } })  

#Own and home regions, mms, Outcoming
category = {:name => '_sctcg_own_home_regions_mmsoutcoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_paket_mms_50[:id])

@tc.add_tarif_class_categories

#Пакеты MMS доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «МегаФон – Все включено», «МегаФон – Все включено 2012», «МегаФон – Онлайн», «О`Хард», «Переходи на НОЛЬ», «Подмосковный», «Свобода слова», «Твое время», «Твоя сеть», «Теплый прием», на тарифах «FIX», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Ветеран», «Вокруг света», «Все просто», «Гибкий», «Домашний», «Единый», «За Три», «Контакт», «Международный», «Мобильный», «О’Лайт», «Первый Федеральный», «Прием Частный СИТИ», «Просто», «Ринг-Динг», «₽вый», «Своя сеть», «Связь городов», «Смешарики», «Студенческий», «ФиксЛАЙТ», а также отдельных корпоративных тарифных планах.
#Разноименные пакеты можно комбинировать, подключив одновременно несколько пакетов MMS разного объема. 
#Неиспользованный объем пакета на следующий месяц не переносится. 
#Пакет MMS расходуется при отправке любых исходящих MMS, за исключением сообщений на короткие и сервисные номера.
#Пакет MMS не работает при нахождении за пределами Московского региона.
#В месяц подключения пакета включенный объем MMS предоставляется пропорционально числу дней со дня подключения до конца текущего месяца. Абонентская плата также рассчитывается исходя из фактически предоставленного объема.
