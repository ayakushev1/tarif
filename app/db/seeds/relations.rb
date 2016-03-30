Relation.delete_all
rln =[]

rln << {:id => 0, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _moscow, :children => [_moscow_region],:name => 'Beeline, Moscow home regions'}
rln << {:id => 1, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _moscow_region, :children => [_moscow],:name => 'Beeline, Moscow region home regions'}
rln << {:id => 2, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _piter, :children => [_piter_region],:name => 'Beeline, Piter home regions'}
rln << {:id => 3, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _piter_region, :children => [_piter],:name => 'Beeline, Piter region home regions'}
rln << {:id => 4, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'Beeline, Ekaterinburg home regions'}
rln << {:id => 5, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Beeline, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'Beeline, Ekaterinburg region home regions'}

rln << {:id => 1000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _moscow, :children => [_moscow_region],:name => 'Megafon, Moscow home regions'}
rln << {:id => 1001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _moscow_region, :children => [_moscow],:name => 'Megafon, Moscow region home regions'}
rln << {:id => 1002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _piter, :children => [_piter_region],:name => 'Megafon, Piter home regions'}
rln << {:id => 1003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _piter_region, :children => [_piter],:name => 'Megafon, Piter region home regions'}
rln << {:id => 1004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'Megafon, Ekaterinburg home regions'}
rln << {:id => 1005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Megafon, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'Megafon, Ekaterinburg region home regions'}

rln << {:id => 2000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _moscow, :children => [_moscow_region],:name => 'MTS, Moscow home regions'}
rln << {:id => 2001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _moscow_region, :children => [_moscow],:name => 'MTS, Moscow region home regions'}
rln << {:id => 2002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _piter, :children => [_piter_region],:name => 'MTS, Piter home regions'}
rln << {:id => 2003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _piter_region, :children => [_piter],:name => 'MTS, Piter region home regions'}
rln << {:id => 2004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'MTS, Ekaterinburg home regions'}
rln << {:id => 2005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Mts, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'MTS, Ekaterinburg region home regions'}

rln << {:id => 3000, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _moscow, :children => [_moscow_region],:name => 'Теле2, Moscow home regions'}
rln << {:id => 3001, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _moscow_region, :children => [_moscow],:name => 'Теле2, Moscow region home regions'}
rln << {:id => 3002, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _piter, :children => [_piter_region],:name => 'Теле2, Piter home regions'}
rln << {:id => 3003, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _piter_region, :children => [_piter],:name => 'Теле2, Piter region home regions'}
rln << {:id => 3004, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'Теле2, Ekaterinburg home regions'}
rln << {:id => 3005, :type_id => _operator_home_regions, :owner_id => Category::Operator::Const::Tele2, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'Теле2, Ekaterinburg region home regions'}

