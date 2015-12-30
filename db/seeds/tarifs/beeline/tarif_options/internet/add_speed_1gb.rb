@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_add_speed_1gb, :name => 'Продли скорость 1 Гб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/prodli-skorost-1-gb/'},
  :dependency => {
    :incompatibility => {
#      :add_speed_internet_options => [_bln_add_speed_1gb, _bln_add_speed_3gb, _bln_auto_add_speed, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )


#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.02} } })

#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

#_sc_rouming_bln_cenral_regions_not_moscow_regions, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _sc_rouming_bln_cenral_regions_not_moscow_regions, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet
  category = {:name => 'all_russia_except_some_regions_for_internet_internet', :service_category_rouming_id => _sc_rouming_bln_all_russia_except_some_regions_for_internet, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet
  category = {:name => 'all_russia_except_some_regions_for_internet_internet', :service_category_rouming_id => _sc_rouming_bln_bad_internet_regions, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

@tc.add_tarif_class_categories


