#Smart+, only grouped calls, sms and internet, with option "Везде как дома"
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class('Smart_plus_groups_with_everywhere_as_home')
#Добавление новых service_category_group
  #calls included in tarif
  scg_mts_smart_plus_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_calls' }, 
    {:name => "price for _scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, :formula => {:window_condition => "(1000.0 >= sum_duration_minute)"}, :price => 0.0, :description => '' }
    )
  #sms included in tarif
  scg_mts_smart_plus_included_in_tarif_sms = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_sms' }, 
    {:name => "price for _scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_sms"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, :formula => {:window_condition => "(1000.0 >= count_volume)"}, :price => 0.0, :description => '' }
    )
  #internet included in tarif
  scg_mts_smart_plus_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_smart_plus_with_everywhere_as_home_included_in_tarif_internet"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, :formula => {:window_condition => "(3000.0 >= sum_volume)"}, :price => 0.0, :description => '' }
    )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 100.0})


#Own region, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_other_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_calls_local_fixed_line, scg_mts_smart_plus_included_in_tarif_calls[:id])

#Own region, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_own_operator, _sctcg_own_region_calls_local_own_operator)

#Own region, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_other_operator, _sctcg_own_region_calls_local_other_operator)

#Own region, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_home_region_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Own region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_calls_own_country_own_operator, _sctcg_own_region_calls_local_own_operator)

#Own region, sms, Outcoming, to_local_number
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_sms_local, scg_mts_smart_plus_included_in_tarif_sms[:id])

#Own region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_region_sms_home_region, _sctcg_own_region_sms_local)

#Own region, Internet
  @tc.add_grouped_service_category_tarif_class(_sctcg_own_region_internet, scg_mts_smart_plus_included_in_tarif_internet[:id])


#Home region, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_other_operator, _sctcg_own_region_calls_local_other_operator)

#Home region, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_local_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Home region, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_other_operator, _sctcg_own_region_calls_local_other_operator)

#Home region, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_fixed_line, _sctcg_own_region_calls_local_fixed_line)

#Home region, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, _sctcg_own_region_calls_local_own_operator)

#Home region, sms, Outcoming, to_local_number
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_local, _sctcg_own_region_sms_local)

#Home region, sms, Outcoming, to_home_region
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_sms_home_region, _sctcg_own_region_sms_local)

#Home region, Internet
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_internet, _sctcg_own_region_internet)




#Own country, Calls, Outcoming, to_local_number, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_home_region_calls_local_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_home_region_calls_local_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 0.0000000000})

#Own country, Calls, Outcoming, to_local_number, to_other_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_home_region_calls_local_other_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_home_region_calls_local_other_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0000000000})

#Own country, Calls, Outcoming, to_local_number, to_fixed_line
  @tc.add_grouped_service_category_tarif_class(_sctcg_home_region_calls_local_fixed_line, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_home_region_calls_local_fixed_line, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 2.0000000000})

#Own country, Calls, Outcoming, to_home_region, to_own_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_own_operator, _sctcg_home_region_calls_local_own_operator)

#Own country, Calls, Outcoming, to_home_region, to_other_operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_other_operator, _sctcg_home_region_calls_local_other_operator)

#Own country, Calls, Outcoming, to_home_region, to_fixed_line
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_calls_home_region_fixed_line, _sctcg_home_region_calls_local_fixed_line)

#Own country, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, scg_mts_smart_plus_included_in_tarif_calls[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_home_region_calls_own_country_own_operator, {}, 
    {:calculation_order => 1,:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 5.0000000000})

#Own country, Internet
  @tc.add_as_other_service_category_tarif_class(_sctcg_home_region_internet, _sctcg_own_region_internet)


  
  @tc.load_repositories

#Для подключения / отключения опции наберите на своем мобильном телефоне *111*1021#вызов.

#Ежемесячная плата за опцию «Везде как дома Smart»: 100 руб.

#Плата взимается один раз в месяц в полном объеме: первый раз – при подключении опции; в последующие периоды - каждый месяц, начиная со второго, в день, соответствующий дате подключения опции.

#При нахождении на территории всей России в сети МТС:
#все прочие услуги связи, за исключением перечисленных выше направлений
#а также, в случае отключения опции – доступ в интернет и входящие, исходящие вызовы по перечисленным выше направлениям оплачиваются в соответствии с базовыми тарифами, действующими во внутрисетевом роуминге.

#* Точки доступа - internet.mts.ru, wap.mts.ru. При нахождении на территории Норильска, Республики Саха (Якутия), Камчатского края, Магаданской области и Чукотского АО скорость в пределах включенных в тарифные планы пакетов интернета ограничивается до 128 Кбит/с; при нахождении на территории остальных регионов России скорость в пределах включенных пакетов не ограничена.
#После исчерпания включенного объема интернет-трафика абонент может и далее использовать доступ в Интернет, докупив требуемый объем трафика путем подключения «Турбо-кнопок».
