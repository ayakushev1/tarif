@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_all_world, :name => 'Весь мир', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/allworld.html'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => false
  } } )

scg_mgf_all_world = @tc.add_service_category_group(
  {:name => 'scg_mgf_all_world' }, 
  {:name => "price for scg_mgf_all_world"}, 
  {:calculation_order => 0, :price => 0.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mgf_all_world', :description => '', 
   :formula => {
     :window_condition => "(30.0 >= sum_duration_minute)", :window_over => 'day',
     :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price'}, }  )

#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 30.0})  

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 25.0})


#All world, calls, incoming
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _calls_in}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_all_world[:id])


@tc.add_tarif_class_categories

#–При нахождении в международном роуминге абоненты тарифных планов для физических лиц и корпоративных тарифных планов, в рамках опции «Весь Мир» могут принимать 30 бесплатных входящих минут в течение календарных суток независимо от использования: в рамках одного соединения или суммарно нескольких соединений. Начиная с 31 минуты, все входящие вызовы до конца суток будут тарифицироваться по роуминговым тарифам страны пребывания;
#–Под сутками подразумевается период с 00:00 до 23:59 по московскому времени;
#–Условия тарификации входящих вызовов по тарифной опции «Весь Мир» действуют только в международном роуминге;
#–Опцию могут подключить абоненты всех тарифных планов для физических лиц и корпоративных тарифных планов, за исключением ТП «Вокруг Света»;
#–Данная опция не работает совместно с другими опциями модифицирующими стоимость звонков в международном роуминге;
#–Стоимость услуг связи по тарифной опции не распространяется на вызовы, которые совершаются через сети спутниковой связи с помощью специального оборудования, а также на вызовы через сеть AT&T Mobility LLC (BMU01);
#–Срок действия Опций не ограничен. Опция действует до момента отключения услуги абонентом;
#–Включенные бесплатные минуты предоставляются только 1 раз в сутки. При исчерпании минут в течение суток, а также при повторном подключении опции новые минуты будут предоставлены с начала новых суток.
