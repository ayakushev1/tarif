@tc = TarifCreator.new(Category::Operator::Const::Beeline)
@tc.create_tarif_class({
  :id => _bln_internet_on_day_500_mb, :name => 'Интернет на день 500 Мб', :operator_id => Category::Operator::Const::Beeline, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moskva.beeline.ru/customers/products/mobile/services/details/internet-na-den-500mb/'},
  :dependency => {
    :incompatibility => {:internet_options => [_bln_highway_1, _bln_highway_3, _bln_highway_7, _bln_highway_15, _bln_highway_30, _bln_internet_on_day_100_mb, _bln_internet_on_day_500_mb]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Добавление новых service_category_group
#internet included in tarif
scg_bln_internet_on_day_500_mb = @tc.add_service_category_group(
    {:name => 'scg_bln_internet_on_day_500_mb' }, 
    {:name => "price for scg_bln_internet_on_day_500_mb"}, 
    {:calculation_order => 0, :price => 29.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_bln_internet_on_day_500_mb', :description => '', 
     :formula => {
       :window_condition => "(500.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 500.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )


#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_internet_on_day_500_mb[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_bln_internet_on_day_500_mb[:id])



@tc.add_tarif_class_categories


