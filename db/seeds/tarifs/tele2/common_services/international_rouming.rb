@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_international_rouming, :name => 'Путешествия по миру', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://spb.tele2.ru/roaming/abroad/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#SIC, calls, incoming
  category = {:name => '_sctcg_SIC_calls_incoming', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#SIC, calls, outcoming, to Russia, to all operators
  category = {:name => '_sctcg_SIC_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#SIC, calls, outcoming, to rouming country
  category = {:name => '_sctcg_SIC_calls_to_rouming_country', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#SIC, calls, outcoming, to sic
  category = {:name => '_sctcg_SIC_calls_to_sic', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#SIC, calls, outcoming, to Europe
  category = {:name => '_sctcg_SIC_calls_to_europe', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#SIC, calls, outcoming, to Asia, Africa, Australia
  category = {:name => '_sctcg_SIC_calls_to_asia_afr_austr', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#SIC, calls, outcoming, to Noth and South America
  category = {:name => '_sctcg_SIC_calls_to_americas', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  


#SIC, sms, incoming
  category = {:name => '_sctcg_SIC_sms_incoming', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#SIC, sms, outcoming
  category = {:name => '_sctcg_SIC_sms_outcoming', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.00})  


#SIC, mms, incoming
  category = {:name => '_sctcg_SIC_mms_incoming', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#SIC, mms, outcoming
  category = {:name => '_sctcg_SIC_mms_outcoming', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.00})  

#SIC, Internet
  category = {:name => '_sctcg_SIC_internet', :service_category_rouming_id => _sc_tele_sic_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 25.0})




#Europe, calls, incoming
  category = {:name => '_sctcg_europe_calls_incoming', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#Europe, calls, outcoming, to Russia, to all operators
  category = {:name => '_sctcg_europe_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#Europe, calls, outcoming, to rouming country
  category = {:name => '_sctcg_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#Europe, calls, outcoming, to sic
  category = {:name => '_sctcg_europe_calls_to_sic', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#Europe, calls, outcoming, to Europe
  category = {:name => '_sctcg_europe_calls_to_europe', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.45})  

#Europe, calls, outcoming, to Asia, Africa, Australia
  category = {:name => '_sctcg_europe_calls_to_asia_afr_austr', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Europe, calls, outcoming, to Noth and South America
  category = {:name => '_sctcg_europe_calls_to_americas', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  


#Europe, sms, incoming
  category = {:name => '_sctcg_europe_sms_incoming', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#Europe, sms, outcoming
  category = {:name => '_sctcg_europe_sms_outcoming', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.00})  


#Europe, mms, incoming
  category = {:name => '_sctcg_europe_mms_incoming', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#Europe, mms, outcoming
  category = {:name => '_sctcg_europe_mms_outcoming', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.00})  

#Europe, Internet
  category = {:name => '_sctcg_europe_internet', :service_category_rouming_id => _sc_tele_europe_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 25.0})




#Asia, Africa and Australia, calls, incoming
  category = {:name => '_sctcg_asia_afr_aust_calls_incoming', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to Russia, to all operators
  category = {:name => '_sctcg_asia_afr_aust_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_asia_afr_aust_calls_to_rouming_country', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to sic
  category = {:name => '_sctcg_asia_afr_aust_calls_to_sic', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to Europe
  category = {:name => '_sctcg_asia_afr_aust_calls_to_europe', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to Asia, Africa, Australia
  category = {:name => '_sctcg_asia_afr_aust_calls_to_asia_afr_austr', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 35.0})  

#Asia, Africa and Australia, calls, outcoming, to Noth and South America
  category = {:name => '_sctcg_asia_afr_aust_calls_to_americas', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  


#Asia, Africa and Australia, sms, incoming
  category = {:name => '_sctcg_asia_afr_aust_sms_incoming', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#Asia, Africa and Australia, sms, outcoming
  category = {:name => '_sctcg_asia_afr_aust_sms_outcoming', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 12.00})  


#Asia, Africa and Australia, mms, incoming
  category = {:name => '_sctcg_asia_afr_aust_mms_incoming', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#Asia, Africa and Australia, mms, outcoming
  category = {:name => '_sctcg_asia_afr_aust_mms_outcoming', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 12.00})  

#Asia, Africa and Australia, Internet
  category = {:name => '_sctcg_asia_afr_aust_internet', :service_category_rouming_id => _sc_tele_asia_afr_aust_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 50.0})



#South and North America, calls, incoming
  category = {:name => '_sctcg_americas_calls_incoming', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to Russia, to all operators
  category = {:name => '_sctcg_americas_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to rouming country
  category = {:name => '_sctcg_americas_calls_to_rouming_country', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to sic
  category = {:name => '_sctcg_americas_calls_to_sic', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to Europe
  category = {:name => '_sctcg_americas_calls_to_europe', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to Asia, Africa, Australia
  category = {:name => '_sctcg_americas_calls_to_asia_afr_austr', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  

#South and North America, calls, outcoming, to Noth and South America
  category = {:name => '_sctcg_americas_calls_to_americas', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 65.0})  


#South and North America, sms, incoming
  category = {:name => '_sctcg_americas_sms_incoming', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#South and North America, sms, outcoming
  category = {:name => '_sctcg_americas_sms_outcoming', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 12.00})  


#South and North America, mms, incoming
  category = {:name => '_sctcg_americas_mms_incoming', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.00})  

#South and North America, mms, outcoming
  category = {:name => '_sctcg_americas_mms_outcoming', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 12.00})  

#South and North America, Internet
  category = {:name => '_sctcg_americas_internet', :service_category_rouming_id => _sc_tele_americas_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 50.0})





@tc.add_tarif_class_categories

