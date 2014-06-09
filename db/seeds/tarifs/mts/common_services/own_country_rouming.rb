#Own country rouming
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class('Own country rouming')

#Own country, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.9})  

#Own country, calls, outcoming, to own region, to own operator
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_local_own_operator, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.9})  

#Own country, calls, outcoming, to own region, to other operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_local_other_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, calls, outcoming, to own region, to fixed line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_local_fixed_line, _sctcg_own_country_calls_local_own_operator)

#Own country, calls, outcoming, to home region, to own operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_own_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, calls, outcoming, to home region, to other operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_other_operator, _sctcg_own_country_calls_local_own_operator)

#Own country, calls, outcoming, to home region, to fixed line
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_home_region_fixed_line, _sctcg_own_country_calls_local_own_operator)

#Own country, calls, outcoming, to own country, to own operator
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_calls_own_country_own_operator, _sctcg_own_country_calls_local_own_operator)


#Own country, sms, outcoming, to own region
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_sms_local, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})  

#Own country, sms, outcoming, to home region
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_sms_home_region, _sctcg_own_country_sms_local)

#Own country, sms, outcoming, to own country
  @tc.add_as_other_service_category_tarif_class(_sctcg_own_country_sms_own_country, _sctcg_own_country_sms_local)

#Own country, sms, outcoming, to not own country
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_sms_not_own_country, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.25})  

  

@tc.load_repositories

#Тарификация поминутная, с округлением до целых минут в большую сторону

#В Ямало-Ненецком, Ханты-Мансийском АО, Пермском крае, Волгоградской и Пензенской областях кроме сети МТС, действуют сети операторов-партнеров.
#При выборе их сетей действуют следующие тарифы:
#– Все входящие вызовы и исходящие на номера России – 17 руб./мин.
#– Исходящие вызовы в другие страны СНГ – 38 руб./мин.
#– Исходящие вызовы в прочие страны – 129 руб./мин.
#– Исходящие SMS – 4,5 руб.
#– Входящие SMS – 0 руб.
#– GPRS – 8,6 руб. за 40 кб
#Скидки и опции в сетях других операторов не действуют.

# Доступ к услугам контент-провайдеров в роуминге посредством SMS на короткие номера, оплачивается по тарифу, действующему в "домашнем" регионе, плюс 3.95 руб.