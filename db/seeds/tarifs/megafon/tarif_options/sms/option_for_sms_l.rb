@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_option_for_sms_l, :name => 'Опция для SMS L', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/tariffs/options/sms_mms/sms_options.html#29729'},
  :dependency => {
    :incompatibility => {
      :sms_pakets_and_options_for_sms => [
        _mgf_sms_stihia, _mgf_100_sms, _mgf_paket_sms_100, _mgf_paket_sms_150, _mgf_paket_sms_200, _mgf_paket_sms_350, _mgf_paket_sms_500, _mgf_paket_sms_1000,
        _mgf_sms_stihia, _mgf_option_for_sms_s, _mgf_option_for_sms_l, _mgf_option_for_sms_m, _mgf_option_for_sms_xl]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#Own and home regions, sms, to_own_and_home_regions
category = {:name => '_sctcg_own_home_regions_sms_to_own_and_home_regions', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_and_home_regions}
  @tc.add_one_service_category_tarif_class(category, {},
    {:calculation_order => 0, :price => 300.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(600 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count(description->>'volume')"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
   } } )


@tc.add_tarif_class_categories

#Опции «SMS S», «SMS M» и «SMS L»:
#—Списание абонентской платы осуществляется в день подключения Опции и далее ежемесячно в день календарного подключения.
#—Возобновление объема SMS в рамках Опции происходит ежемесячно в день календарного подключения, неиспользованный объем SMS на следующий месяц не переносится.
#—SMS-сообщения в рамках Опции расходуются при отправке на номера МегаФон и других операторов Домашнего региона. Тарификация SMS-сообщений вне рамок Опции осуществляется согласно условиям Вашего тарифного плана.

#Опция «SMS XL»:
#—Абонентская плата списывается ежедневно с момента подключения Опции.
#—SMS-сообщения в рамках Опции расходуются при отправке на номера МегаФон и других операторов по всей России, кроме Республики Крым и г. Севастополь. Тарификация SMS-сообщений вне рамок Опции осуществляется согласно условиям Вашего тарифного плана.

#Все опции работают при нахождении Абонента в пределах Домашнего региона, на территории которого был заключен договор об оказании услуг связи.
#SMS-сообщения на номера контент-провайдеров и поставщиков прочих развлекательных услуг тарифицируются вне рамок Опции.
#Срок действия Опций не ограничен. Опция действует до момента отключения услуги абонентом.
#Неиспользованный объем SMS на следующий месяц не переносится.
