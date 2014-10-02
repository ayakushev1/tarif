@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_abroad_10, :name => 'Интернет за границей, 10 Мб', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/internet_abroad.html'},
  :dependency => {
    :incompatibility => {:internet_abroad_pakets => [_mgf_internet_abroad_10, _mgf_internet_abroad_30, _mgf_vacation_online]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => true
  } } )


#Ukraine, internet
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_ukraine_internet_abroad, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 49.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_abroad_10', :description => '', 
     :formula => {
       :window_condition => "(10.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 10.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Europe, internet
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_europe_internet_abroad, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 129.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_abroad_10', :description => '', 
     :formula => {
       :window_condition => "(10.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 10.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Popular countries plus SIC, internet
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_popular_countries_internet_abroad, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 329.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_abroad_10', :description => '', 
     :formula => {
       :window_condition => "(10.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 10.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Other countries, internet
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_other_countries_internet_abroad, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 1990.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_abroad_10', :description => '', 
     :formula => {
       :window_condition => "(10.0 >= sum_volume)", :window_over => 'day', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 10.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )



@tc.add_tarif_class_categories

#–Опцию могут подключить абоненты всех тарифных планов для физических лиц и корпоративных тарифных планов (за исключением ТП «Вокруг Света» в Столичном филиале);
#–В настройках мобильного устройства должен быть указан любой из перечисленных APN: «INTERNET», «ANYAPN» и «WAP»;
#–Условия опции действуют только в международном роуминге;
#–Под периодом подразумевается 24 часа;
#–Данная опция не работает совместно с другими опциями модифицирующими стоимость Мобильного интернета в Международном роуминге;
#–Срок действия Опций не ограничен и действует до момента отключения услуги абонентом


#Выбираете подходящий для Вас объем трафика «10 МБ» или «30 МБ» и подключаете опцию (подключение бесплатное!);
#Опция работает во всех указанных странах, а плата за использование взимается только после выхода в Интернет за границей (т. е. после первой Интернет-сессии). Размер платы зависит от страны, в которой Вы воспользовались Интернетом;
#Выбранный объем трафика доступен в течение 24 часов после первого выхода в Интернет в роуминге. После истечения указанного периода повторное подключение опции не требуется и действие опции автоматически возобновляется, при этом плата за пользование взимается после выхода в Интернет;
#Если Вы досрочно исчерпали трафик по опции — доступ в Интернет приостанавливается до наступления нового периода (следующие 24 часа).
#! Если желаете продолжить использование Интернета (до наступления нового периода) — Вы можете переподключить опцию и полный объем трафика сразу будет доступен (при этом выбранный объем трафика будет доступен также в течение 24 часов после выхода в Интернет после «переподключения» опции и плата за использование будет взиматься только после выхода в Интернет после «переподключения»). 
#Или отключите опцию и оплачивайте каждый мегабайт без ограничений по базовым роуминговым тарифам.
