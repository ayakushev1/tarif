#International rouming
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_international_rouming, :name => 'Международный роуминг', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/howtoget/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Europe, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 85.0})  

#Europe, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_to_russia', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 85.0})  

#Europe, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 85.0})  

#Europe, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 135.0})  

#Europe, sms, outcoming
  category = {:name => '_sctcg_mts_europe_sms_outcoming', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Europe, Internet
  category = {:name => '_sctcg_mts_europe_internet', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


#SIC_1, calls, incoming
  category = {:name => '_sctcg_mts_sic_1_calls_incoming', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 39.0})  

#SIC_1, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_1_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 39.0})  

#SIC_1, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_1_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 39.0})  

#SIC_1, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 109.0})  

#SIC_1, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_1_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 135.0})  

#SIC_1, sms, outcoming
  category = {:name => '_sctcg_mts_sic_1_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.5})  

#SIC_1, Internet
  category = {:name => '_sctcg_mts_sic_1_internet', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 350.0})  


#SIC_2, calls, incoming
  category = {:name => '_sctcg_mts_sic_2_calls_incoming', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#SIC_2, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_2_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#SIC_2, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_2_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#SIC_2, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_2_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 135.0})  

#SIC_2, sms, outcoming
  category = {:name => '_sctcg_mts_sic_2_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 15.0})  

#SIC_2, Internet
  category = {:name => '_sctcg_mts_sic_2_internet', :service_category_rouming_id => _sc_mts_sic_2_rouming, :service_category_calls_id => _internet}  
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


#SIC_3, calls, incoming
  category = {:name => '_sctcg_mts_sic_3_calls_incoming', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})  

#SIC_3, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_3_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})  

#SIC_3, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_3_calls_to_rouming_country', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 17.0})  

#SIC_3, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 38.0})  

#SIC_3, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_3_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 135.0})  

#SIC_3, sms, outcoming
  category = {:name => '_sctcg_mts_sic_3_sms_outcoming', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 4.5})  

#SIC_3, Internet (В Южной Осетии нет интернета)
  category = {:name => '_sctcg_mts_sic_3_internet', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.0})  


#Other countries, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_calls_incoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 155.0})  

#Other countries, calls, outcoming
  category = {:name => '_sctcg_mts_other_countries_calls_outcoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 155.0})  

#Other countries, sms, outcoming
  category = {:name => '_sctcg_mts_other_countries_sms_outcoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Other countries, Internet
  category = {:name => '_sctcg_mts_other_countries_internet', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0})  


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