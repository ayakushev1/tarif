@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_100_minutes_europe, :name => '100 минут - Европа', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/100min.html'},
  :dependency => {
    :incompatibility => {:international_calls_options => [_mgf_all_world, _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

scg_100_minutes_europe = @tc.add_service_category_group(
  {:name => 'scg_mgf_100_minutes_europe' }, 
  {:name => "price for scg_mgf_100_minutes_europe"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 100.0, :price => 990.0}, :window_over => 'month' } } )

#All europe, calls, incoming
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_100_minutes_europe[:id])

#All europe, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_calls_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_100_minutes_europe[:id])

#All europe, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_100_minutes_europe[:id])


@tc.add_tarif_class_categories

#–Пакеты доступны на всех тарифных планах, за исключением отдельных корпоративных. Срок действия каждого пакета ― 30 дней с момента заказа. Неиспользованные минуты по истечении 30 дней аннулируются. Досрочное отключение пакета недоступно. Возврат денег за неистраченные минуты не производится.
#Чтобы узнать число оставшихся предоплаченных минут, наберите кодовую команду *105*10#.
#–Пакет «100 минут - Европа» действует только в Европе*.
#–Минуты из оплаченного пакета расходуются на любые входящие вызовы с российских номеров (номеров страны пребывания), а также исходящие вызовы на российский номер (номер страны пребывания). Звонки в другие страны и остальные услуги связи оплачиваются по роуминговому тарифу страны пребывания.
#–В перечень стран Европы входят: Австрия, Албания, Андорра, Армения, Белоруссия, Бельгия, Болгария, Босния и Герцеговина, Великобритания, Венгрия, Германия, Гренландия, Греция, Дания, Ирландия, Исландия, Испания, Италия, Кипр, Латвия, Литва, Лихтенштейн, Люксембург, Македония, Мальта, Молдавия, Монако, Нидерланды, Норвегия, Польша, Португалия, Румыния, Сан-Марино, Сербия, Словакия, Турция, Украина, Финляндия, Франция, Хорватия, Черногория, Чехия, Швейцария, Швеция, Эстония, Южная Осетия.

 

#* В перечень стран Европы входят: Австрия, Албания, Андорра, Армения, Белоруссия, Бельгия, Болгария, Босния и Герцеговина, Великобритания, Венгрия, Германия, Гренландия, Греция, Дания, Ирландия, Исландия, Испания, Италия, Кипр, Латвия, Литва, Лихтенштейн, Люксембург, Македония, Мальта, Молдавия, Монако, Нидерланды, Норвегия, Польша, Португалия, Румыния, Сан-Марино, Сербия, Словакия, Турция, Украина, Финляндия, Франция, Хорватия, Черногория, Чехия, Швейцария, Швеция, Эстония, Южная Осетия.
