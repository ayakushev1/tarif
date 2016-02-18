@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_country_rouming, :name => 'Путешествия по России', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://msk.tele2.ru/roaming/russia/'},
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#Own country region group 1, calls, incoming
  category = {:name => '_sctcg_own_country_region_group_1_calls_incoming', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_in, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 1, calls, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_region_group_1_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:name => '_sctcg_own_country_region_group_1_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 1, calls, outcoming, to sic
  category = {:name => '_sctcg_own_country_region_group_1_calls_to_sic', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }, :to_abroad_countries => {:in => Category::Country::Mts::Sic_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#Own country region group 1, calls, outcoming, to Europe
  category = {:name => '_sctcg_own_country_region_group_1_calls_to_europe', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }, :to_abroad_countries => {:in => Category::Country::Mts::Europe_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#Own country region group 1, calls, outcoming, to other countries
  category = {:name => '_sctcg_own_country_region_group_1_calls_to_other_countries', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }, :to_abroad_countries => {:in => Category::Country::Mts::Other_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Own country region group 1, sms, incoming
  category = {:name => '_sctcg_own_country_region_group_1_sms_incoming', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _sms_in, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country region group 1, sms, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_region_group_1_sms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

  category = {:name => '_sctcg_own_country_region_group_1_sms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

#Own country region group 1, sms, outcoming, to not own country
  category = {:name => '_sctcg_own_country_region_group_1_sms_not_own_country', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.5} } })  


#Own country region group 1, mms, outcoming, to all own country regions, to all operators
#  category = {:name => '_sctcg_own_country_region_group_1_mms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#Own country region group 1, mms, outcoming, to not own country
#  category = {:name => '_sctcg_own_country_region_group_1_mms_not_own_country', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_not_own_country, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  


#Own country region group 1, Internet
#  category = {:name => '_sctcg_own_country_region_group_1_internet', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _internet, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 25.0} } })



#Own country region group 2, calls, incoming
  category = {:name => '_sctcg_own_country_region_group_2_calls_incoming', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_in, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to all own country regions, to own operator
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:name => '_sctcg_own_country_region_group_2_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_operators => {:in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to all own country regions, to not own operator
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

  category = {:name => '_sctcg_own_country_region_group_2_calls_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_not_own_operator, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_operators => {:not_in => [Category::Operator::Const::Tele2] }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, calls, outcoming, to sic
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_sic', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_1, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 25.0} } })  

#Own country region group 2, calls, outcoming, to Europe
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_europe', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_2, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 45.0} } })  

#Own country region group 2, calls, outcoming, to USA and Canada
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_usa_canada', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_3, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_3 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#Own country region group 2, calls, outcoming, to other countries
  category = {:name => '_sctcg_own_country_region_group_2_calls_to_other_countries', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_tele_international_4, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }, :to_abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_4 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Own country region group 2, sms, incoming
  category = {:name => '_sctcg_own_country_region_group_2_sms_incoming', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _sms_in, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Own country region group 2, sms, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_region_group_2_sms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

  category = {:name => '_sctcg_own_country_region_group_2_sms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.5} } })  

#Own country region group 2, sms, outcoming, to not own country
  category = {:name => '_sctcg_own_country_region_group_2_sms_not_own_country', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country, 
  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.5} } })  


#Own country region group 2, mms, outcoming, to all own country regions, to all operators
#  category = {:name => '_sctcg_own_country_region_group_2_mms_to_all_own_country_regions', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  

#Own country region group 2, mms, outcoming, to not own country
#  category = {:name => '_sctcg_own_country_region_group_2_mms_not_own_country', :service_category_rouming_id => _sc_tele_own_country_rouming_2, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_not_own_country, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_2 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 5.0} } })  


#Own country region group 2, Internet
#  category = {:name => '_sctcg_own_country_region_group_1_internet', :service_category_rouming_id => _sc_tele_own_country_rouming_1, :service_category_calls_id => _internet, 
#  :filtr => {:own_country_regions => {:in => Category::Region::Const::Tele_own_country_rouming_1 }}}
#  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 25.0} } })


@tc.add_tarif_class_categories

