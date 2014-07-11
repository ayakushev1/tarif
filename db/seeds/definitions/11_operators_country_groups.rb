def access_methods_to_constant_operator_country_groups  
  _mts_europe_countries = [
    _austria,  _albania, _andorra, _belgium, _bulgaria, _bosnia_and_herzegovina, _vatican, _great_britain, _hungary, _germany, _gibraltar,
    _greenland, _denmark, _greece, _ireland, _israel, _iceland, _spain, _italy, _cyprus, _latvia,
    _liechtenstein, _lithuania, _luxembourg, _macedonia, _malta, _monaco, _netherlands, _norway, _poland, _portugal,
    _romania, _san_marino, _serbia, _slovakia, _slovenia,  _turkey, _the_faroe_islands, _finland, _france, _croatia,
    _montenegro, _czech_republic, _switzerland, _sweden, _estonia,
    _gersi, _men, _gernsi, 
    ]
  _mts_sic_countries = [_belarus, _moldova, _ukraiun, _abkhazia, _armenia, _azerbaijan, _georgia, _kazakhstan, _kyrgyzstan, _tajikistan, _turkmenistan, _uzbekistan, _south_ossetia]          
  _mts_sic_1_countries = [_belarus, _ukraiun, _armenia, _turkmenistan,]              
  _mts_sic_2_countries = [_abkhazia, _azerbaijan, _georgia, _kazakhstan,  _kyrgyzstan, _tajikistan, _uzbekistan,]  
  _mts_sic_2_1_countries = [_abkhazia, _georgia, _kazakhstan,  _kyrgyzstan, _tajikistan]  
  _mts_sic_2_2_countries = [_azerbaijan, _uzbekistan]  
  _mts_sic_3_countries = [ _south_ossetia]  
  _mts_other_countries = _world_countries_without_russia - _mts_europe_countries - _mts_sic_countries
    
  _mts_from_11_9_option_countries_1 = [_egypt, _israel, _china, _cuba, _uae, _tailand, _tunis, _turkey, _south_korea]
  _mts_from_11_9_option_countries_2 = _mts_other_countries - _mts_europe_countries - _mts_sic_countries - _mts_from_11_9_option_countries_1
  
  _mts_bit_abrod_1 = [_abkhazia, _austria, _azerbaijan, _albania, _andorra, _bosnia_and_herzegovina, _belarus, _great_britain, _gibraltar, _honkong, _georgia, _denmark, _ireland, 
    _iceland, _spain, _italy, _kazakhstan, _cyprus, _kyrgyzstan, _luxembourg, _malta, _macedonia, _moldova, _uae, _poland, _romania, _san_marino, _serbia, 
    _slovakia, _slovenia, _tailand, _turkmenistan, _uzbekistan, _france, _sweden, _switzerland, _south_korea, ]    
  _mts_bit_abrod_2 = [ _armenia, _belgium, _hungary, _gernsi, _germany, _greece, _gersi, _egypt, _china, _estonia, _portugal, _tajikistan, _tunis, _turkey, _croatia, _czech_republic, _the_faroe_islands, _men]
  _mts_bit_abrod_3 = [_bulgaria, _israel, _canada, _latvia, _lithuania, _liechtenstein, _norway, _usa, _ukraiun, _finland, _montenegro, _estonia ]
  _mts_bit_abrod_4 = _mts_other_countries - _mts_bit_abrod_1 - _mts_bit_abrod_2 - _mts_bit_abrod_3
  
  _mts_love_countries_4_9 = []; _mts_love_countries_5_5 = []; _mts_love_countries_5_9 = []; _mts_love_countries_6_9 = []; _mts_love_countries_7_9 = []
  _mts_love_countries_8_9 = []; _mts_love_countries_9_9 = []; _mts_love_countries_11_5 = []; _mts_love_countries_12_9 = []; 
  _mts_love_countries_14_9 = []; _mts_love_countries_19_9 = []; _mts_love_countries_29_9 = []; _mts_love_countries_49_9 = [];

  _all_country_list_in_array_with_russian_names.each do |country_array|
    name = country_array[2].to_s.split('.').join('_')
    eval("_mts_love_countries_#{name} << country_array[0]") if country_array[2]
  end
  
  _mts_your_country_1 = [_azerbaijan, _belarus]; _mts_your_country_2 = [_china]; _mts_your_country_3 = [_moldova];
  _mts_your_country_4 = [_uzbekistan]; _mts_your_country_5 = [_tajikistan]; _mts_your_country_6 = [_armenia];
  _mts_your_country_7 = [_vietnam, _south_korea, _singapur]; 
  _mts_your_country_8 = _mts_sic_countries - [_azerbaijan, _belarus, _moldova, _uzbekistan, _tajikistan, _armenia]; 
  _mts_your_country_9 = _mts_other_countries - [_china, _vietnam, _south_korea, _singapur];
  
  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_operator_country_groups

