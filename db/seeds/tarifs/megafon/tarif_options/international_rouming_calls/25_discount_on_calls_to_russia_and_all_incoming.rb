@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_25_discount_on_calls_to_russia_and_all_incoming, :name => 'Скидка 25% на исходящие вызовы в Россию и все входящие', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/25disc.html'},
  :dependency => {
    :incompatibility => {
      :discount_on_all_incoming_calls => [_mgf_50_discount_on_all_incoming_calls, _mgf_25_discount_on_calls_to_russia_and_all_incoming],
      :discount_on_calls_to_russia => [_mgf_50_discount_on_calls_to_russia, _mgf_25_discount_on_calls_to_russia_and_all_incoming],
      :international_calls_options => [
        _mgf_all_world, _mgf_minute_packs_25_europe, _mgf_minute_packs_50_europe, _mgf_minute_packs_25_world, _mgf_minute_packs_50_world, 
        _mgf_30_minutes_all_world, _mgf_far_countries, _mgf_option_around_world, _mgf_100_minutes_europe]
      }, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [_mgf_around_world], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#Параметры опции задаются в описании самого тарифа

#_all_world_rouming, incoming
category = {:name => '_sctcg_mgf_all_world_rouming_calls_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _calls_in}
  @tc.add_only_service_category_tarif_class(category)  

#_all_world_rouming, calls, outcoming, to Russia
category = {:name => '_sctcg_mgf_all_world_rouming_calls_to_russia', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_only_service_category_tarif_class(category)  



@tc.add_tarif_class_categories

#–Подключение и отключение услуги происходит в ближайшие 0 часов 00 минут после отправки запроса.
#– Если абонент, подключивший опцию, находится в стране, где местное время отстает от московского, то скидка начнет действовать только тогда, когда местное время совпадет со временем подключения опции по Москве.
#–Скидки на звонки доступны абонентам всех частных и корпоративных тарифных планов «МегаФон», кроме «Видеоконтроль», «Вокруг света», «Детский Интернет», «Интернет старт», «МегаФон-Логин», «МегаФон-Логин Безлимитный», «МегаФон-Логин Оптимальный» и «MMS-Камера». 
#Чтобы уточнить возможность подключения опции, зайдите в Личный кабинет (Сервис-Гид) и откройте меню «Услуги и тариф», либо позвоните в Контактный центр по номеру 0500.
#–В перечень стран Европы входят: Австрия, Албания, Андорра, Армения, Белоруссия, Бельгия, Болгария, Босния и Герцеговина, Великобритания, Венгрия, Германия, Гренландия, Греция, Дания, Ирландия, Исландия, Испания, Италия, Кипр, Латвия, Литва, Лихтенштейн, Люксембург, Македония, Мальта, Молдавия, Монако, Нидерланды, Норвегия, Польша, Португалия, Румыния, Сан-Марино, Сербия, Словакия, Турция, Украина, Финляндия, Франция, Хорватия, Черногория, Чехия, Швейцария, Швеция, Эстония, Южная Осетия
