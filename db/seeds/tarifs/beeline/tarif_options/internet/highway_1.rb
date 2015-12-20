@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_highway_1, :name => 'Хайвей 1 Гб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/highway-1gb/'},
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_1, _bln_highway_4, _bln_highway_8, _bln_highway_12, _bln_highway_20, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_bln_add_speed_1gb, _bln_add_speed_3gb, _bln_auto_add_speed]},
    :prerequisites => [_bln_all_for_200, _bln_all_for_400, _bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
         _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post,],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_highway_1 = @tc.add_service_category_group(
    {:name => 'scg_bln_highway_1' }, 
    {:name => "price for scg_bln_highway_1"}, 
    {:calculation_order => 0, :price => 200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_bln_highway_1', :description => '', 
     :formula => {
       :window_condition => "(1000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "price_formulas.price",
     }, 
    } )

  #internet for add_speed_1gb option
  scg_bln_add_speed_1gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_1gb_bln_highway_1' }, 
    {:name => "price for scg_bln_add_speed_1gb_bln_highway_1"}, 
    {:calculation_order => 1, :price => 250.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_add_speed_1gb_bln_highway_1', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_1000 => "ceil((sum((description->>'volume')::float) - 0.0) / 1000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_1000, 0.0) + 0.0",
       }
     },
     } 
    )

  #internet for add_speed_4gb option
  scg_bln_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_bln_add_speed_3gb_bln_highway_1' }, 
    {:name => "price for scg_bln_add_speed_3gb_bln_highway_1"}, 
    {:calculation_order => 2, :price => 500.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_add_speed_3gb_bln_highway_1', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_4000 => "ceil((sum((description->>'volume')::float) - 0.0) / 4000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_4000, 0.0) + 0.0",
       }
     },
     } 
    )
   
#internet for auto_add_speed option
  scg_bln_auto_add_speed= @tc.add_service_category_group(
    {:name => 'scg_bln_auto_add_speed_bln_highway_1' }, 
    {:name => "price for scg_bln_auto_add_speed_bln_highway_1"}, 
    {:calculation_order => 3, :price => 20.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_bln_auto_add_speed_bln_highway_1', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_75 => "ceil((sum((description->>'volume')::float) - 0.0) / 75.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_75, 0.0) + 0.0",
       }
     },
     } 
    )

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_1[:id])

#_sc_rouming_bln_cenral_regions_not_moscow_regions, Internet
  category = {:name => '_sc_rouming_bln_cenral_regions_not_moscow_regions_internet', :service_category_rouming_id => _sc_rouming_bln_cenral_regions_not_moscow_regions, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_1[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed] )

#_sc_rouming_bln_exept_for_cenral_regions_not_moscow_regions, Internet
  category = {:name => '_sc_rouming_bln_all_russia_except_some_regions_for_internet_internet', :service_category_rouming_id => _sc_rouming_bln_all_russia_except_some_regions_for_internet, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_1[:id], :tarif_set_must_include_tarif_options => [_bln_30_days_of_internet_for_russia_rouming] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_1gb, _bln_30_days_of_internet_for_russia_rouming] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_bln_add_speed_3gb, _bln_30_days_of_internet_for_russia_rouming] )
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_auto_add_speed[:id], :tarif_set_must_include_tarif_options => [_bln_auto_add_speed, _bln_30_days_of_internet_for_russia_rouming] )


@tc.add_tarif_class_categories


