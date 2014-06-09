def access_methods_to_constant_relations
#operator_country_groups
_relation_mts_europe_countries = 10200; _relation_mts_sic_countries = 10201; _relation_mts_sic_1_countries = 10202; _relation_mts_sic_2_countries = 10203;
_relation_mts_sic_3_countries = 10204; _relation_mts_other_countries = 10205;


  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_relations