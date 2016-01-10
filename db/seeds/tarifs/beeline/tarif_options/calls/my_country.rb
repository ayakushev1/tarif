@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_my_country, :name => 'Моя страна', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/moya-strana/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Подключение
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 25.0} } })  

#Периодическая плата
#  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })


#Own country, calls, incoming
  category = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, calls, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 3.0} } })  

#Own country, sms, outcoming, to all own country regions, to all operators
  category = {:name => '_sctcg_own_country_sms_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 3.0} } })  

#Own country, sms, outcoming, to not own country
#  category = {:name => 'own_country_sms_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}
#  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 2.5} } })  


@tc.add_tarif_class_categories



#Услуга доступна к подключению физическим и юридическим лицам предоплатной и постоплатной системы расчетов во всех регионах России.
#Услуга действует до момента самостоятельного отключения абонентом.
#Цена звонка - за минуту разговора, тарификация поминутная. Звонки тарифицируются с первой секунды. 
#Исходящие вызовы на номера спутниковых систем связи тарифицируются по стандартным тарифам.
#Услуга недоступна на ряде тарифных планов.
#Услуга недоступна на всех тарифных планах для USB-модемов и планшетов.
#Цена указаны с учетом НДС.
