#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_mobile_internet, :name => 'Мобильный интернет', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://beeline.ru'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Own and home regions, Internet
category = {:name => '_sctcg_bln_own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.95})  

#Own country, Internet
category = {:name => '_sctcg_bln_own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.95})  


@tc.add_tarif_class_categories

