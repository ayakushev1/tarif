#100 SMS в поездках по миру
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_100_sms_travelling_in_all_world, :name => '100 SMS в поездках по миру', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/discount_roaming/sms_paket/'},
  :dependency => {
    :categories => [_tcgsc_sms],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mts_50_sms_in_europe, _mts_100_sms_in_europe]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

_sctcg_not_russia_rouming_sms_outcoming = {:name => '_sctcg_not_russia_rouming_sms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_out}

#Own country, sms, Outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_not_russia_rouming_sms_outcoming, {}, 
    {:calculation_order => 0, :price => 700.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(100 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count(description->>'volume')"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(count(description->>'volume') / 100)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

@tc.add_tarif_class_categories

#Есть три способа подключения опции: наберите на своем мобильном телефоне *111*1101#вызов - отправьте SMS на номер 111 с текстом 1101 ;

#Как узнать остаток SMS и срок действия пакета - наберите на своем мобильном телефоне  *100*1#вызов

#Условия пользования
#В пакет включены исходящие SMS на мобильные телефоны всех операторов мобильной связи России и других стран мира.
#Пакет действует в течение 30 суток с момента подключения. Плата за подключение списывается с лицевого счета в полном объеме в момент подключения пакета. 
#После истечения срока действия неиспользованные SMS аннулируются. После израсходования пакета оплата SMS производится в соответствии с базовыми тарифами на роуминг. 
#При одновременном подключении нескольких пакетов действующих в одной и той же зоне остаток SMS из ранее подключенного пакета суммируется с номиналом подключаемого пакета, 
#при этом сроком действия будет выбран максимальный из сроков действия подключенных пакетов. 
#При одновременном подключении пакетов разных зон действия в зоне Европа, первоначально используются SMS из пакетов «50 SMS в Европе», «100 SMS в Европе».

#Предложение действительно для абонентов тарифных планов для физических лиц.
#Воспользоваться предложением в роуминге возможно только при наличии подключенных опций «Международный и национальный роуминг» или «Легкий роуминг и международный доступ». 
#Проверить подключение данных опций можно с помощью Интернет-Помощника, сервиса «Мои услуги». 
#При подключенной опции «Легкий роуминг и международный доступ» использование телефона возможно в сетях операторов, с которыми у МТС заключено соглашение о CAMEL-роуминге.
