def access_methods_to_constant_tarifs
#MTS
#tarid_ids
  #processed
_mts_red_energy = 200; _mts_smart = 201; _mts_smart_mini = 202; _mts_smart_plus = 203; _mts_ultra = 204; _mts_mts_connect_4 = 205; 
_mts_mayak = 206; _mts_your_country = 207; _mts_super_mts = 208; _mts_umnyi_dom = 210;
_mts_super_mts_star = 209; #тариф не забит (и его по-моему вообще уже нет)
  
  #unprocessed
  _mts_a_mobile = 211;
  
  #new (after 20.09.2014) 
_mts_smart_top = 212
_mts_posekundny = 213 

  #new (after 11.10.2015) 
_mts_smart_nonstop = 214

#common_services_ids
_mts_own_country_rouming = 276; _mts_international_rouming = 277; _mts_own_country_rouming_internet = 312;
_mts_incoming_travelling_in_russia = 297;

#tarif option ids
  #calls
_mts_region = 328; _mts_95_cop_in_moscow_region = 329;
_mts_unlimited_calls = 330; _mts_call_free_to_mts_russia_100 = 331; _mts_zero_to_mts = 332;

  #calls_abroad
_mts_love_country = 281; _mts_love_country_all_world = 309; _mts_outcoming_calls_from_11_9_rur = 293;

  #country_rouming
_mts_everywhere_as_home = 294; _mts_everywhere_as_home_Ultra = 282; _mts_everywhere_as_home_smart = 283;
_mts_additional_minutes_150 = 321; _mts_additional_minutes_300 = 322;
_mts_single_country = 348   #new from 11.10.2015

  #international_rouming
_mts_zero_without_limits = 288; _mts_bit_abroad = 289; _mts_maxi_bit_abroad = 290; _mts_super_bit_abroad = 291;
_mts_100mb_in_latvia_and_litva = 292; 
_mts_free_journey = 347   #new from 11.10.2015

  #internet
_mts_internet_packet_200mb = 298; _mts_internet_packet_300mb = 299; _mts_internet_packet_450mb = 300; _mts_internet_packet_900mb = 301;#это архивные опции
_mts_bit = 302; _mts_super_bit = 303; _mts_mini_bit = 304;
_mts_additional_internet_500_mb =310; _mts_additional_internet_1_gb = 311;
_mts_turbo_button_500_mb = 313; _mts_turbo_button_2_gb = 314; 
_mts_internet_mini = 315; _mts_internet_maxi = 316; _mts_internet_super = 317; _mts_internet_vip = 318;
_mts_turbo_button_5_gb = 319; _mts_turbo_button_100_mb = 320;  #new from 11.10.2015
_mts_mts_planshet = 340; _mts_mts_planshet_online = 341;
_mts_unlimited_internet_on_day = 342
_mts_additional_internet_smart_mini =343; _mts_additional_internet_smart =344; _mts_additional_internet_smart_other =345; #new from 11.10.2015

  #mms
_mts_mms_packet_10 = 323; _mts_mms_packet_20 = 324; _mts_mms_packet_50 = 325; _mts_mms_discount_50_percent = 326;

  #service_to_country
_mts_rodnye_goroda = 280; 

  #sms
_mts_50_sms_travelling_in_russia = 295; _mts_100_sms_travelling_in_russia = 296; 
_mts_50_sms_in_europe = 305; _mts_100_sms_in_europe = 306; _mts_50_sms_travelling_in_all_world = 307; _mts_100_sms_travelling_in_all_world = 308;
_mts_onetime_sms_packet_50 = 333; _mts_onetime_sms_packet_150 = 334; _mts_onetime_sms_packet_300 = 335; 
_mts_monthly_sms_packet_100 = 336; _mts_monthly_sms_packet_300 = 337; _mts_monthly_sms_packet_500 = 338; _mts_monthly_sms_packet_1000 = 339;
_mts_unlimited_sms = 346   #new from 11.10.2015

#_mts_everywhere_as_home_smart_plus = 319; _mts_everywhere_as_home_smart_mini = 320

#correct_tarif_class_ids
  _correct_tarif_class_ids = []; _correct_tarif_list_ids = []  
#_all_loaded_tarifs = []
  


#Megafon
#tarifs
_mgf_around_world = 100; _mgf_all_simple = 101; 
_mgf_all_included_xs = 102; _mgf_all_included_s = 103; _mgf_all_included_m = 104; _mgf_all_included_l = 105; _mgf_all_included_vip = 106; _mgf_megafon_online = 107;
_mgf_international = 108; _mgf_go_to_zero = 109; _mgf_sub_moscow = 110; _mgf_city_connection = 112; _mgf_warm_welcome = 113;

#common_services
_mgf_own_country_rouming = 174; _mgf_international_rouming = 177; _mgf_intra_countries_services = 178; _mgf_mobile_internet = 179;

#tarif_options
#international rouming, calls
_mgf_all_world = 400; _mgf_30_minutes_all_world = 401; _mgf_far_countries = 402; _mgf_option_around_world = 403; _mgf_100_minutes_europe = 404;
_mgf_25_discount_on_calls_to_russia_and_all_incoming = 405; _mgf_50_discount_on_calls_to_russia = 406; _mgf_50_discount_on_all_incoming_calls = 407;
_mgf_minute_packs_25_europe = 489; _mgf_minute_packs_50_europe = 490; _mgf_minute_packs_25_world = 491; _mgf_minute_packs_50_world = 492  #new from 11.10.2015