rln << {:id => 9000, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _world, :children => _world_countries_without_russia,:name => 'World'}
rln << {:id => 9001, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Europe'}
rln << {:id => 9002, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _asia, :children => _asia_countries,:name => 'Asia'}
rln << {:id => 9003, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Noth America'}
rln << {:id => 9004, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _south_america, :children => _south_america_countries,:name => 'South America'}
rln << {:id => 9005, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _africa, :children => _africa_countries,:name => 'Africa'}
rln << {:id => 9006, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => nil, :children => _mts_sic_countries,:name => 'CIS'}

rln << {:id => 10000, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _world, :children => _world_countries_without_russia,:name => 'Beeline, World'}
rln << {:id => 10001, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Beeline, Europe'}
rln << {:id => 10002, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _asia, :children => _asia_countries,:name => 'Beeline, Asia'}
rln << {:id => 10003, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Beeline, Noth America'}
rln << {:id => 10004, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _south_america, :children => _south_america_countries,:name => 'Beeline, South America'}
rln << {:id => 10005, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => _africa, :children => _africa_countries,:name => 'Beeline, Africa'}
rln << {:id => 10006, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _mts_sic_countries,:name => 'Beeline, CIS'}

rln << {:id => 10100, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _world, :children => _world_countries_without_russia,:name => 'Megafon, World'}
rln << {:id => 10101, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Megafon, Europe'}
rln << {:id => 10102, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _asia, :children => _asia_countries,:name => 'Megafon, Asia'}
rln << {:id => 10103, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Megafon, Noth America'}
rln << {:id => 10104, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _south_america, :children => _south_america_countries,:name => 'Megafon, South America'}
rln << {:id => 10105, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => _africa, :children => _africa_countries,:name => 'Megafon, Africa'}
rln << {:id => 10106, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mts_sic_countries,:name => 'Megafon, CIS'}

rln << {:id => _relation_mts_europe_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_europe_countries,:name => 'MTS, Europe'}
rln << {:id => _relation_mts_sic_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_countries,:name => 'MTS, SIC'}
rln << {:id => _relation_mts_sic_1_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_1_countries,:name => 'MTS, SIC 1'}
rln << {:id => _relation_mts_sic_2_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_2_countries,:name => 'MTS, SIC 2'}
rln << {:id => _relation_mts_sic_2_1_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_2_1_countries,:name => 'MTS, SIC 2_1'}
rln << {:id => _relation_mts_sic_2_2_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_2_2_countries,:name => 'MTS, SIC 2_2'}
rln << {:id => _relation_mts_sic_3_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_sic_3_countries,:name => 'MTS, SIC 3'}
rln << {:id => _relation_mts_other_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_other_countries,:name => 'MTS, Other World'}
rln << {:id => _relation_mts_calls_from_11_9_option_countries_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_from_11_9_option_countries_1,:name => 'MTS, countries 1 from 11.9 rur tarif option'}
rln << {:id => _relation_mts_calls_from_11_9_option_countries_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_from_11_9_option_countries_2,:name => 'MTS, countries 2 from 11.9 rur tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_bit_abrod_1,:name => 'MTS, countries from bit_abrod_1 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_bit_abrod_2,:name => 'MTS, countries from bit_abrod_2 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_bit_abrod_3,:name => 'MTS, countries from bit_abrod_3 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_bit_abrod_4,:name => 'MTS, countries from bit_abrod_4 tarif option'}

rln << {:id => _relation_mts_love_countries_4_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_4_9,:name => 'MTS, countries from _mts_love_countries_4_9 tarif option'}
rln << {:id => _relation_mts_love_countries_5_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_5_5,:name => 'MTS, countries from _mts_love_countries_5_5 tarif option'}
rln << {:id => _relation_mts_love_countries_5_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_5_9,:name => 'MTS, countries from _mts_love_countries_5_9 tarif option'}
rln << {:id => _relation_mts_love_countries_6_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_6_9,:name => 'MTS, countries from _mts_love_countries_6_9 tarif option'}
rln << {:id => _relation_mts_love_countries_7_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_7_9,:name => 'MTS, countries from _mts_love_countries_7_9 tarif option'}
rln << {:id => _relation_mts_love_countries_8_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_8_9,:name => 'MTS, countries from _mts_love_countries_8_9 tarif option'}
rln << {:id => _relation_mts_love_countries_9_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_9_9,:name => 'MTS, countries from _mts_love_countries_9_9 tarif option'}
rln << {:id => _relation_mts_love_countries_11_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_11_5,:name => 'MTS, countries from _mts_love_countries_11_5 tarif option'}
rln << {:id => _relation_mts_love_countries_12_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_12_9,:name => 'MTS, countries from _mts_love_countries_12_9 tarif option'}
rln << {:id => _relation_mts_love_countries_14_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_14_9,:name => 'MTS, countries from _mts_love_countries_14_9 tarif option'}
rln << {:id => _relation_mts_love_countries_19_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_19_9,:name => 'MTS, countries from _mts_love_countries_19_9 tarif option'}
rln << {:id => _relation_mts_love_countries_29_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_29_9,:name => 'MTS, countries from _mts_love_countries_29_9 tarif option'}
rln << {:id => _relation_mts_love_countries_49_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_love_countries_49_9,:name => 'MTS, countries from _mts_love_countries_49_9 tarif option'}

rln << {:id => _relation_mts_your_country_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_1,:name => 'MTS, countries from _mts_your_country_1 tarif option'}
rln << {:id => _relation_mts_your_country_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_2,:name => 'MTS, countries from _mts_your_country_2 tarif option'}
rln << {:id => _relation_mts_your_country_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_3,:name => 'MTS, countries from _mts_your_country_3 tarif option'}
rln << {:id => _relation_mts_your_country_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_4,:name => 'MTS, countries from _mts_your_country_4 tarif option'}
rln << {:id => _relation_mts_your_country_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_5,:name => 'MTS, countries from _mts_your_country_5 tarif option'}
rln << {:id => _relation_mts_your_country_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_6,:name => 'MTS, countries from _mts_your_country_6 tarif option'}
rln << {:id => _relation_mts_your_country_7, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_7,:name => 'MTS, countries from _mts_your_country_7 tarif option'}
rln << {:id => _relation_mts_your_country_8, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_8,:name => 'MTS, countries from _mts_your_country_8 tarif option'}
rln << {:id => _relation_mts_your_country_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_your_country_9,:name => 'MTS, countries from _mts_your_country_9 tarif option'}

rln << {:id => _relation_mts_free_journey, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Mts, :parent_id => nil, :children => _mts_from_free_journey,:name => 'MTS, countries from _mts_from_free_journey tarif option'}

rln << {:id => _relation_mgf_rouming_in_option_around_world_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_option_around_world_1,:name => 'Megafone, countries from _mgf_option_around_world_1 tarif option'}
rln << {:id => _relation_mgf_rouming_in_option_around_world_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_option_around_world_2,:name => 'Megafone, countries from _mgf_option_around_world_2 tarif option'}
rln << {:id => _relation_mgf_rouming_in_option_around_world_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_option_around_world_3,:name => 'Megafone, countries from _mgf_option_around_world_3 tarif option'}
rln << {:id => _relation_mgf_rouming_in_50_sms_europe, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_50_sms_europe_group,:name => 'Megafone, countries from _mgf_50_sms_europe_group_group tarif option'}
rln << {:id => _relation_mgf_rouming_not_russia_not_in_50_sms_europe, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_not_russia_not_in_50_sms_europe,:name => 'Megafone, countries from _mgf_not_russia_not_in_50_sms_europe tarif option'}

rln << {:id => _relation_mgf_europe_international_rouming, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_europe_international_rouming,:name => 'Megafone, countries from _mgf_europe_international_rouming'}
rln << {:id => _relation_mgf_sic_international_rouming, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_sic_international_rouming,:name => 'Megafone, countries from _mgf_sic_international_rouming'}
rln << {:id => _relation_mgf_other_countries_international_rouming, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_other_countries_international_rouming,:name => 'Megafone, countries from _mgf_other_countries_international_rouming'}
rln << {:id => _relation_mgf_extended_countries_international_rouming, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_extended_countries_international_rouming,:name => 'Megafone, countries from _mgf_extended_countries_international_rouming'}

rln << {:id => _relation_mgf_ukraine_internet_abroad, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_ukraine_internet_abroad,:name => 'Megafone, countries from _mgf_ukraine_internet_abroad'}
rln << {:id => _relation_mgf_europe_internet_abroad, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_europe_internet_abroad,:name => 'Megafone, countries from _mgf_europe_internet_abroad'}
rln << {:id => _relation_mgf_popular_countries_internet_abroad, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_popular_countries_internet_abroad,:name => 'Megafone, countries from _mgf_popular_countries_internet_abroad'}
rln << {:id => _relation_mgf_other_countries_internet_abroad, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_other_countries_internet_abroad,:name => 'Megafone, countries from _mgf_other_countries_internet_abroad'}

rln << {:id => _relation_mgf_countries_vacation_online, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_countries_vacation_online,:name => 'Megafone, countries from _mgf_countries_vacation_online'}

rln << {:id => _relation_service_to_mgf_sms_sic_plus, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_sms_sic_plus,:name => 'Megafone, countries from _mgf_sms_sic_plus'}
rln << {:id => _relation_service_to_mgf_sms_other_countries, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_sms_other_countries,:name => 'Megafone, countries from _mgf_sms_other_countries'}

rln << {:id => _relation_service_to_mgf_country_group_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_country_group_1,:name => 'Megafone, countries from mgf_country_group_1'}
rln << {:id => _relation_service_to_mgf_country_group_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_country_group_2,:name => 'Megafone, countries from mgf_country_group_2'}
rln << {:id => _relation_service_to_mgf_country_group_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_country_group_3,:name => 'Megafone, countries from mgf_country_group_3'}
rln << {:id => _relation_service_to_mgf_country_group_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_country_group_4,:name => 'Megafone, countries from mgf_country_group_4'}
rln << {:id => _relation_service_to_mgf_country_group_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_country_group_5,:name => 'Megafone, countries from mgf_country_group_5'}

rln << {:id => _sc_service_to_mgf_warm_welcome_plus_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_1,:name => 'Megafone, countries from mgf_warm_welcome_plus_1'}
rln << {:id => _sc_service_to_mgf_warm_welcome_plus_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_2,:name => 'Megafone, countries from mgf_warm_welcome_plus_2'}
rln << {:id => _sc_service_to_mgf_warm_welcome_plus_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_3,:name => 'Megafone, countries from mgf_warm_welcome_plus_3'}
rln << {:id => _sc_service_to_mgf_warm_welcome_plus_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_4,:name => 'Megafone, countries from mgf_warm_welcome_plus_4'}
rln << {:id => _sc_service_to_mgf_warm_welcome_plus_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_5,:name => 'Megafone, countries from mgf_warm_welcome_plus_5'}
rln << {:id => _sc_service_to_mgf_warm_welcome_plus_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_warm_welcome_plus_6,:name => 'Megafone, countries from mgf_warm_welcome_plus_6'}

rln << {:id => _sc_service_to_mgf_international_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_international_1,:name => 'Megafone, countries from mgf_international_1'}
rln << {:id => _sc_service_to_mgf_international_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_international_2,:name => 'Megafone, countries from mgf_international_2'}
rln << {:id => _sc_service_to_mgf_international_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_international_3,:name => 'Megafone, countries from mgf_international_3'}
rln << {:id => _sc_service_to_mgf_international_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_international_4,:name => 'Megafone, countries from mgf_international_4'}
rln << {:id => _sc_service_to_mgf_international_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_international_5,:name => 'Megafone, countries from mgf_international_5'}

rln << {:id => _relation_mgf_around_world_countries_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_around_world_countries_1,:name => 'Megafone, countries from _mgf_around_world_countries_1'}
rln << {:id => _relation_mgf_around_world_countries_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_around_world_countries_2,:name => 'Megafone, countries from _mgf_around_world_countries_2'}
rln << {:id => _relation_mgf_around_world_countries_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_around_world_countries_3,:name => 'Megafone, countries from _mgf_around_world_countries_3'}
rln << {:id => _relation_mgf_around_world_countries_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_around_world_countries_4,:name => 'Megafone, countries from _mgf_around_world_countries_4'}
rln << {:id => _relation_mgf_around_world_countries_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_around_world_countries_5,:name => 'Megafone, countries from _mgf_around_world_countries_5'}

rln << {:id => _relation_service_to_mgf_call_to_all_country_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_1,:name => 'Megafone, countries from _mgf_call_to_all_country_1'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_3_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_3_5,:name => 'Megafone, countries from _to_mgf_call_to_all_country_3_5'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_4,:name => 'Megafone, countries from _to_mgf_call_to_all_country_4'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_4_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_4_5,:name => 'Megafone, countries from _to_mgf_call_to_all_country_4_5'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_5,:name => 'Megafone, countries from _to_mgf_call_to_all_country_5'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_6,:name => 'Megafone, countries from _to_mgf_call_to_all_country_6'}

rln << {:id => _relation_service_to_mgf_call_to_all_country_7, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_7,:name => 'Megafone, countries from _to_mgf_call_to_all_country_7'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_8, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_8,:name => 'Megafone, countries from _to_mgf_call_to_all_country_8'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_9,:name => 'Megafone, countries from _to_mgf_call_to_all_country_9'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_10, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_10,:name => 'Megafone, countries from _to_mgf_call_to_all_country_10'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_11, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_11,:name => 'Megafone, countries from _to_mgf_call_to_all_country_11'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_12, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_12,:name => 'Megafone, countries from _to_mgf_call_to_all_country_12'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_13, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_13,:name => 'Megafone, countries from _to_mgf_call_to_all_country_13'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_14, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_14,:name => 'Megafone, countries from _to_mgf_call_to_all_country_14'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_15, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_15,:name => 'Megafone, countries from _to_mgf_call_to_all_country_15'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_16, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_16,:name => 'Megafone, countries from _to_mgf_call_to_all_country_16'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_17, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_17,:name => 'Megafone, countries from _to_mgf_call_to_all_country_17'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_18, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_18,:name => 'Megafone, countries from _to_mgf_call_to_all_country_18'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_19, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_19,:name => 'Megafone, countries from _to_mgf_call_to_all_country_19'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_20, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_20,:name => 'Megafone, countries from _to_mgf_call_to_all_country_20'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_23, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_23,:name => 'Megafone, countries from _to_mgf_call_to_all_country_23'}
rln << {:id => _relation_service_to_mgf_call_to_all_country_30, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_call_to_all_country_30,:name => 'Megafone, countries from _to_mgf_call_to_all_country_30'}

rln << {:id => _relation_mgf_discount_on_calls_to_russia_and_all_incoming, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_discount_on_calls_to_russia_and_all_incoming,:name => 'Megafone, countries from _mgf_discount_on_calls_to_russia_and_all_incoming'}

rln << {:id => _relation_service_to_bln_international_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_1,:name => 'Beeline, countries from _bln_international_1'}
rln << {:id => _relation_service_to_bln_international_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_2,:name => 'Beeline, countries from _bln_international_2'}
rln << {:id => _relation_service_to_bln_international_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_3,:name => 'Beeline, countries from _bln_international_3'}
rln << {:id => _relation_service_to_bln_international_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_4,:name => 'Beeline, countries from _bln_international_4'}
rln << {:id => _relation_service_to_bln_international_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_5,:name => 'Beeline, countries from _bln_international_5'}
rln << {:id => _relation_service_to_bln_international_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_6,:name => 'Beeline, countries from _bln_international_6'}
rln << {:id => _relation_service_to_bln_international_7, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_7,:name => 'Beeline, countries from _bln_international_7'}
rln << {:id => _relation_service_to_bln_international_8, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_8,:name => 'Beeline, countries from _bln_international_8'}
rln << {:id => _relation_service_to_bln_international_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_9,:name => 'Beeline, countries from _bln_international_9'}
rln << {:id => _relation_service_to_bln_international_10, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_10,:name => 'Beeline, countries from _bln_international_10'}
rln << {:id => _relation_service_to_bln_international_11, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_11,:name => 'Beeline, countries from _bln_international_11'}
rln << {:id => _relation_service_to_bln_international_12, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_12,:name => 'Beeline, countries from _bln_international_12'}
rln << {:id => _relation_service_to_bln_international_13, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_international_13,:name => 'Beeline, countries from _bln_international_13'}

rln << {:id => _relation_service_to_bln_welcome_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_1,:name => 'Beeline, countries from bln_welcome_1'}
rln << {:id => _relation_service_to_bln_welcome_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_2,:name => 'Beeline, countries from bln_welcome_2'}
rln << {:id => _relation_service_to_bln_welcome_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_3,:name => 'Beeline, countries from bln_welcome_3'}
rln << {:id => _relation_service_to_bln_welcome_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_4,:name => 'Beeline, countries from bln_welcome_4'}
rln << {:id => _relation_service_to_bln_welcome_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_5,:name => 'Beeline, countries from bln_welcome_5'}
rln << {:id => _relation_service_to_bln_welcome_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_6,:name => 'Beeline, countries from bln_welcome_6'}
rln << {:id => _relation_service_to_bln_welcome_7, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_7,:name => 'Beeline, countries from bln_welcome_7'}
rln << {:id => _relation_service_to_bln_welcome_8, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_8,:name => 'Beeline, countries from bln_welcome_8'}
rln << {:id => _relation_service_to_bln_welcome_9, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_9,:name => 'Beeline, countries from bln_welcome_9'}
rln << {:id => _relation_service_to_bln_welcome_10, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_10,:name => 'Beeline, countries from bln_welcome_10'}
rln << {:id => _relation_service_to_bln_welcome_11, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_welcome_11,:name => 'Beeline, countries from bln_welcome_11'}

rln << {:id => _relation_bln_sic, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_sic,:name => 'Beeline, countries from _bln_sic'}
rln << {:id => _relation_bln_other_world, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_other_world,:name => 'Beeline, countries from _other_world'}

rln << {:id => _relation_sc_bln_my_planet_groups_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_my_planet_groups_1,:name => 'Beeline, countries from _bln_my_planet_groups_1'}
rln << {:id => _relation_sc_bln_my_planet_groups_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_my_planet_groups_2,:name => 'Beeline, countries from _bln_my_planet_groups_2'}

rln << {:id => _relation_sc_bln_calls_to_other_countries_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_calls_to_other_countries_1,:name => 'Beeline, countries from _bln_calls_to_other_countries_1'}
rln << {:id => _relation_sc_bln_calls_to_other_countries_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_calls_to_other_countries_2,:name => 'Beeline, countries from _bln_calls_to_other_countries_2'}
rln << {:id => _relation_sc_bln_calls_to_other_countries_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_calls_to_other_countries_3,:name => 'Beeline, countries from _bln_calls_to_other_countries_3'}

rln << {:id => _relation_sc_bln_the_best_internet_in_rouming_groups_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_the_best_internet_in_rouming_groups_1,:name => 'Beeline, countries from _bln_the_best_internet_in_rouming_groups_1'}
rln << {:id => _relation_sc_bln_the_best_internet_in_rouming_groups_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => _bln_the_best_internet_in_rouming_groups_2,:name => 'Beeline, countries from _bln_the_best_internet_in_rouming_groups_2'}

rln << {:id => _relation_service_to_tele_international_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_1,:name => 'Tele, countries from _tele_service_to_tele_international_1'}
rln << {:id => _relation_service_to_tele_international_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_2,:name => 'Tele, countries from _tele_service_to_tele_international_2'}
rln << {:id => _relation_service_to_tele_international_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_3,:name => 'Tele, countries from _tele_service_to_tele_international_3'}
rln << {:id => _relation_service_to_tele_international_4, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_4,:name => 'Tele, countries from _tele_service_to_tele_international_4'}
rln << {:id => _relation_service_to_tele_international_5, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_5,:name => 'Tele, countries from _tele_service_to_tele_international_5'}
rln << {:id => _relation_service_to_tele_international_6, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_tele_international_6,:name => 'Tele, countries from _tele_service_to_tele_international_6'}

rln << {:id => _relation_service_to_tele_sic_1, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_sic_1,:name => 'Tele, countries from _tele_service_to_tele_sic_1'}
rln << {:id => _relation_service_to_tele_sic_2, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_sic_2,:name => 'Tele, countries from _tele_service_to_tele_sic_2'}
rln << {:id => _relation_service_to_tele_sic_3, :type_id => _operator_country_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_service_to_sic_3,:name => 'Tele, countries from _tele_service_to_tele_sic_3'}


rln << {:id => _relation_mgf_central_region, :type_id => _operator_region_groups, :owner_id => Category::Operator::Const::Megafon, :parent_id => nil, :children => _mgf_central_region,:name => 'Megafone, cental region of Russia'}

rln << {:id => _relation_service_to_russian_operators_group, :type_id => _operator_partner_groups, :owner_id => nil, :parent_id => nil, :children => Category::Operator::Const::RusianOperatorsGroup,:name => 'Beeline, operators from _russian_operators_group'}
rln << {:id => _relation_service_to_sic_operators_group, :type_id => _operator_partner_groups, :owner_id => nil, :parent_id => nil, :children => Category::Operator::Const::SicOperatorsGroup,:name => 'Beeline, operators from _sic_operators_group'}
rln << {:id => _relation_service_to_other_operators_group, :type_id => _operator_partner_groups, :owner_id => nil, :parent_id => nil, :children => Category::Operator::Const::OtherOperatorsGroup,:name => 'Beeline, operators from _other_operators_group'}

rln << {:id => _relation_service_to_bln_partner_operators, :type_id => _operator_partner_groups, :owner_id => Category::Operator::Const::Beeline, :parent_id => nil, :children => Category::Operator::Const::BeelinePartnerOperators,:name => 'Beeline, operators from _bln_partner_operators'}


rln << {:id => _relation_tele_own_country_rouming_1, :type_id => _operator_region_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_own_country_rouming_1,:name => '_tele_own_country_rouming_1'}
rln << {:id => _relation_tele_own_country_rouming_2, :type_id => _operator_region_groups, :owner_id => Category::Operator::Const::Tele2, :parent_id => nil, :children => _tele_own_country_rouming_2,:name => '_tele_own_country_rouming_2'}



rln << {:id => 20000, :type_id => _main_operator_by_country, :owner_id => _ukraiun, :parent_id => nil, :children => [Category::Operator::Const::MtsUkrain],:name => ''}
rln << {:id => 20001, :type_id => _main_operator_by_country, :owner_id => _russia, :parent_id => nil, :children => [Category::Operator::Const::Tele2, Category::Operator::Const::Mts, Category::Operator::Const::Beeline, Category::Operator::Const::Megafon],:name => ''}

i = 20002
_all_country_list_in_string.each do |country_name|
  rln << {:id => i, :type_id => _main_operator_by_country, :owner_id => eval(country_name), :parent_id => nil, :children => [eval("_operator#{country_name}")], :name => ''}
  i += 1
end

Relation.transaction do
  rln.each do |rrr|
    begin
      Relation.create(rrr)
    rescue
      raise(StandardError, [rrr, _mgf_50_sms_europe])
    end
     
  end
  #Relation.create(rln)
end

#  id        :integer          not null, primary key
#  type_id   :integer
#  name      :string(255)
#  owner_id  :integer
#  parent_id :integer
#  childrens :integer          default([]), is an 