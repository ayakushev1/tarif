#constant definition
_common = 160; _specific = 161; # service_category_type_id
_field = 150; _single_value = 151; _multiple_value = 152; #value_choose_option_id
_equal = 120; _not_equal = 121; _less = 122; _less_or_eq = 123; _more = 124; _more_or_eq = 125; _in_array = 126;#comparison_operator_id
#parameter_id
_call_base_service_id =       0; _call_base_sub_service_id =       1;
_call_own_phone_number =      2; _call_own_phone_operator_id =     3; _call_own_phone_region_id =            4; _call_own_phone_country_id =    5;
_call_partner_phone_number =  6; _call_partner_phone_operator_id = 7; _call_partner_phone_operator_type_id = 8; _call_partner_phone_region_id = 9; _call_partner_phone_country_id = 10;
_call_connect_operator_id =  11; _call_connect_region_id =        12; _call_connect_country_id =            13;
_call_description_time =     14; _call_description_duration =     15; _call_description_volume =            16;

#parameter from Category
_category_operator_type_id = 49 #operator_type_id - номер = 30 + category_type_id
_mobile = 170; _fixed_line = 171; #values for operator_type_id

#parameter from final query (fq) about user, his tarif and choosen services
_fq_tarif_operator_id = 100; _fq_tarif_region_id = 101; _fq_tarif_home_region_ids = 102; _fq_tarif_country_id = 103;

#parameter from operator home regions (operator_home_region: id, operator_id, region_ids)
#_operator_home_region = 

#parameter from operator groups of countries (operator_country_group: id, group_name, operator_id, country_ids)
_operator_country_group_operator_id = 200; _operator_country_group_countries_ids = 201;

