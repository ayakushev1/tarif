def access_methods_to_constant_operator_country_groups  
#mts
  _mts_europe_countries = [
    _austria,  _albania, _andorra, _belgium, _bulgaria, _bosnia_and_herzegovina, _vatican, _great_britain, _hungary, _germany, _gibraltar,
    _greenland, _denmark, _greece, _ireland, _israel, _iceland, _spain, _italy, _cyprus, _latvia,
    _liechtenstein, _lithuania, _luxembourg, _macedonia, _malta, _monaco, _netherlands, _norway, _poland, _portugal,
    _romania, _san_marino, _serbia, _slovakia, _slovenia,  _turkey, _the_faroe_islands, _finland, _france, _croatia,
    _montenegro, _czech_republic, _switzerland, _sweden, _estonia,
    _gersi, _men, _gernsi, 
    ]
  
  
  _mts_europe_countries_25_25_25_135 = [_latvia, _lithuania, _netherlands, _finland, _sweden, _estonia]
  _mts_europe_countries_30_30_30_135 = [_bulgaria]
  _mts_europe_countries_45_45_45_135 = [_denmark, _slovenia]
  _mts_europe_countries_50_50_50_135 = [_albania, _cyprus]
  _mts_europe_countries_60_60_60_135 = [_spain, _turkey, _montenegro]
  _mts_europe_countries_65_65_65_135 = [_hungary, _liechtenstein, _poland, _romania, _gibraltar]
  _mts_europe_countries_65_65_75_135 = [_greece, _italy]
  _mts_europe_countries_99_99_99_135 = [_croatia]
  _mts_europe_countries_115_115_115_135 = [_iceland, _israel, _slovakia, _france, _bosnia_and_herzegovina, _malta]
  _mts_europe_countries_155_155_155_155 = [_switzerland]
  _mts_europe_countries_85_85_85_135 = _mts_europe_countries - _mts_europe_countries_25_25_25_135 - _mts_europe_countries_30_30_30_135 - _mts_europe_countries_45_45_45_135 -
    _mts_europe_countries_50_50_50_135 - _mts_europe_countries_60_60_60_135 - _mts_europe_countries_65_65_65_135 - _mts_europe_countries_65_65_75_135 -
    _mts_europe_countries_99_99_99_135 - _mts_europe_countries_115_115_115_135 - _mts_europe_countries_155_155_155_155
    
  _mts_sic_countries = [_belarus, _moldova, _ukraiun, _abkhazia, _armenia, _azerbaijan, _georgia, _kazakhstan, _kyrgyzstan, _tajikistan, _turkmenistan, _uzbekistan, _south_ossetia]          
 
  _mts_sic_abkhazia = [_abkhazia] #155
  _mts_sic_south_ossetia = [_south_ossetia] 
  _mts_sic_135_to_other_countries = _mts_sic_countries - [_abkhazia]
  _mts_sic_109_to_sic = [_belarus, _armenia, _ukraiun]
  _mts_sic_14_for_40_internet = [_armenia, _ukraiun]
  _mts_sic_12_for_40_internet = [_belarus,]
  _mts_sic_30_for_40_internet =_mts_sic_countries - [_belarus, _armenia, _ukraiun]
  _mts_sic_45_to_russia = [_tajikistan] 
  _mts_sic_65_to_russia = [_armenia, _kyrgyzstan, _moldova, _uzbekistan] 
  _mts_sic_75_to_russia = [_belarus] 
  _mts_sic_85_to_russia = [_azerbaijan, _kazakhstan, _ukraiun] 
  _mts_sic_115_to_russia = [_georgia, _turkmenistan] 
 
  _mts_sic_1_countries = [_belarus, _ukraiun, _armenia, _turkmenistan,]              
  _mts_sic_2_countries = [_abkhazia, _azerbaijan, _georgia, _kazakhstan,  _kyrgyzstan, _tajikistan, _uzbekistan,]  
  _mts_sic_2_1_countries = [_abkhazia, _georgia, _kazakhstan,  _kyrgyzstan, _tajikistan]  
  _mts_sic_2_2_countries = [_azerbaijan, _uzbekistan]  
  _mts_sic_3_countries = [ _south_ossetia]  
  
  _mts_other_countries = _world_countries_without_russia - _mts_europe_countries - _mts_sic_countries
  _mts_other_countries_60_60_60_60 = [_egypt, ]
  _mts_other_countries_65_65_65_135 = [_south_korea, ]
  _mts_other_countries_99_99_99_155 = [_japan, ]
  _mts_other_countries_200_200_200_200 = [_canada, _usa, ]
  _mts_other_countries_250_250_250_250 = _africa_countries - _mts_other_countries_60_60_60_60 + 
    [
      _bolivia, _venesuala, _vietnam, _dominiknskaya_republic, _india, _indonezia, _iordania, _iraq, _iran, _iemen, _kambodga, _katar, _columbia, _kosta_rika, _cuba, 
      _kuveit, _laos, _livan, _maldiv_islands, _mexica, _nepal, _uae, _oman, _pakistan, _palestina, _paragvay, _puerto_riko, _saudov_aravia, _singapur, _siria, _taivan, 
      _urugvai, _fillipiny, _shri_lanka, _ekvador, _yamayka
     ] 
  _mts_other_countries_155_155_155_155 = [_australia, _nigeria, _center_africa_republic] + _noth_america_countries + _south_america_countries + _asia_countries - 
    [_south_korea, _japan, _canada, _usa, ] - _mts_other_countries_250_250_250_250
    
  _mts_from_11_9_option_countries_1 = [_egypt, _israel, _china, _cuba, _uae, _tailand, _tunis, _turkey, _south_korea]
  _mts_from_11_9_option_countries_2 = _mts_other_countries - _mts_europe_countries - _mts_sic_countries - _mts_from_11_9_option_countries_1

  _mts_from_free_journey = [_australia, _austria, _armenia, _great_britain, _hungary, _germany, _greece, _israel, _ireland, _italy, 
    _uae, _poland, _portugal, _france, _czech_republic]
  
  _mts_bit_abrod_0 = [_south_ossetia, _turkmenistan] #нет интернета
  _mts_bit_abrod_1 = _mts_europe_countries +  _mts_sic_countries + [_egypt, _israel, _canada, _china, _uae, _usa, _tailand, _turkey, _south_korea]
  _mts_bit_abrod_2 = []
  _mts_bit_abrod_3 = []
  _mts_bit_abrod_4 = _mts_other_countries - _mts_bit_abrod_0 - _mts_bit_abrod_1 - _mts_bit_abrod_2 - _mts_bit_abrod_3
  
  _mts_love_countries_4_9 = []; _mts_love_countries_5_5 = []; _mts_love_countries_5_9 = []; _mts_love_countries_6_9 = []; _mts_love_countries_7_9 = []
  _mts_love_countries_8_9 = []; _mts_love_countries_9_9 = []; _mts_love_countries_11_5 = []; _mts_love_countries_12_9 = []; 
  _mts_love_countries_14_9 = []; _mts_love_countries_19_9 = []; _mts_love_countries_29_9 = []; _mts_love_countries_49_9 = [];

  _all_country_list_in_array_with_russian_names.each do |country_array|
    name = country_array[2].to_s.split('.').join('_')
    eval("_mts_love_countries_#{name} << country_array[0]") if country_array[2]
  end
  
  _mts_your_country_1 = [_azerbaijan, _belarus]; #20
  _mts_your_country_2 = [_china, _south_korea]; #3
  _mts_your_country_3 = [_moldova];#9
  _mts_your_country_4 = [_uzbekistan]; #4
  _mts_your_country_5 = [_georgia, _kyrgyzstan]; #12
  _mts_your_country_6 = [_armenia]; #5 #15
  _mts_your_country_7 = [_vietnam, _abkhazia, _kazakhstan, _tajikistan, _turkmenistan, _south_ossetia]; #8
  _mts_your_country_8 = _mts_sic_countries - [_azerbaijan, _belarus, _moldova, _uzbekistan, _tajikistan, _georgia, _kyrgyzstan, _armenia, _abkhazia, _kazakhstan, _turkmenistan, _south_ossetia];
  _mts_your_country_9 = _mts_other_countries - [_china, _vietnam, _south_korea];


