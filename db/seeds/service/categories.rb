cat = []; crit = [];
#роуминг
cat << {:id => _category_rouming, :name => 'роуминг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}

cat << {:id => _all_russia_rouming, :name => 'роуминг Вся Россия', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => _all_russia_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _all_russia_rouming}


cat << {:id => _intra_net_rouming, :name => 'внутрисетевой роуминг', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => _intra_net_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _intra_net_rouming}

cat << {:id => _own_region_rouming, :name => 'свой регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_region_rouming * 10 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_region_rouming}

cat << {:id => _home_region_rouming, :name => 'домашний регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _home_region_rouming * 10 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _home_region_rouming}

cat << {:id => _own_and_home_regions_rouming, :name => 'свой и домашний регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_and_home_regions_rouming * 10 + 0 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _own_and_home_regions_rouming}

cat << {:id => _own_country_rouming, :name => 'своя страна', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_country_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => _own_country_rouming * 10 + 1 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => _own_country_rouming * 10 + 2, :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _own_country_rouming}

cat << {:id => _sc_mgf_cenral_regions_not_own_and_home_region, :name => 'Мегафон, Центральный регион, кроме домашнего', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _sc_mgf_cenral_regions_not_own_and_home_region * 10 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _sc_mgf_cenral_regions_not_own_and_home_region}
  crit << {:id => _sc_mgf_cenral_regions_not_own_and_home_region * 10 +1 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_region_groups_by_group_id(#{_relation_mgf_central_region})", :service_category_id => _sc_mgf_cenral_regions_not_own_and_home_region}
  

cat << {:id => 5, :name => 'группы стран', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
cat << {:id => 6, :name => 'весь мир', :type_id => _common, :parent_id => 5, :level => 3, :path => [0, 1, 5]}
  crit << {:id => 61 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => 'Relation.operator_country_groups(nil, 1600)', :service_category_id => 6}

cat << {:id => _sc_other_operator_rouming, :name => 'чужой оператор', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => _sc_other_operator_rouming * 10 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _sc_other_operator_rouming}
           
cat << {:id => _sc_national_rouming, :name => 'национальный роуминг', :type_id => _common, :parent_id => _sc_other_operator_rouming, :level => 2, :path => [_category_rouming, _sc_other_operator_rouming]}
  crit << {:id => _sc_national_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _sc_national_rouming}
           
cat << {:id => _all_world_rouming, :name => 'международный роуминг', :type_id => _common, :parent_id => _sc_other_operator_rouming, :level => 2, :path => [_category_rouming, _sc_other_operator_rouming]}
  crit << {:id => _all_world_rouming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => 12}

cat << {:id => _sc_mts_europe_rouming, :name => 'Страны Европы МТС', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_europe_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _sc_mts_europe_rouming}

cat << {:id => _sc_mts_sic_rouming, :name => 'Страны СНГ МТС', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_mts_sic_rouming}

cat << {:id => _sc_mts_sic_1_rouming, :name => 'Страны СНГ МТС 1-я группа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_1_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_1_countries})", :service_category_id => _sc_mts_sic_1_rouming}

cat << {:id => _sc_mts_sic_2_rouming, :name => 'Страны СНГ МТС 2-я группа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_countries})", :service_category_id => _sc_mts_sic_2_rouming}

cat << {:id => _sc_mts_sic_2_1_rouming, :name => 'Страны СНГ МТС 2.1-я группа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_1_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_1_countries})", :service_category_id => _sc_mts_sic_2_1_rouming}

cat << {:id => _sc_mts_sic_2_2_rouming, :name => 'Страны СНГ МТС 2.1-я группа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_2_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_2_countries})", :service_category_id => _sc_mts_sic_2_2_rouming}

cat << {:id => _sc_mts_sic_3_rouming, :name => 'Страны СНГ МТС 3-я группа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_3_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_3_countries})", :service_category_id => _sc_mts_sic_3_rouming}

cat << {:id => _sc_mts_other_countries_rouming, :name => 'Прочие страны МТС', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_other_countries_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _sc_mts_other_countries_rouming}

cat << {:id => _sc_lithuania_and_latvia_rouming, :name => 'Литва и Латвия', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_lithuania_and_latvia_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => [_lithuania, _latvia], :service_category_id => _sc_lithuania_and_latvia_rouming}

cat << {:id => _sc_mts_rouming_in_11_9_option_countries_1, :name => 'Страны МТС 1-я группа 11,9 руб', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_11_9_option_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_calls_from_11_9_option_countries_1})", :service_category_id => _sc_mts_rouming_in_11_9_option_countries_1}

cat << {:id => _sc_mts_rouming_in_11_9_option_countries_2, :name => 'Страны МТС 2-я группа 11,9 руб', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_11_9_option_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_calls_from_11_9_option_countries_2})", :service_category_id => _sc_mts_rouming_in_11_9_option_countries_2}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_1, :name => 'Страны МТС 1-я группа бит заграницей', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_1})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_1}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_2, :name => 'Страны МТС 2-я группа бит заграницей', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_2})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_2}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_3, :name => 'Страны МТС 3-я группа бит заграницей', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_3 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_3})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_3}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_4, :name => 'Страны МТС 4-я группа бит заграницей', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_4 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_4})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_4}


cat << {:id => _sc_mgf_rouming_in_option_around_world_1, :name => 'Страны Мегафон 1-я группа опции вокруг мира', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_rouming_in_option_around_world_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_rouming_in_option_around_world_1})", :service_category_id => _sc_mgf_rouming_in_option_around_world_1}

cat << {:id => _sc_mgf_rouming_in_option_around_world_2, :name => 'Страны Мегафон 2-я группа опции вокруг мира', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_rouming_in_option_around_world_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_rouming_in_option_around_world_2})", :service_category_id => _sc_mgf_rouming_in_option_around_world_2}

cat << {:id => _sc_mgf_rouming_in_option_around_world_3, :name => 'Страны Мегафон 3-я группа опции вокруг мира', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_rouming_in_option_around_world_3 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_rouming_in_option_around_world_3})", :service_category_id => _sc_mgf_rouming_in_option_around_world_3}

cat << {:id => _sc_mgf_rouming_in_50_sms_europe, :name => 'Страны Мегафон опции 50 смс Европа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_rouming_in_50_sms_europe * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_rouming_in_50_sms_europe})", :service_category_id => _sc_mgf_rouming_in_50_sms_europe}

cat << {:id => _sc_mgf_rouming_not_russia_not_in_50_sms_europe, :name => 'Страны Мегафон кроме России и опции 50 смс Европа', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_rouming_not_russia_not_in_50_sms_europe * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_rouming_not_russia_not_in_50_sms_europe})", :service_category_id => _sc_mgf_rouming_not_russia_not_in_50_sms_europe}


cat << {:id => _sc_mgf_europe_international_rouming, :name => 'Страны Европы Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_europe_international_rouming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_europe_international_rouming})", :service_category_id => _sc_mgf_europe_international_rouming}

cat << {:id => _sc_mgf_sic_international_rouming, :name => 'Страны СНГ Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_sic_international_rouming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_sic_international_rouming})", :service_category_id => _sc_mgf_sic_international_rouming}

cat << {:id => _sc_mgf_other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_other_countries_international_rouming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_other_countries_international_rouming})", :service_category_id => _sc_mgf_other_countries_international_rouming}

cat << {:id => _sc_mgf_extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_extended_countries_international_rouming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_extended_countries_international_rouming})", :service_category_id => _sc_mgf_extended_countries_international_rouming}

cat << {:id => _sc_mgf_ukraine_internet_abroad, :name => 'Страны Европы Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_ukraine_internet_abroad * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_ukraine_internet_abroad})", :service_category_id => _sc_mgf_ukraine_internet_abroad}

cat << {:id => _sc_mgf_europe_internet_abroad, :name => 'Страны Европы Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_europe_internet_abroad * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_europe_internet_abroad})", :service_category_id => _sc_mgf_europe_internet_abroad}

cat << {:id => _sc_mgf_popular_countries_internet_abroad, :name => 'Страны Европы Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_popular_countries_internet_abroad * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_popular_countries_internet_abroad})", :service_category_id => _sc_mgf_popular_countries_internet_abroad}

cat << {:id => _sc_mgf_other_countries_internet_abroad, :name => 'Страны Европы Мегафона', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_other_countries_internet_abroad * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_other_countries_internet_abroad})", :service_category_id => _sc_mgf_other_countries_internet_abroad}

cat << {:id => _sc_mgf_countries_vacation_online, :name => 'Страны Мегафона для опции Отпуск онлайн', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_countries_vacation_online * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_countries_vacation_online})", :service_category_id => _sc_mgf_countries_vacation_online}

cat << {:id => _sc_mgf_around_world_countries_1, :name => 'Страны Мегафона для Вокруг света 1', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_around_world_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_around_world_countries_1})", :service_category_id => _sc_mgf_around_world_countries_1}

cat << {:id => _sc_mgf_around_world_countries_2, :name => 'Страны Мегафона для Вокруг света 2', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_around_world_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_around_world_countries_2})", :service_category_id => _sc_mgf_around_world_countries_2}

cat << {:id => _sc_mgf_around_world_countries_3, :name => 'Страны Мегафона для Вокруг света 3', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_around_world_countries_3 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_around_world_countries_3})", :service_category_id => _sc_mgf_around_world_countries_3}

cat << {:id => _sc_mgf_around_world_countries_4, :name => 'Страны Мегафона для Вокруг света 4', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_around_world_countries_4 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_around_world_countries_4})", :service_category_id => _sc_mgf_around_world_countries_4}

cat << {:id => _sc_mgf_around_world_countries_5, :name => 'Страны Мегафона для Вокруг света 5', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_around_world_countries_5 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_around_world_countries_5})", :service_category_id => _sc_mgf_around_world_countries_5}

cat << {:id => _sc_mgf_discount_on_calls_to_russia_and_all_incoming, :name => 'Страны Мегафона для Вокруг света 5', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mgf_discount_on_calls_to_russia_and_all_incoming * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mgf_discount_on_calls_to_russia_and_all_incoming})", :service_category_id => _sc_mgf_discount_on_calls_to_russia_and_all_incoming}


cat << {:id => _sc_bln_sic, :name => 'Страны СНГ Билайна', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_sic * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_bln_sic})", :service_category_id => _sc_bln_sic}

cat << {:id => _sc_bln_other_world, :name => 'Страны мира Билайна (кроме СНГ и России)', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_other_world * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_bln_other_world})", :service_category_id => _sc_bln_other_world}

