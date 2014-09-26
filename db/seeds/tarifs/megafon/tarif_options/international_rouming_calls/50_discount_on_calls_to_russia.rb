@tc = ServiceHelper::TarifCreator.new(_megafon)
@tc.create_tarif_class({
  :id => _mgf_50_discount_on_calls_to_russia, :name => 'Скидка 50% на исходящие вызовы в Россию', :operator_id => _megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/50disc.html'},
  :dependency => {
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :multiple_use => true
  } } )

#Параметры опции задаются в описании самого тарифа

#sic, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_sic_calls_to_russia', :service_category_rouming_id => _sc_mgf_sic_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_only_service_category_tarif_class(category)  

#other_countries, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_other_countries_calls_to_russia', :service_category_rouming_id => _sc_mgf_other_countries_international_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_only_service_category_tarif_class(category)  


@tc.add_tarif_class_categories

#–Подключение и отключение услуги происходит в ближайшие 0 часов 00 минут после отправки запроса.
#– Если абонент, подключивший опцию, находится в стране, где местное время отстает от московского, то скидка начнет действовать только тогда, когда местное время совпадет со временем подключения опции по Москве.
#–Скидки на звонки доступны абонентам всех частных и корпоративных тарифных планов «МегаФон», кроме «Видеоконтроль», «Вокруг света», «Детский Интернет», «Интернет старт», «МегаФон-Логин», «МегаФон-Логин Безлимитный», «МегаФон-Логин Оптимальный» и «MMS-Камера». 
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500.
#–В перечень стран Европы входят: Австрия, Албания, Андорра, Армения, Белоруссия, Бельгия, Болгария, Босния и Герцеговина, Великобритания, Венгрия, Германия, Гренландия, Греция, Дания, Ирландия, Исландия, Испания, Италия, Кипр, Латвия, Литва, Лихтенштейн, Люксембург, Македония, Мальта, Молдавия, Монако, Нидерланды, Норвегия, Польша, Португалия, Румыния, Сан-Марино, Сербия, Словакия, Турция, Украина, Финляндия, Франция, Хорватия, Черногория, Чехия, Швейцария, Швеция, Эстония, Южная Осетия
