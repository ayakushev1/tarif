#Ноль без границ
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_zero_without_limits, :name => 'Ноль без границ', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/discount_roaming/wwb/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Europe rouming
_sctcg_mts_europe_calls_incoming = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_europe_calls_to_russia = {:name => '_sctcg_mts_europe_calls_to_russia', :service_category_rouming_id => _sc_mts_europe_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_sic_calls_incoming = {:name => '_sctcg_mts_sic_calls_incoming', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_calls_to_russia = {:name => '_sctcg_mts_sic_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_sic_1_calls_incoming = {:name => '_sctcg_mts_sic_1_calls_incoming', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_1_calls_to_russia = {:name => '_sctcg_mts_sic_1_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_sic_2_1_calls_incoming = {:name => '_sctcg_mts_sic_2_1_calls_incoming', :service_category_rouming_id => _sc_mts_sic_2_1_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_2_1_calls_to_russia = {:name => '_sctcg_mts_sic_2_1_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_2_1_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_sic_2_2_calls_incoming = {:name => '_sctcg_mts_sic_2_2_calls_incoming', :service_category_rouming_id => _sc_mts_sic_2_2_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_2_2_calls_to_russia = {:name => '_sctcg_mts_sic_2_2_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_2_2_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_sic_3_calls_incoming = {:name => '_sctcg_mts_sic_3_calls_incoming', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_sic_3_calls_to_russia = {:name => '_sctcg_mts_sic_3_calls_to_russia', :service_category_rouming_id => _sc_mts_sic_3_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

_sctcg_mts_other_countries_calls_incoming = {:name => '_sctcg_mts_other_countries_calls_incoming', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_in}
_sctcg_mts_other_countries_calls_to_russia = {:name => '_sctcg_mts_other_countries_calls_to_russia', :service_category_rouming_id => _sc_mts_other_countries_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}

#calls_first_200_minites
scg_mts_zero_without_limits_calls_first_200_minites = @tc.add_service_category_group(
  {:name => 'scg_mts_zero_without_limits_calls_first_200_minites' }, 
  {:name => "price for scg_mts_zero_without_limits_calls_first_200_minites"}, 
  {:calculation_order => 0, :price => 25.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mts_zero_without_limits_calls_first_200_minites', :description => '', 
   :formula => {
     :window_condition => "(200.0 >= sum_duration_minute)", :window_over => 'month',
     :stat_params => {:sum_duration_minute_after_10_min => "sum(case when ceil(((description->>'duration')::float)/60.0) > 10.0 then ceil(((description->>'duration')::float)/60.0) - 10.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * sum_duration_minute_after_10_min'}, }  )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 95.0})

#Europe, calls, incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mts_europe_calls_incoming, scg_mts_zero_without_limits_calls_first_200_minites[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_calls_incoming, {}, 
    {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0, :description => '' } )

#Europe, calls, outcoming, to Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_europe_calls_to_russia, {}, 
  {:calculation_order => 0, :price => 25.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mts_zero_without_limits_calls_first_200_minites', :description => '', 
   :formula => {
     :stat_params => {:sum_duration_minute_between_2_and_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 2.0 and 5.0 then ceil(((description->>'duration')::float)/60.0) - 1.0 else 0.0 end)",
                      :sum_duration_minute_less_2 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 2.0 then 1.0 else 0.0 end)",
                      :count_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_2_and_5 + count_duration_minute_more_5 * 5.0) + 50.0 * (sum_duration_minute_less_2 + sum_duration_minute_more_5)'}, } )

#SIC_1, calls, incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mts_sic_1_calls_incoming, scg_mts_zero_without_limits_calls_first_200_minites[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_calls_incoming, {}, 
    {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0, :description => '' } )

#SIC_1, calls, outcoming, to Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_1_calls_to_russia, {}, 
  {:calculation_order => 0, :price => 25.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mts_zero_without_limits_calls_first_200_minites', :description => '', 
   :formula => {
     :stat_params => {:sum_duration_minute_between_2_and_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 2.0 and 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :sum_duration_minute_less_2 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 2.0 then 1.0 else 0.0 end)",
                      :count_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_2_and_5 + count_duration_minute_more_5 * 5.0) + 75.0 * (sum_duration_minute_less_2 + sum_duration_minute_more_5)'}, } )

#SIC_2_1, calls, incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mts_sic_2_1_calls_incoming, scg_mts_zero_without_limits_calls_first_200_minites[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_1_calls_incoming, {}, 
    {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0, :description => '' } )

#SIC_2_1, calls, outcoming, to Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_sic_2_1_calls_to_russia, {}, 
  {:calculation_order => 0, :price => 25.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mts_zero_without_limits_calls_first_200_minites', :description => '', 
   :formula => {
     :stat_params => {:sum_duration_minute_between_2_and_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 2.0 and 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :sum_duration_minute_less_2 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 2.0 then 1.0 else 0.0 end)",
                      :count_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_2_and_5 + count_duration_minute_more_5 * 5.0) + 115.0 * (sum_duration_minute_less_2 + sum_duration_minute_more_5)'}, } )

#Other countries, calls, incoming
  @tc.add_grouped_service_category_tarif_class(_sctcg_mts_other_countries_calls_incoming, scg_mts_zero_without_limits_calls_first_200_minites[:id])
  @tc.add_one_service_category_tarif_class(_sctcg_mts_other_countries_calls_incoming, {}, 
    {:calculation_order => 1, :standard_formula_id => _stf_price_by_sum_duration_minute, :price => 9.0, :description => '' } )

#Other countries, calls, to Russia
  @tc.add_one_service_category_tarif_class(_sctcg_mts_other_countries_calls_to_russia, {}, 
  {:calculation_order => 0, :price => 25.0, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => '_stf_mts_zero_without_limits_calls_first_200_minites', :description => '', 
   :formula => {
     :stat_params => {:sum_duration_minute_between_2_and_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) between 2.0 and 5.0 then ceil(((description->>'duration')::float)/60.0) else 0.0 end)",
                      :sum_duration_minute_less_2 => "sum(case when ceil(((description->>'duration')::float)/60.0) < 2.0 then 1.0 else 0.0 end)",
                      :count_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then 1.0 else 0.0 end)",
                      :sum_duration_minute_more_5 => "sum(case when ceil(((description->>'duration')::float)/60.0) > 5.0 then ceil(((description->>'duration')::float)/60.0) - 5.0 else 0.0 end)",
                      :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
     :method => 'price_formulas.price * (sum_duration_minute_between_2_and_5 + count_duration_minute_more_5 * 5.0) + 149.0 * (sum_duration_minute_less_2 + sum_duration_minute_more_5)'}, } )
     
@tc.add_tarif_class_categories

#Ежесуточная плата за использование опции составляет 33 руб.
#С 19 июня 2014 года стоимость входящего вызова, начиная с 11-й минуты каждого разговора составит 9 руб./мин.; 
#стоимость исходящих вызовов на российские номера составит 19 руб./мин.
#При нахождении в международном роуминге абоненты всех тарифных планов, за исключением корпоративных, 
#в рамках опции «Ноль без границ» могут принимать 200 минут входящих вызовов в месяц. 
#Начиная с 201 минуты, все входящие вызовы до конца календарного месяца будут стоить 5 руб. за минуту

#Количество накопленных входящих вызовов в международном роуминге можно уточнить следующими способами:
#наберите на своем мобильном телефоне *419*1233#вызов

#Как подключить и отключить опцию
#наберите на своем мобильном телефоне *111*4444#вызов  и выберите соответствующий пункт меню;
#отправьте SMS на номер 111 с текстом: 33 - для подключения опции; 330 - для отключения опции.

#Вы можете подключить опцию, даже находясь за границей.
#На территории России опцию также можно подключить, набрав на своем мобильном телефоне *444#вызов  
#Для абонентов всех тарифных планов команды *111*4444#вызов и *444#вызов бесплатны. Отправка SMS на номер 111 бесплатна в регионе регистрации номера, во внутрисетевом и международном роуминге. 
#При нахождении в национальном роуминге отправка SMS оплачивается в соответствии с роуминговым тарифом.

#Плата за первые сутки списывается при подключении опции. Оплата производится за каждые полные или неполные сутки независимо от местонахождения абонента 
#на протяжении всего времени действия опции вплоть до самостоятельного отключения опции
     

#Условия пользования опцией
#Воспользоваться настоящим предложением в роуминге возможно только при подключенных услугах «Международный и национальный роуминг» и «Международный доступ», 
#либо при подключенной услуге «Легкий роуминг и международный доступ» .Проверить подключение данных услуг можно через «Интернет-помощник».
#При подключенной услуге «Легкий роуминг и международный доступ» использование телефона возможно в сетях операторов, с которыми у ОАО МТС действует соглашение о CAMEL-роуминге.
#Без подключения опции «Ноль без границ» действуют базовые тарифы, ознакомиться с которыми можно в разделе «Тарифы и география» .
#Для абонентов тарифного плана «Европейский» при подключении услуги «Ноль без границ» скидка в странах Европы действует на исходящие звонки.
#TODO#Если в течение 30 суток вы не пользовались услугами связи в сети МТС России, стоимость каждой минуты входящего вызова при подключенной опции «Ноль без границ» равна 15 руб. 
#при нахождении в любой зарубежной стране за исключением Узбекистана, Азербайджана и Южной Осетии. 
#При нахождении в Узбекистане и Азербайджане стоимость входящего вызова равна 59 руб./мин., в Южной Осетии - 17 руб./мин
