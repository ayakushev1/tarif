Relation.delete_all
rln =[]

rln << {:id => 0, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _moscow, :children => [_moscow_region],:name => 'Beeline, Moscow home regions'}
rln << {:id => 1, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _moscow_region, :children => [_moscow],:name => 'Beeline, Moscow region home regions'}
rln << {:id => 2, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _piter, :children => [_piter_region],:name => 'Beeline, Piter home regions'}
rln << {:id => 3, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _piter_region, :children => [_piter],:name => 'Beeline, Piter region home regions'}
rln << {:id => 4, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'Beeline, Ekaterinburg home regions'}
rln << {:id => 5, :type_id => _operator_home_regions, :owner_id => _beeline, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'Beeline, Ekaterinburg region home regions'}

rln << {:id => 1000, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _moscow, :children => [_moscow_region],:name => 'Megafon, Moscow home regions'}
rln << {:id => 1001, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _moscow_region, :children => [_moscow],:name => 'Megafon, Moscow region home regions'}
rln << {:id => 1002, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _piter, :children => [_piter_region],:name => 'Megafon, Piter home regions'}
rln << {:id => 1003, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _piter_region, :children => [_piter],:name => 'Megafon, Piter region home regions'}
rln << {:id => 1004, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'Megafon, Ekaterinburg home regions'}
rln << {:id => 1005, :type_id => _operator_home_regions, :owner_id => _megafon, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'Megafon, Ekaterinburg region home regions'}

rln << {:id => 2000, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _moscow, :children => [_moscow_region],:name => 'MTS, Moscow home regions'}
rln << {:id => 2001, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _moscow_region, :children => [_moscow],:name => 'MTS, Moscow region home regions'}
rln << {:id => 2002, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _piter, :children => [_piter_region],:name => 'MTS, Piter home regions'}
rln << {:id => 2003, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _piter_region, :children => [_piter],:name => 'MTS, Piter region home regions'}
rln << {:id => 2004, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _ekaterin, :children => [_ekaterin_region],:name => 'MTS, Ekaterinburg home regions'}
rln << {:id => 2005, :type_id => _operator_home_regions, :owner_id => _mts, :parent_id => _ekaterin_region, :children => [_ekaterin],:name => 'MTS, Ekaterinburg region home regions'}