#megafone

  _mgf_europe_countries = [
    _austria,  _albania, _andorra, _belgium, _bulgaria, _bosnia_and_herzegovina, _vatican, _great_britain, _hungary, _germany, _gibraltar,
    _greenland, _denmark, _greece, _ireland, _israel, _iceland, _spain, _italy, _cyprus, _latvia,
    _liechtenstein, _lithuania, _luxembourg, _macedonia, _malta, _monaco, _netherlands, _norway, _poland, _portugal,
    _romania, _san_marino, _serbia, _slovakia, _slovenia,  _turkey, _the_faroe_islands, _finland, _france, _croatia,
    _montenegro, _czech_republic, _switzerland, _sweden, _estonia,
    _gersi, _men, _gernsi, 
    ]
    
 _mgf_europe_international_rouming = _mgf_europe_countries + [_armenia, _belarus, _moldova, _ukraiun, _south_ossetia] - [_israel]
 _mgf_sic_international_rouming = _mts_sic_countries - [_armenia, _belarus, _moldova, _ukraiun, _south_ossetia]
 
 _mgf_extended_countries_international_rouming = [_bagam_islands, _belis, _benin, _botsvana, _bruney, _burundy, _butan, 
   _venesuala, _gainana, _gvatemala, _gvinea, _gvinea_bisay, _gonduras, _greenland, _guam, _zambia, _zimbabve, _iran, 
   _china, _columbia, _komorskie_islands, _kongo, _kosta_rika, _laos, _liberia, _livia, _mavritania, _malavi,
   _mali, _mozambik, _namibia, _niger, _nikaragya, _palay, _palestina, _paragvay, _peru, _puerto_riko, _reunion_island, _ruanda,
   _salvador, _svazilend, _senegal, _surinam, _sierra_leone, _togo, _urugvai, _the_faroe_islands, _french_polinesia, 
   _center_africa_republic, _chad, _chily, _ekvador, _ekvator_gvinea
   ]

 _mgf_option_around_world_2 = [_vietnam, _honkong, _egypt, _israel, _north_korea, _south_korea, _tailand, _uae, _puerto_riko, _usa, _japan]
 _mgf_option_around_world_1 = _mts_europe_countries + _mts_sic_countries - _mgf_option_around_world_2
 _mgf_option_around_world_3 = _world_countries_without_russia - _mgf_option_around_world_1 - _mgf_option_around_world_2
 _mgf_other_countries_international_rouming = _world_countries_without_russia - _mgf_option_around_world_1 - _mgf_option_around_world_2 - _mgf_extended_countries_international_rouming

 _mgf_50_sms_europe_group = _mts_europe_countries + [_armenia, _belarus, _moldova, _ukraiun, _south_ossetia] - [_israel]
 _mgf_sic_international_rouming = _mts_sic_countries - [_armenia, _belarus, _moldova, _ukraiun, _south_ossetia]
 _mgf_not_russia_not_in_50_sms_europe = _world_countries_without_russia - _mgf_50_sms_europe_group
  
 _mgf_ukraine_internet_abroad = [_ukraiun] 
 _mgf_europe_internet_abroad = _mgf_europe_international_rouming - _mgf_ukraine_internet_abroad
 _mgf_popular_countries_internet_abroad = [_abkhazia, _azerbaijan, _vietnam, _honkong, _georgia, _egypt, _israel, _kazakhstan,
   _kyrgyzstan, _china, _south_korea, _uae, _puerto_riko, _usa, _tajikistan, _tailand, _turkmenistan, _uzbekistan, _japan
   ]
 _mgf_other_countries_internet_abroad = _world_countries_without_russia - _mgf_ukraine_internet_abroad - _mgf_europe_internet_abroad - _mgf_popular_countries_internet_abroad

 _mgf_countries_vacation_online = [_austria, _armenia, _belarus, _great_britain, _germany, _greece, _egypt, _israel, _ireland,
   _spain, _italy, _lithuania, _latvia, _liechtenstein, _uae, _portugal, _romania, _turkey, _ukraiun, _finland, 
   _france, _croatia, _czech_republic, _switzerland, _estonia, _south_africa, 
   ]
  
  _mgf_sms_sic_plus = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia]
  _mgf_sms_other_countries = _world_countries_without_russia - _mgf_sms_sic_plus

