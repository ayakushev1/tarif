#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_international_rouming, :name => 'Путешествие по миру', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/?aid=128'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Europe, calls, incoming
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#Europe, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_calls_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#Europe, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#Europe, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_europe_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Europe, sms, incoming
category = {:name => '_sctcg_mgf_europe_sms_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#Europe, sms, outcoming
category = {:name => '_sctcg_mgf_europe_sms_outcoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Europe, mms, incoming
category = {:name => '_sctcg_mgf_europe_mms_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 30.0})  

#Europe, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_mms_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 37.0})  

#Europe, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_europe_mms_to_sic', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 40.0})  

#Europe, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_europe_mms_to_europe', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 50.0})  

#Europe, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_europe_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 50.0})  

#Europe, Internet
category = {:name => '_sctcg_mgf_europe_internet', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 490.0})  



#sic, calls, incoming
category = {:name => '_sctcg_mgf_sic_calls_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#sic, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_sic_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#sic, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_sic_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#sic, sms, incoming
category = {:name => '_sctcg_mgf_sic_sms_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#sic, sms, outcoming
category = {:name => '_sctcg_mgf_sic_sms_outcoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#sic, mms, incoming
category = {:name => '_sctcg_mgf_sic_mms_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 35.0})  

#sic, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_mms_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 42.0})  

#sic, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_sic_mms_to_sic', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 45.0})  

#sic, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_sic_mms_to_europe', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 55.0})  

#sic, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_sic_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 55.0})  

#sic, Internet
category = {:name => '_sctcg_mgf_sic_internet', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 490.0})  


#Other countries, calls, incoming
category = {:name => '_sctcg_mgf_other_countries_calls_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 79.0})  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_russia', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 79.0})  

#other_countries, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_other_countries_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 79.0})  

#other_countries, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#other_countries, sms, incoming
category = {:name => '_sctcg_mgf_other_countries_sms_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#other_countries, sms, outcoming
category = {:name => '_sctcg_mgf_other_countries_sms_outcoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#other_countries, mms, incoming
category = {:name => '_sctcg_mgf_other_countries_mms_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 100.0})  

#other_countries, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_mms_to_russia', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 107.0})  

#other_countries, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_other_countries_mms_to_sic', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 110.0})  

#other_countries, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_other_countries_mms_to_europe', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 120.0})  

#other_countries, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_other_countries_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 120.0})  

#Other countries, Internet
category = {:name => '_sctcg_mgf_other_countries_internet', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 630.0})  


#Extended countries, calls, incoming
category = {:name => '_sctcg_mgf_extended_countries_calls_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Extended countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_russia', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Extended countries, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_extended_countries_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Extended countries, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#Extended countries, sms, incoming
category = {:name => '_sctcg_mgf_extended_countries_sms_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#Extended countries, sms, outcoming
category = {:name => '_sctcg_mgf_extended_countries_sms_outcoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#Extended countries, mms, incoming
category = {:name => '_sctcg_mgf_extended_countries_mms_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 140.0})  

#Extended countries, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_mms_to_russia', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 147.0})  

#Extended countries, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_extended_countries_mms_to_sic', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 150.0})  

#Extended countries, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_extended_countries_mms_to_europe', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 160.0})  

#Extended countries, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_extended_countries_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 160.0})  

#Extended countries, Internet
category = {:name => '_sctcg_mgf_extended_countries_internet', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 630.0})  



#Tarif option 'Скидка 25% на исходящие вызовы в Россию и все входящие'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 15.0},
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#sic, incoming
category = {:name => '_sctcg_mgf_sic_calls_incoming_25_disc', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 36.75},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia_25_disc', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 36.75},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#Other countries, calls, incoming
category = {:name => '_sctcg_mgf_other_countries_calls_incoming_25_disc', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 59.25},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_russia_25_disc', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 59.25},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#Extended countries, calls, incoming
category = {:name => '_sctcg_mgf_extended_countries_calls_incoming_25_disc', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 96.75},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  

#Extended countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_russia_25_disc', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 96.75},  
    :tarif_set_must_include_tarif_options => [_mgf_25_discount_on_calls_to_russia_and_all_incoming] )  



#Tarif option 'Скидка 50% на исходящие вызовы в Россию'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_calls_to_russia] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 25.0},
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_calls_to_russia] )  

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia_50_disc_out', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 24.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_calls_to_russia] )  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_russia_50_disc_out', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 39.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_calls_to_russia] )  

#Extended countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_russia_50_disc_out', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 64.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_calls_to_russia] )  


#Tarif option 'Скидка 50% на все входящие вызовы'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_all_incoming_calls] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 15.0},
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_all_incoming_calls] )  

#sic, incoming
category = {:name => '_sctcg_mgf_sic_calls_incoming_50_disc_in', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 24.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_all_incoming_calls] )  

#Other countries, calls, incoming
category = {:name => '_sctcg_mgf_other_countries_calls_incoming_50_disc_in', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 39.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_all_incoming_calls] )  

#Extended countries, calls, incoming
category = {:name => '_sctcg_mgf_extended_countries_calls_incoming_50_disc_in', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 64.5},  
    :tarif_set_must_include_tarif_options => [_mgf_50_discount_on_all_incoming_calls] )  



@tc.add_tarif_class_categories

