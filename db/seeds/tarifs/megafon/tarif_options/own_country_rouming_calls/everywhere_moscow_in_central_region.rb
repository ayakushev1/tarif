@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_everywhere_moscow_in_central_region, :name => 'Везде Москва — в Центральном регионе', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/mskcenter.html'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Параметры опции задаются в описании самого тарифа

#Подключение услуги
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежедневная плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0})




@tc.add_tarif_class_categories

#–Тарифная опция начинает действовать через 10–15 минут после подключения.
#–Опция действует в российской сети «МегаФон» за пределами Московской области в регионах, указанных выше.
#–При использовании тарифной опции «Везде Москва – в Центральном регионе» действуют только Интернет-опции (как дополнительно подключаемые, так и предоставляемые по условиям тарифного плана): опции с зоной действия «Вся Россия» действуют автоматически, а если подключена Интернет-опция с зоной действия «Московский регион», то для ее использования в других регионах страны необходимо дополнительно подключить опцию «Интернет по России».
#–Все остальные опции и услуги, а также льготные тарифы и скидки, меняющие цену услуг по тарифному плану (в том числе предоставляемые по условиям тарифного плана), не действуют.
#–Опция «Везде Москва ― В Центральном регионе» доступна для подключения абонентам большинства частных и корпоративных тарифных планов «МегаФон».
