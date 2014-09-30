@tc = ServiceHelper::TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_welcome, :name => 'Добро пожаловать', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _tarif,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/tariffs/details/dobro-pozhalovat/'},
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_tarif_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )
  
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

  
#Own and home regions, Calls, Incoming
category = {:name => '_sctcg_own_home_regions_calls_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own and home regions, Calls, Outcoming, to_own_and_home_regions
category = {:name => '_sctcg_own_home_regions_calls_to_own_and_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, to_own_country
category = {:name => '_sctcg_own_home_regions_calls_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5 })



#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_1_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_1, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, 
  {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute,
   :formula => {
     :stat_params => {:count_calls => "count(case when ((description->>'duration')::float) > 0.0 then 1.0 else 0.0 end)",                                            
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * count_calls + 1.0 * (sum_duration_minute - count_calls)'}, } )

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_1 (Таджикистан), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_1_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_1, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_2_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_2, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_2 (Армения), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_2_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_2, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5})


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_3_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_3, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_3 (Украина), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_3_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_3, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0})


#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Грузия, Казахстан, Кыргызстан, Узбекистан), телефоны Билайн
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_4_to_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_4, :service_category_partner_type_id =>  _service_to_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_4 (Грузия, Казахстан, Кыргызстан, Узбекистан), другие телефоны
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_4_to_not_bln_partner', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_4, :service_category_partner_type_id =>  _service_to_not_bln_partner_operator}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_5 (Туркменистан, Абхазия, Южная Осетия)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_5', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_5}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_6 (Молдова)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_6', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_6}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 6.0})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_7 (Беларусь, Азербайджан)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_7', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_7}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_8 (Вьетнам)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_8', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_8}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.8})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_9 (Китай)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_9', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_9}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_10 (Индия, Южная Корея)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_10', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_10}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, Calls, Outcoming, service_to_bln_welcome_11 (Турция)
category = {:name => '_sctcg_own_home_regions_calls_to_bln_welcome_11', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_bln_welcome_11}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 4.5})


#Own and home regions, sms, incoming
category = {:name => '_sctcg_own_home_regions_sms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, sms, Outcoming, to_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.5})

#Own and home regions, sms, Outcoming, to_bln_international_2 (СНГ, Абхазия, Грузия и Южная Осетия)
category = {:name => '_sctcg_own_home_regions_sms_to_bln_international_1', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _sc_service_to_bln_international_2}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.95})

#Own and home regions, mms, incoming
category = {:name => '_sctcg_own_home_regions_mms_incoming', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 0.0})

#Own and home regions, mms, Outcoming, to_all_own_country_regions
category = {:name => '_sctcg_own_home_regions_mms_to_all_own_country_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 7.95})


#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => _stf_price_by_count_volume_item, :price => 9.95})


@tc.add_tarif_class_categories

