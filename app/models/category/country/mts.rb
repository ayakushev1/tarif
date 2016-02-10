module Category::Country::Mts
  c = Category::Country::Const
  o = Category::Country::Mts

  o::Europe_countries = [c::Avstriya, c::Albaniya, c::Andorra, c::Belgiya, c::Bolgariya, c::Bosniya_i_gertsegovina, c::Vatikan, c::Velikobritaniya, c::Vengriya, c::Gernsi, 
    c::Germaniya, c::Gibraltar, c::Grenlandiya, c::Gretsiya, c::Daniya, c::Gersi, c::Izrail, c::Irlandiya, c::Islandiya, c::Ispaniya, c::Italiya, c::Kipr, c::Latviya, 
    c::Litva, c::Lihtenshtein, c::Luksemburg, c::Men, c::Makedoniya, c::Malta, c::Monako, c::Niderlandy, c::Norvegiya, c::Polsha, c::Portugaliya, c::Rumyniya, c::San_marino, 
    c::Serbiya, c::Slovakiya, c::Sloveniya, c::Turtsiya, c::Farerskie_o_va, c::Finlyandiya, c::Frantsiya, c::Horvatiya, c::Chernogoriya, c::Chehiya, c::Shveitsariya, 
    c::Shvetsiya, c::Estoniya].sort
    
  o::Europe_countries_25_25_25_135 = [c::Latviya, c::Litva, c::Niderlandy, c::Finlyandiya, c::Shvetsiya, c::Estoniya].sort
  o::Europe_countries_30_30_30_135 = [c::Bolgariya].sort
  o::Europe_countries_45_45_45_135 = [c::Daniya, c::Sloveniya].sort
  o::Europe_countries_50_50_50_135 = [c::Albaniya, c::Kipr].sort
  o::Europe_countries_60_60_60_135 = [c::Ispaniya, c::Turtsiya, c::Chernogoriya].sort
  o::Europe_countries_65_65_65_135 = [c::Vengriya, c::Lihtenshtein, c::Polsha, c::Rumyniya, c::Gibraltar].sort
  o::Europe_countries_65_65_75_135 = [c::Gretsiya, c::Italiya].sort
  o::Europe_countries_99_99_99_135 = [c::Horvatiya].sort
  o::Europe_countries_115_115_115_135 = [c::Islandiya, c::Izrail, c::Slovakiya, c::Frantsiya, c::Bosniya_i_gertsegovina, c::Malta].sort
  o::Europe_countries_155_155_155_155 = [c::Shveitsariya].sort
  o::Europe_countries_85_85_85_135 = o::Europe_countries - o::Europe_countries_25_25_25_135 - o::Europe_countries_30_30_30_135 - o::Europe_countries_45_45_45_135 -
    o::Europe_countries_50_50_50_135 - o::Europe_countries_60_60_60_135 - o::Europe_countries_65_65_65_135 - o::Europe_countries_65_65_75_135 -
    o::Europe_countries_99_99_99_135 - o::Europe_countries_115_115_115_135 - o::Europe_countries_155_155_155_155
    
  o::Sic_countries = [c::Ukraina, c::Azerbaidzhan, c::Armeniya, c::Belarus, c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya, c::Kazahstan, c::Kyrgyzstan, c::Moldova, 
    c::Tadzhikistan, c::Turkmenistan, c::Uzbekistan]

  o::Sic_abkhazia = [c::Abhaziya] #155
  o::Sic_south_ossetia = [c::Uzhnaya_osetiya] 
  o::Sic_135_to_other_countries = o::Sic_countries - [c::Abhaziya]
  o::Sic_109_to_sic = [c::Belarus, c::Armeniya, c::Ukraina]
  o::Sic_14_for_40_internet = [c::Armeniya, c::Ukraina]
  o::Sic_12_for_40_internet = [c::Belarus,]
  o::Sic_30_for_40_internet =o::Sic_countries - [c::Belarus, c::Armeniya, c::Ukraina]
  o::Sic_45_to_russia = [c::Tadzhikistan] 
  o::Sic_65_to_russia = [c::Armeniya, c::Kyrgyzstan, c::Moldova, c::Uzbekistan] 
  o::Sic_75_to_russia = [c::Belarus] 
  o::Sic_85_to_russia = [c::Azerbaidzhan, c::Kazahstan, c::Ukraina] 
  o::Sic_115_to_russia = [c::Gruziya, c::Turkmenistan] 
 
  o::Sic_1_countries = [c::Belarus, c::Ukraina, c::Armeniya, c::Turkmenistan,]              
  o::Sic_2_countries = [c::Abhaziya, c::Azerbaidzhan, c::Gruziya, c::Kazahstan,  c::Kyrgyzstan, c::Tadzhikistan, c::Uzbekistan,]  
  o::Sic_2_1_countries = [c::Abhaziya, c::Gruziya, c::Kazahstan,  c::Kyrgyzstan, c::Tadzhikistan]  
  o::Sic_2_2_countries = [c::Azerbaidzhan, c::Uzbekistan]  
  o::Sic_3_countries = [ c::Uzhnaya_osetiya]  

  o::Other_countries = c::World_countries_without_russia - o::Europe_countries - o::Sic_countries
  o::Other_countries_60_60_60_60 = [c::Egipet, ]
  o::Other_countries_65_65_65_135 = [c::Koreya_uzhnaya, ]
  o::Other_countries_99_99_99_155 = [c::Yaponiya, ]
  o::Other_countries_200_200_200_200 = [c::Kanada, c::Ssha, ]
  o::Other_countries_250_250_250_250 = (c::Africa_countries - o::Other_countries_60_60_60_60 + [
    c::Boliviya, c::Venesuela, c::Vetnam, c::Dominikanskaya_respublika, c::Indiya, c::Indoneziya, c::Iordaniya, c::Irak, c::Iran, c::Iemen, c::Kambodzha, c::Katar, 
    c::Kolumbiya, c::Kosta_rika, c::Kuba, c::Kuveit, c::Laos, c::Livan, c::Maldivskie_o_va, c::Meksika, c::Nepal, c::Oae, c::Oman, c::Pakistan, c::Palestina, c::Paragvai, 
    c::Puerto_riko, c::Saudovskaya_araviya, c::Singapur, c::Siriya, c::Taivan, c::Urugvai, c::Filippiny, c::Shri_lanka, c::Ekvador, c::Yamaika
  ]).sort
  o::Other_countries_155_155_155_155 = ([c::Avstraliya, c::Nigeriya, c::Tsentralno_afrikanskaya_respublika] + c::Noth_america_countries + c::South_america_countries + c::Asia_countries - 
    [c::Kanada, c::Koreya_uzhnaya, c::Ssha, c::Yaponiya, ] - o::Other_countries_250_250_250_250).sort
