#International rouming
@tc = TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_international_rouming_internet_post, :name => 'Путешествие по миру, интернет (постоплатный)', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/roaming/puteshestviya-po-miru/'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1200_post, _bln_all_for_2700_post, _bln_total_all_post],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#SIC, Internet
category = {:name => '_sctcg_bln_sic_internet', :service_category_rouming_id => _sc_bln_sic, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte,
   :formula => {:window_condition => "(40.0 >= sum_volume)", :window_over => 'day'} } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 5.0})  

#Other countries, Internet
category = {:name => '_sctcg_bln_other_countries_internet', :service_category_rouming_id => _sc_bln_other_world, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte,
   :formula => {:window_condition => "(40.0 >= sum_volume)", :window_over => 'day'} } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 5.0})  


@tc.add_tarif_class_categories

