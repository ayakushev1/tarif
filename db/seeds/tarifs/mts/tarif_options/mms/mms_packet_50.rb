#Пакет 50 MMS
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_mms_packet_50, :name => 'Пакет 50 MMS', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :dependency => {
    :categories => [_tcgsc_mms],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Добавление новых service_category_group for smart+
  #calls included in tarif
  scg_mts_mms_packet_50 = @tc.add_service_category_group(
    {:name => 'scg_mts_mms_packet_50' }, 
    {:name => "price for scg_mts_mms_packet_50"}, 
    {:calculation_order => 0, :price => 110.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(50 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count((description->>'volume')::integer)"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(count((description->>'volume')::integer) / 50)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

#Without region, mms, Outcoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mms_outcoming, scg_mts_mms_packet_50[:id]) 

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
