@tc = TarifCreator.new(_tele_2)
@tc.create_tarif_class({
  :id => _tele_day_in_net, :name => 'День в сети', :operator_id => _tele_2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/internet/skidki/den-v-seti/'},
  :dependency => {
    :incompatibility => {
      :internet_options => [_tele_internet_from_phone, _tele_paket_interneta, _tele_portfel_interneta, _tele_chemodan_interneta, 
        _tele_day_in_net, _tele_add_speed_3gb, _tele_add_speed_100mb]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_tele_black, _tele_very_black, _tele_most_black], :to_serve => []},
    :multiple_use => false
  } } )

#sms included in tarif
scg_tele_day_in_net = @tc.add_service_category_group(
    {:name => 'scg_tele_day_in_net' }, 
    {:name => "price for scg_tele_day_in_net"}, 
    {:calculation_order => 0, :price => 0.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_tele_day_in_net', :description => '', 
     :formula => {
       :window_condition => "(250.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "price_formulas.price",
#       
#       :multiple_use_of_tarif_option => {
#         :group_by => 'day',
#         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 250.0)", :sum_volume => "sum((description->>'volume')::float)"},
#         :method => "15.0 * tarif_option_count_of_usage", 
#       }
     }, 
    } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 50.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 450.0})

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_day_in_net[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_day_in_net[:id])

@tc.add_tarif_class_categories
