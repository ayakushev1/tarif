#International rouming
@tc = ServiceHelper::TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_international_rouming, :name => 'Путешествие по миру', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/roaming/puteshestviya-po-miru/'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#SIC, calls, incoming
category = {:name => '_sctcg_bln_sic_calls_incoming', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#SIC, calls, outcoming, to Russia
category = {:name => '_sctcg_bln_sic_calls_to_russia', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#SIC, calls, outcoming, to rouming country
category = {:name => '_sctcg_bln_sic_calls_to_rouming_country', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})  

#SIC, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_bln_sic_calls_to_not_rouming_country', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#SIC, sms, incoming
category = {:name => '_sctcg_bln_sic_sms_incoming', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#SIC, sms, outcoming
category = {:name => '_sctcg_bln_sic_sms_outcoming', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#SIC, mms, incoming
#category = {:name => '_sctcg_bln_sic_mms_incoming', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _mms_in}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 30.0})  

#SIC, mms, outcoming, to Russia
#category = {:name => '_sctcg_bln_sic_mms_to_russia', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 37.0})  

#SIC, mms, outcoming, to sic
#category = {:name => '_sctcg_bln_sic_mms_to_sic', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 40.0})  

#SIC, mms, outcoming, to europe
#category = {:name => '_sctcg_bln_sic_mms_to_europe', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 50.0})  

#SIC, mms, outcoming, to other_countries
#category = {:name => '_sctcg_bln_sic_mms_to_other_countries', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 50.0})  

#SIC, Internet
category = {:name => '_sctcg_bln_sic_internet', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0},  
    :tarif_set_must_include_tarif_options => [_bln_total_all_post, _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1200_post, _bln_all_for_2700_post] )
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte,
   :formula => {:window_condition => "(30.0 >= sum_volume)", :window_over => 'day'} } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 5.0})  


#Other countries, calls, incoming
category = {:name => '_sctcg_bln_other_countries_calls_incoming', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 69.0})  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_bln_other_countries_calls_to_russia', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 69.0})  

#other_countries, calls, outcoming, to rouming country
category = {:name => '_sctcg_bln_other_countries_calls_to_rouming_country', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 69.0})  

#other_countries, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_bln_other_countries_calls_to_not_rouming_country_not_russia', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 129.0})  

#other_countries, sms, incoming
category = {:name => '_sctcg_bln_other_countries_sms_incoming', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})  

#other_countries, sms, outcoming
category = {:name => '_sctcg_bln_other_countries_sms_outcoming', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 19.0})  

#other_countries, mms, incoming
category = {:name => '_sctcg_bln_other_countries_mms_incoming', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 100.0})  

#other_countries, mms, outcoming, to Russia
#category = {:name => '_sctcg_bln_other_countries_mms_to_russia', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 107.0})  

#other_countries, mms, outcoming, to sic
#category = {:name => '_sctcg_bln_other_countries_mms_to_sic', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_sic}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 110.0})  

#other_countries, mms, outcoming, to europe
#category = {:name => '_sctcg_bln_other_countries_mms_to_europe', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_europe}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 120.0})  

#other_countries, mms, outcoming, to other_countries
#category = {:name => '_sctcg_bln_other_countries_mms_to_other_countries', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_mts_other_countries}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 120.0})  

#Other countries, Internet
category = {:name => '_sctcg_bln_other_countries_internet', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 750.0},  
    :tarif_set_must_include_tarif_options => [_bln_total_all_post, _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1200_post, _bln_all_for_2700_post] )
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte,
   :formula => {:window_condition => "(30.0 >= sum_volume)", :window_over => 'day'} } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 5.0})  


@tc.add_tarif_class_categories

