@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_100_sms, :name => '100 SMS', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/sms_packs.html'},
  :dependency => {
    :incompatibility => {
      :sms_pakets_and_options_for_sms => [
        _mgf_sms_stihia, _mgf_100_sms, _mgf_paket_sms_100, _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000,
        _mgf_sms_stihia, _mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, 
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => true
  } } )

#sms included in tarif
  scg_mgf_100_sms = @tc.add_service_category_group(
    {:name => 'scg_mgf_100_sms' }, 
    {:name => "price for scg_mgf_100_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 150.0} } } )

#Own and home regions, sms, to_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_100_sms[:id])

#Own and home regions, sms, to_not_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_not_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_100_sms[:id])


@tc.add_tarif_class_categories

#Пакеты SMS доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «МегаФон – Все включено», «МегаФон – Все включено 2012», «МегаФон – Онлайн», «О`Хард», «Переходи на НОЛЬ», «Подмосковный», «Свобода слова», «Твоё время», «Твоя сеть», «Тёплый приём», на тарифах «FIX», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Ветеран», «Видеоконтроль» (кроме пакета «100 SMS»), «Вокруг света», «Все просто», «Гибкий», «Домашний», «Единый», «За Три», «Контакт», «Международный», «ММС-Камера» (кроме пакета «100 SMS»), «Мобильный», «О’Лайт», «Первый Федеральный», «Приём Частный СИТИ», «Просто», «Ринг-Динг», «₽вый», «Своя сеть», «Связь городов», «Смешарики», «Студенческий», «ФиксЛАЙТ», а также отдельных корпоративных тарифных планах.
#Разноименные пакеты можно комбинировать, подключив одновременно несколько пакетов SMS разного объёма.
#Неиспользованный объём пакета на следующий месяц не переносится.
#Возможно одновременное подключение сразу нескольких пакетов «100 SMS». В таком случае объём SMS суммируется, а срок действия всех подключенных пакетов составит 30 календарных дней с момента подключения последнего из пакетов.
#Пакеты расходуются при отправке любых исходящих SMS, за исключением сообщений на короткие и сервисные номера.
#Пакеты SMS не работают при нахождении за пределами Московского региона.
#В месяц подключения пакета включенный объем SMS предоставляется пропорционально числу дней со дня подключения до конца текущего месяца. Абонентская плата также рассчитывается исходя из фактически предоставленного объема.
