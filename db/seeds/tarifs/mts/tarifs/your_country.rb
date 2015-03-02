#Твоя страна
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_your_country, :name => 'Твоя страна', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/your_country/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

#All_russia_rouming, mms, Incoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_russia_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_mms_outcoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#All_world_rouming, mms, Incoming
  category = {:name => '_sctcg_all_world_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_world_mms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  


#TODO#Звонки на абонентов тарифного плана "Твоя страна", 1 руб/мин, никак не сделать
#Own and home regions, calls, incoming
  category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_fixed_line}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_other_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_other_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_other_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, calls, outcoming, to_own_country, to_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own and home regions, calls, outcoming, to_own_country, to_not_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country_to_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

  
#Own and home regions, calls, outcoming, _azerbaijan, _belarus
  category = {:name => '_sctcg_own_home_regions_calls_to_azerbaijan_belarus', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.5})

#Own and home regions, Calls, outcoming, to_china
  category = {:name => '_sctcg_own_home_regions_calls_to_china', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.0})

#Own and home regions, Calls, outcoming, to_moldova
  category = {:name => '_sctcg_own_home_regions_calls_to_moldova', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5})

#Own and home regions, Calls, outcoming, to_uzbekistan
  category = {:name => '_sctcg_own_home_regions_calls_to_uzbekistan', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, outcoming, to_tajikistan
  category = {:name => '_sctcg_own_home_regions_calls_to_tajikistan', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration => "sum(((description->>'duration')::float)/60.0)",
                      :times_of_14_minutes => "sum(ceil(ceil(((description->>'duration')::float)/60.0)/14.0))",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * times_of_14_minutes + (sum_duration - times_of_14_minutes) * 1.0'}, } )

#Own and home regions, Calls, outcoming, to_armenia
  category = {:name => '_sctcg_own_home_regions_calls_to_armenia', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration => "sum(((description->>'duration')::float)/60.0)",
                      :times_of_4_minutes => "sum(ceil(ceil(((description->>'duration')::float)/60.0)/4.0))",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * times_of_4_minutes + (sum_duration - times_of_4_minutes) * 0.0'}, } )

#Own and home regions, Calls, outcoming, to_vietnam_south_korea_singapur
  category = {:name => '_sctcg_own_home_regions_calls_to_vietnam_south_korea_singapur', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration_minute_between_5_and_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 5.0 and 10.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute_less_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :count_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_5_and_10 + count_duration_minute_more_10 * 10.0) + 4.5 * (sum_duration_minute_less_5 + sum_duration_minute_more_10)'}, } )

#Own and home regions, Calls, outcoming, to_other_sic
  category = {:name => '_sctcg_own_home_regions_calls_to_other_sic', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration_minute_between_5_and_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 5.0 and 10.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute_less_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :count_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_5_and_10 + count_duration_minute_more_10 * 10.0) + 4.5 * (sum_duration_minute_less_5 + sum_duration_minute_more_10)'}, } )

#Own and home regions, Calls, outcoming, to_europe
  category = {:name => '_sctcg_own_home_regions_calls_europe', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own and home regions, calls, outcoming, to_other_country
  category = {:name => '_sctcg_own_home_regions_calls_other_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#Own and home regions, sms, incoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Own and home regions, sms, outcoming, to_own_home_regions
  category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.0})

#Own and home regions, sms, outcoming, to_own_country
  category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.0})

#Own and home regions, sms, outcoming, to_sic_country
  category = {:name => '_sctcg_own_home_regions_sms_to_sic_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 2.0})

#Own and home regions, sms, outcoming, to_not_own_country, others (отрегулировано порядоком вычисления, а не категорией)
  category = {:name => '_sctcg_own_home_regions_sms_to_other_countries', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.25})

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9})

#Own and home regions, wap-internet
  category = {:name => '_sctcg_own_home_regions_wap_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _wap_internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_volume_k_byte, :price => 2.75})

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга

#Own country, calls, outcoming, _azerbaijan, _belarus
  category = {:name => '_sctcg_own_country_calls_to_azerbaijan_belarus', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_1}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.5})

#Own country, Calls, outcoming, to_china
  category = {:name => '_sctcg_own_country_calls_to_china', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.0})

#Own country, Calls, outcoming, to_moldova
  category = {:name => '_sctcg_own_country_calls_to_moldova', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_3}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5})

#Own country, Calls, outcoming, to_uzbekistan
  category = {:name => '_sctcg_own_country_calls_to_uzbekistan', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_4}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own country, Calls, outcoming, to_tajikistan
  category = {:name => '_sctcg_own_country_calls_to_tajikistan', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration => "sum(((description->>'duration')::float)/60.0)",
                      :times_of_14_minutes => "sum(ceil(ceil(((description->>'duration')::float)/60.0)/14.0))",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * times_of_14_minutes + (sum_duration - times_of_14_minutes) * 1.0'}, } )

#Own country, Calls, outcoming, to_armenia
  category = {:name => '_sctcg_own_country_calls_to_armenia', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration => "sum(((description->>'duration')::float)/60.0)",
                      :times_of_4_minutes => "sum(ceil(ceil(((description->>'duration')::float)/60.0)/4.0))",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * times_of_4_minutes + (sum_duration - times_of_4_minutes) * 0.0'}, } )

#Own country, Calls, outcoming, to_vietnam_south_korea_singapur
  category = {:name => '_sctcg_own_country_calls_to_vietnam_south_korea_singapur', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration_minute_between_5_and_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 5.0 and 10.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute_less_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :count_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_5_and_10 + count_duration_minute_more_10 * 10.0) + 4.5 * (sum_duration_minute_less_5 + sum_duration_minute_more_10)'}, } )

#Own country, Calls, outcoming, to_other_sic
  category = {:name => '_sctcg_own_country_calls_to_other_sic', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 1.5, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:sum_duration_minute_between_5_and_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 5.0 and 10.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute_less_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :sum_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :count_duration_minute_more_10 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_5_and_10 + count_duration_minute_more_10 * 10.0) + 4.5 * (sum_duration_minute_less_5 + sum_duration_minute_more_10)'}, } )

#Own country, Calls, outcoming, to_europe
  category = {:name => '_sctcg_own_country_calls_europe', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own country, calls, outcoming, to_other_country
  category = {:name => '_sctcg_own_country_calls_to_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_mts_your_country_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})


#Own country, sms, Incoming
  category = {:name => 'own_country_sms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All world, sms, Incoming
  category = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Tarif option MMS+ (discount 50%)
#Другие mms категории должны иметь мешьший приоритет, или не пересекаться с опцией
_sctcg_own_home_regions_mms_to_own_country_own_operator = { :name => '_sctcg_own_home_regions_mms_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_intranet_rouming_mms_to_own_country_own_operator = { :name => '_sctcg_intranet_rouming_mms_to_own_country_own_operator', :service_category_rouming_id => _intra_net_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions, :service_category_partner_type_id => _service_to_own_operator}

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 34.0},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 34.0},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Own and home regions, mms, outcoming, to all own country regions, to own operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_home_regions_mms_to_own_country_own_operator, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.25},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Intranet rouming, mms, outcoming, to all own country regions, to own operator
  @tc.add_one_service_category_tarif_class(_sctcg_intranet_rouming_mms_to_own_country_own_operator, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.25},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#enf_of MMS+

@tc.add_tarif_class_categories

#есть pdf file