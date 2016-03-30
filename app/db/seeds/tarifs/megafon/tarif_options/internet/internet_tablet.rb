@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_internet_tablet, :name => 'Интернет Планшет', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
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
  @tc.add_one_service_category_tarif_class(_sctcg_one_time_tarif_switch_on, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByItem, :formula => {:params => {:price => 100.0} } })  

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.0} } })

  #internet included in tarif
  scg_mgf_internet_tablet_20 = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_tablet_20' }, 
    {:name => "price for scg_mgf_internet_tablet_20"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice,  
      :formula => {:params => {:max_sum_volume => 20.0, :price => 0.0}, :window_over => 'day' } } )

  scg_mgf_internet_tablet_300 = @tc.add_service_category_group(
    {:name => 'scg_mgf_internet_tablet_300' }, 
    {:name => "price for scg_mgf_internet_tablet_300"}, 
    {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 300.0, :price => 30.0}, :window_over => 'day' } } )

#Own and home regions, Internet
  category = {:name => 'own_and_home_regions_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_tablet_20[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_tablet_300[:id])

#Own country, Internet
  category = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_tablet_20[:id])
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_internet_tablet_300[:id])


@tc.add_tarif_class_categories

#Ограничение максимальной скорости до 64 кбит/с снимается ежедневно с началом новых суток.
#Для того чтобы пользоваться опцией «БИТ PRO», «БИТ MegaPro 150» и «БИТ MegaPro 250» в поездках по России, подключите опцию «Интернет по России».
#Опции доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «Гибкий», «Домашний», «МегаФон – Все включено», «Нон-Стоп», «О`Хард», «Первый Федеральный», «Подмосковный», «Приём», «Свобода слова», «Студенческий», «Тариф», «Твоё время», «Твоя сеть», «Тёплый приём 2009», а также на тарифах «5+», «FIX», «FiXL», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Болельщик», «Вокруг света», «Дневник.ру», «Единый», «За Три», «Классический», «Коммуникатор», «Контакт», «Международный», «Мобильный», «Ноль по области», «О`Лайт», «Один к одному!», «Переходи на ноль 2012», «Просто», «Ринг-Динг», «Рублевый», «Своя сеть», «Связь городов», «Смешарики», «УльтраЛАЙТ», «ФиксЛАЙТ».
