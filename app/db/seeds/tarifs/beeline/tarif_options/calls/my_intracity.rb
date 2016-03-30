@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_intracity, :name => 'Мой межгород', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moy-mezgorod/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => [_bln_my_beeline]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [ _bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
        _bln_all_for_600_post, _bln_all_for_900_post,_bln_all_for_1500_post, _bln_all_for_2700_post, 
        _bln_total_all_post,], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 30.0} } })


#Own and home regions, Calls, Outcoming, to_own_country
category = {:name => '_sctcg_own_home_regions_calls_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 2.5} } })

#Own and home regions, sms, Outcoming, to_own_country
category = {:name => '_sctcg_own_home_regions_sms_to_own_country', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 1.5} } })




@tc.add_tarif_class_categories



#Если одновременно подключены опции «Мой межгород» и «Мой Билайн»: 
#• звонки абонентам «Билайн» России рассчитываются согласно опции «Мой Билайн»
#• звонки остальным абонентам – согласно опции «Мой межгород»
#Если вместе с тарифом «Всё включено M», «Всё за 300» подключена опция «Мой межгород»: 
#• звонки абонентам «Билайн» рассчитываются согласно условиям тарифа, сверх пакета – согласно опции «Мой межгород»
#• звонки другим абонентам – согласно опции «Мой межгород»
#Если вместе с тарифом «Всё включено M», «Всё за 300» подключена опция «Мой межгород»: 
#• звонки абонентам «Билайн» рассчитываются согласно условиям тарифа, сверх пакета – согласно опции «Мой межгород»
#• звонки другим абонентам – согласно условиям тарифа, сверх пакета – согласно опции «Мой межгород».
#Опции «Разговоры издалека», «Родной межгород» и «Любимый междугородный номер»:
#• отключаются автоматически, если вы подключаете опцию «Мой межгород» по номеру 06741, на сайте, в Личном кабинете 
#Опция доступна всем абонентам предоплатной системы расчётов, на всех тарифных планах, за исключением тарифов с включенными минутами на других операторов других регионов России, а также «Безлимитный интернет для планшетов», «Простая логика», «Твои правила», архивные тарифы линейки «Ноль сомнений » и «Ноль сомнений.Область». 
#Опция "Мой межгород" недоступна на тарифных планах постоплатной системы расчетов "Всё за 600", "Всё за 900", "Всё за 1450" и Всё за 1750"  