cat << {:id => _sc_bln_my_planet_groups_1, :name => 'Страны Билайна для "Моя Планета", Европа, СНГ и популярные страны', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_my_planet_groups_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_my_planet_groups_1})", :service_category_id => _sc_bln_my_planet_groups_1}

cat << {:id => _sc_bln_my_planet_groups_2, :name => 'Страны Билайна для "Моя Планета", остальные страны ', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_my_planet_groups_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_my_planet_groups_2})", :service_category_id => _sc_bln_my_planet_groups_2}

cat << {:id => _sc_bln_calls_to_other_countries_1, :name => 'Страны Билайна для "Мои звонки в другие страны", СНГ (Абхазия, Армения, Грузия, Южная Осетия, Казахстан, Киргизия, Таджикистан, Туркменистан, Узбекистан, Украина)', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_calls_to_other_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_calls_to_other_countries_1})", :service_category_id => _sc_bln_calls_to_other_countries_1}

cat << {:id => _sc_bln_calls_to_other_countries_2, :name => 'Страны Билайна для "Мои звонки в другие страны", Европа, США, Канада, Белоруссия, Азербайджан, Молдова, Турция, Китай', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_calls_to_other_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_calls_to_other_countries_2})", :service_category_id => _sc_bln_calls_to_other_countries_2}