#international rouming, sms
_mgf_50_sms_all_world = 410; _mgf_100_sms_all_world = 411; _mgf_50_sms_europe = 412; _mgf_100_sms_europe = 413

#international rouming, internet
_mgf_internet_abroad_10 = 430; _mgf_internet_abroad_30 = 431; _mgf_vacation_online = 432;

#own_country rouming, calls
_mgf_all_russia = 440; _mgf_travel_without_worry = 441; _mgf_everywhere_moscow_in_central_region = 442; 
_mgf_internet_in_russia = 443; _mgf_internet_in_russia_for_specific_options = 444; _mgf_gigabite_to_road = 445;
_mgf_be_as_home = 493  #new from 11.10.2015

#mms
_mgf_mms_24 = 450; _mgf_paket_mms_10 = 451; _mgf_paket_mms_50 = 452;

#sms
_mgf_option_for_sms_s = 455; _mgf_option_for_sms_l = 456; _mgf_option_for_sms_m = 457; _mgf_option_for_sms_xl = 458; 
_mgf_sms_stihia = 459;
_mgf_paket_sms_100 = 460; _mgf_paket_sms_150 = 461; _mgf_paket_sms_200 = 462; _mgf_paket_sms_350 = 463; _mgf_paket_sms_500 = 464; _mgf_paket_sms_1000 = 465;
_mgf_100_sms  = 466;

#["440", "441", "442", "", "442_455", "442_456", "442_457", "442_458", "442_459", "442_460", "442_461", "442_462", "442_463", "442_464", "442_465", "442_466", 
#  "455", "456", "457", "458", "459", "460", "461", "462", "463", "464", "465", "466"]



#calls
_mgf_unlimited_communication = 470; _mgf_call_to_russia = 471; _mgf_call_to_all_country = 472; _mgf_option_city_connection = 473;

#internet
_mgf_internet_extra_1_gb = 475;
_mgf_internet_xs = 476; _mgf_internet_s = 477; _mgf_internet_m = 478; _mgf_internet_l = 479; _mgf_internet_xl = 480;
_mgf_internet_24 = 481; _mgf_internet_24_pro = 482; 
_mgf_bit_pro = 484; _mgf_bit_mega_pro_150 = 485; _mgf_bit_mega_pro_250 = 486; _mgf_bit_mega_pro_500 = 487;
_mgf_internet_tablet = 488;  #new from 11.10.2015
 

#beeline
#tarifs
_bln_all_for_200 = 600; _bln_all_for_400 = 601; _bln_all_for_600 = 602; _bln_all_for_900 = 603; _bln_all_for_1500 = 604; _bln_all_for_2700 = 605;
_bln_all_for_600_post = 610; _bln_all_for_900_post = 611; _bln_all_for_1500_post = 612; _bln_all_for_2700_post = 613;  
_bln_total_all_post = 620; _bln_go = 621; _bln_welcome = 622; _bln_mobile_pencioner = 623; _bln_zero_doubts = 624; #_bln_first_child = 625; 
_bln_co_communication = 626; 

#    :prerequisites => [_bln_all_for_200, _bln_all_for_400, _bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
#                       _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post,
#                       _bln_go, _bln_welcome, _bln_mobile_pencioner, _bln_zero_doubts, _bln_co_communication, #_bln_first_child, 
#                       ],

#common_services
_bln_own_country_rouming = 650; _bln_international_rouming = 651; _bln_international_rouming_internet = 652; _bln_international_rouming_internet_post = 653; 
_bln_intra_countries_services = 654; _bln_mobile_internet = 655;

#tarif_options
#international rouming
_bln_planeta_zero = 660; ; _bln_my_planet = 661; _bln_the_best_internet_in_rouming = 662; _bln_planet_of_internet_post = 663; #_bln_week_of_internet_rouming = 664;

#country rouming
_bln_my_country = 670; 

#calls
_bln_my_intracity = 680; _bln_my_beeline = 681; _bln_my_beeline_post = 682; _bln_my_calls_to_other_countries = 683; #_bln_my_ukraine = 687; 

#sms
_bln_my_sms = 700; _bln_my_sms_post = 701; _bln_sms_without_borders = 702;

#mms
_bln_mms = 720;

#internet 
_bln_highway_1 = 730; _bln_highway_3 = 731; _bln_highway_7 = 732; _bln_highway_15 = 733; _bln_highway_30 = 734;
_bln_internet_on_day_100_mb = 735; _bln_internet_on_day_500_mb = 736;

#Tele2
#tarifs
_tele_black = 800; _tele_very_black = 801; _tele_orange = 802; _tele_yellow = 803; _tele_green = 804;
_tele_most_black = 805;   #new from 11.10.2015

#common_services
_tele_country_rouming = 830; _tele_international_rouming = 831;  _tele_intra_countries_services = 832;

#calls abroad
_tele_simple_geography = 850;   #new from 11.10.2015

#calls
_tele_zero_everywhere = 840;

#sms
_tele_sms_svoboda = 860; 
_tele_day_sms = 861;  #new from 11.10.2015

#internet
_tele_internet_from_phone = 880; _tele_paket_interneta = 881; _tele_portfel_interneta = 882; _tele_day_in_net = 883;
_tele_add_speed_3gb = 884; _tele_add_speed_100mb = 885; _tele_chemodan_interneta = 886;   #new from 11.10.2015

#international rouming, internet
_tele_internet_abroad = 890;   #new from 11.10.2015

#international rouming, calls
_tele_talks_without_limits = 895;   #new from 11.10.2015

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_tarifs