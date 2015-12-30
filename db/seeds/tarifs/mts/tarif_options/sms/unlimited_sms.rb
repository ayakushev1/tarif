#Безлимитные SMS
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_unlimited_sms, :name => 'Безлимитные SMS', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/messaging/sms/discount2/sms_unlim/'},
  :dependency => {
    :categories => [_tcgsc_sms],
    :incompatibility => {:sms_packets => [_mts_monthly_sms_packet_100, _mts_monthly_sms_packet_300, _mts_monthly_sms_packet_500, _mts_monthly_sms_packet_1000,
      _mts_onetime_sms_packet_50, _mts_onetime_sms_packet_150, _mts_onetime_sms_packet_300]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_red_energy],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 300.0} } })

#Own and home regions, sms, outcoming, to own and home regions, to own operator
  category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#Own and home regions, sms, outcoming, to own and home regions, to other operators
  category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions_to_other_operators', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed,  
      :formula => {:params => {:max_count_volume => 30.0, :price => 0.0}, :window_over => 'day' } } )

@tc.add_tarif_class_categories


#Пакеты SMS

#МТС предлагает 2 типа пакетов:
#Периодические SMS-пакеты для тех, кто постоянно отправляет много SMS (автоматически продлеваются каждый месяц, пока Вы их не отключите): 
 
#Пакет          Ежемесячная плата, руб.Команда подключения
#Пакет 100 SMS    120                     *111*0100# 
#Пакет 300 SMS    210                     *111*0300# 
#Пакет 500 SMS    260                     *111*0500# 
#Пакет 1000 SMS   340                     *111*01000# 

#Ежемесячная плата списывается в полном объеме в момент подключения пакета и далее первого числа каждого календарного месяца, независимо от количества денежных средств на балансе. При подключении услуги пакет SMS предоставляется в полном объеме, не позднее 04:00 следующих суток после заказа услуг. Далее пакет предоставляется первого числа каждого месяца, при этом неиспользованные сообщения сгорают. Срок действия пакета, в течение которого пакеты будут автоматически обновляться, не ограничен - пакет действует до момента отключения услуги абонентом.
#Разовые SMS-пакеты для тех, кто планирует отправлять много SMS в определенный период времени (подключаются на один месяц): 

#Пакет        Стоимость, руб.    Команда подключения
#SMS пакет 50   75                *111*444*50# 
#SMS пакет 150  200               *111*444*150# 
#SMS пакет 300  300               *111*444*300# 

#Стоимость списывается с лицевого счета абонента в полном объеме в момент подключения. 
#Срок действия пакета — 30 календарных дней с момента активации. После истечения этого периода неизрасходованные сообщения не сохраняются. 
#Время отключения пакета равно времени подключения, например, пакет подключенный в 12:00 будет отключен в 12:00 через 30 суток.
#Цены указаны в рублях с учетом налогов.

#Как узнать остаток SMS и срок действия пакета
#через Мобильный и Интернет-помощники.
#набрав *100*1# — для периодических SMS-пакетов
#*100*2# — для разовых SMS-пакетов

#Условия
#Пакеты SMS действуют на территории домашнего региона при отправке SMS сообщений на телефонные номера абонентов сотовых операторов связи домашнего региона.
#Исходящие SMS сообщения при нахождении во внутрисетевом, национальном и международном роуминге оплачиваются согласно роуминговым тарифам на SMS.
#Исходящие SMS-сообщения на телефоны участников группы "Вместе лучше" и на короткие номера в пакеты не входят.
#Периодические SMS-пакеты доступны для всех пользователей не корпоративных тарифных планов за исключением тарифа ULTRA.
#Разовые SMS-пакеты доступны для всех пользователей не корпоративных тарифных планов и для корпоративных тарифных планов «Команда», «Свой бизнес», «Бизнес общение», 
#за исключением тарифных планов “Red Energy” и "MAXI Super", ULTRA.

#Способы подключения и отключения
#Периодические SMS-пакеты:
#через «Интернет-помощник»
#через «SMS-Помощник», отправив на номер 111 SMS с текстом: 0100 — Пакет 100 SMS; (отключение 00100)
#0300 — Пакет 300 SMS; (отключение 00300)
#0500 — Пакет 500 SMS; (отключение 00500)
#01000 — Пакет 1000 SMS; (отключение 001000)
#через приложение «МТС сервис»

#Разовые SMS-пакеты:
#через «Интернет-помощник»
#через «SMS-Помощник», отправив на номер 111 SMS с текстом: 50SMS, 150SMS или 300SMS (в зависимости от выбранного пакета).
#через приложение «МТС сервис»

#Название пакета и слово SMS пишутся без пробела. SMS — русскими либо латинскими буквами. Все буквы либо заглавные, либо строчные.
#Подключение нескольких пакетов
#Периодические SMS-пакеты
#Услуги «Пакет 100 SMS», «Пакет 300 SMS», «Пакет 500 SMS» и «Пакет 1000 SMS» являются взаимоисключающими. 
#При подключении пакета другого номинала ранее подключенный пакет будет автоматически отключен. 
#При этом неизрасходованный остаток SMS из ранее подключенного пакета сгорает. 
#В случае отключения пакета без подключения нового периодического пакета неизрасходованный остаток SMS может быть использован до конца календарного месяца.

#Разовые SMS-пакеты
#При одновременном подключении нескольких пакетов остаток SMS ранее подключенного пакета суммируется с номиналом подключаемого пакета, 
#при этом новый срок действия - это срок действия последнего из подключенных пакетов