# Category::Country.list_to_const_array([])

  o::From_11_9_option_countries_1 = [c::Egipet, c::Izrail, c::Kitai, c::Koreya_uzhnaya, c::Kuba, c::Oae, c::Tailand, c::Tunis, c::Turtsiya].sort
  o::From_11_9_option_countries_2 = o::Other_countries - o::Europe_countries - o::Sic_countries - o::From_11_9_option_countries_1

  o::From_free_journey = [c::Avstraliya, c::Avstriya, c::Armeniya, c::Velikobritaniya, c::Vengriya, c::Germaniya, c::Gretsiya, c::Izrail, c::Irlandiya, c::Italiya, 
    c::Oae, c::Polsha, c::Portugaliya, c::Frantsiya, c::Chehiya].sort
  
  o::Bit_abrod_0 = [c::Uzhnaya_osetiya, c::Turkmenistan] #нет интернета
  o::Bit_abrod_1 = (o::Europe_countries +  o::Sic_countries + [c::Egipet, c::Izrail, c::Kanada, c::Kitai, c::Koreya_uzhnaya, c::Oae, c::Ssha, c::Tailand, c::Turtsiya]).sort
  o::Bit_abrod_2 = []
  o::Bit_abrod_3 = []
  o::Bit_abrod_4 = o::Other_countries - o::Bit_abrod_0 - o::Bit_abrod_1 - o::Bit_abrod_2 - o::Bit_abrod_3
  
  o::Love_countries_4_9 = [c::Gonkong, c::Kanada, c::Kitai, c::Makao, c::Ssha].sort
  o::Love_countries_5_5 = [c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya, c::Kazahstan, c::Kyrgyzstan, c::Tadzhikistan, c::Turkmenistan, c::Uzbekistan].sort 
  o::Love_countries_5_9 = [c::Armeniya, c::Vetnam, c::Koreya_uzhnaya, c::Moldova, c::Singapur].sort
  o::Love_countries_6_9 = [c::Avstriya, c::Velikobritaniya, c::Germaniya, c::Izrail, c::Kipr, c::Polsha, c::Turtsiya, c::Finlyandiya, c::Frantsiya, c::Shvetsiya].sort 
  o::Love_countries_7_9 = [c::Belgiya, c::Vatikan, c::Vengriya, c::Gretsiya, c::Daniya, c::Ispaniya, c::Italiya, c::Luksemburg, c::Niderlandy, c::Norvegiya, 
      c::Portugaliya, c::Rumyniya].sort
  o::Love_countries_8_9 = [c::Irlandiya, c::Latviya, c::Litva, c::Monako, c::Slovakiya, c::Sloveniya, c::Horvatiya, c::Chehiya, c::Shveitsariya].sort 
  o::Love_countries_9_9 = [c::Andorra, c::Indiya, c::Islandiya, c::Mongoliya, c::Taivan, c::Estoniya, c::Yaponiya].sort
  o::Love_countries_11_5 = [c::Azerbaidzhan, c::Belarus].sort
  o::Love_countries_12_9 = [c::Albaniya, c::Bolgariya, c::Bosniya_i_gertsegovina, c::Makedoniya, c::Malta, c::San_marino, c::Serbiya, c::Chernogoriya].sort 
  o::Love_countries_14_9 = [c::Avstraliya, c::Alzhir, c::Angola, c::Antigua_i_barbuda, c::Argentina, c::Bagamskie_o_va, c::Barbados, c::Bermudskie_o_va, c::Boliviya, 
    c::Braziliya, c::Burundi, c::Venesuela, c::Gabon, c::Gana, c::Gvatemala, c::Gonduras, c::Grenada, c::Guam, c::Dominikanskaya_respublika, c::Egipet, c::Zambiya, 
    c::Kaimanovy_o_va, c::Keniya, c::Kosta_rika, c::Mavrikii, c::Malavi, c::Meksika, c::Niger, c::Nigeriya, c::Niderlandskie_antilskie_o_va, c::Novaya_zelandiya, 
    c::Novaya_kaledoniya, c::Panama, c::Paragvai, c::Peru, c::Puerto_riko, c::Ruanda, c::Seishelskie_o_va, c::Senegal, c::Sen_per_i_mikelon_o_v, c::Sent_lusiya_o_v, 
    c::Sudan, c::Tanzaniya, c::Trinidad_i_tobago, c::Uganda, c::Urugvai, c::Chad, c::Chili, c::Uar, c::Yamaika].sort
  o::Love_countries_19_9 = [c::Afganistan, c::Bangladesh, c::Bahrein, c::Brunei, c::Butan, c::Gibraltar, c::Grenlandiya, c::Indoneziya, c::Iordaniya, c::Irak, c::Iran, 
    c::Iemen, c::Kambodzha, c::Katar, c::Koreya_severnaya, c::Kuveit, c::Laos, c::Livan, c::Lihtenshtein, c::Malaiziya, c::Maldivskie_o_va, c::Myanma, c::Nepal, c::Oae, 
    c::Oman, c::Pakistan, c::Palestina, c::Saudovskaya_araviya, c::Siriya, c::Tailand, c::Farerskie_o_va, c::Filippiny, c::Shri_lanka].sort
  o::Love_countries_29_9 = [c::Angilya, c::Aruba, c::Beliz, c::Benin, c::Botsvana, c::Burkina_faso, c::Gaiti, c::Gaiana, c::Gvadelupa, c::Demokraticheskaya_respublika_kongo, 
    c::Dominika, c::Zimbabve, c::Kabo_verde, c::Kamerun, c::Kolumbiya, c::Kot_divuar, c::Liberiya, c::Liviya, c::Mavritaniya, c::Madagaskar, c::Mozambik, c::Mali, c::Marokko, 
    c::Namibiya, c::Nikaragua, c::Palau, c::Reunon_o_v, c::Salvador, c::Svazilend, c::Sent_kits_i_nevis, c::Surinam, c::Tyorks_i_kaikos, c::Tunis, c::Fidzhi, 
    c::Frantsuzskaya_gviana, c::Frantsuzskaya_polineziya, c::Ekvador, c::Ekvatorialnaya_gvineya, c::Efiopiya].sort 
  o::Love_countries_49_9 = [c::Gambiya, c::Gvineya, c::Gvineya_bisau, c::Komorskie_o_va, c::Kongo, c::Kuba, c::Martinika, c::Papua_novaya_gvineya, c::San_tome_i_prinsipi, 
    c::Somali, c::Serra_leone, c::Togo, c::Folklendskie_o_va, c::Tsentralno_afrikanskaya_respublika, c::Eritreya].sort

  o::Your_country_1 = [c::Azerbaidzhan, c::Belarus].sort #20
  o::Your_country_2 = [c::Kitai, c::Koreya_uzhnaya].sort #3
  o::Your_country_3 = [c::Moldova].sort #9
  o::Your_country_4 = [c::Uzbekistan].sort #4
  o::Your_country_5 = [c::Gruziya, c::Kyrgyzstan].sort #12
  o::Your_country_6 = [c::Armeniya].sort #5 #15
  o::Your_country_7 = [c::Vetnam, c::Abhaziya, c::Uzhnaya_osetiya, c::Kazahstan, c::Tadzhikistan, c::Turkmenistan].sort #8
  o::Your_country_8 = o::Sic_countries - [c::Azerbaidzhan, c::Armeniya, c::Belarus, c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya, c::Kazahstan, c::Kyrgyzstan, 
  c::Moldova, c::Tadzhikistan, c::Turkmenistan, c::Uzbekistan].sort
  o::Your_country_9 = o::Other_countries - [c::Vetnam, c::Kitai, c::Koreya_uzhnaya].sort

      
end

