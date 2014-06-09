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
rln << {:id => _relation_mts_sic_3_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_sic_3_countries,:name => 'MTS, SIC 3'}
rln << {:id => _relation_mts_other_countries, :type_id => _operator_country_groups, :owner_id => _mts, :parent_id => nil, :children => _mts_other_countries,:name => 'MTS, Other World'}

rln << {:id => 20000, :type_id => _main_operator_by_country, :owner_id => _ukraiun, :parent_id => nil, :children => [_mts_ukrain],:name => ''}
rln << {:id => 20100, :type_id => _main_operator_by_country, :owner_id => _great_britain, :parent_id => nil, :children => [_operator_great_britain],:name => ''}
rln << {:id => 20200, :type_id => _main_operator_by_country, :owner_id => _germany, :parent_id => nil, :children => [_operator_germany],:name => ''}
rln << {:id => 20300, :type_id => _main_operator_by_country, :owner_id => _france, :parent_id => nil, :children => [_operator_france],:name => ''}
rln << {:id => 20400, :type_id => _main_operator_by_country, :owner_id => _spain, :parent_id => nil, :children => [_operator_spain],:name => ''}
rln << {:id => 20500, :type_id => _main_operator_by_country, :owner_id => _poland, :parent_id => nil, :children => [_operator_poland],:name => ''}
rln << {:id => 20700, :type_id => _main_operator_by_country, :owner_id => _china, :parent_id => nil, :children => [_operator_china],:name => ''}
rln << {:id => 20800, :type_id => _main_operator_by_country, :owner_id => _india, :parent_id => nil, :children => [_operator_india],:name => ''}
rln << {:id => 20900, :type_id => _main_operator_by_country, :owner_id => _turkey, :parent_id => nil, :children => [_operator_turkey],:name => ''}
rln << {:id => 21000, :type_id => _main_operator_by_country, :owner_id => _abkhazia, :parent_id => nil, :children => [_operator_abhazia],:name => ''}
rln << {:id => 21100, :type_id => _main_operator_by_country, :owner_id => _azerbaijan, :parent_id => nil, :children => [_operator_azerbaigan],:name => ''}
rln << {:id => 21200, :type_id => _main_operator_by_country, :owner_id => _armenia, :parent_id => nil, :children => [_operator_armenia],:name => ''}
rln << {:id => 21300, :type_id => _main_operator_by_country, :owner_id => _georgia, :parent_id => nil, :children => [_operator_gruzia],:name => ''}
rln << {:id => 21400, :type_id => _main_operator_by_country, :owner_id => _usa, :parent_id => nil, :children => [_operator_usa],:name => ''}
rln << {:id => 21500, :type_id => _main_operator_by_country, :owner_id => _canada, :parent_id => nil, :children => [_operator_canada],:name => ''}
rln << {:id => 21600, :type_id => _main_operator_by_country, :owner_id => _mexica, :parent_id => nil, :children => [_operator_mexica],:name => ''}
rln << {:id => 21700, :type_id => _main_operator_by_country, :owner_id => _cuba, :parent_id => nil, :children => [_operator_cuba],:name => ''}
rln << {:id => 21800, :type_id => _main_operator_by_country, :owner_id => _yamayka, :parent_id => nil, :children => [_operator_yamayka],:name => ''}
rln << {:id => 21900, :type_id => _main_operator_by_country, :owner_id => _brasilia, :parent_id => nil, :children => [_operator_brasilia],:name => ''}
rln << {:id => 22000, :type_id => _main_operator_by_country, :owner_id => _argentina, :parent_id => nil, :children => [_operator_argentina],:name => ''}
rln << {:id => 22100, :type_id => _main_operator_by_country, :owner_id => _chily, :parent_id => nil, :children => [_operator_chily],:name => ''}
rln << {:id => 22200, :type_id => _main_operator_by_country, :owner_id => _bolivia, :parent_id => nil, :children => [_operator_bolivia],:name => ''}
rln << {:id => 22300, :type_id => _main_operator_by_country, :owner_id => _egypt, :parent_id => nil, :children => [_operator_egypt],:name => ''}
rln << {:id => 22400, :type_id => _main_operator_by_country, :owner_id => _uae, :parent_id => nil, :children => [_operator_uae],:name => ''}
rln << {:id => 22500, :type_id => _main_operator_by_country, :owner_id => _south_africa, :parent_id => nil, :children => [_operator_south_africa],:name => ''}
rln << {:id => 22600, :type_id => _main_operator_by_country, :owner_id => _livia, :parent_id => nil, :children => [_operator_livia],:name => ''}

rln << {:id => 22700, :type_id => _main_operator_by_country, :owner_id => _kazakhstan, :parent_id => nil, :children => [_operator_kazakhstan],:name => ''}
rln << {:id => 22800, :type_id => _main_operator_by_country, :owner_id => _kyrgyzstan, :parent_id => nil, :children => [_operator_kyrgyzstan],:name => ''}
rln << {:id => 22900, :type_id => _main_operator_by_country, :owner_id => _tajikistan, :parent_id => nil, :children => [_operator_tajikistan],:name => ''}
rln << {:id => 23000, :type_id => _main_operator_by_country, :owner_id => _turkmenistan, :parent_id => nil, :children => [_operator_turkmenistan],:name => ''}
rln << {:id => 23100, :type_id => _main_operator_by_country, :owner_id => _uzbekistan, :parent_id => nil, :children => [_operator_uzbekistan],:name => ''}
rln << {:id => 23200, :type_id => _main_operator_by_country, :owner_id => _south_ossetia, :parent_id => nil, :children => [_operator_south_ossetia],:name => ''}
rln << {:id => 23300, :type_id => _main_operator_by_country, :owner_id => _belarus, :parent_id => nil, :children => [_operator_belarus],:name => ''}
rln << {:id => 23400, :type_id => _main_operator_by_country, :owner_id => _moldova, :parent_id => nil, :children => [_operator_moldova],:name => ''}

#  raise(StandardError, [rln, _mts_cis, Relation.create(rln).to_sql])
   

Relation.transaction do
  Relation.create(rln)
end

#  id        :integer          not null, primary key
#  type_id   :integer
#  name      :string(255)
#  owner_id  :integer
#  parent_id :integer
#  childrens :integer          default([]), is an 