def access_methods_to_constant_operator_country_groups
  _moscow = 1238; _moscow_region = 1127; _piter = 1255; _piter_region = 1124; _ekaterin = 1217; _ekaterin_region = 1162;
  
  _bryansk = 1209; _vladimir = 1212; _ivanovo = 1218; _kaluga = 1224; _kursk = 1231; _kostroma = 1227;
  _nigni_novgorod = 1241; _orel = 1245; _rezyan = 1252; _smolensk = 1258; _tver = 1262; _tula = 1264; _yaroslav = 1278;
   
  _bryansk_region = 1106; _vladimir_region = 1107; _ivanov_region = 1112; _kaluga_region = 1116; _kursk_region = 1123; _kostroma_region = 1119; 
  _nigegorod_region = 1129; _orel_region = 1134; _rezyan_region = 1158; _smolensk_region = 1163; _tver_region = 1166; _tula_region = 1168; _yaroslav_region = 1179; 

#all
  _regions = [_moscow, _moscow_region, _piter, _piter_region, _ekaterin, _ekaterin_region]

#megafon
_mgf_central_region = 
  [_bryansk, _vladimir, _ivanovo, _kaluga, _kursk, _kostroma, _moscow, _nigni_novgorod, _orel, _rezyan, _smolensk, _tver, _tula, _yaroslav] + 
  [_bryansk_region, _vladimir_region, _ivanov_region, _kaluga_region, _kursk_region, _kostroma_region, _moscow_region, _nigegorod_region, _orel_region,
   _rezyan_region, _smolensk_region, _tver_region, _tula_region, _yaroslav_region]

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_operator_country_groups