begin   
  _mgf_country_group_1 =  _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia]
  _mgf_country_group_2 = _mts_europe_countries + [_turkey, _israel, _usa, _canada]
  _mgf_country_group_3 = _australia_countries
  _mgf_country_group_4 = _asia_countries - _mgf_country_group_2
  _mgf_country_group_5 = _world_countries_without_russia - _mgf_country_group_1 - _mgf_country_group_2 - _mgf_country_group_3 - _mgf_country_group_4
rescue
  raise(StandardError, [_asia_countries, _mts_europe_countries, [_turkey, _israel, _usa, _canada], _mgf_country_group_2])
end
  
  _mgf_warm_welcome_plus_1 = [_tajikistan, _ukraiun, _armenia, _kazakhstan, _kyrgyzstan, _turkmenistan]
  _mgf_warm_welcome_plus_2 = [_abkhazia, _south_ossetia]
  _mgf_warm_welcome_plus_3 = [_georgia, ]
  _mgf_warm_welcome_plus_4 = [_uzbekistan, ]
  _mgf_warm_welcome_plus_5 = [_azerbaijan, _belarus]
  _mgf_warm_welcome_plus_6 = [_moldova]
  
  _mgf_international_1 = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia]
  _mgf_international_2 = _mts_europe_countries + [_turkey, _israel] + _asia_countries
  _mgf_international_3 = [_usa, _canada]
  _mgf_international_5 = [_gabon, _gambia, _gambia, _gvinea_bisay, _dem_republick_kongo, _zimbabve, _komorskie_islands, _kongo, _cuba, _maldiv_islands, _martinika, 
    _papua_new_gvinea, _san_tome_and_prinsipi, _somali, _sierra_leone, _togo, _folklend_islands, _center_africa_republic, _chily, _ekvator_gvinea]
  _mgf_international_4 = _world_countries_without_russia - _mgf_international_1 - _mgf_international_2 - _mgf_international_3 - _mgf_international_5

  _mgf_around_world_countries_1 = _mts_europe_countries + [_turkey]
  _mgf_around_world_countries_2 = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia]
  _mgf_around_world_countries_3 = [_vietnam, _honkong, _egypt, _israel, _north_korea, _south_korea, _tailand, _uae, _puerto_riko, _usa, _japan]
  _mgf_around_world_countries_4 = _world_countries_without_russia - _mgf_around_world_countries_1 - _mgf_around_world_countries_2 - _mgf_around_world_countries_3
  _mgf_around_world_countries_5 = [_austria, _armenia, _belarus, _great_britain, _germany, _greece, _egypt, _israel, _ireland,
    _spain, _italy, _lithuania, _latvia, _liechtenstein, _uae, _portugal, _romania, _turkey, _ukraiun, _finland, 
    _france, _croatia, _czech_republic, _switzerland, _estonia, _south_africa, ]
  
  _mgf_call_to_all_country_1 = [_china]
  _mgf_call_to_all_country_3_5 = [_south_ossetia, ]
  _mgf_call_to_all_country_4 = [_usa, _canada, _india, ]
  _mgf_call_to_all_country_4_5 = [_vietnam, ]
  _mgf_call_to_all_country_5 = [_uzbekistan, _poland, _portugal, _tailand, _south_korea, ]
  _mgf_call_to_all_country_6 = [_georgia, _tajikistan, _turkmenistan, 
      _bulgaria, _hungary, _germany, _denmark, _greece, _ireland, _spain, _italy, _cyprus, _lithuania, _netherlands, _norway,
      _romania, _finland, _france, _czech_republic, _sweden, ]
  _mgf_call_to_all_country_7 = [_iceland, ]
  _mgf_call_to_all_country_8 = [_turkey, _armenia, _kazakhstan, _kyrgyzstan, _latvia, _luxembourg, _croatia, _egypt, ]
  _mgf_call_to_all_country_9 = [_andorra, _slovakia, _japan, ]
  _mgf_call_to_all_country_10 = [_ukraiun, _israel, _malta, _uae,]
  _mgf_call_to_all_country_11 = [_great_britain, _moldova, _abkhazia, ]
  _mgf_call_to_all_country_12 = [_san_marino,]
  _mgf_call_to_all_country_13 = [_austria, ]
  _mgf_call_to_all_country_14 = [_estonia, _australia, _south_africa]
  _mgf_call_to_all_country_15 = [_azerbaijan, _belarus, _liechtenstein,]
  _mgf_call_to_all_country_16 = [_bosnia_and_herzegovina, _switzerland,]
  _mgf_call_to_all_country_17 = [_monaco,]
  _mgf_call_to_all_country_18 = [_belgium, _macedonia, _serbia, _montenegro,]
  _mgf_call_to_all_country_19 = [_gibraltar, _indonezia]
  _mgf_call_to_all_country_20 = [_albania, ]
  _mgf_call_to_all_country_23 = [_tunis]
  _mgf_call_to_all_country_30 = [_greenland, _slovenia, _cuba]
   
   _mgf_discount_on_calls_to_russia_and_all_incoming = _world_countries_without_russia - [
    _austria,  _albania, _andorra, _armenia, _belarus, _belgium, _bulgaria, _bosnia_and_herzegovina, _great_britain, _hungary, _germany, 
    _greenland, _denmark, _greece, _ireland, _iceland, _spain, _italy, _cyprus, _latvia,
    _liechtenstein, _lithuania, _luxembourg, _macedonia, _malta, _moldova, _monaco, _netherlands, _norway, _poland, _portugal,
    _romania, _san_marino, _serbia, _slovakia, _turkey, _ukraiun, _finland, _france, _croatia,
    _montenegro, _czech_republic, _switzerland, _sweden, _estonia, _south_ossetia]

