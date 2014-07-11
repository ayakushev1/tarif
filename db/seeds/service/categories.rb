Service::Category.delete_all; Service::Criterium.delete_all;
cat = []; crit = [];
#роуминг
cat << {:id => _category_rouming, :name => 'роуминг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}

cat << {:id => _all_russia_rouming, :name => 'роуминг Вся Россия', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => _all_russia_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _all_russia_rouming}


cat << {:id => _intra_net_rouming, :name => 'внутрисетевой роуминг', :type_id => _common, :parent_id => _category_rouming, :level => 1, :path => [_category_rouming]}
  crit << {:id => _intra_net_rouming * 10 , :criteria_param_id => _call_connect_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _intra_net_rouming}

cat << {:id => _own_region_rouming, :name => 'свой регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_region_rouming * 10 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_region_rouming}

cat << {:id => _home_region_rouming, :name => 'домашний регион', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _home_region_rouming * 10 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _home_region_rouming}

cat << {:id => _own_and_home_regions_rouming, :name => '_own_and_home_regions_rouming', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_and_home_regions_rouming * 10 + 0 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _own_and_home_regions_rouming}

cat << {:id => _own_country_rouming, :name => 'своя страна', :type_id => _common, :parent_id => _intra_net_rouming, :level => 2, :path => [_category_rouming, _intra_net_rouming]}
  crit << {:id => _own_country_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => _own_country_rouming * 10 + 1 , :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _own_country_rouming}
  crit << {:id => _own_country_rouming * 10 + 2, :criteria_param_id => _call_connect_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _own_country_rouming}

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

cat << {:id => _sc_mts_europe_rouming, :name => '_sc_mts_europe_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_europe_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _sc_mts_europe_rouming}

cat << {:id => _sc_mts_sic_rouming, :name => '_sc_mts_sic_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_mts_sic_rouming}

cat << {:id => _sc_mts_sic_1_rouming, :name => '_sc_mts_sic_1_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_1_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_1_countries})", :service_category_id => _sc_mts_sic_1_rouming}

cat << {:id => _sc_mts_sic_2_rouming, :name => '_sc_mts_sic_2_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_countries})", :service_category_id => _sc_mts_sic_2_rouming}

cat << {:id => _sc_mts_sic_2_1_rouming, :name => '_sc_mts_sic_2_1_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_1_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_1_countries})", :service_category_id => _sc_mts_sic_2_1_rouming}

cat << {:id => _sc_mts_sic_2_2_rouming, :name => '_sc_mts_sic_2_2_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_2_2_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_2_2_countries})", :service_category_id => _sc_mts_sic_2_2_rouming}

cat << {:id => _sc_mts_sic_3_rouming, :name => '_sc_mts_sic_3_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_sic_3_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_3_countries})", :service_category_id => _sc_mts_sic_3_rouming}

cat << {:id => _sc_mts_other_countries_rouming, :name => '_sc_mts_other_countries_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_other_countries_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _sc_mts_other_countries_rouming}

cat << {:id => _sc_lithuania_and_latvia_rouming, :name => '_sc_lithuania_and_latvia_rouming', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_lithuania_and_latvia_rouming * 10 , :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => [_lithuania, _latvia], :service_category_id => _sc_lithuania_and_latvia_rouming}

cat << {:id => _sc_mts_rouming_in_11_9_option_countries_1, :name => '_sc_mts_rouming_in_11_9_option_countries_1', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_11_9_option_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_calls_from_11_9_option_countries_1})", :service_category_id => _sc_mts_rouming_in_11_9_option_countries_1}

cat << {:id => _sc_mts_rouming_in_11_9_option_countries_2, :name => '_sc_mts_rouming_in_11_9_option_countries_2', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_11_9_option_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_calls_from_11_9_option_countries_2})", :service_category_id => _sc_mts_rouming_in_11_9_option_countries_2}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_1, :name => '_sc_mts_rouming_in_bit_abrod_option_countries_1', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_1 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_1})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_1}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_2, :name => '_sc_mts_rouming_in_bit_abrod_option_countries_2', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_2 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_2})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_2}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_3, :name => '_sc_mts_rouming_in_bit_abrod_option_countries_3', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_3 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_3})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_3}

cat << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_4, :name => '_sc_mts_rouming_in_bit_abrod_option_countries_4', :type_id => _common, :parent_id => _all_world_rouming, :level => 3, :path => [_category_rouming, _sc_other_operator_rouming, _all_world_rouming]}
  crit << {:id => _sc_mts_rouming_in_bit_abrod_option_countries_4 * 10, :criteria_param_id => _call_connect_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_internet_bit_abrod_4})", :service_category_id => _sc_mts_rouming_in_bit_abrod_option_countries_4}

#география услуг
cat << {:id => _geography_services, :name => 'география услуг', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_region, :name => 'услуги в свой регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_region * 10 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_region}

cat << {:id => _service_to_home_region, :name => 'услуги в домашний регион', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_home_region * 10 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_home_region}

cat << {:id => _service_to_own_and_home_regions, :name => '_service_to_own_and_home_regions', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_and_home_regions * 10, :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_own_and_home_region_ids, :value => nil, :service_category_id => _service_to_own_and_home_regions}

cat << {:id => _service_to_all_own_country_regions, :name => '_service_to_all_own_country_regions', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_all_own_country_regions * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_all_own_country_regions}

cat << {:id => _service_to_rouming_region, :name => '_service_to_rouming_region', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_rouming_region * 10, :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_region_id, :value => nil, :service_category_id => _service_to_rouming_region}

#TODO исправить плохой критерий 1030
cat << {:id => _service_to_own_country, :name => 'услуги в свою страну', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
  crit << {:id => _service_to_own_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => _service_to_own_country * 10 + 1 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_region_id, :value => nil, :service_category_id => _service_to_own_country}
  crit << {:id => _service_to_own_country * 10 + 2 , :criteria_param_id => _call_partner_phone_region_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_home_region_ids, :value => nil, :service_category_id => _service_to_own_country}

cat << {:id => _service_to_group_of_countries, :name => 'услуги в группу стран', :type_id => _common, :parent_id => _geography_services, :level => 1, :path => [_geography_services]}
cat << {:id => _service_to_not_own_country, :name => 'весь мир', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_not_own_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_country_id, :value => nil, :service_category_id => _service_to_not_own_country}

cat << {:id => _service_to_mts_europe, :name => 'mts Europe', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_europe * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_europe_countries})", :service_category_id => _service_to_mts_europe}
cat << {:id => _service_to_mts_sic, :name => 'mts SIC', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _service_to_mts_sic}
cat << {:id => _service_to_mts_other_countries, :name => 'mts other countries', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _service_to_mts_other_countries * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_other_countries})", :service_category_id => _service_to_mts_other_countries}


cat << {:id => _sc_service_to_russia, :name => '_service_to_russia', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_russia * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_russia}

cat << {:id => _sc_service_to_rouming_country, :name => '_service_to_rouming_country', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_rouming_country * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_rouming_country}

cat << {:id => _sc_service_to_not_rouming_not_russia, :name => '_sc_service_to_not_rouming_not_russia', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_not_rouming_not_russia * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia}
  crit << {:id => _sc_service_to_not_rouming_not_russia * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia}

cat << {:id => _sc_service_not_rouming_not_russia_to_sic, :name => '_sc_service_to_sic_countries', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_not_rouming_not_russia_to_sic}
  crit << {:id => _sc_service_not_rouming_not_russia_to_sic * 10 + 2 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_not_rouming_not_russia_to_sic}

cat << {:id => _sc_service_to_not_rouming_not_russia_not_sic, :name => '_sc_service_to_not_rouming_not_russia_not_sic', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value => _russia, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 + 1 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _value_param_is_criterium_param, 
           :value_param_id => _call_connect_country_id, :value => nil, :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}
  crit << {:id => _sc_service_to_not_rouming_not_russia_not_sic * 10 + 2 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _not_in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_sic_countries})", :service_category_id => _sc_service_to_not_rouming_not_russia_not_sic}

cat << {:id => _sc_service_to_mts_love_countries_4_9, :name => '_sc_service_to_mts_love_countries_4_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_4_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_4_9})", :service_category_id => _sc_service_to_mts_love_countries_4_9}

cat << {:id => _sc_service_to_mts_love_countries_5_5, :name => '_sc_service_to_mts_love_countries_5_5', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_5_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_5_5})", :service_category_id => _sc_service_to_mts_love_countries_5_5}

cat << {:id => _sc_service_to_mts_love_countries_5_9, :name => '_sc_service_to_mts_love_countries_5_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_5_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_5_9})", :service_category_id => _sc_service_to_mts_love_countries_5_9}

cat << {:id => _sc_service_to_mts_love_countries_6_9, :name => '_sc_service_to_mts_love_countries_6_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_6_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_6_9})", :service_category_id => _sc_service_to_mts_love_countries_6_9}

cat << {:id => _sc_service_to_mts_love_countries_7_9, :name => '_sc_service_to_mts_love_countries_7_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_7_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_7_9})", :service_category_id => _sc_service_to_mts_love_countries_7_9}

cat << {:id => _sc_service_to_mts_love_countries_8_9, :name => '_sc_service_to_mts_love_countries_8_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_8_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_8_9})", :service_category_id => _sc_service_to_mts_love_countries_8_9}

cat << {:id => _sc_service_to_mts_love_countries_9_9, :name => '_sc_service_to_mts_love_countries_9_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_9_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_9_9})", :service_category_id => _sc_service_to_mts_love_countries_9_9}

cat << {:id => _sc_service_to_mts_love_countries_11_5, :name => '_sc_service_to_mts_love_countries_11_5', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_11_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_11_5})", :service_category_id => _sc_service_to_mts_love_countries_11_5}

cat << {:id => _sc_service_to_mts_love_countries_12_9, :name => '_sc_service_to_mts_love_countries_12_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_12_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_12_9})", :service_category_id => _sc_service_to_mts_love_countries_12_9}

cat << {:id => _sc_service_to_mts_love_countries_14_9, :name => '_sc_service_to_mts_love_countries_14_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_14_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_14_9})", :service_category_id => _sc_service_to_mts_love_countries_14_9}

cat << {:id => _sc_service_to_mts_love_countries_19_9, :name => '_sc_service_to_mts_love_countries_19_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_19_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_19_9})", :service_category_id => _sc_service_to_mts_love_countries_19_9}

cat << {:id => _sc_service_to_mts_love_countries_29_9, :name => '_sc_service_to_mts_love_countries_29_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_29_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_29_9})", :service_category_id => _sc_service_to_mts_love_countries_29_9}

cat << {:id => _sc_service_to_mts_love_countries_49_9, :name => '_sc_service_to_mts_love_countries_49_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_love_countries_49_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_love_countries_49_9})", :service_category_id => _sc_service_to_mts_love_countries_49_9}

cat << {:id => _sc_service_to_mts_your_country_1, :name => '_sc_service_to_mts_your_country_1', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_1 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_1})", :service_category_id => _sc_service_to_mts_your_country_1}

cat << {:id => _sc_service_to_mts_your_country_2, :name => '_sc_service_to_mts_your_country_2', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_2 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_2})", :service_category_id => _sc_service_to_mts_your_country_2}

cat << {:id => _sc_service_to_mts_your_country_3, :name => '_sc_service_to_mts_your_country_3', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_3 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_3})", :service_category_id => _sc_service_to_mts_your_country_3}

cat << {:id => _sc_service_to_mts_your_country_4, :name => '_sc_service_to_mts_your_country_4', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_4 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_4})", :service_category_id => _sc_service_to_mts_your_country_4}

cat << {:id => _sc_service_to_mts_your_country_5, :name => '_sc_service_to_mts_your_country_5', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_5 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_5})", :service_category_id => _sc_service_to_mts_your_country_5}

cat << {:id => _sc_service_to_mts_your_country_6, :name => '_sc_service_to_mts_your_country_6', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_6 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_6})", :service_category_id => _sc_service_to_mts_your_country_6}

cat << {:id => _sc_service_to_mts_your_country_7, :name => '_sc_service_to_mts_your_country_7', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_7 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_7})", :service_category_id => _sc_service_to_mts_your_country_7}

cat << {:id => _sc_service_to_mts_your_country_8, :name => '_sc_service_to_mts_your_country_8', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_8 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_8})", :service_category_id => _sc_service_to_mts_your_country_8}

cat << {:id => _sc_service_to_mts_your_country_9, :name => '_sc_service_to_mts_your_country_9', :type_id => _common, :parent_id => _service_to_group_of_countries, :level => 2, :path => [_geography_services, _service_to_group_of_countries]}
  crit << {:id => _sc_service_to_mts_your_country_9 * 10 , :criteria_param_id => _call_partner_phone_country_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :eval_string => "Relation.operator_country_groups_by_group_id(#{_relation_mts_your_country_9})", :service_category_id => _sc_service_to_mts_your_country_9}


#оператор второй стороны
cat << {:id => _partner_operator_services, :name => 'оператор второй стороны', :type_id => _common, :parent_id => nil, :level => 0, :path => []}
cat << {:id => _service_to_own_operator, :name => 'свой оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_own_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_own_operator}

cat << {:id => _service_to_not_own_operator, :name => '_service_to_not_own_operator', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_not_own_operator * 10 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_not_own_operator}

cat << {:id => _service_to_other_operator, :name => 'другой мобильный оператор', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_other_operator * 10 + 0 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_other_operator}
  crit << {:id => _service_to_other_operator * 10 + 1 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _mobile}, :service_category_id => _service_to_other_operator}

cat << {:id => _service_to_fixed_line, :name => 'фиксированная линия', :type_id => _common, :parent_id => _partner_operator_services, :level => 1, :path => [_partner_operator_services]}
  crit << {:id => _service_to_fixed_line * 10 + 0 , :criteria_param_id => _call_partner_phone_operator_id, :comparison_operator_id => _not_equal, :value_choose_option_id => _field, 
           :value_param_id => _fq_tarif_operator_id, :value => nil, :service_category_id => _service_to_fixed_line}
  crit << {:id => _service_to_fixed_line * 10 + 1 , :criteria_param_id => _call_partner_phone_operator_type_id, :comparison_operator_id => _equal, :value_choose_option_id => _single_value, 
           :value_param_id => _category_operator_type_id, :value => {:integer => _fixed_line}, :service_category_id => _service_to_fixed_line}


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

cat << {:id => _sc_mobile_connection, :name => 'mobile_connection', :type_id => _common, :parent_id => _sc_phone_service, :level => 2, :path => [_sc_tarif_service, _sc_phone_service]}

cat << {:id => _internet, :name => 'Internet', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _internet * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _in_array, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => [_3g, _4g], :service_category_id => _internet}

cat << {:id => _wap_internet, :name => 'wap', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _wap_internet * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _wap, :service_category_id => _wap_internet}

cat << {:id => _gprs, :name => 'gprs', :type_id => _common, :parent_id => _sc_mobile_connection, :level => 3, :path => [_sc_tarif_service, _sc_phone_service, _sc_mobile_connection]}
  crit << {:id => _gprs * 10 , :criteria_param_id => _call_base_service_id, :comparison_operator_id => _equal, :value_choose_option_id => _field, 
           :value_param_id => nil, :value => _2g, :service_category_id => _gprs}




ActiveRecord::Base.transaction do
  Service::Category.create(cat)
  Service::Criterium.create(crit)
end
