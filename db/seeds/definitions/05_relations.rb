def access_methods_to_constant_relations
#operator_country_groups
_relation_mts_europe_countries = 10200; _relation_mts_sic_countries = 10201; _relation_mts_sic_1_countries = 10202; _relation_mts_sic_2_countries = 10203;
_relation_mts_sic_2_1_countries = 10204; _relation_mts_sic_2_2_countries = 10205;
_relation_mts_sic_3_countries = 10206; _relation_mts_other_countries = 10207;
_relation_mts_calls_from_11_9_option_countries_1 = 10208; _relation_mts_calls_from_11_9_option_countries_2 = 10209;
_relation_mts_internet_bit_abrod_1 = 10210; _relation_mts_internet_bit_abrod_2 = 10211; 
_relation_mts_internet_bit_abrod_3 = 10212; _relation_mts_internet_bit_abrod_4 = 10213;

_relation_mts_love_countries_4_9 = 10215; _relation_mts_love_countries_5_5 = 10216; _relation_mts_love_countries_5_9 = 10217;
_relation_mts_love_countries_6_9 = 10218; _relation_mts_love_countries_7_9 = 10219; _relation_mts_love_countries_8_9 = 10220;
_relation_mts_love_countries_9_9 = 10221; _relation_mts_love_countries_11_5 = 10222; _relation_mts_love_countries_12_9 = 10223; 
_relation_mts_love_countries_14_9 = 10224; _relation_mts_love_countries_19_9 = 10225; _relation_mts_love_countries_29_9 = 10226; 
_relation_mts_love_countries_49_9 = 10227;

_relation_mts_your_country_1 = 10228; _relation_mts_your_country_2 = 10229; _relation_mts_your_country_3 = 10230;
_relation_mts_your_country_4 = 10231; _relation_mts_your_country_5 = 10232; _relation_mts_your_country_6 = 10233;
_relation_mts_your_country_7 = 10234; _relation_mts_your_country_8 = 10235; _relation_mts_your_country_9 = 10236

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_relations