cat << {:id => _sc_bln_calls_to_other_countries_3, :name => 'Страны Билайна для "Мои звонки в другие страны", остальные страны', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_calls_to_other_countries_3 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_calls_to_other_countries_3})", :service_category_id => _sc_bln_calls_to_other_countries_3}

cat << {:id => _sc_bln_the_best_internet_in_rouming_groups_1, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", Европа, СНГ и популярные страны', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_the_best_internet_in_rouming_groups_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_the_best_internet_in_rouming_groups_1})", :service_category_id => _sc_bln_the_best_internet_in_rouming_groups_1}

cat << {:id => _sc_bln_the_best_internet_in_rouming_groups_2, :name => 'Страны Билайна для "Самый выгодный интернет в роуминге", остальные страны', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_bln_the_best_internet_in_rouming_groups_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_sc_bln_the_best_internet_in_rouming_groups_2})", :service_category_id => _sc_bln_the_best_internet_in_rouming_groups_2}



#география услуг
cat << {:id => _geography_services, :name => 'география услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_region, :name => 'услуги в свой регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_region * 10 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_region}

cat << {:id => _service_to_home_region, :name => 'услуги в домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_home_region * 10 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_home_region}

cat << {:id => _service_to_own_and_home_regions, :name => 'услуги в свой и домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_and_home_regions * 10, :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _service_to_own_and_home_regions}

cat << {:id => _service_to_all_own_country_regions, :name => 'услуги во все регионы страны', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_all_own_country_regions * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_all_own_country_regions}

cat << {:id => _service_to_rouming_region, :name => 'услуги в регион нахождения (роуминга)', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_rouming_region * 10, :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_region_id, :value => nil, :service_category_id => _service_to_rouming_region}

cat << {:id => _service_to_not_own_and_home_region, :name => 'услуги не в свой и  домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_not_own_and_home_region * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_not_own_and_home_region}
  crit << {:id => _service_to_not_own_and_home_region * 10 + 1 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _service_to_not_own_and_home_region}


#TODO исправить плохой критерий 1030
cat << {:id => _service_to_own_country, :name => 'услуги в свою страну', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => _service_to_own_country * 10 + 1 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => _service_to_own_country * 10 + 2 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_own_country}

cat << {:id => _service_to_group_of_countries, :name => 'услуги в группу стран', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
cat << {:id => _service_to_not_own_country, :name => 'услуги за пределы страны', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_not_own_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_not_own_country}

cat << {:id => _service_to_mts_europe, :name => 'услуги в Европу МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_europe * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _service_to_mts_europe}

cat << {:id => _service_to_mts_sic, :name => 'услуги в СНГ МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _service_to_mts_sic}

cat << {:id => _service_to_mts_other_countries, :name => 'услуги в прочие страны МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_other_countries * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _service_to_mts_other_countries}


cat << {:id => _sc_service_to_russia, :name => 'услуги в Россию', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_russia * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_russia}

cat << {:id => _sc_service_to_rouming_country, :name => 'услуги в страну нахождения (роуминга)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_rouming_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_rouming_country}
  crit << {:id => _sc_service_to_rouming_country * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_rouming_country}

cat << {:id => _sc_service_to_not_rouming_not_russia, :name => 'услуги за пределы России и страны нахождения (роуминга)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_not_rouming_not_russia * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia}
  crit << {:id => _sc_service_to_not_rouming_not_russia * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia}

cat << {:id => _sc_service_not_rouming_not_russia_to_sic, :name => 'услуги в СНГ', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 + 2 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_not_rouming_not_russia_to_sic}

cat << {:id => _sc_service_to_not_rouming_not_russia_not_sic, :name => 'услуги за пределы России, СНГ и страны нахождения (роуминга)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 + 2 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}

cat << {:id => _sc_service_to_mts_love_countries_4_9, :name => 'услуги в 1-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_4_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_4_9})", :service_category_id => _sc_service_to_mts_love_countries_4_9}

cat << {:id => _sc_service_to_mts_love_countries_5_5, :name => 'услуги в 2-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_5_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_5_5})", :service_category_id => _sc_service_to_mts_love_countries_5_5}

cat << {:id => _sc_service_to_mts_love_countries_5_9, :name => 'услуги в 3-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_5_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_5_9})", :service_category_id => _sc_service_to_mts_love_countries_5_9}

cat << {:id => _sc_service_to_mts_love_countries_6_9, :name => 'услуги в 4-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_6_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_6_9})", :service_category_id => _sc_service_to_mts_love_countries_6_9}

cat << {:id => _sc_service_to_mts_love_countries_7_9, :name => 'услуги в 5-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_7_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_7_9})", :service_category_id => _sc_service_to_mts_love_countries_7_9}

cat << {:id => _sc_service_to_mts_love_countries_8_9, :name => 'услуги в 6-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_8_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_8_9})", :service_category_id => _sc_service_to_mts_love_countries_8_9}

cat << {:id => _sc_service_to_mts_love_countries_9_9, :name => 'услуги в 7-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_9_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_9_9})", :service_category_id => _sc_service_to_mts_love_countries_9_9}

cat << {:id => _sc_service_to_mts_love_countries_11_5, :name => 'услуги в 8-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_11_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_11_5})", :service_category_id => _sc_service_to_mts_love_countries_11_5}

cat << {:id => _sc_service_to_mts_love_countries_12_9, :name => 'услуги в 9-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_12_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_12_9})", :service_category_id => _sc_service_to_mts_love_countries_12_9}

cat << {:id => _sc_service_to_mts_love_countries_14_9, :name => 'услуги в 10-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_14_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_14_9})", :service_category_id => _sc_service_to_mts_love_countries_14_9}

cat << {:id => _sc_service_to_mts_love_countries_19_9, :name => 'услуги в 11-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_19_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_19_9})", :service_category_id => _sc_service_to_mts_love_countries_19_9}

cat << {:id => _sc_service_to_mts_love_countries_29_9, :name => 'услуги в 12-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_29_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_29_9})", :service_category_id => _sc_service_to_mts_love_countries_29_9}

cat << {:id => _sc_service_to_mts_love_countries_49_9, :name => 'услуги в 13-ю любимую группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_49_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_49_9})", :service_category_id => _sc_service_to_mts_love_countries_49_9}

cat << {:id => _sc_service_to_mts_your_country_1, :name => 'услуги в твою 1-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_1})", :service_category_id => _sc_service_to_mts_your_country_1}

cat << {:id => _sc_service_to_mts_your_country_2, :name => 'услуги в твою 2-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_2})", :service_category_id => _sc_service_to_mts_your_country_2}

cat << {:id => _sc_service_to_mts_your_country_3, :name => 'услуги в твою 3-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_3})", :service_category_id => _sc_service_to_mts_your_country_3}

cat << {:id => _sc_service_to_mts_your_country_4, :name => 'услуги в твою 4-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_4})", :service_category_id => _sc_service_to_mts_your_country_4}

cat << {:id => _sc_service_to_mts_your_country_5, :name => 'услуги в твою 5-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_5})", :service_category_id => _sc_service_to_mts_your_country_5}

cat << {:id => _sc_service_to_mts_your_country_6, :name => 'услуги в твою 6-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_6})", :service_category_id => _sc_service_to_mts_your_country_6}

cat << {:id => _sc_service_to_mts_your_country_7, :name => 'услуги в твою 7-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_7 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_7})", :service_category_id => _sc_service_to_mts_your_country_7}

cat << {:id => _sc_service_to_mts_your_country_8, :name => 'услуги в твою 8-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_8 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_8})", :service_category_id => _sc_service_to_mts_your_country_8}

cat << {:id => _sc_service_to_mts_your_country_9, :name => 'услуги в твою 9-ю группу стран МТС', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_9})", :service_category_id => _sc_service_to_mts_your_country_9}


cat << {:id => _sc_service_to_mgf_sms_sic_plus, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_sms_sic_plus * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_sms_sic_plus})", :service_category_id => _sc_service_to_mgf_sms_sic_plus}

cat << {:id => _sc_service_to_mgf_sms_other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_sms_other_countries * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_sms_other_countries})", :service_category_id => _sc_service_to_mgf_sms_other_countries}

cat << {:id => _sc_service_to_mgf_country_group_1, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_country_group_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_country_group_1})", :service_category_id => _sc_service_to_mgf_country_group_1}

cat << {:id => _sc_service_to_mgf_country_group_2, :name => 'Мегафон, услуги в Европу (вкл. Турцию, Израиль), США, Канада', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_country_group_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_country_group_2})", :service_category_id => _sc_service_to_mgf_country_group_2}

cat << {:id => _sc_service_to_mgf_country_group_3, :name => 'Мегафон, услуги в Австралию и Океанию', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_country_group_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_country_group_3})", :service_category_id => _sc_service_to_mgf_country_group_3}

cat << {:id => _sc_service_to_mgf_country_group_4, :name => 'Мегафон, услуги в Азию', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_country_group_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_country_group_4})", :service_category_id => _sc_service_to_mgf_country_group_4}

cat << {:id => _sc_service_to_mgf_country_group_5, :name => 'Мегафон, услуги в остальные  страны', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_country_group_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_country_group_5})", :service_category_id => _sc_service_to_mgf_country_group_5}


cat << {:id => _sc_service_to_mgf_warm_welcome_plus_1, :name => 'Мегафон, услуги в Таджикистан', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_1})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_1}

cat << {:id => _sc_service_to_mgf_warm_welcome_plus_2, :name => 'Мегафон, услуги в Украину', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_2})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_2}

cat << {:id => _sc_service_to_mgf_warm_welcome_plus_3, :name => 'Мегафон, услуги на номера Абхазии, Грузии, Казахстана, Кыргызстана,Туркменистана, Узбекистана, Южной Осетии', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_3})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_3}

cat << {:id => _sc_service_to_mgf_warm_welcome_plus_4, :name => 'Мегафон, услуги в Армению', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_4})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_4}

cat << {:id => _sc_service_to_mgf_warm_welcome_plus_5, :name => 'Мегафон, услуги на номера Азербайджана, Беларуси', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_5})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_5}

cat << {:id => _sc_service_to_mgf_warm_welcome_plus_6, :name => 'Мегафон, услуги в Молдову', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_warm_welcome_plus_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_warm_welcome_plus_6})", :service_category_id => _sc_service_to_mgf_warm_welcome_plus_6}


cat << {:id => _sc_service_to_mgf_international_1, :name => 'Мегафон, услуги СНГ, Абхазия, Грузия и Южная Осетия', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_international_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_international_1})", :service_category_id => _sc_service_to_mgf_international_1}

cat << {:id => _sc_service_to_mgf_international_2, :name => 'Мегафон, услуги Азия, Европа', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_international_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_international_2})", :service_category_id => _sc_service_to_mgf_international_2}

cat << {:id => _sc_service_to_mgf_international_3, :name => 'Мегафон, услуги США, Канада', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_international_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_international_3})", :service_category_id => _sc_service_to_mgf_international_3}

cat << {:id => _sc_service_to_mgf_international_4, :name => 'Мегафон, услуги Другие страны - 1', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_international_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_international_4})", :service_category_id => _sc_service_to_mgf_international_4}

cat << {:id => _sc_service_to_mgf_international_5, :name => 'Мегафон, услуги Другие страны - 2', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_international_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_international_5})", :service_category_id => _sc_service_to_mgf_international_5}


cat << {:id => _sc_service_to_mgf_call_to_all_country_1, :name => 'Мегафон, опция Звони во все страны - 1 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_1})", :service_category_id => _sc_service_to_mgf_call_to_all_country_1}

cat << {:id => _sc_service_to_mgf_call_to_all_country_3_5, :name => 'Мегафон, опция Звони во все страны - 3.5 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_3_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_3_5})", :service_category_id => _sc_service_to_mgf_call_to_all_country_3_5}

cat << {:id => _sc_service_to_mgf_call_to_all_country_4, :name => 'Мегафон, опция Звони во все страны - 4 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_4})", :service_category_id => _sc_service_to_mgf_call_to_all_country_4}

cat << {:id => _sc_service_to_mgf_call_to_all_country_4_5, :name => 'Мегафон, опция Звони во все страны - 4.5 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_4_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_4_5})", :service_category_id => _sc_service_to_mgf_call_to_all_country_4_5}

cat << {:id => _sc_service_to_mgf_call_to_all_country_5, :name => 'Мегафон, опция Звони во все страны - 5 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_5})", :service_category_id => _sc_service_to_mgf_call_to_all_country_5}

cat << {:id => _sc_service_to_mgf_call_to_all_country_6, :name => 'Мегафон, опция Звони во все страны - 6 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_6})", :service_category_id => _sc_service_to_mgf_call_to_all_country_6}

cat << {:id => _sc_service_to_mgf_call_to_all_country_7, :name => 'Мегафон, опция Звони во все страны - 7 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_7 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_7})", :service_category_id => _sc_service_to_mgf_call_to_all_country_7}

cat << {:id => _sc_service_to_mgf_call_to_all_country_8, :name => 'Мегафон, опция Звони во все страны - 8 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_8 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_8})", :service_category_id => _sc_service_to_mgf_call_to_all_country_8}

cat << {:id => _sc_service_to_mgf_call_to_all_country_9, :name => 'Мегафон, опция Звони во все страны - 9 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_9})", :service_category_id => _sc_service_to_mgf_call_to_all_country_9}

cat << {:id => _sc_service_to_mgf_call_to_all_country_10, :name => 'Мегафон, опция Звони во все страны - 10 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_10 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_10})", :service_category_id => _sc_service_to_mgf_call_to_all_country_10}

cat << {:id => _sc_service_to_mgf_call_to_all_country_11, :name => 'Мегафон, опция Звони во все страны - 1 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_11 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_11})", :service_category_id => _sc_service_to_mgf_call_to_all_country_11}

cat << {:id => _sc_service_to_mgf_call_to_all_country_12, :name => 'Мегафон, опция Звони во все страны - 12 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_12 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_12})", :service_category_id => _sc_service_to_mgf_call_to_all_country_12}

cat << {:id => _sc_service_to_mgf_call_to_all_country_13, :name => 'Мегафон, опция Звони во все страны - 13 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_13 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_13})", :service_category_id => _sc_service_to_mgf_call_to_all_country_13}

cat << {:id => _sc_service_to_mgf_call_to_all_country_14, :name => 'Мегафон, опция Звони во все страны - 14 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_14 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_14})", :service_category_id => _sc_service_to_mgf_call_to_all_country_14}

cat << {:id => _sc_service_to_mgf_call_to_all_country_15, :name => 'Мегафон, опция Звони во все страны - 15 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_15 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_15})", :service_category_id => _sc_service_to_mgf_call_to_all_country_15}

cat << {:id => _sc_service_to_mgf_call_to_all_country_16, :name => 'Мегафон, опция Звони во все страны - 16 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_16 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_16})", :service_category_id => _sc_service_to_mgf_call_to_all_country_16}

cat << {:id => _sc_service_to_mgf_call_to_all_country_17, :name => 'Мегафон, опция Звони во все страны - 17 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_17 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_17})", :service_category_id => _sc_service_to_mgf_call_to_all_country_17}

cat << {:id => _sc_service_to_mgf_call_to_all_country_18, :name => 'Мегафон, опция Звони во все страны - 18 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_18 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_18})", :service_category_id => _sc_service_to_mgf_call_to_all_country_18}

cat << {:id => _sc_service_to_mgf_call_to_all_country_19, :name => 'Мегафон, опция Звони во все страны - 19 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_19 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_19})", :service_category_id => _sc_service_to_mgf_call_to_all_country_19}

cat << {:id => _sc_service_to_mgf_call_to_all_country_20, :name => 'Мегафон, опция Звони во все страны - 20 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_20 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_20})", :service_category_id => _sc_service_to_mgf_call_to_all_country_20}

cat << {:id => _sc_service_to_mgf_call_to_all_country_23, :name => 'Мегафон, опция Звони во все страны - 23 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_23 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_23})", :service_category_id => _sc_service_to_mgf_call_to_all_country_23}

cat << {:id => _sc_service_to_mgf_call_to_all_country_30, :name => 'Мегафон, опция Звони во все страны - 30 руб', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mgf_call_to_all_country_30 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_mgf_call_to_all_country_30})", :service_category_id => _sc_service_to_mgf_call_to_all_country_30}


cat << {:id => _sc_service_to_bln_international_1, :name => 'Билайн, услуги СНГ, Грузия телефоны Билалайн', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_1})", :service_category_id => _sc_service_to_bln_international_1}

cat << {:id => _sc_service_to_bln_international_2, :name => 'Билайн, услуги СНГ, Абхазия, Грузия и Южная Осетия на прочие телефоны', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_2})", :service_category_id => _sc_service_to_bln_international_2}

cat << {:id => _sc_service_to_bln_international_3, :name => 'Билайн, услуги в Европу, США, Канаду', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_3})", :service_category_id => _sc_service_to_bln_international_3}

cat << {:id => _sc_service_to_bln_international_4, :name => 'Билайн, услуги Северная и Центральная Америка (без США и Канады)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_4})", :service_category_id => _sc_service_to_bln_international_4}

cat << {:id => _sc_service_to_bln_international_5, :name => 'Билайн, услуги в остальные страны - 1', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_5})", :service_category_id => _sc_service_to_bln_international_5}

cat << {:id => _sc_service_to_bln_international_6, :name => 'Билайн, услуги в остальные страны - 2', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_6})", :service_category_id => _sc_service_to_bln_international_6}

cat << {:id => _sc_service_to_bln_international_7, :name => 'Билайн, услуги на другие телефоны стран СНГ (кроме Азербайджана, Беларуси и Молдовы), Грузии, Абхазии, Южной Осетии', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_7 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_7})", :service_category_id => _sc_service_to_bln_international_7}

cat << {:id => _sc_service_to_bln_international_8, :name => 'Билайн, услуги на другие телефоны стран СНГ (кроме Азербайджана, Беларуси), Грузии, Абхазии, Южной Осетии', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_8 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_8})", :service_category_id => _sc_service_to_bln_international_8}

cat << {:id => _sc_service_to_bln_international_9, :name => 'Билайн, услуги Азербайджан, Беларусия', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_9})", :service_category_id => _sc_service_to_bln_international_9}

cat << {:id => _sc_service_to_bln_international_10, :name => 'Билайн, услуги в Северную и Центральную Америку (кроме стран США, Канада, Куба, Багамские острова, Барбадос)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_10 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_10})", :service_category_id => _sc_service_to_bln_international_10}

cat << {:id => _sc_service_to_bln_international_11, :name => 'Билайн, услуги в остальные страны (кроме стран Мальдивы, Мадагаскар, Бурунди, КНДР, Папуа-Новая Гвинея, Сейшельские острова, Сомали, Токелау, Тунис)', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_11 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_11})", :service_category_id => _sc_service_to_bln_international_11}

cat << {:id => _sc_service_to_bln_international_12, :name => 'Билайн, услуги на Кубу, Багамские острова, Барбадос', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_12 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_12})", :service_category_id => _sc_service_to_bln_international_12}

cat << {:id => _sc_service_to_bln_international_13, :name => 'Билайн, услуги в страны кроме России и СНГ', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_international_13 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_international_13})", :service_category_id => _sc_service_to_bln_international_13}



cat << {:id => _sc_service_to_bln_welcome_1, :name => 'Билайн, услуги по тарифу Добро пожаловать, Таджикистан', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_1})", :service_category_id => _sc_service_to_bln_welcome_1}

cat << {:id => _sc_service_to_bln_welcome_2, :name => 'Билайн, услуги по тарифу Добро пожаловать, Армения', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_2})", :service_category_id => _sc_service_to_bln_welcome_2}

cat << {:id => _sc_service_to_bln_welcome_3, :name => 'Билайн, услуги по тарифу Добро пожаловать, Украина', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_3})", :service_category_id => _sc_service_to_bln_welcome_3}

cat << {:id => _sc_service_to_bln_welcome_4, :name => 'Билайн, услуги по тарифу Добро пожаловать, Грузия, Казахстан, Кыргызстан, Узбекистан', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_4})", :service_category_id => _sc_service_to_bln_welcome_4}

cat << {:id => _sc_service_to_bln_welcome_5, :name => 'Билайн, услуги по тарифу Добро пожаловать, Туркменистан, Абхазия, Южная Осетия', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_5})", :service_category_id => _sc_service_to_bln_welcome_5}

cat << {:id => _sc_service_to_bln_welcome_6, :name => 'Билайн, услуги по тарифу Добро пожаловать, Молдова', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_6})", :service_category_id => _sc_service_to_bln_welcome_6}

cat << {:id => _sc_service_to_bln_welcome_7, :name => 'Билайн, услуги по тарифу Добро пожаловать, Беларусь, Азербайджан', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_7 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_7})", :service_category_id => _sc_service_to_bln_welcome_7}

cat << {:id => _sc_service_to_bln_welcome_8, :name => 'Билайн, услуги по тарифу Добро пожаловать, Вьетнам', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_8 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_8})", :service_category_id => _sc_service_to_bln_welcome_8}

cat << {:id => _sc_service_to_bln_welcome_9, :name => 'Билайн, услуги по тарифу Добро пожаловать, Китай', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_9})", :service_category_id => _sc_service_to_bln_welcome_9}

cat << {:id => _sc_service_to_bln_welcome_10, :name => 'Билайн, услуги по тарифу Добро пожаловать, Индия, Южная Корея', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_10 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_10})", :service_category_id => _sc_service_to_bln_welcome_10}

cat << {:id => _sc_service_to_bln_welcome_11, :name => 'Билайн, услуги по тарифу Добро пожаловать, Турция', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_bln_welcome_11 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_service_to_bln_welcome_11})", :service_category_id => _sc_service_to_bln_welcome_11}




#оператор второй стороны
cat << {:id => _partner_operator_services, :name => 'оператор второй стороны', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_operator, :name => 'свой оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_own_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_own_operator}

cat << {:id => _service_to_not_own_operator, :name => 'не свой оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_not_own_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_not_own_operator}

cat << {:id => _service_to_other_operator, :name => 'другой мобильный оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_other_operator * 10 + 0 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_other_operator}
  crit << {:id => _service_to_other_operator * 10 + 1 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _mobile}, :service_category_id => _service_to_other_operator}

cat << {:id => _service_to_fixed_line, :name => 'оператор фиксированной связи', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_fixed_line * 10 + 0 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_fixed_line}
  crit << {:id => _service_to_fixed_line * 10 + 1 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _fixed_line}, :service_category_id => _service_to_fixed_line}

cat << {:id => _service_to_bln_partner_operator, :name => 'партнер оператора', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_bln_partner_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_partner_groups_by_group_id(#{_relation_service_to_bln_partner_operators})", :service_category_id => _service_to_bln_partner_operator}

cat << {:id => _service_to_not_bln_partner_operator, :name => 'партнер оператора', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_not_bln_partner_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_partner_groups_by_group_id(#{_relation_service_to_bln_partner_operators})", :service_category_id => _service_to_not_bln_partner_operator}

#TODO Пока не использовать
cat << {:id => _service_to_russian_operators, :name => 'Операторы России', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_russian_operators * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_partner_groups_by_group_id(#{_relation_service_to_russian_operators_group})", :service_category_id => _service_to_russian_operators}

#TODO Пока не использовать
cat << {:id => _service_to_sic_operators, :name => 'Операторы СНГ', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_sic_operators * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_partner_groups_by_group_id(#{_relation_service_to_sic_operators_group})", :service_category_id => _service_to_sic_operators}

#TODO Пока не использовать
cat << {:id => _service_to_other_operators, :name => 'Операторы других стран', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_other_operators * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_partner_groups_by_group_id(#{_relation_service_to_other_operators_group})", :service_category_id => _service_to_other_operators}


#виды услуг
cat << {:id => _sc_tarif_service, :name => 'виды услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _sc_onetime, :name => 'разовые', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}
cat << {:id => _tarif_switch_on, :name => 'подключение тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
#TODO откорректировать
  crit << {:id => _tarif_switch_on * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _one_time, :service_category_id => _tarif_switch_on}
           
cat << {:id => 203, :name => 'смена тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 204, :name => 'отключение тарифа', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 205, :name => 'подключение услуги', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 206, :name => 'отключение услуги', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 207, :name => 'подключение опции', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 208, :name => 'отключение опции', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 209, :name => 'смена номера', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 210, :name => 'смена оператора', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 211, :name => 'смена региона', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 212, :name => 'федеральный номер', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 213, :name => 'локальный номер', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 214, :name => 'регулярный отчет об операциях', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 215, :name => 'отчет об операциях по запросу', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 216, :name => 'доступ в личный интернет кабинет', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}
cat << {:id => 217, :name => 'доступ в личный мобильный кабинет', :type_id => _common, :parent_id => _sc_onetime, :level => 2, :path => [_sc_tarif_service, _sc_onetime]}

cat << {:id => _sc_periodic, :name => 'периодические', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}
cat << {:id => _periodic_monthly_fee, :name => 'месячная абонентская плата', :type_id => _common, :parent_id => _sc_periodic, :level => 2, :path => [_sc_tarif_service, _sc_periodic]}
#TODO откорректировать
  crit << {:id => _periodic_monthly_fee * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_monthly_fee}
cat << {:id => _periodic_day_fee, :name => 'ежедневная плата', :type_id => _common, :parent_id => _sc_periodic, :level => 2, :path => [_sc_tarif_service, _sc_periodic]}
#TODO откорректировать
  crit << {:id => _periodic_day_fee * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _periodic, :service_category_id => _periodic_day_fee}

cat << {:id => _sc_phone_service, :name => 'телефонные', :type_id => _common, :parent_id => _sc_tarif_service, :level => 1, :path => [_sc_tarif_service]}
cat << {:id => _sc_calls, :name => 'звонки', :type_id => _common, :parent_id => _sc_phone_service, :level => 2, :path => [_sc_tarif_service, _sc_phone_service]}
  crit << {:id => _sc_calls * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _calls, :service_category_id => _sc_calls}

cat << {:id => _calls_in, :name => 'входящие звонки', :type_id => _common, :parent_id => _sc_calls, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_calls]}
  crit << {:id => _calls_in * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => _calls_in}

cat << {:id => _calls_out, :name => 'исходящие звонки', :type_id => _common, :parent_id => _sc_calls, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_calls]}
  crit << {:id => _calls_out * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => _calls_out}

cat << {:id => _sc_sms, :name => 'смс', :type_id => _common, :parent_id => _sc_phone_service, :level => 2, :path => [_sc_tarif_service, _sc_phone_service]}
  crit << {:id => _sc_sms * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _sms, :service_category_id => _sc_sms}

cat << {:id => _sms_in, :name => 'входящие смс', :type_id => _common, :parent_id => _sc_sms, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_sms]}
  crit << {:id => _sms_in * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => _sms_in}

cat << {:id => _sms_out, :name => 'исходящие смс', :type_id => _common, :parent_id => _sc_sms, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_sms]}
  crit << {:id => _sms_out * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => _sms_out}

cat << {:id => _sc_mms, :name => 'ммс', :type_id => _common, :parent_id => _sc_phone_service, :level => 2, :path => [_sc_tarif_service, _sc_phone_service]}
  crit << {:id => _sc_mms * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _mms, :service_category_id => _sc_mms}

cat << {:id => _mms_in, :name => 'входящие ммс', :type_id => _common, :parent_id => _sc_mms, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mms]}
  crit << {:id => _mms_in * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _inbound, :service_category_id => _mms_in}

cat << {:id => _mms_out, :name => 'исходящие ммс', :type_id => _common, :parent_id => _sc_mms, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mms]}
  crit << {:id => _mms_out * 10 , :criteria_param_id => _call_base_sub_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _outbound, :service_category_id => _mms_out}

cat << {:id => _sc_mobile_connection, :name => 'мобильные подключения', :type_id => _common, :parent_id => _sc_phone_service, :level => 2, :path => [_sc_tarif_service, _sc_phone_service]}

cat << {:id => _internet, :name => 'интернет', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _internet * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => [_3g, _4g], :service_category_id => _internet}

cat << {:id => _wap_internet, :name => 'wap', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _wap_internet * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _wap, :service_category_id => _wap_internet}

cat << {:id => _gprs, :name => 'gprs', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _gprs * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _2g, :service_category_id => _gprs}



Service::Category.delete_all; Service::Criterium.delete_all;

ActiveRecord::Base.transaction do
  Service::Category.create(cat)
  Service::Criterium.create(crit)

#  Service::Category.batch_save(cat, {}) #create(cat)
#  Service::Criterium.batch_save(crit, {}) #create(crit)
end