#beeline     
  _bln_sic = _mts_sic_countries
  _bln_other_world = _world_countries_without_russia - _bln_sic
  
  _bln_international_1 = _mts_sic_countries + [_georgia]
  _bln_international_2 = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia]
  _bln_international_3 = _mts_europe_countries + [_turkey] + [ _usa, _canada] 
  _bln_international_4 = _noth_america_countries - [ _usa, _canada]
  _bln_international_5 = []#_asia_countries
  _bln_international_6 = _world_countries_without_russia - _bln_international_2 - _bln_international_3 - _bln_international_4 - _bln_international_5
  _bln_international_7 = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia] - [_azerbaijan, _belarus, _moldova]
  _bln_international_8 = _mts_sic_countries + [_abkhazia, _georgia, _south_ossetia] - [_azerbaijan, _belarus]
  _bln_international_9 = [_azerbaijan, _belarus]
  _bln_international_10 = _noth_america_countries - [ _usa, _canada, _cuba, _barbados, _bagam_islands]
  _bln_international_12 = [_maldiv_islands, _magadaskar, _burundy, _north_korea, _papua_new_gvinea, _seishel_island, _tunis]
  _bln_international_11 = _world_countries_without_russia - _bln_international_2 - _bln_international_3 - _bln_international_10 - _bln_international_12
  _bln_international_13 = _world_countries_without_russia - _bln_international_2

  _bln_welcome_1 = [_tajikistan]
  _bln_welcome_2 = [_armenia, _ukraiun]
  _bln_welcome_3 = [_kazakhstan]
  _bln_welcome_4 = [_uzbekistan]
  _bln_welcome_5 = [_turkmenistan, ]
  _bln_welcome_6 = [_moldova]
  _bln_welcome_7 = [_belarus, _azerbaijan]
  _bln_welcome_8 = [_vietnam]
  _bln_welcome_9 = [_china]
  _bln_welcome_10 = [_india, _south_korea]
  _bln_welcome_11 = [_turkey]
  
  _bln_welcome_12 = [_kyrgyzstan, ] #3,5 9
  _bln_welcome_13 = [_georgia, ] #8 12
  _bln_welcome_14 = [_abkhazia, _south_ossetia] #12
  
  
  _bln_my_planet_groups_popular_countries_1 = [_egypt, _china, _usa, _tailand, _turkey]
  _bln_my_planet_groups_1 = _mts_sic_countries + _mts_europe_countries + _bln_my_planet_groups_popular_countries_1
  _bln_my_planet_groups_2 = _world_countries_without_russia - _bln_my_planet_groups_1
  
  _bln_calls_to_other_countries_1 = _mts_sic_countries - [_belarus, _azerbaijan, _moldova]
  _bln_calls_to_other_countries_2 = _mts_europe_countries + [_turkey + _china] + [ _usa, _canada] + [_belarus, _azerbaijan, _moldova]
  _bln_calls_to_other_countries_3 = _world_countries_without_russia - _bln_calls_to_other_countries_1 - _bln_calls_to_other_countries_2
  
  _bln_my_planet_groups_popular_countries_2 = [_egypt,  _india, _israel,  _canada, _china, _kambodga, _katar, _kuveit, _malazia, _singapur, _usa, 
    _tailand, _turkey, _south_ossetia, _uae, _japan]
  _bln_the_best_internet_in_rouming_groups_1 = _mts_sic_countries + _mts_europe_countries + _bln_my_planet_groups_popular_countries_2
  _bln_the_best_internet_in_rouming_groups_2 = _world_countries_without_russia - _bln_the_best_internet_in_rouming_groups_1 - [_abkhazia, _andorra, _cuba]

  _bln_my_abroad_countries_1 =  [ _usa, _canada, _china, _vietnam, _india, _south_korea]
  _bln_my_abroad_countries_2 = _mts_europe_countries + [_turkey]
  _bln_my_abroad_countries_3 = _world_countries_without_russia - _mts_sic_countries - _bln_my_abroad_countries_1 - _bln_my_abroad_countries_2

#tele2
_tele_service_to_tele_international_1 = _mts_sic_countries
_tele_service_to_tele_international_2 = _mts_europe_countries
_tele_service_to_tele_international_3 = [_usa, _canada]
_tele_service_to_tele_international_4 = _world_countries_without_russia - _mts_sic_countries - _mts_europe_countries - _tele_service_to_tele_international_3
_tele_service_to_tele_international_5 = _asia_countries + _australia_countries + _africa_countries
_tele_service_to_tele_international_6 = _noth_america_countries + _south_america_countries

_tele_service_to_sic_1 = [_uzbekistan, _tajikistan]
_tele_service_to_sic_2 = [_azerbaijan, _belarus, _moldova]
_tele_service_to_sic_3 = _mts_sic_countries - _tele_service_to_sic_1 - _tele_service_to_sic_2

_tele_service_to_uzbekistan = [_uzbekistan,]
_tele_service_to_sic_not_uzbekistan = _mts_sic_countries - [_uzbekistan,]
  
  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_operator_country_groups

