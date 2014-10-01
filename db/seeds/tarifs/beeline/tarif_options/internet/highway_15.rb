@tc = ServiceHelper::TarifCreator.new(_beeline)
@tc.create_tarif_class({
  :id => _bln_highway_15, :name => 'Хайвей 15 Гб', :operator_id => _beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/highway-15gb/'},
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_1, _bln_highway_3, _bln_highway_7, _bln_highway_15, _bln_highway_30, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {
      :to_switch_on => 
        [_bln_all_for_150, _bln_all_for_390, _bln_all_for_600, _bln_all_for_900, _bln_all_for_1200, _bln_all_for_2700,
         _bln_all_for_600_post, _bln_all_for_900_post, _bln_all_for_1200_post, _bln_all_for_2700_post, _bln_total_all_post,
         _bln_go], 
       :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_highway_15 = @tc.add_service_category_group(
    {:name => 'scg_bln_highway_15' }, 
    {:name => "price for scg_bln_highway_15"}, 
    {:calculation_order => 0, :price => 850.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_bln_highway_15', :description => '', 
     :formula => {
       :window_condition => "(15000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_200 => "ceil((sum((description->>'volume')::float) - 15000.0) / 200.0)"},
       :method => "price_formulas.price + count_of_usage_of_200 * 20.0",
       }
     }, 
    } )


#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_15[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_highway_15[:id])



@tc.add_tarif_class_categories


