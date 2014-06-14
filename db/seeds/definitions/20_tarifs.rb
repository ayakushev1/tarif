def access_methods_to_constant_tarifs
#tarid_ids
_mts_smart = 201; _mts_smart_mini = 202; _mts_smart_plus = 203;  

#common_services_ids
_mts_own_country_rouming = 276; _mts_international_rouming = 277;

#tarif option ids
_mts_everywhere_as_home = 293;
_mts_smart_groups = 294; _mts_smart_mini_groups = 295; _mts_smart_plus_groups = 296; 
_mts_smart_groups_with_everywhere_as_home = 297; _mts_smart_mini_groups_with_everywhere_as_home = 298; _mts_smart_plus_groups_with_everywhere_as_home = 299;

#correct_tarif_class_ids
  _correct_tarif_class_ids = [
    _mts_smart, _mts_smart_mini, _mts_smart_plus,
    _mts_own_country_rouming, _mts_international_rouming,
    _mts_everywhere_as_home, 
    _mts_smart_groups, _mts_smart_mini_groups, _mts_smart_plus_groups,
    _mts_smart_groups_with_everywhere_as_home, _mts_smart_mini_groups_with_everywhere_as_home, _mts_smart_plus_groups_with_everywhere_as_home,
    ]  
  _correct_tarif_list_ids = []  


#_all_loaded_tarifs = []
  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_tarifs