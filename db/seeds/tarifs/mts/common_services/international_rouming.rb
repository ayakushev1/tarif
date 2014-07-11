#International rouming
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_international_rouming, :name => 'International rouming', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _tarif,
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Europe rouming
_sctcg_mts_europe_calls_incoming = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_europe_calls_to_russia = {:name => '_sctcg_mts_europe_calls_to_russia', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
_sctcg_mts_europe_calls_to_rouming_country = {:name => '_sctcg_mts_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
_sctcg_mts_europe_calls_to_not_rouming_country = {:name => '_sctcg_mts_europe_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
_sctcg_mts_europe_sms_outcoming = {:name => '_sctcg_mts_europe_sms_outcoming', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_europe_internet = {:name => '_sctcg_mts_europe_internet', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _internet}

_sctcg_mts_sic_calls_incoming = {:name => '_sctcg_mts_sic_calls_incoming', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_calls_to_russia = {:name => '_sctcg_mts_sic_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
_sctcg_mts_sic_calls_to_rouming_country = {:name => '_sctcg_mts_sic_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
_sctcg_mts_sic_calls_to_not_rouming_country = {:name => '_sctcg_mts_sic_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
_sctcg_mts_sic_sms_outcoming = {:name => '_sctcg_mts_sic_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_sic_internet = {:name => '_sctcg_mts_sic_internet', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _internet}

_sctcg_mts_sic_1_calls_incoming = {:name => '_sctcg_mts_sic_1_calls_incoming', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_1_calls_to_russia = {:name => '_sctcg_mts_sic_1_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
_sctcg_mts_sic_1_calls_to_rouming_country = {:name => '_sctcg_mts_sic_1_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_to_sic = {:name => '_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_not_sic = {:name => '_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
_sctcg_mts_sic_1_sms_outcoming = {:name => '_sctcg_mts_sic_1_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_sic_1_internet = {:name => '_sctcg_mts_sic_1_internet', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _internet}

_sctcg_mts_sic_2_calls_incoming = {:name => '_sctcg_mts_sic_2_calls_incoming', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_2_calls_to_russia = {:name => '_sctcg_mts_sic_2_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
_sctcg_mts_sic_2_calls_to_rouming_country = {:name => '_sctcg_mts_sic_2_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
_sctcg_mts_sic_2_calls_to_not_rouming_country = {:name => '_sctcg_mts_sic_2_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
_sctcg_mts_sic_2_sms_outcoming = {:name => '_sctcg_mts_sic_2_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_sic_2_internet = {:name => '_sctcg_mts_sic_2_internet', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _internet}

_sctcg_mts_sic_3_calls_incoming = {:name => '_sctcg_mts_sic_3_calls_incoming', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_3_calls_to_russia = {:name => '_sctcg_mts_sic_3_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
_sctcg_mts_sic_3_calls_to_rouming_country = {:name => '_sctcg_mts_sic_3_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_to_sic = {:name => '_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_not_sic = {:name => '_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
_sctcg_mts_sic_3_sms_outcoming = {:name => '_sctcg_mts_sic_3_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_sic_3_internet = {:name => '_sctcg_mts_sic_3_internet', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _internet}

_sctcg_mts_other_countries_calls_incoming = {:name => '_sctcg_mts_other_countries_calls_incoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_other_countries_calls_outcoming = {:name => '_sctcg_mts_other_countries_calls_outcoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_out}
_sctcg_mts_other_countries_sms_outcoming = {:name => '_sctcg_mts_other_countries_sms_outcoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _sms_out}
_sctcg_mts_other_countries_internet = {:name => '_sctcg_mts_other_countries_internet', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _internet}

#Europe, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 79.0})  

#Europe, calls, outcoming, to Russia
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_europe_calls_to_russia, _sctcg_mts_europe_calls_incoming)

#Europe, calls, outcoming, to rouming country
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_europe_calls_to_rouming_country, _sctcg_mts_europe_calls_incoming)

#Europe, calls, outcoming, to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_calls_to_not_rouming_country, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Europe, sms, outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_sms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Europe, Internet
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_internet, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


#SIC_1, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 33.0})  

#SIC_1, calls, outcoming, to Russia
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_1_calls_to_russia, _sctcg_mts_sic_1_calls_incoming)

#SIC_1, calls, outcoming, to rouming country
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_1_calls_to_rouming_country, _sctcg_mts_sic_1_calls_incoming)

#SIC_1, calls, outcoming, to SIC,  to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_to_sic, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 103.0})  

#SIC_1, calls, outcoming, to not SIC, to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_not_sic, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#SIC_1, sms, outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_sms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.5})  

#SIC_1, Internet
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_internet, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 350.0})  


#SIC_2, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 59.0})  

#SIC_2, calls, outcoming, to Russia
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_2_calls_to_russia, _sctcg_mts_sic_2_calls_incoming)

#SIC_2, calls, outcoming, to rouming country
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_2_calls_to_rouming_country, _sctcg_mts_sic_2_calls_incoming)

#SIC_2, calls, outcoming, to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_calls_to_not_rouming_country, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#SIC_2, sms, outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_sms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 15.0})  

#SIC_2, Internet
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_internet, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


#SIC_3, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_3_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})  

#SIC_3, calls, outcoming, to Russia
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_3_calls_to_russia, _sctcg_mts_sic_3_calls_incoming)

#SIC_3, calls, outcoming, to rouming country
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_sic_3_calls_to_rouming_country, _sctcg_mts_sic_3_calls_incoming)

#SIC_3, calls, outcoming, to SIC,  to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_to_sic, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 38.0})  

#SIC_3, calls, outcoming, to not SIC, to not rouming country and not Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_not_sic, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#SIC_3, sms, outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_3_sms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 4.5})  

#SIC_3, Internet (В Южной Осетии нет интернета)
#  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_3_internet, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.0})  


#Other countries, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_other_countries_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 149.0})  

#Other countries, calls, outcoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_mts_other_countries_calls_outcoming, _sctcg_mts_other_countries_calls_incoming)

#Other countries, sms, outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_mts_other_countries_sms_outcoming, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Other countries, Internet
  @tc.add_one_service_category_tarif_class(_sctcg_mts_other_countries_internet, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


@tc.add_tarif_class_categories

#Тарификация поминутная, с округлением до целых минут в большую сторону

#В Ямало-Ненецком, Ханты-Мансийском АО, Пермском крае, Волгоградской и Пензенской областях кроме сети МТС, действуют сети операторов-партнеров.
#При выборе их сетей действуют следующие тарифы:
#– Все входящие вызовы и исходящие на номера России – 17 руб./мин.
#– Исходящие вызовы в другие страны СНГ – 38 руб./мин.
#– Исходящие вызовы в прочие страны – 129 руб./мин.
#– Исходящие SMS – 4,5 руб.
#– Входящие SMS – 0 руб.
#– GPRS – 8,6 руб. за 40 кб
#Скидки и опции в сетях других операторов не действуют.

# Доступ к услугам контент-провайдеров в роуминге посредством SMS на короткие номера, оплачивается по тарифу, действующему в "домашнем" регионе, плюс 3.95 руб.