#Везде как дома
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class('Везде как дома')

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_price_by_30_day, :price => 5.0})

#Own region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_region_calls_own_country_own_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own region, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_own_country_other_operator, _sctcg_own_region_calls_own_country_own_operator)

#Own region, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_own_country_fixed_line, _sctcg_own_region_calls_own_country_own_operator)

#Home region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, _sctcg_own_region_calls_own_country_own_operator)

#Home region, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_other_operator, _sctcg_own_region_calls_own_country_own_operator)

#Home region, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_fixed_line, _sctcg_own_region_calls_own_country_own_operator)


#Own country, Calls, Incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_incoming, _scg_free_sum_duration)


#Own country, Calls, Outcoming, to_own_region, to_own_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_local_own_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own country, Calls, Outcoming, to_own_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_local_other_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_own_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_local_fixed_line, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_own_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_other_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_fixed_line, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_own_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_own_country, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_other_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, Calls, Outcoming, to_own_country, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_fixed_line, _sctcg_own_country_calls_local_own_operator)


  
  @tc.load_repositories

