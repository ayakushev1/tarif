@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_24, :name => 'Интернет 24', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_24.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      :mgf_internet_in_russia_for_specific_options => []}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_l, _mgf_all_included_m, _mgf_all_included_vip], :to_serve => []},
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_24 = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_24' }, 
    {:name => "price for scg_mgf_internet_24"}, 
    {:calculation_order => 0, :price => 24.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_24', :description => '', 
     :formula => {
       :window_condition => "(200.0 >= sum_volume)", :window_over => 'day',
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
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_24[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.5})  

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_24[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :price => 0.5})  


@tc.add_tarif_class_categories

#-При въезде в регионы, где технически доступна сеть 4G+, услуги по передаче данных будут предоставляться автоматически в сетях 4G+ при наличии у абонента мобильного устройства, поддерживающего технологию LTE (4G+), и USIM-карты.
#-Максимально достижимая скорость в каждом конкретном случае зависит от технических возможностей сети и оборудования, с помощью которого вы осуществляете доступ в Интернет. 
#-Опция доступна для подключения на всех тарифах, кроме тарифов серии «МегаФон — Все включено», «Видеоконтроль», «Детский Интернет», «МегаФон-Логин Оптимальный», «ММС-Камера».
#-Сверх 200 МБ в сутки далее до начала новых суток действует тариф 0,5 ₽ за 1 МБ (с почасовым округлением до 1 КБ).
#-Плата за пользование опцией «Интернет 24» не списывается, если в течение суток вы не пользовались мобильным интернетом. Сутки считаются с 00:00 до 24:00.
#-Опция не подключается совместно с другими опциями и пакетами мобильного интернета с включенным объемом интернет-трафика на максимальной скорости. 
#-Для подключения новой опции необходимо отключить имеющуюся опцию/пакет.
#-При отказе от опций отключение происходит с текущего момента. 
#-При достижении включенного объема трафика доступ в Интернет приостанавливается и автоматически возобновляется при подключении опций линейки «Продли скорость».
