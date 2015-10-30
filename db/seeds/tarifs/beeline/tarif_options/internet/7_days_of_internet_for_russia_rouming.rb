@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_7_days_of_internet_for_russia_rouming, :name => '7 дней интернета для путешествий по России', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/7-dney/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => true
  } } )


@tc.add_tarif_class_categories