Service::Category.delete_all; Service::Criterium.delete_all;
cat = []; crit = [];
#роуминг
cat << {:id => 0, :name => 'роуминг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}

cat << {:id => 1, :name => 'внутрисетевой роуминг', :type_id => _common, :parent_id => 0, :level => 1, :path => [0]}
  crit << {:id => 10 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 1}

cat << {:id => 2, :name => 'свой регион', :type_id => _common, :parent_id => 1, :level => 2, :path => [0, 1]}
  crit << {:id => 20 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => 2}

cat << {:id => 3, :name => 'домашний регион', :type_id => _common, :parent_id => 1, :level => 2, :path => [0, 1]}
  crit << {:id => 30 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => 3}

cat << {:id => 4, :name => 'своя страна', :type_id => _common, :parent_id => 1, :level => 2, :path => [0, 1]}
  crit << {:id => 40 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 4}

cat << {:id => 5, :name => 'группы стран', :type_id => _common, :parent_id => 1, :level => 2, :path => [0, 1]}
cat << {:id => 6, :name => 'весь мир', :type_id => _common, :parent_id => 5, :level => 3, :path => [0, 1, 5]}
  crit << {:id => 60 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _operator_country_group_operator_id, :value => nil, :service_category_id => 6}
  crit << {:id => 61 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _operator_country_group_countries_ids, :value => nil, :service_category_id => 6}

cat << {:id => 10, :name => 'чужой оператор', :type_id => _common, :parent_id => 0, :level => 1, :path => [0]}
  crit << {:id => 100 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 10}
           
cat << {:id => 11, :name => 'национальный роуминг', :type_id => _common, :parent_id => 10, :level => 2, :path => [0, 10]}
  crit << {:id => 110 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 11}
           
cat << {:id => 12, :name => 'международный роуминг', :type_id => _common, :parent_id => 10, :level => 2, :path => [0, 10]}
  crit << {:id => 120 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 12}

#география услуг
cat << {:id => 100, :name => 'география услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => 101, :name => 'услуги в свой регион', :type_id => _common, :parent_id => 100, :level => 1, :path => [100]}
  crit << {:id => 1010 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => 101}

cat << {:id => 102, :name => 'услуги в домашний регион', :type_id => _common, :parent_id => 100, :level => 1, :path => [100]}
  crit << {:id => 1020 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => 102}

cat << {:id => 103, :name => 'услуги в свою страну', :type_id => _common, :parent_id => 100, :level => 1, :path => [100]}
  crit << {:id => 1030 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 103}

cat << {:id => 104, :name => 'услуги в группу стран', :type_id => _common, :parent_id => 100, :level => 1, :path => [100]}
cat << {:id => 105, :name => 'весь мир', :type_id => _common, :parent_id => 104, :level => 2, :path => [100, 104]}
  crit << {:id => 1050 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _operator_country_group_operator_id, :value => nil, :service_category_id => 105}
  crit << {:id => 1051 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _operator_country_group_countries_ids, :value => nil, :service_category_id => 105}

#оператор второй стороны
cat << {:id => 190, :name => 'оператор второй стороны', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => 191, :name => 'свой оператор', :type_id => _common, :parent_id => 190, :level => 1, :path => [190]}
  crit << {:id => 1910 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 191}

cat << {:id => 192, :name => 'другой мобильный оператор', :type_id => _common, :parent_id => 190, :level => 1, :path => [190]}
  crit << {:id => 1920 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 192}
  crit << {:id => 1921 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => _mobile, :service_category_id => 192}

cat << {:id => 193, :name => 'фиксированная линия', :type_id => _common, :parent_id => 190, :level => 1, :path => [190]}
  crit << {:id => 1930 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 193}
  crit << {:id => 1931 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => _fixed_line, :service_category_id => 193}


#виды услуг
cat << {:id => 200, :name => 'виды услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => 201, :name => 'разовые', :type_id => _common, :parent_id => 200, :level => 1, :path => [200]}
cat << {:id => 202, :name => 'подключение тарифа', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 203, :name => 'смена тарифа', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 204, :name => 'отключение тарифа', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 205, :name => 'подключение услуги', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 206, :name => 'отключение услуги', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 207, :name => 'подключение опции', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 208, :name => 'отключение опции', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 209, :name => 'смена номера', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 210, :name => 'смена оператора', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 211, :name => 'смена региона', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 212, :name => 'федеральный номер', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 213, :name => 'локальный номер', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 214, :name => 'регулярный отчет об операциях', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 215, :name => 'отчет об операциях по запросу', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 216, :name => 'доступ в личный интернет кабинет', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
cat << {:id => 217, :name => 'доступ в личный мобильный кабинет', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}

cat << {:id => 280, :name => 'периодические', :type_id => _common, :parent_id => 200, :level => 1, :path => [200]}
cat << {:id => 281, :name => 'месячная абонентская плата', :type_id => _common, :parent_id => 280, :level => 2, :path => [200, 280]}
cat << {:id => 282, :name => 'ежедневная плата', :type_id => _common, :parent_id => 280, :level => 2, :path => [200, 280]}

cat << {:id => 300, :name => 'телефонные', :type_id => _common, :parent_id => 200, :level => 1, :path => [200]}
cat << {:id => 301, :name => 'звонки', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 302, :name => 'входящие звонки', :type_id => _common, :parent_id => 301, :level => 3, :path => [200, 300, 3001]}
cat << {:id => 303, :name => 'исходящие звонки', :type_id => _common, :parent_id => 301, :level => 3, :path => [200, 300, 301]}
cat << {:id => 310, :name => 'смс', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 311, :name => 'входящие смс', :type_id => _common, :parent_id => 310, :level => 3, :path => [200, 300, 310]}
cat << {:id => 312, :name => 'исходящие смс', :type_id => _common, :parent_id => 310, :level => 3, :path => [200, 300, 310]}
cat << {:id => 320, :name => 'ммс', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 321, :name => 'входящие ммс', :type_id => _common, :parent_id => 320, :level => 3, :path => [200, 300, 320]}
cat << {:id => 322, :name => 'исходящие ммс', :type_id => _common, :parent_id => 320, :level => 3, :path => [200, 300, 320]}
cat << {:id => 330, :name => 'gprs', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 331, :name => 'входящие gprs', :type_id => _common, :parent_id => 330, :level => 3, :path => [200, 300, 330]}
cat << {:id => 332, :name => 'исходящие gprs', :type_id => _common, :parent_id => 330, :level => 3, :path => [200, 300, 330]}
cat << {:id => 340, :name => '3G', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 341, :name => 'входящие 3G', :type_id => _common, :parent_id => 340, :level => 3, :path => [200, 300, 340]}
cat << {:id => 342, :name => 'исходящие 3G', :type_id => _common, :parent_id => 340, :level => 3, :path => [200, 300, 340]}
cat << {:id => 350, :name => 'LTE', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
cat << {:id => 351, :name => 'входящие LTE', :type_id => _common, :parent_id => 350, :level => 3, :path => [200, 300, 350]}
cat << {:id => 352, :name => 'исходящие LTE', :type_id => _common, :parent_id => 350, :level => 3, :path => [200, 300, 350]}


ActiveRecord::Base.transaction do
  Service::Category.create(cat)
  Service::Criterium.create(crit)
end
