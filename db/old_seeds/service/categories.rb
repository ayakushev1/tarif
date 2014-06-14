Service::Category.delete_all; Service::Criterium.delete_all;
cat = []; crit = [];
#роуминг
cat << {:id => _category_rouming, :name => 'роуминг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}

cat << {:id => _intra_net_rouming, :name => 'внутрисетевой роуминг', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => 10 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _intra_net_rouming}

cat << {:id => _own_region_rouming, :name => 'свой регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => 20 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_region_rouming}

cat << {:id => _home_region_rouming, :name => 'домашний регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => 30 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _home_region_rouming}

cat << {:id => _own_and_home_regions_rouming, :name => '_own_and_home_regions_rouming', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_and_home_regions_rouming * 10 + 0 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.own_home_regions#{_fq_tarif_operator_id}, (#{_fq_tarif_operator_id})", :service_category_id => _own_and_home_regions_rouming}

cat << {:id => _own_country_rouming, :name => 'своя страна', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => 40 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => 41 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => 42 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _own_country_rouming}

cat << {:id => 5, :name => 'группы стран', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
cat << {:id => 6, :name => 'весь мир', :type_id => _common, :parent_id => 5, :level => 3, :path => [0, 1, 5]}
  crit << {:id => 61 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => 'Relation.operator_country_groups(nil, 1600)', :service_category_id => 6}

cat << {:id => 10, :name => 'чужой оператор', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => 100 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => 10}
           
cat << {:id => 11, :name => 'национальный роуминг', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 110 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 11}
           
cat << {:id => _all_world_rouming, :name => 'международный роуминг', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 120 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 12}

cat << {:id => _sc_mts_europe_rouming, :name => '_sc_mts_europe_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 130 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _sc_mts_europe_rouming}

cat << {:id => _sc_mts_sic_rouming, :name => '_sc_mts_sic_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 140 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_mts_sic_rouming}

cat << {:id => _sc_mts_sic_1_rouming, :name => '_sc_mts_sic_1_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 150 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_1_countries})", :service_category_id => _sc_mts_sic_1_rouming}

cat << {:id => _sc_mts_sic_2_rouming, :name => '_sc_mts_sic_2_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 160 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_countries})", :service_category_id => _sc_mts_sic_2_rouming}

cat << {:id => _sc_mts_sic_3_rouming, :name => '_sc_mts_sic_3_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 170 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_3_countries})", :service_category_id => _sc_mts_sic_3_rouming}

cat << {:id => _sc_mts_other_countries_rouming, :name => '_sc_mts_other_countries_rouming', :type_id => _common, :parent_id => 10, :level => 2, :path => [_category_rouming, 10]}
  crit << {:id => 180 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _sc_mts_other_countries_rouming}


#география услуг
cat << {:id => _geography_services, :name => 'география услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_region, :name => 'услуги в свой регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => 1010 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_region}

cat << {:id => _service_to_home_region, :name => 'услуги в домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => 1020 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_home_region}

cat << {:id => _service_to_own_and_home_regions, :name => 'услуги в домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_and_home_regions * 10, :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.own_home_regions#{_fq_tarif_operator_id}, (#{_fq_tarif_operator_id})", :service_category_id => _service_to_own_and_home_regions}

#TODO исправить плохой критерий 1030
cat << {:id => _service_to_own_country, :name => 'услуги в свою страну', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => 1030 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => 1031 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => 1032 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_own_country}

cat << {:id => _service_to_group_of_countries, :name => 'услуги в группу стран', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
cat << {:id => _service_to_not_own_country, :name => 'весь мир', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1050 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_not_own_country}

cat << {:id => _service_to_mts_europe, :name => 'mts Europe', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1061 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _service_to_mts_europe}
cat << {:id => _service_to_mts_sic, :name => 'mts SIC', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1071 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _service_to_mts_sic}
cat << {:id => _service_to_mts_other_countries, :name => 'mts other countries', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1081 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _service_to_mts_other_countries}


cat << {:id => _sc_service_to_russia, :name => '_service_to_russia', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1090 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_russia}

cat << {:id => _sc_service_to_rouming_country, :name => '_service_to_rouming_country', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1100 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_rouming_country}

cat << {:id => _sc_service_to_not_rouming_not_russia, :name => '_sc_service_to_not_rouming_not_russia', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1110 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia}
  crit << {:id => 1111 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia}

cat << {:id => _sc_service_not_rouming_not_russia_to_sic, :name => '_sc_service_to_sic_countries', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1120 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => 1121 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => 1122 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_not_rouming_not_russia_to_sic}

cat << {:id => _sc_service_to_not_rouming_not_russia_not_sic, :name => '_sc_service_to_not_rouming_not_russia_not_sic', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => 1130 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => 1131 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => 1132 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}

#оператор второй стороны
cat << {:id => _partner_operator_services, :name => 'оператор второй стороны', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_operator, :name => 'свой оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => 1910 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_own_operator}

cat << {:id => _service_to_other_operator, :name => 'другой мобильный оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => 1920 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_other_operator}
  crit << {:id => 1921 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _mobile}, :service_category_id => _service_to_other_operator}

cat << {:id => _service_to_fixed_line, :name => 'фиксированная линия', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => 1930 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_fixed_line}
  crit << {:id => 1931 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _fixed_line}, :service_category_id => _service_to_fixed_line}


#виды услуг
cat << {:id => 200, :name => 'виды услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => 201, :name => 'разовые', :type_id => _common, :parent_id => 200, :level => 1, :path => [200]}
cat << {:id => 202, :name => 'подключение тарифа', :type_id => _common, :parent_id => 201, :level => 2, :path => [200, 201]}
#TODO откорректировать
  crit << {:id => 2020 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _one_time, :service_category_id => 202}
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
cat << {:id => _periodic_monthly_fee, :name => 'месячная абонентская плата', :type_id => _common, :parent_id => 280, :level => 2, :path => [200, 280]}
#TODO откорректировать
  crit << {:id => 2810 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_monthly_fee}
cat << {:id => _periodic_day_fee, :name => 'ежедневная плата', :type_id => _common, :parent_id => 280, :level => 2, :path => [200, 280]}
#TODO откорректировать
  crit << {:id => 2820 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_day_fee}

cat << {:id => 300, :name => 'телефонные', :type_id => _common, :parent_id => 200, :level => 1, :path => [200]}
cat << {:id => 301, :name => 'звонки', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
  crit << {:id => 3010 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _calls, :service_category_id => 301}

cat << {:id => 302, :name => 'входящие звонки', :type_id => _common, :parent_id => 301, :level => 3, :path => [200, 300, 301]}
  crit << {:id => 3020 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => 302}

cat << {:id => 303, :name => 'исходящие звонки', :type_id => _common, :parent_id => 301, :level => 3, :path => [200, 300, 301]}
  crit << {:id => 3030 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => 303}

cat << {:id => 310, :name => 'смс', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
  crit << {:id => 3100 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _sms, :service_category_id => 310}

cat << {:id => 311, :name => 'входящие смс', :type_id => _common, :parent_id => 310, :level => 3, :path => [200, 300, 310]}
  crit << {:id => 3110 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => 311}

cat << {:id => 312, :name => 'исходящие смс', :type_id => _common, :parent_id => 310, :level => 3, :path => [200, 300, 310]}
  crit << {:id => 3120 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => 312}

cat << {:id => 320, :name => 'ммс', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
  crit << {:id => 3200 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _mms, :service_category_id => 320}

cat << {:id => 321, :name => 'входящие ммс', :type_id => _common, :parent_id => 320, :level => 3, :path => [200, 300, 320]}
  crit << {:id => 3210 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => 321}

cat << {:id => 322, :name => 'исходящие ммс', :type_id => _common, :parent_id => 320, :level => 3, :path => [200, 300, 320]}
  crit << {:id => 3220 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => 322}

cat << {:id => 330, :name => 'gprs', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
  crit << {:id => 3300 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _2g, :service_category_id => 330}

#cat << {:id => 331, :name => 'входящие gprs', :type_id => _common, :parent_id => 330, :level => 3, :path => [200, 300, 330]}
#cat << {:id => 332, :name => 'исходящие gprs', :type_id => _common, :parent_id => 330, :level => 3, :path => [200, 300, 330]}
cat << {:id => 340, :name => 'Internet', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
  crit << {:id => 3400 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => [_3g, _4g], :service_category_id => 340}

#cat << {:id => 341, :name => 'входящие 3G', :type_id => _common, :parent_id => 340, :level => 3, :path => [200, 300, 340]}
#cat << {:id => 342, :name => 'исходящие 3G', :type_id => _common, :parent_id => 340, :level => 3, :path => [200, 300, 340]}
#cat << {:id => 350, :name => 'LTE', :type_id => _common, :parent_id => 300, :level => 2, :path => [200, 300]}
#cat << {:id => 351, :name => 'входящие LTE', :type_id => _common, :parent_id => 350, :level => 3, :path => [200, 300, 350]}
#cat << {:id => 352, :name => 'исходящие LTE', :type_id => _common, :parent_id => 350, :level => 3, :path => [200, 300, 350]}


ActiveRecord::Base.transaction do
  Service::Category.create(cat)
  Service::Criterium.create(crit)
end
