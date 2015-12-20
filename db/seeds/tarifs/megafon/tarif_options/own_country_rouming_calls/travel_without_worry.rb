@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_travel_without_worry, :name => 'Путешествуй без забот', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/tww.html'},
  :dependency => {
    :incompatibility => {:intra_country_rouming => [_mgf_be_as_home, _mgf_all_russia, _mgf_travel_without_worry, _mgf_everywhere_moscow_in_central_region]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Добавление новых service_category_group
  #calls included in option
  scg_mgf_travel_without_worry_calls = @tc.add_service_category_group(
    {:name => 'scg_mgf_travel_without_worry_calls' }, 
    {:name => "price for scg_mgf_travel_without_worry_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(30.0 >= sum_duration_minute)", :window_over => 'day'}, :price => 0.0, :description => '' }
    )
  #sms included in option
  scg_mgf_travel_without_worry_sms = @tc.add_service_category_group(
    {:name => 'scg_mgf_travel_without_worry_sms' }, 
    {:name => "price for scg_mgf_travel_without_worry_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, 
      :formula => {:window_condition => "(30.0 >= count_volume)", :window_over => 'day'}, :price => 0.0, :description => '' }
    )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0})  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_any, :price => 39.0})


#Own country, calls, incoming
  category = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_travel_without_worry_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own country, calls, outcoming, to own and home regions, to own operator
  category = {:name => '_sctcg_own_country_calls_to_own_and_home_region_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_travel_without_worry_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0})

#Own country, calls, outcoming, to own and home regions, to other operators
  category = {:name => '_sctcg_own_country_calls_to_own_and_home_region_other_operators', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_not_own_operator}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_travel_without_worry_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own country, calls, outcoming, to not own and home regions, to all operators
  category = {:name => '_sctcg_own_country_calls_to_not_own_and_home_regions_all_operators', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_not_own_and_home_region}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_travel_without_worry_calls[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.0})

#Own country, sms, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_sms_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_travel_without_worry_sms[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 3.9})



@tc.add_tarif_class_categories

#–Тарифная опция начинает действовать через 10–15 минут после подключения;
#–Действие опции начинается за пределами Домашнего региона (Домашним регионом является субъект РФ (область или республика), в котором был заключен договор на оказание услуг связи с ОАО «МегаФон»);
#–Опция доступна для подключения абонентам большинства коммерческих и корпоративных тарифных планов «МегаФон»;
#–SMS-сообщения на номера контент-провайдеров и поставщиков прочих развлекательных услуг тарифицируются вне рамок опции;
#–Срок действия опций не ограничен. Опция действует до момента отключения услуги абонентом.
