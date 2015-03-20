@tc = TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_gigabite_to_road, :name => 'Гигабайт в дорогу', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/national/gbpack.html'},
  :dependency => {
    :incompatibility => {
      :mgf_internet_in_russia => [_mgf_internet_in_russia_for_specific_options, _mgf_internet_in_russia, _mgf_gigabite_to_road],
    }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )


#Own country rouming, internet
category = {:name => '_sctcg_mgf_own_country_rouming_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 300.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mgf_own_country_rouming_internet', :description => '', 
     :formula => {
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 1000.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage", 
       }
     }, 
    } )


@tc.add_tarif_class_categories

#–Пакет начинает действовать через 10–15 минут после подключения.
#–Округление трафика — до 150 КБ в час.
#–Чтобы узнать остаток трафика, наберите *105*1*2#.
#–Пакет «Гигабайт в дорогу» доступен всем абонентам «МегаФон» Московского региона, подключивших услугу «Мобильный Интернет».
#–Пакет действует на всей территории России за пределами столичного региона. В Москве и Московской области интернет-трафик оплачивается по тарифному плану абонента.
#–Допускается одновременно подключить несколько пакетов. Каждый последующий пакет начинает действовать после закрытия текущей интернет-сессии и открытия новой.
#–При отключении пакета неиспользованный трафик не сохраняется. Оставшаяся часть стоимости пакета не возвращается на счет абонента.
#–Максимальная скорость приема-передачи данных в каждом случае зависит от технических возможностей сети и оборудования, с помощью которого абонент выходит в интернет
