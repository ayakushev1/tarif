#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_international_rouming, :name => 'Международный роуминг', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/howtoget/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_internet],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#All world, sms, incoming
  category = {:name => '_sctcg_mts_sic_abkhazia_sms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#All world, sms, outcoming
  category = {:name => '_sctcg_mts_sic_abkhazia_sms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#_mts_sic_12_for_40_internet, Internet
  category = {:name => '_sctcg_mts_12_for_40_internet', :service_category_rouming_id => _sc_rouming_mts_sic_12_for_40_internet, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 300.0} } })  

#_mts_sic_14_for_40_internet, Internet
  category = {:name => '_sctcg_mts_14_for_40_internet', :service_category_rouming_id => _sc_rouming_mts_sic_14_for_40_internet, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 350.0} } })  

#_mts_sic_30_for_40_internet, Internet
  category = {:name => '_sctcg_mts_30_for_40_internet', :service_category_rouming_id => _sc_rouming_mts_sic_30_for_40_internet, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  

#Europe, Internet
  category = {:name => '_sctcg_mts_europe_internet', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  

#Other countries, Internet
  category = {:name => '_sctcg_mts_other_countries_internet', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 750.0} } })  



#_mts_sic_abkhazia, calls, incoming
  category = {:name => '_sctcg_mts_sic_abkhazia_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_sic_abkhazia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_abkhazia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_abkhazia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_abkhazia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_abkhazia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_mts_sic_abkhazia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_abkhazia_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_rouming_mts_sic_abkhazia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })

#_mts_sic_abkhazia, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_abkhazia_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_rouming_mts_sic_abkhazia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_mts_sic_south_ossetia, calls, incoming
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 17.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 38.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#_mts_sic_south_ossetia, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_south_ossetia_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_rouming_mts_sic_south_ossetia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 38.0} } })  


#_mts_sic_45_to_russia, calls, incoming
  category = {:name => '_sctcg_mts_sic_45_to_russia_calls_in', :service_category_rouming_id => _sc_rouming_mts_sic_45_to_russia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, incoming
  category = {:name => '_sctcg_mts_sic_65_to_russia_calls_in', :service_category_rouming_id => _sc_rouming_mts_sic_65_to_russia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, incoming
  category = {:name => '_sctcg_mts_sic_75_to_russia_calls_in', :service_category_rouming_id => _sc_rouming_mts_sic_75_to_russia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, incoming
  category = {:name => '_sctcg_mts_sic_85_to_russia_calls_in', :service_category_rouming_id => _sc_rouming_mts_sic_85_to_russia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, incoming
  category = {:name => '_sctcg_mts_sic_115_to_russia_calls_in', :service_category_rouming_id => _sc_rouming_mts_sic_115_to_russia, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  


#_mts_sic_45_to_russia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_45_to_russia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_45_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_65_to_russia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_65_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_75_to_russia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_75_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_85_to_russia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_85_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_sic_115_to_russia_calls_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_sic_115_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  



#_mts_sic_45_to_russia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_45_to_russia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_45_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_mts_sic_65_to_russia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_65_to_russia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_65_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_mts_sic_75_to_russia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_75_to_russia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_75_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_mts_sic_85_to_russia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_85_to_russia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_85_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_mts_sic_115_to_russia, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_sic_115_to_russia_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_sic_115_to_russia, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_mts_sic_109_to_sic, calls, outcoming, to SIC,  to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_109_to_sic_calls_to_not_rouming_not_russia_to_sic', :service_category_rouming_id => _sc_rouming_mts_sic_109_to_sic, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_not_rouming_not_russia_to_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 109.0} } })  

#_mts_sic_135_to_other_countries, calls, outcoming, to not SIC, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_sic_135_to_other_countries_calls_to_not_rouming_not_russia_not_sic', :service_category_rouming_id => _sc_rouming_mts_sic_135_to_other_countries, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia_not_sic}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_25_25_25_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_25_25_25_135_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_25_25_25_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_25_25_25_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_25_25_25_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_25_25_25_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_25_25_25_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#_sc_rouming_mts_europe_countries_25_25_25_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_25_25_25_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_25_25_25_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_30_30_30_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_30_30_30_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_30_30_30_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_30_30_30_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_30_30_30_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_30_30_30_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 30.0} } })  

#_sc_rouming_mts_europe_countries_30_30_30_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_30_30_30_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_30_30_30_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_45_45_45_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_45_45_45_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_45_45_45_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_45_45_45_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_45_45_45_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_45_45_45_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#_sc_rouming_mts_europe_countries_45_45_45_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_45_45_45_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_45_45_45_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_50_50_50_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_50_50_50_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_50_50_50_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_50_50_50_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_50_50_50_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_50_50_50_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 50.0} } })  

#_sc_rouming_mts_europe_countries_50_50_50_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_50_50_50_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_50_50_50_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_60_60_60_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_60_60_60_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_60_60_60_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_60_60_60_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_60_60_60_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_60_60_60_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_europe_countries_60_60_60_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_60_60_60_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_60_60_60_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_65_65_65_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_65_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_65_65_65_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_65_65_65_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_65_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_65_65_65_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_65_65_75_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_75_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_65_65_75_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_75_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_65_65_75_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_75_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 75.0} } })  

#_sc_rouming_mts_europe_countries_65_65_75_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_65_65_75_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_65_65_75_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_99_99_99_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_99_99_99_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_99_99_99_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_99_99_99_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_99_99_99_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_99_99_99_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_europe_countries_99_99_99_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_99_99_99_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_99_99_99_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_115_115_115_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_115_115_115_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_115_115_115_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_115_115_115_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_115_115_115_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_115_115_115_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 115.0} } })  

#_sc_rouming_mts_europe_countries_115_115_115_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_115_115_115_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_115_115_115_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_europe_countries_155_155_155_155, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_155_155_155_155, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_155_155_155_155_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_155_155_155_155_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_europe_countries_155_155_155_155, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_155_155_155_155_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_sc_rouming_mts_europe_countries_85_85_85_135, calls, incoming
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_europe_countries_85_85_85_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_europe_calls_85_85_85_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_europe_countries_85_85_85_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_europe_calls_85_85_85_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_85_85_85_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 85.0} } })  

#_sc_rouming_mts_europe_countries_85_85_85_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_europe_calls_85_85_85_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_europe_countries_85_85_85_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_other_countries_60_60_60_60, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_60_60_60_60_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_60_60_60_60, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_60_60_60_60_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_60_60_60_60, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_60_60_60_60_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_60_60_60_60, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  

#_sc_rouming_mts_other_countries_60_60_60_60, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_60_60_60_60_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_60_60_60_60, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 60.0} } })  


#_sc_rouming_mts_other_countries_65_65_65_135, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_65_65_65_135_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_65_65_65_135, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_65_65_65_135_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_65_65_65_135_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#_sc_rouming_mts_other_countries_65_65_65_135, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_65_65_65_135_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_65_65_65_135, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 135.0} } })  


#_sc_rouming_mts_other_countries_99_99_99_155, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_99_99_99_155_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_99_99_99_155, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_99_99_99_155_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_99_99_99_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_99_99_99_155_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_99_99_99_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 99.0} } })  

#_sc_rouming_mts_other_countries_99_99_99_155, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_99_99_99_155_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_99_99_99_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


#_sc_rouming_mts_other_countries_200_200_200_200, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_200_200_200_200_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_200_200_200_200, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_200_200_200_200_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_200_200_200_200, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_200_200_200_200_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_200_200_200_200, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  

#_sc_rouming_mts_other_countries_200_200_200_200, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_200_200_200_200_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_200_200_200_200, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 200.0} } })  


#_sc_rouming_mts_other_countries_250_250_250_250, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_250_250_250_250_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_250_250_250_250, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_250_250_250_250_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_250_250_250_250, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_250_250_250_250_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_250_250_250_250, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  

#_sc_rouming_mts_other_countries_250_250_250_250, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_250_250_250_250_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_250_250_250_250, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 250.0} } })  


#_sc_rouming_mts_other_countries_155_155_155_155, calls, incoming
  category = {:name => '_sctcg_mts_other_countries_155_155_155_155_incoming', :service_category_rouming_id => _sc_rouming_mts_other_countries_155_155_155_155, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to Russia
  category = {:name => '_sctcg_mts_other_countries_155_155_155_155_to_russia', :service_category_rouming_id => _sc_rouming_mts_other_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to rouming country
  category = {:name => '_sctcg_mts_other_countries_155_155_155_155_to_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  

#_sc_rouming_mts_other_countries_155_155_155_155, calls, outcoming, to not rouming country and not Russia
  category = {:name => '_sctcg_mts_other_countries_155_155_155_155_to_not_rouming_country', :service_category_rouming_id => _sc_rouming_mts_other_countries_155_155_155_155, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 155.0} } })  


@tc.add_tarif_class_categories

#Тарификация поминутная, с округлением до целых минут в большую сторону

#В Ямало-Ненецком, Ханты-Мансийском АО, Пермском крае, Волгоградской и Пензенской областях кроме сети МТС, действуют сети операторов-партнеров.
#При выборе их сетей действуют следующие тарифы:
#– Все входящие вызовы и исходящие на номера России – 17 руб./мин.
#– Исходящие вызовы в другие страны СНГ – 38 руб./мин.
#– Исходящие вызовы в прочие страны – 129 руб./мин.
#– Исходящие SMS – 4,5 руб.
#– Входящие SMS – 0 руб.
#– GPRS – 8,6 руб. за 40 кб
#Скидки и опции в сетях других операторов не действуют.

# Доступ к услугам контент-провайдеров в роуминге посредством SMS на короткие номера, оплачивается по тарифу, действующему в "домашнем" регионе, плюс 3.95 руб.