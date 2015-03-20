#Интернет-Mini
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_internet_mini, :name => 'Интернет-Mini', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_phone/additionally_services/unlim_options/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_mts_planshet, _mts_bit, _mts_super_bit, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip]}, 
      :internet_smart => [_mts_mts_planshet, _mts_additional_internet_500_mb, _mts_additional_internet_1_gb, _mts_super_bit],
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4, _mts_smart_top], :to_serve => []},
    :multiple_use => false
  } } )

#auto_turbo_buttons 
_sctcg_all_russia_rouming_internet = {:name => '_sctcg_all_russia_rouming_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 350.0})

#All Russia rouming, internet, with turbo-buttons
  @tc.add_one_service_category_tarif_class(_sctcg_all_russia_rouming_internet, {}, 
    {:calculation_order => 0, :price => 0.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_internet_mini', :description => '', 
     :formula => {
       :window_condition => "(3000.0 >= sum_volume)", :window_over => 'month', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 3000.0) / 500.0)",
           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 3000.0) / 2000.0)"},
       :method => "price_formulas.price + case when count_of_usage_of_500 > 2.66667 then count_of_usage_of_2000 * 200.0 when count_of_usage_of_500 > 0.0 then count_of_usage_of_500 * 75.0 else 0.0 end",
       }
     }, 
    } )

@tc.add_tarif_class_categories

#есть описание в pdf
#турбо-кнопки добавлены в опцию, а не отдельно
#TODO не добавлена кнопка "Турбо-ночи"
