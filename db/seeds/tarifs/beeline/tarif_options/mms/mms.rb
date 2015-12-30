@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_mms, :name => 'MMS', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/mms/'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_mobile_pencioner],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } ) 

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItemIfUsed, :formula => {:params => {:price => 30.0} } })  

#Own and home regions, mms, Outcoming, to_all_own_country_regions
category = {:name => '_sctcg_own_home_regions_mms_to_all_own_country_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.6} } })

#Own country, mms, Outcoming, _service_to_all_own_country_regions
category = {:name => '_sctcg_own_country_mms_to_own_home_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.6} } })

#All_world_rouming, mms, outcoming
category = {:name => '_sctcg_bln_all_world_rouming_mms_to_sic', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _mms_out}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.6} } })  


@tc.add_tarif_class_categories


#Если Вы отключили услугу, а теперь снова хотите отправлять друзьям картинки и фотографии, подключите MMS вновь с помощью команды *110*181#  
#Условия предоставления
#Максимальный размер исходящего MMS в сети «Билайн» 1 Мб  
#Максимальный размер исходящего MMS в сети других операторов до 500 Кб*  
#Дополнительная информация
#В национальном и международном роуминге при отправке MMS также тарифицируется GPRS-трафик.
#Оплата производится в рублях. Цены указаны в рублях с учетом НДС. * Сети некоторых операторов связи поддерживают передачу MMS объемом не более 300 Кб. В случае отправки абонентам этих сетей MMS большего размера, передача MMS по сетям таких операторов может не осуществляться
