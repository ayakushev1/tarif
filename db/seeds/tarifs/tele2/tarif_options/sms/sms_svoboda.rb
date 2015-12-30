@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_sms_svoboda, :name => 'SMS-свобода', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/tariff/sms-svoboda/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#sms included in tarif
  scg_tele_sms_svoboda = @tc.add_service_category_group(
    {:name => 'scg_tele_sms_svoboda' }, 
    {:name => "price for scg_tele_sms_svoboda"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed,  
      :formula => {:params => {:max_count_volume => 200.0, :price => 5.0}, :window_over => 'day' } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 20.0} } })  

#Own and home regions, sms, _service_to_all_own_country_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_sms_svoboda[:id])

@tc.add_tarif_class_categories
