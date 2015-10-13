#Интернет во внутресетевом роуминге 
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_own_country_rouming_internet, :name => 'Интернет во внутресетевом роуминге', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/inet_roaming/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )


#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9})

@tc.add_tarif_class_categories
