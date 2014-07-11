#50 SMS в поездках по России
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_50_sms_travelling_in_russia, :name => '50 SMS в поездках по России', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :dependency => {
    :categories => [_tcgsc_sms],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_ultra], :to_serve => []},
    :multiple_use => true
  } } )

_sctcg_own_country_sms_outcoming = {:name => '_sctcg_own_country_sms_outcoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out}

#Own country, sms, Outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_sms_outcoming, {}, 
    {:calculation_order => 0, :price => 135.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(50 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count((description->>'volume')::integer)"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(count((description->>'volume')::integer) / 50)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

@tc.add_tarif_class_categories

#Есть три способа подключения опции: наберите на своем мобильном телефоне *111*124# - отправьте SMS на номер 111 с текстом 124;

#Как узнать, подключена ли опция - отправьте любое SMS на номер 8111;

#Как узнать остаток SMS и срок действия пакета - наберите на своем мобильном телефоне *100*2#;

#Условия предоставления
#Опции могут подключить:
#абоненты всех некорпоративных тарифных планов МТС (за исключением тарифа ULTRA), а также тарифных планов «Команда», «Свой бизнес», «Свой круг», «Бизнес сеть», «Бизнес общение», «Готовый офис».

#Опции действуют:
#за пределами г. Москвы и Московской области на всей территории России в сети МТС. Обращаем внимание, что опции не действуют при нахождении в г. Москва и Московской области.

#Особенности тарификации при подключении опций:
#Стоимость подключения опций взимается разово в полном объеме в момент подключения опций.
#Срок действия пакетов - 30 суток с момента подключения. После истечения срока действия неиспользованные SMS аннулируются. Время отключения пакетов соответствует времени подключения: например, пакет, подключенный в 12:00, будет отключен в 12:00 через 30 суток.
#После израсходования пакета оплата SMS производится в соответствии с базовыми тарифами на SMS во внутрисетевом роуминге.
#Стоимость остальных услуг связи (в том числе голосовых услуг связи и интернет-трафика) при подключении опций – не меняется; тарификация осуществляется по базовым тарифам.
