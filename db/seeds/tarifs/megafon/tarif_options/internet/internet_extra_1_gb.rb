@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_extra_1_gb, :name => 'Интернет-экстра 1 ГБ', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet-ekstra_1_gb.html'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_extra_1_gb = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_extra_1_gb' }, 
    {:name => "price for scg_mgf_internet_extra_1_gb"}, 
    {:calculation_order => 0, :price => 150.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_additional_internet_2_gb_for_smart', :description => '', 
     :formula => {
       :window_condition => "(1000.0 >= sum_volume)", :window_over => 'month',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 1000.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_extra_1_gb[:id])

@tc.add_tarif_class_categories

#Пакет действует только при нахождении в Московском регионе.
#При подключении пакета 1 ГБ Интернет-трафика предоставляется единовременно разово в полном объеме.
#Одновременно можно подключить сразу несколько пакетов. В этом случае объем Интернет-трафика по каждому пакету предоставляется в полном объеме, при исчерпании пакета каждый последующий пакет начнет действовать после закрытия текущей и открытия новой Интернет-сессии.
#При отключении пакета неиспользованный объём трафика не сохраняется и не компенсируется.
#Максимально достижимая скорость приёма и передачи данных в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого осуществляется доступ в Интернет.
#Пакет «Интернет-экстра 1 ГБ» доступен для подключения только на тарифах линейки «МегаФон — Все включено». 
