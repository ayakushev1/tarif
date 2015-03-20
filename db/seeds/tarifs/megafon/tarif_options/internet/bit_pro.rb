@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_bit_pro, :name => 'БИТ PRO', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/bit_megafonpro.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_m, _mgf_all_included_l, _mgf_all_included_vip, 
      _mgf_sub_moscow, _mgf_around_world, _mgf_international, _mgf_city_connection, ],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_bit_pro = @tc.add_service_category_group(
    {:name => 'scg_mgf_bit_pro' }, 
    {:name => "price for scg_mgf_bit_pro"}, 
    {:calculation_order => 0, :price => 9.9, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_bit_pro', :description => '', 
     :formula => {
       :window_condition => "(80.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
     }, 
    } )

#Own and home regions, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_bit_pro[:id])

#Tarif option 'Интернет по России'
#Другие категории опции должны иметь мешьший приоритет, или не пересекаться с опцией

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 10.0},
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia] )

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_bit_pro[:id], 
    :tarif_set_must_include_tarif_options => [_mgf_internet_in_russia] )


@tc.add_tarif_class_categories

#Ограничение максимальной скорости до 64 кбит/с снимается ежедневно с началом новых суток.
#Для того чтобы пользоваться опцией «БИТ PRO», «БИТ MegaPro 150» и «БИТ MegaPro 250» в поездках по России, подключите опцию «Интернет по России».
#Опции доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «Гибкий», «Домашний», «МегаФон – Все включено», «Нон-Стоп», «О`Хард», «Первый Федеральный», «Подмосковный», «Приём», «Свобода слова», «Студенческий», «Тариф», «Твоё время», «Твоя сеть», «Тёплый приём 2009», а также на тарифах «5+», «FIX», «FiXL», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Болельщик», «Вокруг света», «Дневник.ру», «Единый», «За Три», «Классический», «Коммуникатор», «Контакт», «Международный», «Мобильный», «Ноль по области», «О`Лайт», «Один к одному!», «Переходи на ноль 2012», «Просто», «Ринг-Динг», «Рублевый», «Своя сеть», «Связь городов», «Смешарики», «УльтраЛАЙТ», «ФиксЛАЙТ».
