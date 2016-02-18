#Пакет 10 MMS
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_mms_packet_10, :name => 'Пакет 10 MMS', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/messaging/mms/discount2_mms/sms_pack/'},
  :dependency => {
    :categories => [_tcgsc_mms],
    :incompatibility => {:mms_packets => [_mts_mms_discount_50_percent, _mts_mms_packet_10, _mts_mms_packet_20, _mts_mms_packet_50]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Добавление новых service_category_group for smart+
  #calls included in tarif
  scg_mts_mms_packet_10 = @tc.add_service_category_group(
    {:name => 'scg_mts_mms_packet_10' }, 
    {:name => "price for scg_mts_mms_packet_10"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth,  
      :formula => {:params => {:max_count_volume => 10.0, :price => 35.0} } } )

 
#_all_russia_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_rouming_mms', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_mms_packet_10[:id]) 

  category = {:name => '_sctcg_all_russia_rouming_mms', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_mms_packet_10[:id]) 

#_all_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_world_rouming_mms', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_mms_packet_10[:id]) 

@tc.add_tarif_class_categories
  
#TODO проверить, действует ли опция в международном роуминге

#МТС предлагает 3 вида MMS-пакетов: «MMS пакет 10», «MMS пакет 20» и «MMS пакет 50».
#Пакет        Стоимость, руб.  Команда подключения
#Пакет 10 MMS  35               *111*445*10# 
#Пакет 20 MMS  60               *111*445*20# 
#Пакет 50 MMS  110              *111*445*50# 
 
#Стоимость списывается в момент подключения. Неизрасходованные за месяц сообщения не сохраняются.
#Срок действия MMS-пакетов - 30 дней.
#Цены указаны в рублях с учетом налогов

#Как узнать остаток MMS и срок действия пакета
#набрав *119#; через Интернет-Помощник.

#Условия
#MMS-пакеты доступны для пользователей любых тарифных планов.

#При помощи пакетов MMS Вы можете рассылать сообщения:
#на телефонные номера внутри сети или на номера других операторов сотовой связи;
#на электронную почту — адресат получит MMS как обычное письмо;
#на номера абонентов, находящихся за пределами домашней сети (за границей или внутри страны), им нужно будет оплатить GPRS-трафик по роуминговым тарифам.

#Получатель может просмотреть MMS-сообщение через WEB/WAP-интерфейс без ввода логина и пароля.
#Ссылка действительна 7 дней.

#Подключение нескольких пакетов
#Вы можете подключить один пакет и пользоваться им регулярно или менять пакеты. При подключении нескольких пакетов количество неизрасходованных сообщений раннего пакета 
#суммируется с количеством нового, а сроком окончания будет срок действия максимального пакета.

#Как подключить
#через Интернет-помощник;
#через «SMS-Помощник», отправив на номер 111 SMS с текстом: 10MMS, 20MMS или 50MMS в зависимости от выбранного пакета.
#через приложение «МТС сервис»
#Название пакета и слово MMS пишутся без пробела. MMS — русскими либо латинскими буквами. Все буквы либо заглавные, либо строчные
