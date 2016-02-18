#100 SMS в поездках по России
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_100_sms_travelling_in_russia, :name => '100 SMS в поездках по России', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/n_roaming/discounts/sms_paket/'},
  :dependency => {
    :categories => [_tcgsc_sms],
    :incompatibility => {:sms_travelling_in_russia => [_mts_50_sms_travelling_in_russia, _mts_100_sms_travelling_in_russia]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mts_everywhere_as_home]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_ultra], :to_serve => []},
    :multiple_use => true
  } } )

  scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth,  
      :formula => {:params => {:max_count_volume => 100.0, :price => 180.0} } }
    )

#Own country, sms, Outcoming
#Own country rouming, sms, Outcoming, to_own_home_regions
  category = {:name => '_sctcg_own_country_sms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms[:id])

#Own country rouming, sms, Outcoming, to_own_country
  category = {:name => '_sctcg_own_country_sms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms[:id])

#Own country rouming, sms, Outcoming, to_not_own_country
  category = {:name => '_sctcg_own_country_sms_to_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_100_sms_travelling_in_russia_included_in_tarif_sms[:id])


@tc.add_tarif_class_categories


#Есть три способа подключения опции: наберите на своем мобильном телефоне *111*125# - отправьте SMS на номер 111 с текстом 125;

#Как узнать, подключена ли опция - отправьте любое SMS на номер 8111;

#Как узнать остаток SMS и срок действия пакета - наберите на своем мобильном телефоне *100*2#;

#Условия предоставления

#Опции могут подключить:
#абоненты всех некорпоративных тарифных планов МТС (за исключением тарифа ULTRA), а также тарифных планов «Команда», «Свой бизнес», «Свой круг», 
#«Бизнес сеть», «Бизнес общение», «Готовый офис».

#Опции действуют: 
#за пределами г. Москвы и Московской области на всей территории России в сети МТС. Обращаем внимание, что опции не действуют при нахождении в г. Москва и Московской области.

#Особенности тарификации при подключении опций:
#Стоимость подключения опций взимается разово в полном объеме в момент подключения опций.
#Срок действия пакетов - 30 суток с момента подключения. После истечения срока действия неиспользованные SMS аннулируются. Время отключения пакетов соответствует времени подключения: например, пакет, подключенный в 12:00, будет отключен в 12:00 через 30 суток.
#После израсходования пакета оплата SMS производится в соответствии с базовыми тарифами на SMS во внутрисетевом роуминге.
#Стоимость остальных услуг связи (в том числе голосовых услуг связи и интернет-трафика) при подключении опций – не меняется; тарификация осуществляется по базовым тарифам.
#При одновременном подключении нескольких пакетов остаток SMS из ранее подключенного пакета суммируется с номиналом подключаемого пакета, при этом сроком действия будет выбран максимальный из сроков действия подключенных пакетов.
#Опции не действуют при нахождении в г. Москва и Московской области: стоимость услуг связи (в том числе стоимость SMS) при подключении опций – не меняется; подключенные пакеты «50 SMS в поездках по России» и «100 SMS в поездках по России» не расходуются
