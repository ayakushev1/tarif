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

#TarifClass
_tarif_classes = {
  :Beeline => {
    :private => {
      :tarif => (0..2),#(0..12),
      :operator_rouming => (75..75),
      :country_rouming => (93..93),
      :world_rouming => (77..77),
      :services => (80..92),
    }, 
    :corporate => {
      :tarif => (50..51),#(50..55),
      :operator_rouming => (71..71),
      :country_rouming => (72..72),
      :world_rouming => (73..73),
      :services => (),
    }
  },
  :Megafon => {
    :private => {
      :tarif => (100..101),#(100..113),
      :operator_rouming => (175..175),
      :country_rouming => (176..176),
      :world_rouming => (177..177),
      :services => (),
    }, 
    :corporate => {
      :tarif => (150..151),#(150..160),
      :operator_rouming => (171..171),
      :country_rouming => (172..172),
      :world_rouming => (173..173),
      :services => (),
    }
  },
  :MTS => {
    :private => {
      :tarif => (200..201),#(200..210),
      :operator_rouming => (275..275),
      :country_rouming => (276..276),
      :world_rouming => (277..277),
      :services => (280..292),
    }, 
    :corporate => {
      :tarif => (250..251),#(250..260),
      :operator_rouming => (271..271),
      :country_rouming => (272..272),
      :world_rouming => (273..273),
      :services => (),
    }
  },  
}

_all_loaded_tarifs = []
_tarif_classes.each do |operator, privacies|
  privacies.each do |privacy, tarif_range_collection| 
    tarif_range_collection.each do |name, tarif_range|
      tarif_range.each {|tarif| _all_loaded_tarifs << tarif} if tarif_range 
    end
  end 
end
  
#Standard Category blocks
_stand_cat = {
  :local => {
    :one_time => [_tarif_switch_on],
    :periodic => [_periodic_monthly_fee],
    :rouming_id => _own_region_rouming, 
    :service_type => {
      :one_side => { :stan_serv => _one_side_services},
      :two_side_in => { :stan_serv => _two_side_services_in_way},
      :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_country, _service_to_not_own_country], 
                         :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
    }
  },
  :home_region => {
    :one_time => [_tarif_switch_on],
    :periodic => [_periodic_monthly_fee],
    :rouming_id => _home_region_rouming, 
    :service_type => {
      :one_side => { :stan_serv => _one_side_services },
      :two_side_in => { :stan_serv => _two_side_services_in_way},
      :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_country, _service_to_not_own_country], 
                         :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
    }
  },  
  :home_country => {
    :one_time => [_tarif_switch_on],
    :periodic => [_periodic_monthly_fee],
    :rouming_id => _own_country_rouming, 
    :service_type => {
      :one_side => { :stan_serv => _one_side_services },
      :two_side_in => { :stan_serv => _two_side_services_in_way},
      :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_country, _service_to_not_own_country], 
                         :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
    }
  },  
  :world => {
    :one_time => [_tarif_switch_on],
    :periodic => [_periodic_monthly_fee],
    :rouming_id => _all_world_rouming, 
    :service_type => {
      :one_side => { :stan_serv => _one_side_services },
      :two_side_in => { :stan_serv => _two_side_services_in_way},
      :two_side_out => { :stan_serv => _two_side_services_out_way, :geo => [_service_to_own_region, _service_to_home_region, _service_to_own_country, _service_to_not_own_country], 
                         :partner_type => [_service_to_own_operator, _service_to_other_operator, _service_to_fixed_line] },
    }
  },  
}


  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_tarifs