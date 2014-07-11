#Везде как дома Smart (for smart only)
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_everywhere_as_home_smart, :name => 'Везде как дома SMART', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_smart_mini,_mts_smart, _mts_smart_plus],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#задается в самих тарифах
=begin
#Добавление новых service_category_group for smart
  #calls included in tarif
  scg_mts_smart_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_calls"}, 
    {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(400.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_sms"}, 
    {:calculation_order => 1, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000.0 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_internet"}, 
    {:calculation_order => 1, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(1500.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
=end

#В этой опции задаются только категории, без формул расчета цены 
#Переход на тариф
  @tc.add_only_service_category_tarif_class(_sctcg_one_time_tarif_switch_on)  

#Ежемесячная плата
  @tc.add_only_service_category_tarif_class(_sctcg_periodic_monthly_fee)  
 
#Own country, Calls, Outcoming, to_own_home_regions, to_own_operator
  category = {:name => '_sctcg_own_country_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Calls, Outcoming, to_own_home_regions, to_not_own_operator
  category = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  category = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  

@tc.add_tarif_class_categories
