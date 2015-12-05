#Smart Nonstop
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_smart_nonstop, :name => 'Smart Nonstop', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/smart/'},
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
  scg_mts_smart_nonstop_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_nonstop_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_nonstop_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(500.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_nonstop_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_nonstop_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_nonstop_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(500.0 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_nonstop_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_nonstop_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_nonstop_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(10000.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet for add_speed_100mb option
  scg_mts_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_100mb_mts_smart_nonstop' }, 
    {:name => "price for scg_mts_add_speed_100mb_mts_smart_nonstop"}, 
    {:calculation_order => 1, :price => 30.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_100mb_mts_smart_nonstop', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'day',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_100 => "ceil((sum((description->>'volume')::float) - 0.0) / 100.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_100, 0.0) + 0.01",
       }
     },
     } 
    )

  #internet for add_speed_500mb option
  scg_mts_add_speed_500mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_500mb_mts_smart_nonstop' }, 
    {:name => "price for scg_mts_add_speed_500mb_mts_smart_nonstop"}, 
    {:calculation_order => 2, :price => 95.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_500mb_mts_smart_nonstop', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 0.0) / 500.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_500, 0.0) + 0.02",
       }
     },
     } 
    )

  #internet for add_speed_2gb option
  scg_mts_add_speed_2gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_2gb_mts_smart_nonstop' }, 
    {:name => "price for scg_mts_add_speed_2gb_mts_smart_nonstop"}, 
    {:calculation_order => 3, :price => 250.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_2gb_mts_smart_nonstop', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 0.0) / 2000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_2000, 0.0) + 0.03",
       }
     },
     } 
    )

  #internet for add_speed_5gb option
  scg_mts_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_5gb_mts_smart_nonstop' }, 
    {:name => "price for scg_mts_add_speed_5gb_mts_smart_nonstop"}, 
    {:calculation_order => 4, :price => 450.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_5gb_mts_smart_nonstop', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_5000 => "ceil((sum((description->>'volume')::float) - 0.0) / 5000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_5000, 0.0) + 0.04",
       }
     },
     } 
    )

#own region rouming    

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 650.0})

#All_russia_rouming, mms, Incoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_russia_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#All_world_rouming, mms, Incoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  


#All_russia_rouming, Calls, Incoming
  category = {:name => '_sctcg_all_russia_calls_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})


#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_nonstop_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_nonstop_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5}) #приоритет 2 из-за опции Везде как дома

#All_russia_rouming, Calls, Outcoming, to_own_country, to_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_nonstop_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#All_russia_rouming, Calls, Outcoming, to_own_country, to_not_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_country_not_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#All_russia_rouming, Calls, Outcoming, to_sic_country
  category = {:name => '_sctcg_all_russia_calls_sic_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 29.0})

#All_russia_rouming, Calls, Outcoming, to_europe
  category = {:name => '_sctcg_all_russia_calls_europe', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#All_russia_rouming, Calls, Outcoming, to_other_country
  category = {:name => '_sctcg_all_russia_calls_other_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#All_russia_rouming, sms, Incoming
  category = {:name => '_sctcg_all_russia_sms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_russia_rouming, sms, Outcoming, to_own_home_regions
  category = {:name => '_sctcg_all_russia_sms_to_own_home_regions', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_nonstop_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.0})

#All_russia_rouming, sms, Outcoming, to_own_country
  category = {:name => '_sctcg_all_russia_sms_to_own_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.8})

#All_russia_rouming, sms, Outcoming, to_not_own_country
  category = {:name => '_sctcg_all_russia_sms_to_not_own_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.25})

#All_russia_rouming, Internet
  category = {:name => '_sctcg_all_russia_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_nonstop_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )
#TODO разобраться есть все-таки доступ к интернету при исчерпании лимита, или только с турбо-кнопками
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 5,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9})

#All_russia_rouming, wap-internet
  category = {:name => '_sctcg_all_russia_wap_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _wap_internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_k_byte, :price => 2.75})

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга


#All world, sms, Incoming
  category = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})


@tc.add_tarif_class_categories

  
