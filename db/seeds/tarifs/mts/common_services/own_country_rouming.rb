#Own country rouming
@tc = ServiceHelper::TarifCreator.new(_mts)
  @tc.create_tarif_class({:name => 'Own country rouming'})

_sctcg_own_country_calls_incoming = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}
_sctcg_own_country_calls_to_all_own_country_regions = {:name => '_sctcg_own_country_calls_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_all_own_country_regions}

_sctcg_own_country_sms_to_all_own_country_regions = {:name => '_sctcg_own_country_sms_to_all_own_country_regions', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_all_own_country_regions}
_sctcg_own_country_sms_not_own_country = {:name => 'own_country_sms_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}

#Own country, calls, incoming
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_incoming, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.9})  

#Own country, calls, outcoming, to all own country regions, to all operators
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_calls_to_all_own_country_regions, {}, {:standard_formula_id => _stf_price_by_sum_duration_minute, :price => 8.9})  

#Own country, sms, outcoming, to all own country regions, to all operators
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_sms_to_all_own_country_regions, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 3.95})  

#Own country, sms, outcoming, to not own country
  @tc.add_one_service_category_tarif_class(_sctcg_own_country_sms_not_own_country, {}, {:standard_formula_id => _stf_price_by_count_volume_item, :price => 5.25})  

#@tc.load_repositories

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