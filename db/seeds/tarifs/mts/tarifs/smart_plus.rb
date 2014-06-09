#Smart+
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class('Smart+')
#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_plus_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :formula => {:window_condition => "(1000.0 >= sum_duration_minute)"}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_plus_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, :formula => {:window_condition => "(1000.0 >= count_volume)"}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_plus_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_plus_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, :formula => {:window_condition => "(3000.0 >= sum_volume)"}, :price => 0.0, :description => '' }
    )
  
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 900.0})

#Without region, mms, Incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mms_incoming, _scg_free_count_volume)

#Without region, mms, Outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5000000000})  

#Own region, Calls, Incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_incoming, _scg_free_sum_duration)

#Own region, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_local_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own region, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_other_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_local_other_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0})

#Own region, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_fixed_line, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_local_fixed_line, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0})

#Own region, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_own_operator, _sctcg_own_region_calls_local_own_operator)

#Own region, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_other_operator, _sctcg_own_region_calls_local_other_operator)

#Own region, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Own region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_own_country_own_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})

#Own region, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_own_country_other_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own region, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_own_country_fixed_line, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own region, Calls, Outcoming, to_sic_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_sic_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 29.0})

#Own region, Calls, Outcoming, to_europe
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_europe, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own region, Calls, Outcoming, to_other_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_other_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#Own region, sms, Incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_sms_incoming, _scg_free_count_volume)

#Own region, sms, Outcoming, to_local_number
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_sms_local, scg_mts_smart_plus_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_sms_local, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.5000000000})

#Own region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_sms_home_region, _sctcg_own_region_sms_local)

#Own region, sms, Outcoming, to_own_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_sms_own_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.8000000000})

#Own region, sms, Outcoming, to_not_own_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_sms_not_own_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.2500000000})

#Own region, Internet
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_internet, scg_mts_smart_plus_included_in_tarif_internet[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_internet, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.1000000000})


#Home region, Calls, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_incoming, _sctcg_own_region_calls_incoming)

#Home region, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_other_operator, _sctcg_own_region_calls_local_other_operator)

#Home region, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Home region, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_other_operator, _sctcg_own_region_calls_local_other_operator)

#Home region, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Home region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, _sctcg_own_region_calls_own_country_own_operator)

#Home region, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_other_operator, _sctcg_own_region_calls_own_country_other_operator)

#Home region, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_fixed_line, _sctcg_own_region_calls_own_country_fixed_line)

#Home region, Calls, Outcoming, to_sic_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_sic_country, _sctcg_own_region_calls_sic_country)

#Home region, Calls, Outcoming, to_europe
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_europe, _sctcg_own_region_calls_europe)

#Home region, Calls, Outcoming, to_other_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_other_country, _sctcg_own_region_calls_other_country)

#Home region, sms, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_incoming, _sctcg_own_region_sms_incoming)

#Home region, sms, Outcoming, to_local_number
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_local, _sctcg_own_region_sms_local)

#Home region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_home_region, _sctcg_own_region_sms_local)

#Home region, sms, Outcoming, to_own_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_own_country, _sctcg_own_region_sms_own_country)

#Home region, sms, Outcoming, to_not_own_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_not_own_country, _sctcg_own_region_sms_not_own_country)
    
#Home region, Internet
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_internet, _sctcg_own_region_internet)

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга

#Own country, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_other_operator, _sctcg_own_region_calls_own_country_other_operator)

#Own country, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_fixed_line, _sctcg_own_region_calls_own_country_fixed_line)

#Own country, Calls, Outcoming, to_sic_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_sic_country, _sctcg_own_region_calls_sic_country)

#Own country, Calls, Outcoming, to_europe
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_europe, _sctcg_own_region_calls_europe)

#Own country, Calls, Outcoming, to_other_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_other_country, _sctcg_own_region_calls_other_country)

#Own country, sms, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_sms_incoming, _sctcg_own_region_sms_incoming)

#TODO проверить что при путешествии по стране интернет есть, но его скорость ограничена (очень медленна) в случае, если не включена опция "Везде как дома"
#Own country, Internet
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_internet, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9000000000})


#All world, sms, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_all_world_sms_incoming, _sctcg_own_region_sms_incoming)



  
  @tc.load_repositories

#Первоначальный пакет услуг
#Мобильный помощник; Интернет-помощник; Переадресация вызова; SMS; Ожидание/удержание вызова; Конференц-связь; Определитель номера; 
#Автоинформирование о балансе; GPRS; SMS-информирование при добавлении/удалении услуг; Легкий роуминг и международный доступ; 
#Доступ без настроек; Ежемесячная плата Smart +; Видеозвонок; На полном доверии; Везде как дома Smart

#БЕСПЛАТНЫЕ услуги и сервисы, которые можно активировать или настроить
#Мой новый номер; МТС-Бонус; Международный и национальный роуминг; Детализация разговоров в Интернет-Помощнике;

#Команды
# *111*1025# Команда для перехода на тарифный план «Smart+»
# *100*1# Команда для проверки остатка пакетов минут и SMS


#Опция "Городской Номер" - 500 рублей в месяц (за счет подключения услуги МТС "Городской номер", плата 304,80 рублей)

#Опция "Везде как дома Smart" - звонки и интернет в сети МТС на территории России по тарифам своего региона

#В случае подключенных опций «МТС Планшет», «Безлимит-Mini», «Безлимит-Maxi», «Безлимит-Super», «Безлимит-VIP», «Интернет-Mini», «Интернет-Maxi», «Интернет-Super», 
#«Интернет-VIP» (все модификации опций) тарификация осуществляется по условиям подключенной опции.
#В случае подключенной опции «БИТ + Мобильное ТВ» тарификация осуществляется по условиям тарифного плана; при этом абонент имеет возможность просматривать «Мобильное ТВ».

#В случае подключенной опции «Безлимит на день по России» и нахождении абонента на территории г.Москвы и Московской области тарификация осуществляется по условиям тарифного плана; 
#при нахождении абонента за пределами Московской области тарификация осуществляется по условиям подключенной опции.

#Вызовы на федеральные номера абонентов других операторов мобильной связи тарифицируются по направлению региона

#Тарификация поминутная. Все исходящие вызовы, продолжительностью 3 секунды и более, округляются поминутно в большую сторону. 
#Вызовы продолжительностью менее 3-х сек. не тарифицируются

#Суммарный объем переданных и полученных данных округляется в большую сторону с точностью до 100 Кбайт (единица тарификации) 
#для GPRS-трафика через точку доступа internet.mts.ru и 10 Кбайт (единица тарификации) для WAP-трафика через точку доступа wap.mts.ru по факту закрытия Интернет-соединения, 
#а также один раз в час в случае установленного Интернет-соединения. 1 Кбайт = 1024 байт, 1 Мбайт = 1024 Кбайт. 
#Тариф на передачу данных по протоколу EDGE, а так же с использованием технологии 3G равны тарифам на GPRS-трафик