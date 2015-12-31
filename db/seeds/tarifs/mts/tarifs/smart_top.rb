#TODO разобраться с турбо-кнопками
#Smart Top
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_smart_top, :name => 'Smart Top', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/smart_top/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_tarif_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :multiple_use => false,
  } } )

#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_top_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_top_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_top_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 2000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #sms included in tarif
  scg_mts_smart_top_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_top_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_top_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice,  
      :formula => {:params => {:max_count_volume => 2000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet included in tarif
  scg_mts_smart_top_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_top_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_top_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 10000.0, :price => 0.0}, :window_over => 'month' } }
    )

  #internet for add_speed_100mb option
  scg_mts_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_100mb_mts_smart_top' }, 
    {:name => "price for scg_mts_add_speed_100mb_mts_smart_top"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, 
      :formula => {:params => {:max_sum_volume => 100.0, :price => 30.0} } }
    )

  #internet for add_speed_500mb option
  scg_mts_add_speed_500mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_500mb_mts_smart_top' }, 
    {:name => "price for scg_mts_add_speed_500mb_mts_smart_top"}, 
    {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 500.0, :price => 95.0} } }
    )

  #internet for add_speed_2gb option
  scg_mts_add_speed_2gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_2gb_mts_smart_top' }, 
    {:name => "price for scg_mts_add_speed_2gb_mts_smart_top"}, 
    {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 2000.0, :price => 250.0} } }
    )

  #internet for add_speed_5gb option
  scg_mts_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_5gb_mts_smart_top' }, 
    {:name => "price for scg_mts_add_speed_5gb_mts_smart_top"}, 
    {:calculation_order => 4, :standard_formula_id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, 
      :formula => {:params => {:max_sum_volume => 5000.0, :price => 450.0} } }
    )

#own region rouming    

#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 0.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 1500.0} } })

#All_russia_rouming, mms, Incoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  

#All_world_rouming, mms, Incoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_world_rouming, mms, Outcoming
  category = {:name => '_sctcg_all_russia_mms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.5} } })  


#All_russia_rouming, Calls, Incoming
  category = {:name => '_sctcg_all_russia_calls_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })


#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, Calls, Outcoming, to_own_and_home_region, to_not_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_home_regions_not_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 1.5} } }) #приоритет 2 из-за опции Везде как дома

#All_russia_rouming, Calls, Outcoming, to_own_country, to_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, Calls, Outcoming, to_own_country, to_not_own_operator
  category = {:name => '_sctcg_all_russia_calls_to_own_country_not_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })

#All_russia_rouming, Calls, Outcoming, to_sic_country
  category = {:name => '_sctcg_all_russia_calls_sic_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 29.0} } })

#All_russia_rouming, Calls, Outcoming, to_europe
  category = {:name => '_sctcg_all_russia_calls_europe', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })

#All_russia_rouming, Calls, Outcoming, to_other_country
  category = {:name => '_sctcg_all_russia_calls_other_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 70.0} } })

#All_russia_rouming, sms, Incoming
  category = {:name => '_sctcg_all_russia_sms_incoming', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })

#All_russia_rouming, sms, Outcoming, to_own_home_regions
  category = {:name => '_sctcg_all_russia_sms_to_own_home_regions', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.0} } })

#All_russia_rouming, sms, Outcoming, to_own_country
  category = {:name => '_sctcg_all_russia_sms_to_own_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.8} } })

#All_russia_rouming, sms, Outcoming, to_not_own_country
  category = {:name => '_sctcg_all_russia_sms_to_not_own_country', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.25} } })

#All_russia_rouming, Internet
  category = {:name => '_sctcg_all_russia_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_smart_top_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_100_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )
#TODO разобраться есть все-таки доступ к интернету при исчерпании лимита, или только с турбо-кнопками
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 9.9} } })

#All_russia_rouming, wap-internet
  category = {:name => '_sctcg_all_russia_wap_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _wap_internet}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeKByte, :formula => {:params => {:price => 2.75} } })

#Базовый тариф на междугородние и международные звонки при путешествии по России - как в собственном регионе - не забывать добавлять в тарифах!
#При этом звонки на МТС - по тарифу для роуминга


#All world, sms, Incoming
  category = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })


@tc.add_tarif_class_categories

  
