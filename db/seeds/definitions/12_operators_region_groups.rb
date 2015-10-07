def access_methods_to_constant_operator_country_groups
  _moscow = 1238; _moscow_region = 1127; _piter = 1255; _piter_region = 1124; _ekaterin = 1217; _ekaterin_region = 1162;
  
  
  _arhangelsk = 1203;
  _barnaul = 1205;_blagoveshensk = 1208;
  _bryansk = 1209; _vladimir = 1212; _ivanovo = 1218; _kaluga = 1224; _kursk = 1231; _kostroma = 1227;
  _nigni_novgorod = 1241; _orel = 1245; _rezyan = 1252; _smolensk = 1258; _tver = 1262; _tula = 1264; _yaroslav = 1278;
  
  _sevastopol = 1282;
   
  _altai_region = 1101; _amur_region = 1102; _arhangelsk_region = 1103; _astrahan_region = 1104; _belgorod_region = 1105;
  _bryansk_region = 1106; _vladimir_region = 1107; _vologda_region =1108; _voroneg_region = 1109; _volgograd_region = 1110; 
  _birobidgan_region = 1111; _ivanov_region = 1112; _irkutsk_region = 1113; _kaliningrad_region = 1114; _kamhatsky_region = 1115; 
  _kaluga_region = 1116; _kemerovo_region = 1117; _kirov_region = 1118;  _kostroma_region = 1119; _krasnodar_region = 1120;
  _krasnoyarsk_region = 1121; _kurgansk_region = 1122; _kursk_region = 1123; _leningrad_region = 1124; _lipetsk_region = 1125;
  _magadan_region = 1126; _moscow_region = 1127;  _murmansk_region = 1128; _nigegorod_region = 1129; _novgorod_region = 1130;
  _novosibirsk_region = 1131; _omsk_region = 1132; _orenburg_region = 1133; _orel_region = 1134; _penza_region = 1135;
  _permsk_region = 1136; _primorsk_region = 1137; _pskovsk_region = 1138; adygea_region = 1139; _bashkorostan_region = 1140;
  _buryatia_region = 1141; _dagestan_region = 1142; _yakutia_region = 1143; _tatarstan_region = 1144; _udmurtia_region = 1145; 
  _ingushetia_region = 1146; _kabardino_balkaria_region = 1147; _kalmykia_region = 1148; _karachaevo_cherchesia_region = 1149;
  _karelia_region = 1150; _komi_region = 1151; _maryi_el_region = 1152; _mordovia_region = 1153; _yuznaya_osetia_region = 1154;
  _tyva_tuva_region = 1155; _hakasia_region = 1156; _rostov_region = 1157; _rezyan_region = 1158;_samara_region = 1159;
  _saratov_region = 1160; _sahalin_region = 1161; _sverdlovsk_region = 1162; _smolensk_region = 1163; _stavropol_region = 1164; 
  _tambov_region = 1165; _tver_region = 1166; _tomsk_region = 1167; _tula_region = 1168; _tumen_region = 1169; _ulyanovsk_region = 1170;
  _habarovsk_region = 1171; _hanty_mansiisk_region = 1172; _chelyabinsk_region = 1173; _chechen_region = 1174; _chita_region = 1175; 
  _chuvashia_region = 1176; _chukotka_region = 1177; _yamalo_nenetsk_region = 1178; _yaroslav_region = 1179; _altai_republik = 1180; 
  _zabaikalsk_region = 1181; _krum = 1182;

#all
  _regions = [_moscow, _moscow_region, _piter, _piter_region, _ekaterin, _ekaterin_region]

#megafon
_mgf_central_region = 
  [_bryansk, _vladimir, _ivanovo, _kaluga, _kursk, _kostroma, _moscow, _nigni_novgorod, _orel, _rezyan, _smolensk, _tver, _tula, _yaroslav] + 
  [_bryansk_region, _vladimir_region, _ivanov_region, _kaluga_region, _kursk_region, _kostroma_region, _moscow_region, _nigegorod_region, _orel_region,
   _rezyan_region, _smolensk_region, _tver_region, _tula_region, _yaroslav_region]

#beeline
_bln_all_russia_except_some_regions_for_internet = [] 

#tele_2
_tele_own_country_rouming_1 = [_altai_region, _barnaul, _amur_region, _blagoveshensk, _astrahan_region, _volgograd_region, _zabaikalsk_region, _ivanov_region,
    _irkutsk_region, _kabardino_balkaria_region, _karachaevo_cherchesia_region, _krasnoyarsk_region, _kurgansk_region, _moscow_region, _orenburg_region,
    _penza_region, _permsk_region, _primorsk_region, _altai_republik, _bashkorostan_region, _buryatia_region, _dagestan_region, _ingushetia_region, 
    _kalmykia_region, _maryi_el_region, _mordovia_region, _yakutia_region, _yuznaya_osetia_region, _tatarstan_region, _tyva_tuva_region, 
    _hakasia_region, _samara_region, _saratov_region, _sverdlovsk_region, _stavropol_region, _tumen_region, _ulyanovsk_region, _habarovsk_region, 
    _hanty_mansiisk_region, _chechen_region, _chuvashia_region, _yaroslav_region]

_tele_own_country_rouming_2 = [_arhangelsk_region, _arhangelsk, _belgorod_region, _bryansk_region, _vladimir_region, _vologda_region, _voroneg_region, 
    _birobidgan_region, _kaliningrad_region, _kaluga_region, _kamhatsky_region, _kemerovo_region, _kirov_region, _kostroma_region, _krasnodar_region,
    adygea_region, _kursk_region, _lipetsk_region, _magadan_region, _murmansk_region, _yamalo_nenetsk_region, _nigegorod_region, _novgorod_region,
    _novosibirsk_region, _omsk_region, _orel_region, _pskovsk_region, _karelia_region, _komi_region, _rostov_region, _rezyan_region, _sahalin_region,
    _smolensk_region, _tambov_region, _tver_region, _tomsk_region, _tula_region, _udmurtia_region, _chelyabinsk_region, _chukotka_region]

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_operator_country_groups

