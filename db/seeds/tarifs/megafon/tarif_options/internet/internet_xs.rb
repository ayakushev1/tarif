@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_xs, :name => 'Интернет XS', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_xs.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_xs = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_xs' }, 
    {:name => "price for scg_mgf_internet_xs"}, 
    {:calculation_order => 0, :price => 7.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_xs', :description => '', 
     :formula => {
       :window_condition => "(70.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 70.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "19.0 * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_xs[:id])

#Tarif option 'Интернет по России для определенных опций'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией
#Подключение услуги
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item_if_used, :price => 30.0},
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 5.0},
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_xs[:id], 
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia_for_specific_options] )


@tc.add_tarif_class_categories

#-При въезде в регионы, где технически доступна сеть 4G+, услуги по передаче данных будут предоставляться автоматически в сетях 4G+ при наличии у абонента мобильного устройства, поддерживающего технологию LTE (4G+), и USIM-карты;
#-Максимально достижимая скорость в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого Вы осуществляете доступ в Интернет;
#-Опция не подключается совместно с другими опциями и пакетами мобильного интернета с включенным объемом интернет-трафика на максимальной скорости;
#-Для подключения новой опции необходимо отключить имеющуюся опцию/пакет;
#-При отказе от опций отключение происходит с текущего момента;
#-При достижении включенного объема трафика доступ в Интернет приостанавливается и автоматически возобновляется с начала нового месяца, а также при подключении опций линейки «Продли скорость».
