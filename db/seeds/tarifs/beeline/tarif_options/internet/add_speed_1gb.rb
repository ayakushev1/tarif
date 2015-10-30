@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_add_speed_1gb, :name => 'Продли скорость 1 Гб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/prodli-skorost-1-gb/'},
  :dependency => {
    :incompatibility => {:internet_options => []}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_200, _bln_all_for_400, _bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
         _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post,],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )


@tc.add_tarif_class_categories


