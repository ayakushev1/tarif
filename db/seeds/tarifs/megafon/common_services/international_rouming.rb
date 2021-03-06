#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_international_rouming, :name => 'Путешествие по миру', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/?aid=128'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Europe, calls, incoming
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_calls_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_europe_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Europe, sms, incoming
category = {:name => '_sctcg_mgf_europe_sms_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _sms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Europe, sms, outcoming
category = {:name => '_sctcg_mgf_europe_sms_outcoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _sms_out, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#Europe, mms, incoming
category = {:name => '_sctcg_mgf_europe_mms_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 30.0} } })  

#Europe, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_mms_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 37.0} } })  

#Europe, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_europe_mms_to_sic', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_sic_plus, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 40.0} } })  

#Europe, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_europe_mms_to_europe', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 50.0} } })  

#Europe, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_europe_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Other_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 50.0} } })  

#Europe, Internet
category = {:name => '_sctcg_mgf_europe_internet', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 490.0} } })  



#sic, calls, incoming
category = {:name => '_sctcg_mgf_sic_calls_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_sic_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_sic_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#sic, sms, incoming
category = {:name => '_sctcg_mgf_sic_sms_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _sms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#sic, sms, outcoming
category = {:name => '_sctcg_mgf_sic_sms_outcoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _sms_out, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#sic, mms, incoming
category = {:name => '_sctcg_mgf_sic_mms_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 35.0} } })  

#sic, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_mms_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 42.0} } })  

#sic, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_sic_mms_to_sic', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_sic_plus, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 45.0} } })  

#sic, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_sic_mms_to_europe', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 55.0} } })  

#sic, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_sic_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Other_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 55.0} } })  

#sic, Internet
category = {:name => '_sctcg_mgf_sic_internet', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 490.0} } })  


#Other countries, calls, incoming
category = {:name => '_sctcg_mgf_other_countries_calls_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration,:formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_russia', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_other_countries_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#other_countries, sms, incoming
category = {:name => '_sctcg_mgf_other_countries_sms_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _sms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#other_countries, sms, outcoming
category = {:name => '_sctcg_mgf_other_countries_sms_outcoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _sms_out, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#other_countries, mms, incoming
category = {:name => '_sctcg_mgf_other_countries_mms_incoming', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 100.0} } })  

#other_countries, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_mms_to_russia', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 107.0} } })  

#other_countries, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_other_countries_mms_to_sic', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_sic_plus, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 110.0} } })  

#other_countries, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_other_countries_mms_to_europe', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 120.0} } })  

#other_countries, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_other_countries_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Other_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 120.0} } })  

#Other countries, Internet
category = {:name => '_sctcg_mgf_other_countries_internet', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 630.0} } })  


#Extended countries, calls, incoming
category = {:name => '_sctcg_mgf_extended_countries_calls_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_russia', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_extended_countries_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_extended_countries_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, sms, incoming
category = {:name => '_sctcg_mgf_extended_countries_sms_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _sms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Extended countries, sms, outcoming
category = {:name => '_sctcg_mgf_extended_countries_sms_outcoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _sms_out, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#Extended countries, mms, incoming
category = {:name => '_sctcg_mgf_extended_countries_mms_incoming', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 140.0} } })  

#Extended countries, mms, outcoming, to Russia
category = {:name => '_sctcg_mgf_extended_countries_mms_to_russia', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 147.0} } })  

#Extended countries, mms, outcoming, to sic
category = {:name => '_sctcg_mgf_extended_countries_mms_to_sic', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_sic_plus, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 150.0} } })  

#Extended countries, mms, outcoming, to europe
category = {:name => '_sctcg_mgf_extended_countries_mms_to_europe', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 160.0} } })  

#Extended countries, mms, outcoming, to other_countries
category = {:name => '_sctcg_mgf_extended_countries_mms_to_other_countries', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _sc_service_mgf_from_abroad_to_other_countries, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Other_countries }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 160.0} } })  

#Extended countries, Internet
category = {:name => '_sctcg_mgf_extended_countries_internet', :service_category_rouming_id => _sc_mgf_extended_countries_international_rouming, :service_category_calls_id => _internet, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 630.0} } })  




@tc.add_tarif_class_categories

