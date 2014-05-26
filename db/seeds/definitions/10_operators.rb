def access_methods_to_constant_operators  
#operator_country_groups
_beeline_world = 10000; _beeline_europe = 10001; _beeline_asia = 10002; _beeline__noth_america = 10003; _beeline_south_america = 10004; _beeline_africa = 10005; _beeline_cis = 10006; 
_megafon_world = 10100; _megafon_europe = 10101; _megafon_asia = 10102; _megafon__noth_america = 10103; _megafon_south_america = 10104; _megafon_africa = 10105; _megafon_cis = 10106; 
_mts_world = 10200; _mts_europe = 10201; _mts_asia = 10202; _mts__noth_america = 10203; _mts_south_america = 10204; _mts_africa = 10205; _mts_cis = 10206; 


#  _operator_country_group_operator_id = 200; _operator_country_group_countries_ids = 201;
  
#_beeline_GO = 0; _beeline_ALL_FOR_1200 = 1; _beeline_national_rouming = 72; _beeline_international_rouming = 73; _beeline_MY_INTRACITY = 80;
#_megafon_AroundWorld = 100; _megafon_All_Simple = 101; _megafon_national_rouming = 176; _megafon_international_rouming = 177;
#_mts_RED_Energy = 200; _mts_Smart = 201; _mts_national_rouming = 276; _mts_international_rouming = 277; _mts_ULTRA = 282; _mts_SMART = 283 

#_beeline_tarif_classes = [_beeline_GO, _beeline_ALL_FOR_1200, _beeline_national_rouming, _beeline_international_rouming, _beeline_MY_INTRACITY]     
#_megafon_tarif_classes = [_megafon_AroundWorld, _megafon_All_Simple, _megafon_national_rouming, _megafon_international_rouming]
#_mts_tarif_classes = [_mts_RED_Energy, _mts_Smart, _mts_national_rouming, _mts_international_rouming, _mts_ULTRA, _mts_SMART]

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_operators