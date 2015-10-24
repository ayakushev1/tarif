#Умный дом
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_umnyi_dom, :name => 'Умный дом', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/umny_dom/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :is_archived => true,
    :prerequisites => [],
    :is_archived => true,
    :multiple_use => false
  } } )

#Добавление новых service_category_group
  #sms included in tarif
  scg_mts_umnyi_dom_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_umnyi_dom_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_umnyi_dom_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000.0 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )
  #mms included in tarif
  scg_mts_umnyi_dom_included_in_tarif_mms = @tc.add_service_category_group(
    {:name => 'scg_mts_umnyi_dom_included_in_tarif_mms' }, 
    {:name => "price for scg_mts_umnyi_dom_included_in_tarif_mms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(1000.0 >= count_volume)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 300.0})

#All_russia_rouming, mms, Incoming
  category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All_world_rouming, mms, Incoming
  category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Own and home regions, mms, outcoming, to own and home regions, to all operators
  category = { :name => '_sctcg_own_home_regions_mms_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_umnyi_dom_included_in_tarif_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#Intranet rouming, mms, outcoming, to own and home regions, to all operators
  category = { :name => '_sctcg_all_russia_rouming_mms_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_umnyi_dom_included_in_tarif_mms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})

#TODO исправить на правильный регион, а также ниже в Tarif option MMS+ (discount 50%)
#All_russia_rouming, mms, outcoming, to_own_country
  category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_geo_id => _service_to_own_country, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#All_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 6.5})  

#Own and home regions, calls, incoming
  category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_fixed_line
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_fixed_line', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_fixed_line}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own and home regions, calls, outcoming, to_own_and_home_region, to_other_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_to_other_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_other_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own and home regions, calls, outcoming, to_own_country, to_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country_to_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})

#Own and home regions, calls, outcoming, to_own_country, to_not_own_operator
  category = {:name => '_sctcg_own_home_regions_calls_to_own_country_to_not_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own and home regions, calls, outcoming, to_sic_country
  category = {:name => '_sctcg_own_home_regions_calls_sic_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 29.0})

#Own and home regions, Calls, 0utcoming, to_europe
  category = {:name => '_sctcg_own_home_regions_calls_europe', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own and home regions, calls, outcoming, to_other_country
  category = {:name => '_sctcg_own_home_regions_calls_other_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#Own and home regions, sms, incoming
  category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Own and home regions, sms, outcoming, to_own_home_regions
  category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_umnyi_dom_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 2.0})

#Own and home regions, sms, outcoming, to_own_country
  category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 3.8})

#Own and home regions, sms, outcoming, to_not_own_country
  category = {:name => '_sctcg_own_home_regions_sms_to_not_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_count_volume_item, :price => 5.25})

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 9.9})

#Own and home regions, wap-internet
  category = {:name => '_sctcg_own_home_regions_wap_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _wap_internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_volume_k_byte, :price => 2.75})

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга

#Own country, Calls, Outcoming, to_own_country, to_not_own_operator
 category = {:name => '_sctcg_own_country_calls_to_own_country_not_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 14.0})

#Own country, Calls, Outcoming, to_sic_country
  category = {:name => 'own_country_calls_sic_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 29.0})

#Own country, Calls, Outcoming, to_europe
  category = {:name => 'own_country_calls_europe', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 49.0})

#Own country, Calls, Outcoming, to_other_country
 category = {:name => 'own_country_calls_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 70.0})

#Own country, sms, Incoming
  category = {:name => 'own_country_sms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#All world, sms, Incoming
  category = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_zero_count_volume_item, :price => 0.0})

#Tarif option MMS+ (discount 50%)
#Другие mms категории должны иметь мешьший приоритет, или не пересекаться с опцией

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 34.0},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 34.0},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Own and home regions, mms, outcoming, to own and home regions, to all operators
  category = { :name => '_sctcg_own_home_regions_mms_to_own_country_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_umnyi_dom_included_in_tarif_mms[:id],
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )  
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 3.25},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#Intranet rouming, mms, outcoming, to own and home regions, to all operators
  category = { :name => '_sctcg_all_russia_rouming_mms_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_umnyi_dom_included_in_tarif_mms[:id],
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => _stf_price_by_count_volume_item, :price => 3.25},
    :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )

#enf_of MMS+

@tc.add_tarif_class_categories

#есть pdf file