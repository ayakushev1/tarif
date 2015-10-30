@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_the_best_internet_in_rouming, :name => 'Самый выгодный интернет в роуминге', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/mobilneei-internet-v-royminge/'},
  :dependency => {
    :incompatibility => {}, #:internet_international_rouming => [_bln_planet_of_internet_post, _bln_the_best_internet_in_rouming] 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#bln_the_best_internet_in_rouming_1, Internet
category = {:name => '_sctcg_bln_the_best_internet_in_rouming_1_internet', :service_category_rouming_id => _sc_bln_the_best_internet_in_rouming_groups_1, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_bln_the_best_internet_in_rouming', :description => '', 
     :formula => {
       :window_condition => "(40.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
     }, 
    } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 5.0})  

#bln_the_best_internet_in_rouming_1, Internet
category = {:name => '_sctcg_bln_the_best_internet_in_rouming_2_internet', :service_category_rouming_id => _sc_bln_the_best_internet_in_rouming_groups_2, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 90.0})  



@tc.add_tarif_class_categories


