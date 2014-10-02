#Дополнительные пакеты минут 300
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_additional_minutes_300, :name => 'Дополнительные пакеты минут 300', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/discounts/discounts_in_region/calls_on_number_mts/paketu/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_smart, _mts_smart_plus, _mts_smart_top],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Добавление новых service_category_group for smart+
  #calls included in tarif
  scg_mts_additional_minutes_300_included_in_tarif_calls = @tc.add_service_category_group(
    {:name => 'scg_mts_additional_minutes_300_included_in_tarif_calls' }, 
    {:name => "price for scg_mts_additional_minutes_300_included_in_tarif_calls"}, 
    {:calculation_order => 0, :standard_formula_id => _stf_price_by_sum_duration_minute, 
      :formula => {:window_condition => "(300.0 >= sum_duration_minute)", :window_over => 'month'}, :price => 0.0, :description => '' }
    )

_sctcg_all_own_country_regions_calls_to_own_home_regions = {:name => '_sctcg_all_own_country_regions_calls_to_own_home_regions', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions}
_sctcg_all_own_country_regions_calls_to_own_country_own_operator = {:name => '_sctcg_all_own_country_regions_calls_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
 
#Переход на тариф
#  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 34.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 390.0})
 
#All own country regions, Calls, Outcoming, to_own_home_regions, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_all_own_country_regions_calls_to_own_home_regions, scg_mts_additional_minutes_300_included_in_tarif_calls[:id]) 

#All own country regions, Calls, Outcoming, to_own_country, to_own_operator
  @tc.add_grouped_service_category_tarif_class(_sctcg_all_own_country_regions_calls_to_own_country_own_operator, scg_mts_additional_minutes_300_included_in_tarif_calls[:id]) 

@tc.add_tarif_class_categories
  
#TODO проверить, действует ли опция в международном роуминге
#TODO проверить учитываются ли в звонках - звонки из домашних регионов в 150 минутах
#TODO добавить учет в опции звонков на 0885, прослушивание сообщений (см ниже)

#В пакет минут включены следующие вызовы: исходящие вызовы на все сети г. Москвы и Московской области и МТС России, 
#исходящие вызовы по номеру 0885, прослушивание сообщений из почтового ящика при использовании Голосовой почты. 
#При подключении/переходе предоставляется количество минут пропорциональное количеству дней, оставшихся до конца текущего календарного месяца. 
#В дальнейшем пакет минут будет начисляться в полном объеме первого числа каждого месяца, при этом неиспользованные минуты сгорают.   

#Пакеты минут "+150 минут", "+300 минут" не являются взаимоисключающимися и доступны на тарифах «Smart», «Smart+», «MAXI Smart», 
#«MAXI Top» и «MAXI». Отключение дополнительных пакетов минут "+150 минут", "+300 минут" возможно только при обращении в 
#Контактный центр или салон-магазин МТС. Отключение производится не ранее чем в последний день текущего месяца