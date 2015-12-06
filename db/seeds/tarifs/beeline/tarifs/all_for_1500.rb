@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_all_for_1500, :name => 'Всё за 1500', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/tariffs/details/vse-za-1500/'},
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
  scg_bln_all_for_1500_calls = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_1500_calls' }, 
    {:name => "price for scg_bln_all_for_1500_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(2000.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_bln_all_for_1500_sms = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_1500_sms' }, 
    {:name => "price for scg_bln_all_for_1500_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000 >= count_volume)", :window_over => 'day'}, :price => 0.0, :description => '' }
    )

  #internet included in tarif
  scg_bln_all_for_1500_internet = @tc.add_service_category_group(
    {:name => 'scg_bln_all_for_1500_internet' }, 
    {:name => "price for scg_bln_all_for_1500_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, 
      :formula => {:window_condition => "(10000.0 >= sum_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

  #internet for add_speed_1gb option
  scg_bln_add_speed_1gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_1gb_bln_all_for_1500' }, 
    {:name => "price for scg_bln_add_speed_1gb_bln_all_for_1500"}, 
    {:calculation_order => 1, :price => 250.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_add_speed_1gb_bln_all_for_1500', :description => '', 
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
  scg_bln_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_3gb_bln_all_for_1500' }, 
    {:name => "price for scg_bln_add_speed_3gb_bln_all_for_1500"}, 
    {:calculation_order => 2, :price => 500.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_add_speed_3gb_bln_all_for_1500', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_4000 => "ceil((sum((description->>'volume')::float) - 0.0) / 4000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_4000, 0.0) + 0.0",
       }
     },
     } 
    )
   
#internet for auto_add_speed option
  scg_bln_auto_add_speed= @tc.add_service_category_group(
    {:name => 'scg_bln_auto_add_speed_bln_all_for_1500' }, 
    {:name => "price for scg_bln_auto_add_speed_bln_all_for_1500"}, 
    {:calculation_order => 3, :price => 20.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_auto_add_speed_bln_all_for_1500', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_75 => "ceil((sum((description->>'volume')::float) - 0.0) / 75.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_75, 0.0) + 0.0",
       }
     },
     } 
    )


#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 1500.0})

  
#Own and home regions, Calls, Incoming
category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_regions, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_and_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_regions, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.6})

#Own and home regions, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 })

#Own and home regions, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_home_regions_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0 })


#Own and home regions, Calls, Outcoming, to_bln_international_1 (СНГ, Грузия), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_international_1', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_international_1, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {:window_condition => "(10.0 >= sum_duration_minute)", :window_over => 'day'} } )

#Own and home regions, Calls, Outcoming, to_bln_international_2 (на другие телефоны стран СНГ, Грузии, Абхазии, Южной Осетии)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_international_2', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {:window_condition => "(10.0 >= sum_duration_minute)", :window_over => 'day'} } )

#Own and home regions, Calls, Outcoming, to_bln_international_3 (Европа (вкл. Турцию, Израиль), США, Канада)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_international_3', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_international_3}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {:window_condition => "(10.0 >= sum_duration_minute)", :window_over => 'day'} } )


#Own and home regions, sms, incoming
category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.00})

#Own and home regions, sms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})

#Own and home regions, sms, Outcoming, to_not_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_not_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})


#Own and home regions, mms, incoming
category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_mms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.95})

#Own and home regions, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_home_regions_mms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.95})

#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )


#Own country, Calls, Incoming
category = {:name => '_sctcg_own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own country, Calls, Outcoming, to_own_and_home_regions, to_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_and_home_regions_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own country, Calls, Outcoming, to_own_and_home_regions, to_not_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.60 })

#Own country, Calls, Outcoming, to_own_country, to_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0 })

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
category = {:name => '_sctcg_own_country_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.00 })

#Own country, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_country_sms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.00 })

#Own country, sms, Outcoming, to_own country
category = {:name => '_sctcg_own_country_sms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})

#Own country, sms, Outcoming, to_not_own country
category = {:name => '_sctcg_own_country_sms_to_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})

#Own country, mms, incoming
category = {:name => '_sctcg_own_country_mms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own country, mms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_country_mms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.95})

#Own country, mms, Outcoming, to_own country
category = {:name => '_sctcg_own_country_mms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.95})

#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet
  category = {:name => '_sc_rouming_bln_all_russia_except_some_regions_for_internet_internet', :service_category_rouming_id => _sc_rouming_bln_all_russia_except_some_regions_for_internet, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_all_for_1500_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )

#_sc_rouming_bln_bad_internet_regions, Internet
  category = {:name => '_sc_rouming_bln_bad_internet_regions_internet', :service_category_rouming_id => _sc_rouming_bln_bad_internet_regions, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.95})  



@tc.add_tarif_class_categories

