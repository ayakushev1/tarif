@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_all_included_s, :name => 'Мегафон все включено S', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/alltariffs/all_inclusive/all_inclusive_s/s.html'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Добавление новых service_category_group
  #calls included in tarif
  scg_mgf_all_included_s_calls = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_calls' }, 
    {:name => "price for scg_mgf_all_included_s_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(200.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms/mms included in tarif
  scg_mgf_all_included_s_sms_mms = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_sms_mms' }, 
    {:name => "price for scg_mgf_all_included_s_sms_mms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(200 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet included in tarif
  scg_mgf_all_included_s_internet = @tc.add_service_category_group(
    {:name => 'scg_mgf_all_included_s_internet' }, 
    {:name => "price for scg_mgf_all_included_s_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(3000.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet for add_speed_1gb option
  scg_mgf_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_1gb_mgf_all_included_s' }, 
    {:name => "price for scg_mgf_add_speed_1gb_mgf_all_included_s"}, 
    {:calculation_order => 1, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mgf_add_speed_1gb_mgf_all_included_s', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_1000 => "ceil((sum((description->>'volume')::float) - 0.0) / 1000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_1000, 0.0) + 0.0",
       }
     },
     } 
    )

  #internet for add_speed_4gb option
  scg_mgf_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_5gb_mgf_all_included_s' }, 
    {:name => "price for scg_mgf_add_speed_5gb_mgf_all_included_s"}, 
    {:calculation_order => 2, :price => 400.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mgf_add_speed_5gb_mgf_all_included_s', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_5000 => "ceil((sum((description->>'volume')::float) - 0.0) / 5000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_5000, 0.0) + 0.0",
       }
     },
     } 
    )
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 400.0})

  
#Own and home regions, Calls, Incoming
category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
#  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 12.5 })

#Own and home regions, sms, incoming
category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_sms_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.9})

#Own and home regions, sms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.9})


#Own and home regions, mms, incoming
category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_mms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_sms_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.0})

#Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_mms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.0})

#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )




#Tarif option 'Везде Москва — в Центральном регионе'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 3.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Incoming
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  
  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_not_own_operator', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 12.5 },
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_sms_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_home_regions', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.9},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, sms, Outcoming, to_own country
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_country', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.9},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  


#Central regions RF except for Own and home regions, mms, incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_mms_incoming', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_own_home_regions', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 10.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  

#Central regions RF except for Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_mms_to_own_country', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 10.0},
    :tarif_set_must_include_tarif_options => [_mgf_everywhere_moscow_in_central_region] )  



#Tarif option 'Интернет по России для определенных опций'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_volume, :price => 10.0},
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_internet[:id], :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb, _mgf_internet_in_russia_for_specific_options] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb, _mgf_internet_in_russia_for_specific_options] )


#Tarif option 'Будь как дома'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 15.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Incoming
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  
  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 12.5 },
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, incoming
category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_sms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.9},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, sms, Outcoming, to_own country
category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.9},
    :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )  

#All Russia except for Own and home regions, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_included_s_internet[:id], :tarif_set_must_include_tarif_options => [_mgf_be_as_home] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb, _mgf_be_as_home] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb, _mgf_be_as_home] )


@tc.add_tarif_class_categories

