@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_be_as_home, :name => 'Будь как дома', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/bud_kak_doma.html'},
  :dependency => {
    :incompatibility => {
      :intra_country_rouming => [_mgf_be_as_home, _mgf_all_russia, _mgf_travel_without_worry, _mgf_everywhere_moscow_in_central_region, _mgf_internet_in_russia, _mgf_gigabite_to_road],
      :mgf_internet_in_russia => [_mgf_be_as_home, _mgf_internet_in_russia_for_specific_options, _mgf_internet_in_russia, _mgf_gigabite_to_road],
     }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => false
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 30.0} } })  
#  @tc.add_only_service_category_tarif_class(_sctcg_one_time_tarif_switch_on)  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price =>53.0} } })
#  @tc.add_only_service_category_tarif_class(_sctcg_periodic_day_fee)  

#All Russia except for Own and home regions, Calls
category = {:name => 'sctcg_own_country_rouming_calls', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_only_service_category_tarif_class(category)  

#All Russia except for Own and home regions, sms
category = {:name => '_sctcg_own_country_rouming_sms_to_own_and_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_only_service_category_tarif_class(category)  
category = {:name => '_sctcg_own_country_rouming_sms_to_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_only_service_category_tarif_class(category)  
category = {:name => '_sctcg_own_country_rouming_sms_to_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
  @tc.add_only_service_category_tarif_class(category)  

#All Russia except for Own and home regions, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_only_service_category_tarif_class(category)  


@tc.add_tarif_class_categories

#–Тарифная опция начинает действовать через 10–15 минут после подключения.
#–Опция действует в российской сети «МегаФон» за пределами Московской области в регионах, указанных выше.
#–При использовании тарифной опции «Везде Москва – в Центральном регионе» действуют только Интернет-опции (как дополнительно подключаемые, так и предоставляемые по условиям тарифного плана): опции с зоной действия «Вся Россия» действуют автоматически, а если подключена Интернет-опция с зоной действия «Московский регион», то для ее использования в других регионах страны необходимо дополнительно подключить опцию «Интернет по России».
#–Все остальные опции и услуги, а также льготные тарифы и скидки, меняющие цену услуг по тарифному плану (в том числе предоставляемые по условиям тарифного плана), не действуют.
#–Опция «Везде Москва ― В Центральном регионе» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон».
