@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_minute_packs_25_europe, :name => 'Пакеты минут 25 Европа и СНГ', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/minute_packs.html'},
  :dependency => {
    :incompatibility => {
      :international_calls_options => [
        _mgf_all_world, _mgf_minute_packs_25_europe, _mgf_minute_packs_50_europe, _mgf_minute_packs_25_world, _mgf_minute_packs_50_world, 
        _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]
        }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
#    :is_archived => true,
    :multiple_use => false
  } } )

scg_minute_packs_25_europe = @tc.add_service_category_group(
  {:name => 'scg_minute_packs_25_europe' }, 
  {:name => "price for scg_minute_packs_25_europe"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice,  
      :formula => {:params => {:max_duration_minute => 25.0, :price => 329.0}, :window_over => 'month' } } )

#Europe, calls, incoming
category = {:name => '_sctcg_mgf_europe_calls_incoming', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#Europe, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_europe_calls_to_russia', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#Europe, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_europe_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#Europe, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_europe_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_europe_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  


#sic, calls, incoming
category = {:name => '_sctcg_mgf_sic_calls_incoming', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_in, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#sic, calls, outcoming, to rouming country
category = {:name => '_sctcg_mgf_sic_calls_to_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_rouming_country, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

#sic, calls, outcoming, to not rouming country and not Russia
category = {:name => '_sctcg_mgf_sic_calls_to_not_rouming_country', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_not_rouming_not_russia, 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming }}}
  @tc.add_grouped_service_category_tarif_class(category, scg_minute_packs_25_europe[:id])  

@tc.add_tarif_class_categories

#–Пакеты доступны на всех тарифных планах, за исключением отдельных корпоративных. Срок действия каждого пакета ― 30 дней с момента заказа. Неиспользованные минуты по истечении 30 дней аннулируются. Возврат денег за неистраченные минуты не производится.
#Чтобы узнать число оставшихся предоплаченных минут, наберите кодовую команду *105*10#.
#–Пакет «30 минут Весь мир» действует во всех странах, где есть международный роуминг «МегаФон».
#–Минуты из оплаченного пакета расходуются на любые входящие вызовы с российских номеров (номеров страны пребывания), а также исходящие вызовы на российский номер (номер страны пребывания). Звонки в другие страны и остальные услуги связи оплачиваются по роуминговому тарифу страны пребывания.
#–Допускается одновременно подключить несколько пакетов.
