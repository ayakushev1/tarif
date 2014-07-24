#Smart
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_smart, :name => 'Smart', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _tarif,
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(400.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000.0 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(1500.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
#raise(StandardError, [scg_mts_smart_included_in_tarif_calls[:id]])
#own region rouming    
_sctcg_own_home_regions_calls_incoming = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
_sctcg_own_home_regions_calls_to_own_home_regions_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
_sctcg_own_home_regions_calls_to_own_country_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_home_regions_calls_to_own_country_not_own_operator = {:name => '_sctcg_own_home_regions_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}

_sctcg_own_home_regions_calls_sic_country = {:name => '_sctcg_own_home_regions_calls_sic_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
_sctcg_own_home_regions_calls_europe = {:name => '_sctcg_own_home_regions_calls_europe', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
_sctcg_own_home_regions_calls_other_country = {:name => '_sctcg_own_home_regions_calls_other_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}

_sctcg_own_home_regions_sms_incoming = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
_sctcg_own_home_regions_sms_to_own_home_regions = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
_sctcg_own_home_regions_sms_to_own_country = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
_sctcg_own_home_regions_sms_to_not_own_country = {:name => '_sctcg_own_home_regions_sms_to_not_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}

_sctcg_own_home_regions_internet = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
 
_sctcg_own_country_calls_incoming = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
_sctcg_own_country_calls_to_own_country_not_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
_sctcg_own_country_calls_sic_country = {:name => 'own_country_calls_sic_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
_sctcg_own_country_calls_europe = {:name => 'own_country_calls_europe', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
_sctcg_own_country_calls_other_country = {:name => 'own_country_calls_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}

_sctcg_own_country_sms_incoming = {:name => 'own_country_sms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in}

_sctcg_all_world_sms_incoming = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
 
 
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 400.0})

#All_russia_rouming, mms, Incoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_russia_rouming, mms, Outcoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#All_world_rouming, mms, Incoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  


#Own and home regions, Calls, Incoming
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_incoming, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_sum_duration_second, :price => 0.0})


#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_own_operator, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator, scg_mts_smart_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator, {}, 
    {:calculation_order => 2,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0}) #приоритет 2 из-за опции Везде как дома

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_country_own_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_to_own_country_not_own_operator, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own and home regions, Calls, Outcoming, to_sic_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_sic_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 29.0})

#Own and home regions, Calls, Outcoming, to_europe
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_europe, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own and home regions, Calls, Outcoming, to_other_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_calls_other_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#Own and home regions, sms, Incoming
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_sms_incoming, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_sms_to_own_home_regions, scg_mts_smart_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_sms_to_own_home_regions, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.5000000000})

#Own and home regions, sms, Outcoming, to_own_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_sms_to_own_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.8000000000})

#Own and home regions, sms, Outcoming, to_not_own_country
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_sms_to_not_own_country, {}, 
    {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.2500000000})

#Own and home regions, Internet
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_home_regions_internet, scg_mts_smart_included_in_tarif_internet[:id])
#TODO разобраться есть все-таки доступ к интернету при исчерпании лимита, или только с турбо-кнопками
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9})

#Own and home regions, wap-internet
  category = {:name => '_sctcg_own_home_regions_wap_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _wap_internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_k_byte, :price => 2.75})

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_not_own_operator, _sctcg_own_home_regions_calls_to_own_country_not_own_operator)

#Own country, Calls, Outcoming, to_sic_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_sic_country, _sctcg_own_home_regions_calls_sic_country)
  
#Own country, Calls, Outcoming, to_europe
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_europe, _sctcg_own_home_regions_calls_europe)

#Own country, Calls, Outcoming, to_other_country
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_other_country, _sctcg_own_home_regions_calls_other_country)

#Own country, sms, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_sms_incoming, _sctcg_own_home_regions_sms_incoming)


#All world, sms, Incoming
  @tc.add_as_other_service_category_tarif_class(_sctcg_all_world_sms_incoming, _sctcg_own_home_regions_sms_incoming)


#Tarif option Везде как дома Smart (for smart only)
_sctcg_own_country_calls_to_own_country_own_operator = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_to_own_home_regions_not_own_operator = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
_sctcg_own_country_internet = {:name => '_sctcg_own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
 
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), {}, 
    {:standard_formula_id => _stf_price_by_1_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}),  {}, 
    {:standard_formula_id => _stf_price_by_1_month, :price => 100.0},
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )
 
#Own country, Calls, Outcoming, to_own_home_regions, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), 
    scg_mts_smart_included_in_tarif_calls[:id],
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0000000000},
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )

#Own country, Calls, Outcoming, to_own_home_regions, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_not_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), 
    scg_mts_smart_included_in_tarif_calls[:id],
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_home_regions_not_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), {},  
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0000000000},
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), 
    scg_mts_smart_included_in_tarif_calls[:id],
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_own_country_own_operator.merge({:tarif_option_id => _mts_everywhere_as_home_smart, :tarif_option_order => 0}), {},  
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0000000000},
    :tarif_set_must_include_tarif_options => [_mts_everywhere_as_home_smart] )

#enf_of tarif option  

@tc.add_tarif_class_categories

  
