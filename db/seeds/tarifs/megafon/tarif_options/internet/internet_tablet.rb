@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_tablet, :name => 'Интернет Планшет', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/internet_tablet.html'},
  :dependency => {
    :incompatibility => {:mgf_internet_tablet => [_mgf_internet_tablet, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_megafon_online],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Переход на тариф
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => _stf_price_by_1_item, :price => 100.0})  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 0.0})

  
 
#Добавление новых service_category_group
#internet included in tarif
scg_mgf_internet_tablet = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_tablet' }, 
    {:name => "price for scg_mgf_internet_tablet"}, 
    {:calculation_order => 0, :price => 30.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_internet_tablet', :description => '', 
     :formula => {
       :window_condition => "(320.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {
         :sum_volume => "sum((description->>'volume')::float)",
         :volume_more_than_20 => "(sum((description->>'volume')::float) - 20.0)"},
       :method => "case when volume_more_than_20 > 0.0 then price_formulas.price else 0.0 end",
     }, 
    } )

#_all_russia_rouming, Internet
  category = {:name => '_sctcg_own_home_regions_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_tablet[:id])


@tc.add_tarif_class_categories

#Ограничение максимальной скорости до 64 кбит/с снимается ежедневно с началом новых суток.
#Для того чтобы пользоваться опцией «БИТ PRO», «БИТ MegaPro 150» и «БИТ MegaPro 250» в поездках по России, подключите опцию «Интернет по России».
#Опции доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «Гибкий», «Домашний», «МегаФон – Все включено», «Нон-Стоп», «О`Хард», «Первый Федеральный», «Подмосковный», «Приём», «Свобода слова», «Студенческий», «Тариф», «Твоё время», «Твоя сеть», «Тёплый приём 2009», а также на тарифах «5+», «FIX», «FiXL», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Болельщик», «Вокруг света», «Дневник.ру», «Единый», «За Три», «Классический», «Коммуникатор», «Контакт», «Международный», «Мобильный», «Ноль по области», «О`Лайт», «Один к одному!», «Переходи на ноль 2012», «Просто», «Ринг-Динг», «Рублевый», «Своя сеть», «Связь городов», «Смешарики», «УльтраЛАЙТ», «ФиксЛАЙТ».
