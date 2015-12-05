@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_most_black, :name => 'Самый черный', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://msk.tele2.ru/tariff/theblackest/'},
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
  scg_tele_most_black_calls = @tc.add_service_category_group(
    {:name => 'scg_tele_most_black_calls' }, 
    {:name => "price for scg_tele_most_black_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(1000.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_tele_most_black_sms = @tc.add_service_category_group(
    {:name => 'scg_tele_most_black_sms' }, 
    {:name => "price for scg_tele_most_black_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet included in tarif
  scg_tele_most_black_internet = @tc.add_service_category_group(
    {:name => 'scg_tele_most_black_internet' }, 
    {:name => "price for scg_tele_most_black_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(10000.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet for scg_tele_add_speed_100mb option
  scg_tele_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_100mb_tele_most_black' }, 
    {:name => "price for scg_tele_add_speed_100mb_tele_most_black"}, 
    {:calculation_order => 1, :price => 15.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_tele_add_speed_100mb_tele_most_black', :description => '', 
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

  #internet for scg_tele_add_speed_3gb option
  scg_tele_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_3gb_tele_most_black' }, 
    {:name => "price for scg_tele_add_speed_3gb_tele_most_black"}, 
    {:calculation_order => 2, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_tele_add_speed_3gb_tele_most_black', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_3000 => "ceil((sum((description->>'volume')::float) - 0.0) / 3000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_3000, 0.0) + 0.02",
       }
     },
     } 
    )
   
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 599.0})

  
#Own and home regions, Calls, Incoming
category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5})

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5 })

#Own and home regions, sms, incoming
category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 1.5})

#Own and home regions, sms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.5})


#Own and home regions, mms, incoming
category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_mms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_mms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.16})  #как в опции Добавить скорость плюс 1 копейка



#Own country, Calls, Outcoming, to_own_and_home_region, to_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])

#Own country, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_calls[:id])

#Own country, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_country_sms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_sms[:id])

#Own country, sms, Outcoming, to_own country
category = {:name => '_sctcg_own_country_sms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_sms[:id])


#Own country, mms, incoming
category = {:name => '_sctcg_own_country_mms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own country, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_country_mms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#Own country, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_country_mms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#Own country, mms, outcoming, to not Russia
  category = {:name => '_sctcg_own_country_mms_outcoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#Own country, Internet
  category = {:name => 'own_and_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_most_black_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.16})  #как в опции Добавить скорость плюс 1 копейка



@tc.add_tarif_class_categories

