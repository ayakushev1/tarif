#Свободное путешествие
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_free_journey, :name => 'Свободное путешествие', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/discount_roaming/free_travel/'},
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )

#calls_first_60_minites
scg_mts_free_journey = @tc.add_service_category_group(
  {:name => 'scg_mts_free_journey' }, 
  {:name => "price for scg_mts_free_journey"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice, 
      :formula => {:params => {:max_duration_minute => 60.0, :price => 0.0}, :window_over => 'day' } } )

#Ежедневная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :formula => {:params => {:price => 250.0} } })

#Chosen countries, calls, incoming, Австралия, Австрия, Армения, Великобритания, Венгрия, Германия, Греция, Израиль, Ирландия, Италия, Нидерланды, ОАЭ, Польша, Португалия, Франция, Чехия
  category = {:name => '_sctcg_mts_europe_calls_incoming', :service_category_rouming_id => _sc_rouming_mts_free_journey, :service_category_calls_id => _calls_in}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_free_journey[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })

#Chosen countries, calls, outcoming, to Russia, Австралия, Австрия, Армения, Великобритания, Венгрия, Германия, Греция, Израиль, Ирландия, Италия, Нидерланды, ОАЭ, Польша, Португалия, Франция, Чехия
  category = {:name => '_sctcg_mts_europe_calls_to_russia', :service_category_rouming_id => _sc_rouming_mts_free_journey, :service_category_calls_id => _calls_out, :service_category_geo_id => _sc_service_to_russia}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_free_journey[:id])
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1,:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 10.0} } })

     
@tc.add_tarif_class_categories

#Ежесуточная плата за использование опции составляет 33 руб.
#С 19 июня 2014 года стоимость входящего вызова, начиная с 11-й минуты каждого разговора составит 9 руб./мин.; 
#стоимость исходящих вызовов на российские номера составит 19 руб./мин.
#При нахождении в международном роуминге абоненты всех тарифных планов, за исключением корпоративных, 
#в рамках опции «Ноль без границ» могут принимать 200 минут входящих вызовов в месяц. 
#Начиная с 201 минуты, все входящие вызовы до конца календарного месяца будут стоить 5 руб. за минуту

#Количество накопленных входящих вызовов в международном роуминге можно уточнить следующими способами:
#наберите на своем мобильном телефоне *419*1233#вызов

#Как подключить и отключить опцию
#наберите на своем мобильном телефоне *111*4444#вызов  и выберите соответствующий пункт меню;
#отправьте SMS на номер 111 с текстом: 33 - для подключения опции; 330 - для отключения опции.

#Вы можете подключить опцию, даже находясь за границей.
#На территории России опцию также можно подключить, набрав на своем мобильном телефоне *444#вызов  
#Для абонентов всех тарифных планов команды *111*4444#вызов и *444#вызов бесплатны. Отправка SMS на номер 111 бесплатна в регионе регистрации номера, во внутрисетевом и международном роуминге. 
#При нахождении в национальном роуминге отправка SMS оплачивается в соответствии с роуминговым тарифом.

#Плата за первые сутки списывается при подключении опции. Оплата производится за каждые полные или неполные сутки независимо от местонахождения абонента 
#на протяжении всего времени действия опции вплоть до самостоятельного отключения опции
     

#Условия пользования опцией
#Воспользоваться настоящим предложением в роуминге возможно только при подключенных услугах «Международный и национальный роуминг» и «Международный доступ», 
#либо при подключенной услуге «Легкий роуминг и международный доступ» .Проверить подключение данных услуг можно через «Интернет-помощник».
#При подключенной услуге «Легкий роуминг и международный доступ» использование телефона возможно в сетях операторов, с которыми у ОАО МТС действует соглашение о CAMEL-роуминге.
#Без подключения опции «Ноль без границ» действуют базовые тарифы, ознакомиться с которыми можно в разделе «Тарифы и география» .
#Для абонентов тарифного плана «Европейский» при подключении услуги «Ноль без границ» скидка в странах Европы действует на исходящие звонки.
#TODO#Если в течение 30 суток вы не пользовались услугами связи в сети МТС России, стоимость каждой минуты входящего вызова при подключенной опции «Ноль без границ» равна 15 руб. 
#при нахождении в любой зарубежной стране за исключением Узбекистана, Азербайджана и Южной Осетии. 
#При нахождении в Узбекистане и Азербайджане стоимость входящего вызова равна 59 руб./мин., в Южной Осетии - 17 руб./мин
