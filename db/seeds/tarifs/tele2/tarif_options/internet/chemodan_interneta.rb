@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_chemodan_interneta, :name => 'Чемодан интернета', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/internet/dlya-telefonov/chemodan-interneta-3g4g/'},
  :dependency => {
    :incompatibility => {
      :internet_options => [_tele_internet_from_phone, _tele_paket_interneta, _tele_portfel_interneta, _tele_chemodan_interneta, _tele_day_in_net]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [ _tele_add_speed_3gb, _tele_add_speed_100mb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_tele_black, _tele_very_black, _tele_most_black], :to_serve => []},
    :multiple_use => false
  } } )

#internet included in tarif
scg_tele_chemodan_interneta = @tc.add_service_category_group(
    {:name => 'scg_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_chemodan_interneta"}, 
    {:calculation_order => 0, :price => 899.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_tele_chemodan_interneta', :description => '', 
     :formula => {
       :window_condition => "(30000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "price_formulas.price",
     }, 
    } )

  #internet for scg_tele_add_speed_100mb option
  scg_tele_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_100mb_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_add_speed_100mb_tele_chemodan_interneta"}, 
    {:calculation_order => 1, :price => 15.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_tele_add_speed_100mb_tele_chemodan_interneta', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'day',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_100 => "ceil((sum((description->>'volume')::float) - 0.0) / 100.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_100, 0.0) + 0.01",
       }
     },
     } 
    )

  #internet for scg_tele_add_speed_3gb option
  scg_tele_add_speed_3gb= @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_3gb_tele_chemodan_interneta' }, 
    {:name => "price for scg_tele_add_speed_3gb_tele_chemodan_interneta"}, 
    {:calculation_order => 2, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_tele_add_speed_3gb_tele_chemodan_interneta', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_3000 => "ceil((sum((description->>'volume')::float) - 0.0) / 3000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_3000, 0.0) + 0.02",
       }
     },
     } 
    )
   
   #Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 0.0})  

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_chemodan_interneta[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_chemodan_interneta[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_100mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_3gb[:id], :tarif_set_must_include_tarif_options => [_tele_add_speed_3gb] )

@tc.add_tarif_class_categories
