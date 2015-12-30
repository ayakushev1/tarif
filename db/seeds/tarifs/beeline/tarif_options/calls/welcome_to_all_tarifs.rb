@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_welcome_to_all_tarifs, :name => 'Добро пожаловать на ВСЕ', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/dobro-pozhalovat-na-vse/'},
  :dependency => {
    :incompatibility => {:international_calls => [_bln_my_abroad_countries, _bln_my_calls_to_other_countries, _bln_welcome_to_all_tarifs]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_200, _bln_all_for_400, 
      _bln_all_for_600, _bln_all_for_600_post, _bln_all_for_900, _bln_all_for_900_post,
      _bln_all_for_1500, _bln_all_for_1500_post, _bln_all_for_2700, _bln_all_for_2700_post],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 50.0} } })  

#Периодическая плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_1_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_1, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, 
    :formula => {:params => {:duration_minute_1 => 1.0, :price_0 => 5.0, :price_1 => 1.0} } } )

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_1_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_1, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_2_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_2, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_2_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_2, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина, Казахстан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_3_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_3, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина, Казахстан), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_3_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_3, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_4_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_4, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.7} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Узбекистан), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_4_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_4, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.7} } })


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_12_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_12, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_12 (Кыргызстан), телефоны не Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_12_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_12, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_13 (Грузия), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_13_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_13, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_13 (Грузия), телефоны не Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_13_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_13, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 8.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_5 (Туркменистан)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_14 (Абхазия, Южная Осетия)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_14', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_14}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 7.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_6 (Молдова)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_6', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 9.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_7 (Беларусь, Азербайджан)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_7', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 13.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_8 (Вьетнам)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_8', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_9 (Китай)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_9', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.0} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_10 (Индия, Южная Корея)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_10', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_10}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_11 (Турция)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_11', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_11}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 6.0} } })


@tc.add_tarif_class_categories

