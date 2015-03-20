#Own country rouming
@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_zero_everywhere, :name => 'Везде ноль', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://spb.tele2.ru/roaming/skidki/vezde-nol/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0})  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 2.0})

#Own country, calls, incoming
  category = {:name => '_sctcg_own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})  

@tc.add_tarif_class_categories

