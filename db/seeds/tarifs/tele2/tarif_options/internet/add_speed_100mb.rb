@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_add_speed_100mb, :name => 'Добавить скорости 100Mb', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/internet/dlya-telefonov/dobavit-skorost/'},
  :dependency => {
    :incompatibility => {
      :internet_options => [_tele_internet_from_phone, _tele_day_in_net, _tele_add_speed_3gb, _tele_add_speed_100mb]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_tele_black, _tele_very_black, _tele_most_black],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#sms included in tarif
scg_tele_add_speed_100mb = @tc.add_service_category_group(
    {:name => 'scg_tele_add_speed_100mb' }, 
    {:name => "price for scg_tele_add_speed_100mb"}, 
    {:calculation_order => 0, :price => 15.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_tele_add_speed_100mb', :description => '', 
     :formula => {
       :window_condition => "(100.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 100.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }

#       :auto_turbo_buttons  => {
#         :group_by => 'month',
#         :stat_params => {
#           :sum_volume => "sum((description->>'volume')::float)",
#           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 5000.0) / 500.0)"},
#       :method => "price_formulas.price + case when count_of_usage_of_500 > 1.0 then count_of_usage_of_500 * 30.0 else 0.0 end",
#       }
     }, 
    } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 0.0})  

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_tele_add_speed_100mb[:id])

@tc.add_tarif_class_categories
