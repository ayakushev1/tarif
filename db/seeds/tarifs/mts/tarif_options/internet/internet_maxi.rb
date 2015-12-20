#TODO добавить 50 руб в день в роуминге по России
#Интернет-Maxi
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_internet_maxi, :name => 'Интернет-Maxi', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_phone/additionally_services/unlim_options/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_internet_super, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip], 
      :internet_smart => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb,  _mts_super_bit]},
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit], :higher => [_mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_ultra, _mts_smart_top, _mts_smart_nonstop], :to_serve => [_mts_ultra, _mts_smart_top, _mts_smart_nonstop]}, #:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4, _mts_smart_top], :to_serve => []},
    :multiple_use => false
  } } )

  #internet included in tarif
  scg_mts_internet_maxi_included_in_tarif_internet = @tc.add_service_category_group(
    {:name => 'scg_mts_internet_maxi_included_in_tarif_internet' }, 
    {:name => "price for _scg_mts_internet_maxi_included_in_tarif_internet"}, 
    {:calculation_order => 0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :price => 700.0, :name => 'scf_mts_internet_maxi_included_in_tarif_internet', :description => '', 
      :formula => {
       :window_condition => "(12000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "price_formulas.price",
     }, 
    } )

  #internet for add_speed_500mb option
  scg_mts_add_speed_500mb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_500mb_mts_internet_maxi' }, 
    {:name => "price for scg_mts_add_speed_500mb_mts_internet_maxi"}, 
    {:calculation_order => 1, :price => 95.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_500mb_mts_internet_maxi', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 0.0) / 500.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_500, 0.0) + 0.0",
       }
     },
     } 
    )

  #internet for add_speed_2gb option
  scg_mts_add_speed_2gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_2gb_mts_internet_maxi' }, 
    {:name => "price for scg_mts_add_speed_2gb_mts_internet_maxi"}, 
    {:calculation_order => 2, :price => 250.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_2gb_mts_internet_maxi', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 0.0) / 2000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_2000, 0.0) + 0.0",
       }
     },
     } 
    )

  #internet for add_speed_5gb option
  scg_mts_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mts_add_speed_5gb_mts_internet_maxi' }, 
    {:name => "price for scg_mts_add_speed_5gb_mts_internet_maxi"}, 
    {:calculation_order => 3, :price => 450.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mts_add_speed_5gb_mts_internet_maxi', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_5000 => "ceil((sum((description->>'volume')::float) - 0.0) / 5000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_5000, 0.0) + 0.0",
       }
     },
     } 
    )

#auto_turbo_buttons 
#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

#_own_and_home_regions_rouming, internet
category = {:name => '_sctcg_home_region_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_internet_maxi_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )

#All Russia rouming, internet, with turbo-buttons
category = {:name => '_sctcg_all_russia_rouming_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_internet_maxi_included_in_tarif_internet[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_500mb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_500_mb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_2gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_2_gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mts_turbo_button_5_gb] )

@tc.add_tarif_class_categories

#есть описание в pdf
#турбо-кнопки добавлены в опцию, а не отдельно
#TODO не добавлена кнопка "Турбо-ночи"
