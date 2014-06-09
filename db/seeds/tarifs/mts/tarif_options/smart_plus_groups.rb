#Smart+, only grouped calls, sms and internet
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class('Smart_plus_groups')
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

#Own region, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_other_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_fixed_line, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_own_operator, _sctcg_own_region_calls_local_own_operator)

#Own region, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_other_operator, _sctcg_own_region_calls_local_other_operator)

#Own region, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Own region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_own_country_own_operator, _sctcg_own_region_calls_local_own_operator)

#Own region, sms, Outcoming, to_local_number
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_sms_local, scg_mts_smart_plus_included_in_tarif_sms[:id])

#Own region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_sms_home_region, _sctcg_own_region_sms_local)

#Own region, Internet
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_internet, scg_mts_smart_plus_included_in_tarif_internet[:id])


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
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, sms, Outcoming, to_local_number
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_local, _sctcg_own_region_sms_local)

#Home region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_home_region, _sctcg_own_region_sms_local)

#Home region, Internet
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_internet, _sctcg_own_region_internet)



  
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