@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_everywhere_moscow_in_central_region, :name => 'Везде Москва — в Центральном регионе', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/mskcenter.html'},
  :dependency => {
    :incompatibility => {
      :mms_options => [_mgf_mms_24, _mgf_paket_mms_10, _mgf_paket_mms_50, _mgf_everywhere_moscow_in_central_region],
      :sms_options => [_mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl, _mgf_sms_stihia, _mgf_paket_sms_100,
        _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000, _mgf_100_sms, _mgf_everywhere_moscow_in_central_region],
      :calls_options => [_mgf_unlimited_communication, _mgf_call_to_russia, _mgf_call_to_all_country, _mgf_option_city_connection, _mgf_everywhere_moscow_in_central_region],
      :intra_country_rouming => [_mgf_be_as_home, _mgf_all_russia, _mgf_travel_without_worry, _mgf_everywhere_moscow_in_central_region],
     }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})

#Central regions RF except for Own and home regions, Calls
#category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_calls', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _calls_in}
#  @tc.add_only_service_category_tarif_class(category)  

#Central regions RF except for Own and home regions, sms
#category = {:name => '_sctcg_cenral_regions_not_own_and_home_region_sms', :service_category_rouming_id => _sc_mgf_cenral_regions_not_own_and_home_region, :service_category_calls_id => _sms_out}
#  @tc.add_only_service_category_tarif_class(category)  

#Central regions RF except for Own and home regions, mms
#category = {:name => 'sctcg_cenral_regions_not_own_and_home_region_mms', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_in}
#  @tc.add_only_service_category_tarif_class(category)  



@tc.add_tarif_class_categories

#–Тарифная опция начинает действовать через 10–15 минут после подключения.
#–Опция действует в российской сети «МегаФон» за пределами Московской области в регионах, указанных выше.
#–При использовании тарифной опции «Везде Москва – в Центральном регионе» действуют только Интернет-опции (как дополнительно подключаемые, так и предоставляемые по условиям тарифного плана): опции с зоной действия «Вся Россия» действуют автоматически, а если подключена Интернет-опция с зоной действия «Московский регион», то для ее использования в других регионах страны необходимо дополнительно подключить опцию «Интернет по России».
#–Все остальные опции и услуги, а также льготные тарифы и скидки, меняющие цену услуг по тарифному плану (в том числе предоставляемые по условиям тарифного плана), не действуют.
#–Опция «Везде Москва ― В Центральном регионе» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон».
