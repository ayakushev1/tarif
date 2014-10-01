@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_100_sms, :name => '100 SMS', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/sms_packs.html'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip, 
      _mgf_go_to_zero, _mgf_sub_moscow, _mgf_around_world, _mgf_all_simple, _mgf_warm_welcome, _mgf_go_to_zero, _mgf_city_connection],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#sms included in tarif
  scg_mgf_100_sms = @tc.add_service_category_group(
    {:name => 'scg_mgf_100_sms' }, 
    {:name => "price for scg_mgf_100_sms"}, 
    {:calculation_order => 0, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(100 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count(description->>'volume')"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(count(description->>'volume') / 100.0)",
                          :count_volume => "count(description->>'volume')"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

#Own and home regions, sms, to_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_100_sms[:id])

#Own and home regions, sms, to_own_country
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
