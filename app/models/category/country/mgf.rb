module Category::Country::Mgf
  c = Category::Country::Const
  m = Category::Country::Mts
  o = Category::Country::Mgf

  o::Europe_countries = [
    c::Avstriya, c::Albaniya, c::Andorra, c::Belgiya, c::Bolgariya, c::Bosniya_i_gertsegovina, c::Vatikan, c::Velikobritaniya, c::Vengriya, c::Gernsi, c::Germaniya, 
    c::Gibraltar, c::Grenlandiya, c::Gretsiya, c::Daniya, c::Gersi, c::Izrail, c::Irlandiya, c::Islandiya, c::Ispaniya, c::Italiya, c::Kipr, c::Latviya, c::Litva, 
    c::Lihtenshtein, c::Luksemburg, c::Men, c::Makedoniya, c::Malta, c::Monako, c::Niderlandy, c::Norvegiya, c::Polsha, c::Portugaliya, c::Rumyniya, c::San_marino, 
    c::Serbiya, c::Slovakiya, c::Sloveniya, c::Turtsiya, c::Farerskie_o_va, c::Finlyandiya, c::Frantsiya, c::Horvatiya, c::Chernogoriya, c::Chehiya, c::Shveitsariya, 
    c::Shvetsiya, c::Estoniya 
    ].sort
    
 o::Europe_international_rouming = (o::Europe_countries + [c::Ukraina, c::Armeniya, c::Belarus, c::Uzhnaya_osetiya, c::Moldova] - [c::Izrail]).sort
 o::Sic_international_rouming = m::Sic_countries - [c::Ukraina, c::Armeniya, c::Belarus, c::Uzhnaya_osetiya, c::Moldova]
 
 o::Extended_countries_international_rouming = [c::Bagamskie_o_va, c::Beliz, c::Benin, c::Botsvana, c::Brunei, c::Burundi, c::Butan, c::Venesuela, c::Gaiana, c::Gvatemala, 
   c::Gvineya, c::Gvineya_bisau, c::Gonduras, c::Grenlandiya, c::Guam, c::Zambiya, c::Zimbabve, c::Iran, c::Kitai, c::Kolumbiya, c::Komorskie_o_va, c::Kongo, c::Kosta_rika, 
   c::Laos, c::Liberiya, c::Liviya, c::Mavritaniya, c::Mozambik, c::Malavi, c::Mali, c::Namibiya, c::Niger, c::Nikaragua, c::Palau, c::Palestina, c::Paragvai, c::Peru, 
   c::Puerto_riko, c::Reunon_o_v, c::Ruanda, c::Salvador, c::Svazilend, c::Senegal, c::Surinam, c::Serra_leone, c::Togo, c::Urugvai, c::Farerskie_o_va, 
   c::Frantsuzskaya_polineziya, c::Tsentralno_afrikanskaya_respublika, c::Chad, c::Chili, c::Ekvador, c::Ekvatorialnaya_gvineya].sort

 o::Option_around_world_2 = [c::Vetnam, c::Gonkong, c::Egipet, c::Izrail, c::Koreya_severnaya, c::Koreya_uzhnaya, c::Oae, c::Puerto_riko, c::Ssha, c::Tailand, c::Yaponiya].sort
 o::Option_around_world_1 = (m::Europe_countries + m::Sic_countries - o::Option_around_world_2).sort
 o::Option_around_world_3 = c::World_countries_without_russia - o::Option_around_world_1 - o::Option_around_world_2
 o::Other_countries_international_rouming = c::World_countries_without_russia - o::Option_around_world_1 - o::Option_around_world_2 - o::Extended_countries_international_rouming

 o::C50_sms_europe_group = (m::Europe_countries + [c::Ukraina, c::Armeniya, c::Belarus, c::Uzhnaya_osetiya, c::Moldova] - [c::Izrail]).sort
 o::Not_russia_not_in_50_sms_europe = c::World_countries_without_russia - o::C50_sms_europe_group
  
 o::Ukraine_internet_abroad = [c::Ukraina] 
 o::Europe_internet_abroad = o::Europe_international_rouming - o::Ukraine_internet_abroad
 o::Popular_countries_internet_abroad = [c::Azerbaidzhan, c::Vetnam, c::Gonkong, c::Gruziya, c::Abhaziya, c::Egipet, c::Izrail, c::Kazahstan, c::Kitai, c::Koreya_uzhnaya, 
   c::Kyrgyzstan, c::Oae, c::Puerto_riko, c::Ssha, c::Tadzhikistan, c::Tailand, c::Turkmenistan, c::Uzbekistan, c::Yaponiya].sort
 o::Other_countries_internet_abroad = c::World_countries_without_russia - o::Ukraine_internet_abroad - o::Europe_internet_abroad - o::Popular_countries_internet_abroad

 o::Countries_vacation_online = [c::Ukraina, c::Avstriya, c::Armeniya, c::Belarus, c::Velikobritaniya, c::Germaniya, c::Gretsiya, c::Egipet, c::Izrail, c::Irlandiya, 
   c::Ispaniya, c::Italiya, c::Latviya, c::Litva, c::Lihtenshtein, c::Oae, c::Portugaliya, c::Rumyniya, c::Turtsiya, c::Finlyandiya, c::Frantsiya, c::Horvatiya, c::Chehiya, 
   c::Shveitsariya, c::Estoniya, c::Uar].sort
  
  o::Sms_sic_plus = (m::Sic_countries + [c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya]).sort
  o::Sms_other_countries = c::World_countries_without_russia - o::Sms_sic_plus

  o::Country_group_1 = ( m::Sic_countries + [c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya]).sort
  o::Country_group_2 = (m::Europe_countries + [c::Izrail, c::Kanada, c::Ssha, c::Turtsiya]).sort
  o::Country_group_3 = c::Australia_countries
  o::Country_group_4 = c::Asia_countries - o::Country_group_2
  o::Country_group_5 = c::World_countries_without_russia - o::Country_group_1 - o::Country_group_2 - o::Country_group_3 - o::Country_group_4
  
  o::Warm_welcome_plus_1 = [c::Ukraina, c::Armeniya, c::Kazahstan, c::Kyrgyzstan, c::Tadzhikistan, c::Turkmenistan].sort
  o::Warm_welcome_plus_2 = [c::Abhaziya, c::Uzhnaya_osetiya].sort
  o::Warm_welcome_plus_3 = [c::Gruziya, ]
  o::Warm_welcome_plus_4 = [c::Uzbekistan, ]
  o::Warm_welcome_plus_5 = [c::Azerbaidzhan, c::Belarus].sort
  o::Warm_welcome_plus_6 = [c::Moldova]
  
  o::International_1 = (m::Sic_countries + [c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya]).sort
  o::International_2 = (c::Europe_countries + [c::Turtsiya, c::Izrail] + c::Asia_countries).sort
  o::International_3 = [c::Kanada, c::Ssha].sort
  o::International_5 = [c::Gabon, c::Gambiya, c::Gvineya_bisau, c::Demokraticheskaya_respublika_kongo, c::Zimbabve, c::Komorskie_o_va, c::Kongo, c::Kuba, c::Maldivskie_o_va, 
    c::Martinika, c::Papua_novaya_gvineya, c::San_tome_i_prinsipi, c::Somali, c::Serra_leone, c::Togo, c::Folklendskie_o_va, c::Tsentralno_afrikanskaya_respublika, c::Chili, 
    c::Ekvatorialnaya_gvineya].sort
  o::International_4 = c::World_countries_without_russia - o::International_1 - o::International_2 - o::International_3 - o::International_5

  o::Around_world_countries_1 = (m::Europe_countries + [c::Turtsiya]).sort
  o::Around_world_countries_2 = (m::Sic_countries + [c::Gruziya, c::Abhaziya, c::Uzhnaya_osetiya]).sort
  o::Around_world_countries_3 = [c::Vetnam, c::Gonkong, c::Egipet, c::Izrail, c::Koreya_severnaya, c::Koreya_uzhnaya, c::Oae, c::Puerto_riko, c::Ssha, c::Tailand, c::Yaponiya].sort
  o::Around_world_countries_4 = c::World_countries_without_russia - o::Around_world_countries_1 - o::Around_world_countries_2 - o::Around_world_countries_3
  o::Around_world_countries_5 = [c::Ukraina, c::Avstriya, c::Armeniya, c::Belarus, c::Velikobritaniya, c::Germaniya, c::Gretsiya, c::Egipet, c::Izrail, c::Irlandiya, 
    c::Ispaniya, c::Italiya, c::Latviya, c::Litva, c::Lihtenshtein, c::Oae, c::Portugaliya, c::Rumyniya, c::Turtsiya, c::Finlyandiya, c::Frantsiya, c::Horvatiya, 
    c::Chehiya, c::Shveitsariya, c::Estoniya, c::Uar].sort
  
  o::Call_to_all_country_1 = [c::Kitai]
  o::Call_to_all_country_3_5 = [c::Uzhnaya_osetiya, ]
  o::Call_to_all_country_4 = [c::Ssha, c::Kanada, c::Indiya, ].sort
  o::Call_to_all_country_4_5 = [c::Vetnam, ]
  o::Call_to_all_country_5 = [c::Koreya_uzhnaya, c::Polsha, c::Portugaliya, c::Tailand, c::Uzbekistan].sort
  o::Call_to_all_country_6 = [c::Bolgariya, c::Vengriya, c::Germaniya, c::Gretsiya, c::Gruziya, c::Daniya, c::Irlandiya, c::Ispaniya, c::Italiya, c::Kipr, c::Litva, 
    c::Niderlandy, c::Norvegiya, c::Rumyniya, c::Tadzhikistan, c::Turkmenistan, c::Finlyandiya, c::Frantsiya, c::Chehiya, c::Shvetsiya].sort
  o::Call_to_all_country_7 = [c::Islandiya, ]
  o::Call_to_all_country_8 = [c::Armeniya, c::Egipet, c::Kazahstan, c::Kyrgyzstan, c::Latviya, c::Luksemburg, c::Turtsiya, c::Horvatiya ].sort
  o::Call_to_all_country_9 = [c::Andorra, c::Slovakiya, c::Yaponiya].sort
  o::Call_to_all_country_10 = [c::Ukraina, c::Izrail, c::Malta, c::Oae,].sort
  o::Call_to_all_country_11 = [c::Velikobritaniya, c::Abhaziya, c::Moldova].sort
  o::Call_to_all_country_12 = [c::San_marino,]
  o::Call_to_all_country_13 = [c::Avstriya, ]
  o::Call_to_all_country_14 = [c::Avstraliya, c::Estoniya, c::Uar].sort
  o::Call_to_all_country_15 = [c::Azerbaidzhan, c::Belarus, c::Lihtenshtein].sort
  o::Call_to_all_country_16 = [c::Bosniya_i_gertsegovina, c::Shveitsariya].sort
  o::Call_to_all_country_17 = [c::Monako,]
  o::Call_to_all_country_18 = [c::Belgiya, c::Makedoniya, c::Serbiya, c::Chernogoriya].sort
  o::Call_to_all_country_19 = [c::Gibraltar, c::Indoneziya].sort
  o::Call_to_all_country_20 = [c::Albaniya, ]
  o::Call_to_all_country_23 = [c::Tunis]
  o::Call_to_all_country_30 = [c::Grenlandiya, c::Kuba, c::Sloveniya].sort
   
   o::Discount_on_calls_to_russia_and_all_incoming = c::World_countries_without_russia - [c::Ukraina, c::Avstriya, c::Albaniya, c::Andorra, c::Armeniya, c::Belarus, c::Belgiya, 
     c::Bolgariya, c::Bosniya_i_gertsegovina, c::Velikobritaniya, c::Vengriya, c::Germaniya, c::Grenlandiya, c::Gretsiya, c::Uzhnaya_osetiya, c::Daniya, c::Irlandiya, 
     c::Islandiya, c::Ispaniya, c::Italiya, c::Kipr, c::Latviya, c::Litva, c::Lihtenshtein, c::Luksemburg, c::Makedoniya, c::Malta, c::Moldova, c::Monako, c::Niderlandy, 
     c::Norvegiya, c::Polsha, c::Portugaliya, c::Rumyniya, c::San_marino, c::Serbiya, c::Slovakiya, c::Turtsiya, c::Finlyandiya, c::Frantsiya, c::Horvatiya, c::Chernogoriya, 
     c::Chehiya, c::Shveitsariya, c::Shvetsiya, c::Estoniya]


end