rln << {:id => 9000, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _world, :children => _world_countries_without_russia,:name => 'World'}
rln << {:id => 9001, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Europe'}
rln << {:id => 9002, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _asia, :children => _asia_countries,:name => 'Asia'}
rln << {:id => 9003, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Noth America'}
rln << {:id => 9004, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _south_america, :children => _south_america_countries,:name => 'South America'}
rln << {:id => 9005, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => _africa, :children => _africa_countries,:name => 'Africa'}
rln << {:id => 9006, :type_id => _operator_country_groups, :owner_id => nil, :parent_id => nil, :children => _mts_sic_countries,:name => 'CIS'}

rln << {:id => 10000, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _world, :children => _world_countries_without_russia,:name => 'Beeline, World'}
rln << {:id => 10001, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Beeline, Europe'}
rln << {:id => 10002, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _asia, :children => _asia_countries,:name => 'Beeline, Asia'}
rln << {:id => 10003, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Beeline, Noth America'}
rln << {:id => 10004, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _south_america, :children => _south_america_countries,:name => 'Beeline, South America'}
rln << {:id => 10005, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => _africa, :children => _africa_countries,:name => 'Beeline, Africa'}
rln << {:id => 10006, :type_id => _operator_country_groups, :owner_id => _beeline, :parent_id => nil, :children => _mts_sic_countries,:name => 'Beeline, CIS'}

rln << {:id => 10100, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _world, :children => _world_countries_without_russia,:name => 'Megafon, World'}
rln << {:id => 10101, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _europe, :children => _europe_countries_without_russia,:name => 'Megafon, Europe'}
rln << {:id => 10102, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _asia, :children => _asia_countries,:name => 'Megafon, Asia'}
rln << {:id => 10103, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _noth_america, :children => _noth_america_countries,:name => 'Megafon, Noth America'}
rln << {:id => 10104, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _south_america, :children => _south_america_countries,:name => 'Megafon, South America'}
rln << {:id => 10105, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => _africa, :children => _africa_countries,:name => 'Megafon, Africa'}
rln << {:id => 10106, :type_id => _operator_country_groups, :owner_id => _megafon, :parent_id => nil, :children => _mts_sic_countries,:name => 'Megafon, CIS'}

rln << {:id => _relation_mts_europe_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_europe_countries,:name => 'MTS, Europe'}
rln << {:id => _relation_mts_sic_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_countries,:name => 'MTS, SIC'}
rln << {:id => _relation_mts_sic_1_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_1_countries,:name => 'MTS, SIC 1'}
rln << {:id => _relation_mts_sic_2_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_2_countries,:name => 'MTS, SIC 2'}
rln << {:id => _relation_mts_sic_2_1_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_2_1_countries,:name => 'MTS, SIC 2_1'}
rln << {:id => _relation_mts_sic_2_2_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_2_2_countries,:name => 'MTS, SIC 2_2'}
rln << {:id => _relation_mts_sic_3_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_3_countries,:name => 'MTS, SIC 3'}
rln << {:id => _relation_mts_other_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_other_countries,:name => 'MTS, Other World'}
rln << {:id => _relation_mts_calls_from_11_9_option_countries_1, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_from_11_9_option_countries_1,:name => 'MTS, countries 1 from 11.9 rur tarif option'}
rln << {:id => _relation_mts_calls_from_11_9_option_countries_2, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_from_11_9_option_countries_2,:name => 'MTS, countries 2 from 11.9 rur tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_1, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_bit_abrod_1,:name => 'MTS, countries from bit_abrod_1 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_2, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_bit_abrod_2,:name => 'MTS, countries from bit_abrod_2 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_3, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_bit_abrod_3,:name => 'MTS, countries from bit_abrod_3 tarif option'}
rln << {:id => _relation_mts_internet_bit_abrod_4, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_bit_abrod_4,:name => 'MTS, countries from bit_abrod_4 tarif option'}

rln << {:id => _relation_mts_love_countries_4_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_4_9,:name => 'MTS, countries from _mts_love_countries_4_9 tarif option'}
rln << {:id => _relation_mts_love_countries_5_5, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_5_5,:name => 'MTS, countries from _mts_love_countries_5_5 tarif option'}
rln << {:id => _relation_mts_love_countries_5_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_5_9,:name => 'MTS, countries from _mts_love_countries_5_9 tarif option'}
rln << {:id => _relation_mts_love_countries_6_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_6_9,:name => 'MTS, countries from _mts_love_countries_6_9 tarif option'}
rln << {:id => _relation_mts_love_countries_7_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_7_9,:name => 'MTS, countries from _mts_love_countries_7_9 tarif option'}
rln << {:id => _relation_mts_love_countries_8_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_8_9,:name => 'MTS, countries from _mts_love_countries_8_9 tarif option'}
rln << {:id => _relation_mts_love_countries_9_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_9_9,:name => 'MTS, countries from _mts_love_countries_9_9 tarif option'}
rln << {:id => _relation_mts_love_countries_11_5, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_11_5,:name => 'MTS, countries from _mts_love_countries_11_5 tarif option'}
rln << {:id => _relation_mts_love_countries_12_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_12_9,:name => 'MTS, countries from _mts_love_countries_12_9 tarif option'}
rln << {:id => _relation_mts_love_countries_14_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_14_9,:name => 'MTS, countries from _mts_love_countries_14_9 tarif option'}
rln << {:id => _relation_mts_love_countries_19_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_19_9,:name => 'MTS, countries from _mts_love_countries_19_9 tarif option'}
rln << {:id => _relation_mts_love_countries_29_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_29_9,:name => 'MTS, countries from _mts_love_countries_29_9 tarif option'}
rln << {:id => _relation_mts_love_countries_49_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_love_countries_49_9,:name => 'MTS, countries from _mts_love_countries_49_9 tarif option'}

rln << {:id => _relation_mts_your_country_1, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_1,:name => 'MTS, countries from _mts_your_country_1 tarif option'}
rln << {:id => _relation_mts_your_country_2, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_2,:name => 'MTS, countries from _mts_your_country_2 tarif option'}
rln << {:id => _relation_mts_your_country_3, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_3,:name => 'MTS, countries from _mts_your_country_3 tarif option'}
rln << {:id => _relation_mts_your_country_4, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_4,:name => 'MTS, countries from _mts_your_country_4 tarif option'}
rln << {:id => _relation_mts_your_country_5, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_5,:name => 'MTS, countries from _mts_your_country_5 tarif option'}
rln << {:id => _relation_mts_your_country_6, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_6,:name => 'MTS, countries from _mts_your_country_6 tarif option'}
rln << {:id => _relation_mts_your_country_7, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_7,:name => 'MTS, countries from _mts_your_country_7 tarif option'}
rln << {:id => _relation_mts_your_country_8, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_8,:name => 'MTS, countries from _mts_your_country_8 tarif option'}
rln << {:id => _relation_mts_your_country_9, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_your_country_9,:name => 'MTS, countries from _mts_your_country_9 tarif option'}


rln << {:id => 20000, :type_id => _main_operator_by_country, :owner_id => _ukraiun, :parent_id => nil, :children => [_mts_ukrain],:name => ''}
rln << {:id => 20001, :type_id => _main_operator_by_country, :owner_id => _russia, :parent_id => nil, :children => [_mts, _beeline, _megafon],:name => ''}

i = 20002
_all_country_list_in_string.each do |country_name|
  rln << {:id => i, :type_id => _main_operator_by_country, :owner_id => eval(country_name), :parent_id => nil, :children => [eval("_operator#{country_name}")], :name => ''}
  i += 1
end

Relation.transaction do
  Relation.create(rln)
end

#  id        :integer          not null, primary key
#  type_id   :integer
#  name      :string(255)
#  owner_id  :integer
#  parent_id :integer
#  childrens :integer          default([]), is an 