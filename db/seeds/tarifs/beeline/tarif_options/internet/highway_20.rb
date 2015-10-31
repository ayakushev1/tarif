@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_highway_20, :name => 'Хайвей 20 Гб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/hayvey-20-gb-tv/'},
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_1, _bln_highway_4, _bln_highway_8, _bln_highway_12, _bln_highway_20, 
      _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_bln_all_for_200, _bln_all_for_400, _bln_all_for_600, _bln_all_for_900, _bln_all_for_1500, _bln_all_for_2700,
         _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1500_post, _bln_all_for_2700_post, _bln_total_all_post,],
    :forbidden_tarifs => { :to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_highway_20 = @tc.add_service_category_group(
    {:name => 'scg_bln_highway_20' }, 
    {:name => "price for scg_bln_highway_20"}, 
    {:calculation_order => 0, :price => 1200.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_bln_highway_20', :description => '', 
     :formula => {
       :window_condition => "(20000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_1000 => "GREATEST(ceil((sum((description->>'volume')::float) - 20000.0) / 1000.0), 0.0)",
           :count_of_usage_of_3000 => "GREATEST(ceil((sum((description->>'volume')::float) - 20000.0) / 3000.0), 0.0)"},
       :method => "price_formulas.price + case when count_of_usage_of_1000 > 2.0 then 200.0 * count_of_usage_of_3000 else 100.0 * count_of_usage_of_1000 end",
       }
     }, 
    } )


#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_20[:id])

#_sc_rouming_bln_all_russia_except_some_regions_for_internet, Internet
  category = {:name => 'all_russia_except_some_regions_for_internet_internet', :service_category_rouming_id => _sc_rouming_bln_all_russia_except_some_regions_for_internet, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_20[:id])



@tc.add_tarif_class_categories


