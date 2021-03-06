@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_planet_of_internet_post, :name => 'Планета Интернета (постоплата)', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/planeta-interneta/'},
  :dependency => {
    :incompatibility => {:internet_international_rouming => [_bln_planet_of_internet_post, _bln_the_best_internet_in_rouming]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#bln_the_best_internet_in_rouming_1, Internet
category = {:name => '_sctcg_bln_planet_of_internet_post_1_internet', :service_category_rouming_id => _sc_bln_the_best_internet_in_rouming_groups_1, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 40.0, :price => 200.0}, :window_over => 'day' } } )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 5.0} } })  

#bln_the_best_internet_in_rouming_1, Internet
category = {:name => '_sctcg_bln_planet_of_internet_post_2_internet', :service_category_rouming_id => _sc_bln_the_best_internet_in_rouming_groups_2, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Bln::The_best_internet_in_rouming_groups_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 90.0} } })  



@tc.add_tarif_class_categories


