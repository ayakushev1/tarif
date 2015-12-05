@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_m, :name => 'Интернет M', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_m.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => [_mgf_add_speed_1gb, _mgf_add_speed_5gb]},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip], :to_serve => []},
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_m = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_m' }, 
    {:name => "price for scg_mgf_internet_m"}, 
    {:calculation_order => 0, :price => 590.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_m', :description => '', 
     :formula => {
       :window_condition => "(8000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "price_formulas.price",
     }, 
    } )

  #internet for add_speed_1gb option
  scg_mgf_add_speed_1gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_1gb_mgf_internet_m' }, 
    {:name => "price for scg_mgf_add_speed_1gb_mgf_internet_m"}, 
    {:calculation_order => 1, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mgf_add_speed_1gb_mgf_internet_m', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_1000 => "ceil((sum((description->>'volume')::float) - 0.0) / 1000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_1000, 0.0) + 0.01",
       }
     },
     } 
    )

  #internet for add_speed_4gb option
  scg_mgf_add_speed_5gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_add_speed_5gb_mgf_internet_m' }, 
    {:name => "price for scg_mgf_add_speed_5gb_mgf_internet_m"}, 
    {:calculation_order => 2, :price => 400.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'scf_mgf_add_speed_5gb_mgf_internet_m', :description => '', 
     :formula => {
       :auto_turbo_buttons  => {
         :group_by => 'month',
         :stat_params => {
           :sum_volume => "sum((description->>'volume')::float)",
           :count_of_usage_of_5000 => "ceil((sum((description->>'volume')::float) - 0.0) / 5000.0)"},
       :method => "price_formulas.price * GREATEST(count_of_usage_of_5000, 0.0) + 0.02",
       }
     },
     } 
    )
   
#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_m[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
#  @tc.add_only_service_category_tarif_class(category)  
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_m[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_1gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_1gb] )
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_add_speed_5gb[:id], :tarif_set_must_include_tarif_options => [_mgf_add_speed_5gb] )


@tc.add_tarif_class_categories

#-При въезде в регионы, где технически доступна сеть 4G+, услуги по передаче данных будут предоставляться автоматически в сетях 4G+ при наличии у абонента мобильного устройства, поддерживающего технологию LTE (4G+), и USIM-карты;
#-Максимально достижимая скорость в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого Вы осуществляете доступ в Интернет;
#-Опция не подключается совместно с другими опциями и пакетами мобильного интернета с включенным объемом интернет-трафика на максимальной скорости;
#-Для подключения новой опции необходимо отключить имеющуюся опцию/пакет;
#-При отказе от опций отключение происходит с текущего момента;
#-При достижении включенного объема трафика доступ в Интернет приостанавливается и автоматически возобновляется с начала нового месяца, а также при подключении опций линейки «Продли скорость».
