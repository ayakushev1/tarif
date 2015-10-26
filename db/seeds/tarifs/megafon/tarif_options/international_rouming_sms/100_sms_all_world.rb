@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_100_sms_all_world, :name => '100 SMS Весь мир', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/100smsw.html'},
  :dependency => {
    :incompatibility => {:international_sms_pakets => [_mgf_50_sms_all_world, _mgf_100_sms_all_world, _mgf_50_sms_europe, _mgf_100_sms_europe]}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

_sctcg_not_russia_rouming_sms_outcoming = {:name => '_sctcg_not_russia_rouming_sms_outcoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_out}

#Not Russia, sms, Outcoming
  @tc.add_one_service_category_tarif_class(_sctcg_not_russia_rouming_sms_outcoming, {}, 
    {:calculation_order => 0, :price => 695.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :description => '', 
     :formula => {
       :window_condition => "(100.0 >= count_volume)", :window_over => 'month',
       :stat_params => {:count_volume => "count(description->>'volume')"},
       :method => "case when count_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'month',
         :stat_params => {:tarif_option_count_of_usage => "ceil(count(description->>'volume') / 100.0)", :count_volume => "count(description->>'volume')"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

@tc.add_tarif_class_categories

#–Опцию могут подключить абоненты всех тарифных планов для физических лиц и корпоративных тарифных планов;
#–Условия опции действуют только в международном роуминге;
#–Срок действия каждого пакета ― 30 дней с момента заказа. Неиспользованные SMS-сообщения по истечении 30 дней аннулируются. Досрочное отключение пакета и возврат денег за неистраченные SMS недоступны;
#–Чтобы проверить остаток SMS, наберите *558# или отправьте на номер 0500989 бесплатное SMS с текстом «остаток»;
#–Пакетная цена SMS действует при отправке сообщений на любые мобильные номера, кроме коротких номеров развлекательных и новостных сервисов. Отправка сообщений на короткие номера оплачивается в полном объёме по тарифу провайдера услуги;
#–Допускает подключить несколько пакетов одновременно.
