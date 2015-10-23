@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_talks_without_limits, :name => 'Разговоры без границ', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/roaming/skidki/razgovory-bez-granic/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})

#_all_world_rouming, calls, incoming
  category = {:name => '_sctcg_all_world_rouming_calls_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})  

@tc.add_tarif_class_categories

