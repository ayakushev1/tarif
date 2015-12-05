TarifClass.delete_all
#Билайн, частные, тарифы
TarifClass.create(id: _bln_all_for_200, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 200')
TarifClass.create(id: _bln_all_for_400, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 400')
TarifClass.create(id: _bln_all_for_600, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 600')
TarifClass.create(id: _bln_all_for_900, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 900')
TarifClass.create(id: _bln_all_for_1500, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 1500')
TarifClass.create(id: _bln_all_for_2700, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 2700')
TarifClass.create(id: _bln_all_for_600_post, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 600 (постоплатный)')
TarifClass.create(id: _bln_all_for_900_post, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 900 (постоплатный)')
TarifClass.create(id: _bln_all_for_1500_post, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 1500 (постоплатный)')
TarifClass.create(id: _bln_all_for_2700_post, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Всё за 2700 (постоплатный)')
TarifClass.create(id: _bln_total_all_post, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Совсем Всё (постоплатный)')
TarifClass.create(id: _bln_go, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Go!')
TarifClass.create(id: _bln_welcome, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Добро пожаловать')
TarifClass.create(id: _bln_mobile_pencioner, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Мобильный пенсионер')
TarifClass.create(id: _bln_zero_doubts, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Ноль сомнений')
#TarifClass.create(id: _bln_first_child, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Первый детский*')
TarifClass.create(id: _bln_co_communication, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Со-общение')

TarifClass.create(id: _bln_by_second, operator_id: 1025, privacy_id: 2, standard_service_id: 40, name: 'Посекундный')
#Билайн, корпоративные, тарифы

#Билайн, роуминг
TarifClass.create(id: _bln_own_country_rouming , operator_id: 1025, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по России')
TarifClass.create(id: _bln_international_rouming , operator_id: 1025, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по миру')
TarifClass.create(id: _bln_international_rouming_internet , operator_id: 1025, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по миру, интернет')
TarifClass.create(id: _bln_international_rouming_internet_post , operator_id: 1025, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по миру, интернет (постоплатный)')
TarifClass.create(id: _bln_intra_countries_services, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Международные вызовы')
TarifClass.create(id: _bln_mobile_internet, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мобильный интернет')

#Билайн, услуги
TarifClass.create(id: _bln_planeta_zero, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Планета Ноль') #путешествие по миру
TarifClass.create(id: _bln_my_planet, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Моя планета') #путешествие по миру
TarifClass.create(id: _bln_the_best_internet_in_rouming, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Самый выгодный интернет в роуминге') #путешествие по миру
TarifClass.create(id: _bln_planet_of_internet_post, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Планета Интернета (постоплата)') #путешествие по миру
#TarifClass.create(id: _bln_week_of_internet_rouming, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Неделя интернет-роуминга»') #путешествие по миру
TarifClass.create(id: _bln_my_country, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Моя страна') #путешествие по стране
TarifClass.create(id: _bln_my_intracity, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мой межгород')#Междугородная связь
TarifClass.create(id: _bln_my_beeline, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мой Билайн')#Междугородная связь
TarifClass.create(id: _bln_my_beeline_post, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мой Билайн (постоплатная)')#Междугородная связь
TarifClass.create(id: _bln_my_calls_to_other_countries, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мои звонки в другие страны')#Международная связь
#TarifClass.create(id: _bln_my_ukraine, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Моя Украина')#Международная связь

TarifClass.create(id: _bln_my_sms, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мои СМС')# SMS и MMS сообщения
TarifClass.create(id: _bln_my_sms_post, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Мои СМС (постоплатная)')# SMS и MMS сообщения
TarifClass.create(id: _bln_sms_without_borders, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'СМС без границ')# SMS и MMS сообщения
TarifClass.create(id: _bln_mms, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'MMS')# SMS и MMS сообщения

TarifClass.create(id: _bln_highway_1, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Хайвей 1 Гб')# интернет
TarifClass.create(id: _bln_highway_4, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Хайвей 4 Гб')# интернет
TarifClass.create(id: _bln_highway_8, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Хайвей 8 Гб')# интернет
TarifClass.create(id: _bln_highway_12, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Хайвей 12 Гб')# интернет
TarifClass.create(id: _bln_highway_20, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Хайвей 20 Гб')# интернет

TarifClass.create(id: _bln_internet_on_day_100_mb, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Интернет на день 100 Мб')# интернет
TarifClass.create(id: _bln_internet_on_day_500_mb, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Интернет на день 500 Мб')# интернет

TarifClass.create(id: _bln_7_days_of_internet_for_russia_rouming, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: '7 дней интернета для путешествий по России')# интернет
TarifClass.create(id: _bln_30_days_of_internet_for_russia_rouming, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: '30 дней интернета для путешествий по России')# интернет
TarifClass.create(id: _bln_welcome_to_all_tarifs, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Добро пожаловать на ВСЕ')# интернет
TarifClass.create(id: _bln_my_abroad_countries, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Моё зарубежье')# интернет
TarifClass.create(id: _bln_add_speed_1gb, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость 1 Гб')# интернет
TarifClass.create(id: _bln_add_speed_3gb, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость 4 Гб')# интернет
TarifClass.create(id: _bln_auto_add_speed, operator_id: 1025, privacy_id: 2, standard_service_id: 42, name: 'Автопродление скорости')# интернет

#Мегафон, частные, тарифы
TarifClass.create(id: _mgf_around_world, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Вокруг света')#
TarifClass.create(id: _mgf_all_simple, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Все просто')#
TarifClass.create(id: _mgf_all_included_xs, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон все включено XS')#
TarifClass.create(id: _mgf_all_included_s, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон все включено S')#
TarifClass.create(id: _mgf_all_included_m, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон все включено M')#
TarifClass.create(id: _mgf_all_included_l, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон все включено L')#
TarifClass.create(id: _mgf_all_included_vip, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон все включено VIP')#
TarifClass.create(id: _mgf_megafon_online, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Мегафон онлайн')
TarifClass.create(id: _mgf_international, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Международный')#
TarifClass.create(id: _mgf_go_to_zero, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Переходи на ноль')#
TarifClass.create(id: _mgf_sub_moscow, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Подмосковный')#
#TarifClass.create(id: 111, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Подмосковный*')
TarifClass.create(id: _mgf_city_connection, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Связь городов')#
TarifClass.create(id: _mgf_warm_welcome, operator_id: 1028, privacy_id: 2, standard_service_id: 40, name: 'Теплый прием')#
#Мегафон, корпоративные, тарифы

#Мегафон, роуминг
TarifClass.create(id: 171 , operator_id: 1028, privacy_id: 1, standard_service_id: 41, name: 'Внутрисетевой роуминг для бизнеса')
TarifClass.create(id: 172 , operator_id: 1028, privacy_id: 1, standard_service_id: 41, name: 'Национальный роуминг для бизнеса')
TarifClass.create(id: 173 , operator_id: 1028, privacy_id: 1, standard_service_id: 41, name: 'Международный роуминг для бизнеса')

TarifClass.create(id: 175 , operator_id: 1028, privacy_id: 2, standard_service_id: 41, name: 'Внутрисетевой роуминг')
TarifClass.create(id: _mgf_own_country_rouming , operator_id: 1028, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по России')
TarifClass.create(id: _mgf_international_rouming , operator_id: 1028, privacy_id: 2, standard_service_id: 41, name: 'Путешествие по миру')
TarifClass.create(id: _mgf_intra_countries_services, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Международные вызовы')
TarifClass.create(id: _mgf_mobile_internet, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Мобильный интернет')

#Мегафон, услуги
TarifClass.create(id: _mgf_all_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Весь мир')
TarifClass.create(id: _mgf_30_minutes_all_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '30 минут ― Весь мир')
TarifClass.create(id: _mgf_100_minutes_europe, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '100 минут - Европа')
TarifClass.create(id: _mgf_far_countries, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Дальние страны')
TarifClass.create(id: _mgf_option_around_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'опция Вокруг света')
TarifClass.create(id: _mgf_50_sms_all_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '50 SMS Весь мир')
TarifClass.create(id: _mgf_100_sms_all_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '100 SMS Весь мир')
TarifClass.create(id: _mgf_50_sms_europe, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '50 SMS Европа')
TarifClass.create(id: _mgf_100_sms_europe, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '100 SMS Европа')
TarifClass.create(id: _mgf_25_discount_on_calls_to_russia_and_all_incoming, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Скидка 25% на исходящие вызовы в Россию и все входящие')
TarifClass.create(id: _mgf_50_discount_on_calls_to_russia, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Скидка 50% на исходящие вызовы в Россию')
TarifClass.create(id: _mgf_50_discount_on_all_incoming_calls, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Скидка 50% на все входящие вызовы')
TarifClass.create(id: _mgf_internet_abroad_10, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет за границей, 10 Мб')
TarifClass.create(id: _mgf_internet_abroad_30, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет за границей, 30 Мб')
TarifClass.create(id: _mgf_vacation_online, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Отпуск онлайн')

TarifClass.create(id: _mgf_all_russia, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Вся Россия')
TarifClass.create(id: _mgf_travel_without_worry, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Путешествуй без забот')
TarifClass.create(id: _mgf_everywhere_moscow_in_central_region, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Везде Москва — в Центральном регионе')
TarifClass.create(id: _mgf_internet_in_russia, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет по России')
TarifClass.create(id: _mgf_internet_in_russia_for_specific_options, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет по России для определенных опций')
TarifClass.create(id: _mgf_gigabite_to_road, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Гигабайт в дорогу')

TarifClass.create(id: _mgf_unlimited_communication, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Безлимитное общение')
TarifClass.create(id: _mgf_call_to_russia, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Звони по России')
TarifClass.create(id: _mgf_call_to_all_country, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Звони во все страны')
TarifClass.create(id: _mgf_option_for_sms_s, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Опция для SMS S')
TarifClass.create(id: _mgf_option_for_sms_l, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Опция для SMS L')
TarifClass.create(id: _mgf_option_for_sms_m, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Опция для SMS M')
TarifClass.create(id: _mgf_option_for_sms_xl, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Опция для SMS XL')
TarifClass.create(id: _mgf_sms_stihia, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'SMS-стихия')
TarifClass.create(id: _mgf_paket_sms_100, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-100')
TarifClass.create(id: _mgf_paket_sms_150, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-150')
TarifClass.create(id: _mgf_paket_sms_200, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-200')
TarifClass.create(id: _mgf_paket_sms_350, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-350')
TarifClass.create(id: _mgf_paket_sms_500, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-500')
TarifClass.create(id: _mgf_paket_sms_1000, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет SMS-1000')
TarifClass.create(id: _mgf_100_sms, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: '100 SMS')
TarifClass.create(id: _mgf_mms_24, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'MMS 24')
TarifClass.create(id: _mgf_paket_mms_10, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет MMS-10')
TarifClass.create(id: _mgf_paket_mms_50, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакет MMS-50')
TarifClass.create(id: _mgf_option_city_connection, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'опция Связь городов')#

TarifClass.create(id: _mgf_internet_extra_1_gb, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет-экстра 1 ГБ')
TarifClass.create(id: _mgf_internet_xs, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет XS')
TarifClass.create(id: _mgf_internet_s, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет S')
TarifClass.create(id: _mgf_internet_m, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет M')
TarifClass.create(id: _mgf_internet_l, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет L')
TarifClass.create(id: _mgf_internet_xl, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет XL')
TarifClass.create(id: _mgf_internet_24, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет 24')
TarifClass.create(id: _mgf_internet_24_pro, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет 24 PRO')
TarifClass.create(id: _mgf_bit_pro, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'БИТ PRO')
TarifClass.create(id: _mgf_bit_mega_pro_150, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'БИТ MegaPRO 150')
TarifClass.create(id: _mgf_bit_mega_pro_250, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'БИТ MegaPRO 250')
TarifClass.create(id: _mgf_bit_mega_pro_500, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'БИТ MegaPRO 500')

TarifClass.create(id: _mgf_internet_tablet, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Интернет Планшет')
TarifClass.create(id: _mgf_minute_packs_25_europe, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакеты минут 25 Европа и СНГ')
TarifClass.create(id: _mgf_minute_packs_25_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакеты минут 25 Мир')
TarifClass.create(id: _mgf_minute_packs_50_europe, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакеты минут 50 Европа и СНГ')
TarifClass.create(id: _mgf_minute_packs_50_world, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Пакеты минут 50 Мир')
TarifClass.create(id: _mgf_be_as_home, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Будь как дома')
TarifClass.create(id: _mgf_add_speed_1gb, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость 1 ГБ')
TarifClass.create(id: _mgf_add_speed_5gb, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость 5 ГБ')

#TarifClass.create(id: _mgf_prodli_skorost, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость')
#TarifClass.create(id: _mgf_prodli_skorost_lite, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость Лайт')
#TarifClass.create(id: _mgf_prodli_skorost_mega, operator_id: 1028, privacy_id: 2, standard_service_id: 42, name: 'Продли скорость Мега')


#МТС, частные, тарифы
TarifClass.create(id: _mts_red_energy, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'RED Energy')
TarifClass.create(id: _mts_smart, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart')
TarifClass.create(id: _mts_smart_mini, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart mini')
TarifClass.create(id: _mts_smart_plus, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart+')
TarifClass.create(id: _mts_smart_top, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart Top')
TarifClass.create(id: _mts_ultra, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Ultra')
TarifClass.create(id: _mts_mts_connect_4, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'МТС Коннект-4')
TarifClass.create(id: _mts_mayak, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Маяк')
TarifClass.create(id: _mts_your_country, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Твоя страна')
TarifClass.create(id: _mts_super_mts, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Супер МТС')
#TarifClass.create(id: _mts_super_mts_star, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Суперс МТС*')
TarifClass.create(id: _mts_umnyi_dom, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Умный дом')
TarifClass.create(id: _mts_posekundny, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Посекудный')
TarifClass.create(id: _mts_smart_nonstop, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart Nonstop')
#МТС, корпоративные, тарифы
TarifClass.create(id: 250, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Бизнес безлимит L')
TarifClass.create(id: 251, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Бизнес безлимит XL')
TarifClass.create(id: 252, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Бизнес коннект')
TarifClass.create(id: 253, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Бизнес-общение')
TarifClass.create(id: 254, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Бизнес-сеть')
TarifClass.create(id: 255, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Единый бизнес безлимит')
TarifClass.create(id: 256, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Единый бизнес')
TarifClass.create(id: 257, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Корпоративный эксклюзив')
TarifClass.create(id: 258, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Областной бизнес')
TarifClass.create(id: 259, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Умный бизнес M')
TarifClass.create(id: 260, operator_id: 1030, privacy_id: 1, standard_service_id: 40, name: 'Умный бизнес S')
#МТС, роуминг
TarifClass.create(id: 271 , operator_id: 1030, privacy_id: 1, standard_service_id: 41, name: 'Внутрисетевой роуминг для бизнеса')
TarifClass.create(id: 272 , operator_id: 1030, privacy_id: 1, standard_service_id: 41, name: 'Национальный роуминг для бизнеса')
TarifClass.create(id: 273 , operator_id: 1030, privacy_id: 1, standard_service_id: 41, name: 'Международный роуминг для бизнеса')

TarifClass.create(id: 275 , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Внутрисетевой роуминг')
TarifClass.create(id: _mts_own_country_rouming , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Роуминг по стране')
TarifClass.create(id: _mts_international_rouming , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Международный роуминг')
TarifClass.create(id: 278 , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Международный и национальный роуминг')
TarifClass.create(id: 279 , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Легкий роуминг и международный доступ')
TarifClass.create(id: _mts_own_country_rouming_internet , operator_id: 1030, privacy_id: 2, standard_service_id: 41, name: 'Интернет во внутресетевом роуминге')

#МТС, услуги
TarifClass.create(id: _mts_rodnye_goroda , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Родные города')#звонки в другие города
TarifClass.create(id: _mts_love_country , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Любимая страна')#звонки в другие города
TarifClass.create(id: _mts_everywhere_as_home_Ultra , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Везде как дома ULTRA')#звонки в другие города и в поездке по России для тарифа ULTRA
TarifClass.create(id: _mts_everywhere_as_home_smart , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Везде как дома SMART')#звонки в другие города и в поездке по России для тарифа SMART
TarifClass.create(id: 284 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Любимая страна1') #международные звонки
TarifClass.create(id: 285 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Страны МТС')#международные звонки на МТС абонентов
TarifClass.create(id: 286 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Звонки в Узбекистан') #международные звонки в Узбекистан
TarifClass.create(id: 287 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Звонки на Tcell от1 руб.')#международные звонки
TarifClass.create(id: _mts_zero_without_limits , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Ноль без границ')#международный роуминг
TarifClass.create(id: _mts_bit_abroad , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'БИТ за границей')#международный роуминг
TarifClass.create(id: _mts_maxi_bit_abroad , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Макси БИТ за границей')#международный роуминг
TarifClass.create(id: _mts_super_bit_abroad , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Супер БИТ за границей')#международный роуминг
TarifClass.create(id: _mts_100mb_in_latvia_and_litva , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '100 Мб в Литве и Латвии')#международный роуминг
TarifClass.create(id: _mts_outcoming_calls_from_11_9_rur , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Исходящие звонки от 11,9 руб.')#международный роуминг
TarifClass.create(id: _mts_everywhere_as_home , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Везде как дома')#звонки в другие города и в поездке по России 
TarifClass.create(id: _mts_50_sms_travelling_in_russia , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '50 SMS в поездках по России')#смс за пределами г. Москвы и Московской области в поездках по всей России в сети МТС
TarifClass.create(id: _mts_100_sms_travelling_in_russia , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '100 SMS в поездках по России')#смс за пределами г. Москвы и Московской области в поездках по всей России в сети МТС
TarifClass.create(id: _mts_incoming_travelling_in_russia , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Входящие в поездках по России')# все входящие звонки с номеров абонентов МТС региона пребывания бесплатные
TarifClass.create(id: _mts_internet_packet_200mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-пакет 200Мбайт')# 
TarifClass.create(id: _mts_internet_packet_300mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-пакет 300Мбайт')# 
TarifClass.create(id: _mts_internet_packet_450mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-пакет 450Мбайт')# 
TarifClass.create(id: _mts_internet_packet_900mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-пакет 900Мбайт')# 
TarifClass.create(id: _mts_bit , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'БИТ')# интернет с телефона
TarifClass.create(id: _mts_super_bit , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'СуперБИТ')# интернет с телефона
TarifClass.create(id: _mts_mini_bit , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'МиниБИТ')# интернет с телефона
TarifClass.create(id: _mts_50_sms_in_europe , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '50 SMS в Европе')# смс международный роуминг
TarifClass.create(id: _mts_100_sms_in_europe , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '100 SMS в Европе')# смс международный роуминг
TarifClass.create(id: _mts_50_sms_travelling_in_all_world , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '50 SMS в поездках по миру')# смс международный роуминг
TarifClass.create(id: _mts_100_sms_travelling_in_all_world , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '100 SMS в поездках по миру')# смс международный роуминг
TarifClass.create(id: _mts_love_country_all_world , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Любимая страна. Весь мир')#звонки в другие города
TarifClass.create(id: _mts_additional_internet_500_mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительный пакет 500 Мб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_additional_internet_1_gb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительный пакет 1 Гб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_additional_internet_smart_mini , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительный пакет интернета Smart mini')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_additional_internet_smart , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительный пакет интернета Smart')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_additional_internet_smart_other , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительный пакет интернета Smart Nonstop, Plus, Top')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_turbo_button_100_mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Турбо-кнопка 100 Мб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_turbo_button_500_mb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Турбо-кнопка 500 Мб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_turbo_button_2_gb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Турбо-кнопка 2 Гб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_turbo_button_5_gb , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Турбо-кнопка 5 Гб')#дополнительный объем интернета для Smart and Ultra
TarifClass.create(id: _mts_internet_mini , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-Mini')#дополнительный объем интернета
TarifClass.create(id: _mts_internet_maxi , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-Maxi')#дополнительный объем интернета
TarifClass.create(id: _mts_internet_super , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-Super')#дополнительный объем интернета
TarifClass.create(id: _mts_internet_vip , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет-VIP')#дополнительный объем интернета
#TarifClass.create(id: _mts_everywhere_as_home_smart_plus , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Везде как дома SMART plus')#звонки в другие города и в поездке по России для тарифа SMART
#TarifClass.create(id: _mts_everywhere_as_home_smart_mini , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Везде как дома SMART mini')#звонки в другие города и в поездке по России для тарифа SMART
TarifClass.create(id: _mts_additional_minutes_150 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительные пакеты минут 150')#дополнительные минуты для тарифов SMART
TarifClass.create(id: _mts_additional_minutes_300 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Дополнительные пакеты минут 300')#дополнительные минуты для тарифов SMART
TarifClass.create(id: _mts_mms_packet_10 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 10 MMS')#дополнительные mms
TarifClass.create(id: _mts_mms_packet_20 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 20 MMS')#дополнительные mms
TarifClass.create(id: _mts_mms_packet_50 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 50 MMS')#дополнительные mms
TarifClass.create(id: _mts_mms_discount_50_percent , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'MMS+')#Скидка mms
TarifClass.create(id: _mts_region , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Область')#Звоники из области в собственный и домашний регионы
TarifClass.create(id: _mts_95_cop_in_moscow_region , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '95 копеек в Московской области')#Звоники из области в собственный и домашний регионы
TarifClass.create(id: _mts_unlimited_calls , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Безлимитные звонки')#Звоники из области в собственный и домашний регионы
TarifClass.create(id: _mts_call_free_to_mts_russia_100 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Звони бесплатно на МТС России 100')#Звоники из области в собственный и домашний регионы
TarifClass.create(id: _mts_zero_to_mts , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Ноль на МТС')#Звоники из области в собственный и домашний регионы
TarifClass.create(id: _mts_onetime_sms_packet_50 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'SMS пакет 50')#смс пакет - одноразовый
TarifClass.create(id: _mts_onetime_sms_packet_150 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'SMS пакет 150')#смс пакет - одноразовый
TarifClass.create(id: _mts_onetime_sms_packet_300 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'SMS пакет 300')#смс пакет - одноразовый
TarifClass.create(id: _mts_monthly_sms_packet_100 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 100 SMS')#смс пакет - месячный
TarifClass.create(id: _mts_monthly_sms_packet_300 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 300 SMS')#смс пакет - месячный
TarifClass.create(id: _mts_monthly_sms_packet_500 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 500 SMS')#смс пакет - месячный
TarifClass.create(id: _mts_monthly_sms_packet_1000 , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Пакет 1000 SMS')#смс пакет - месячный
TarifClass.create(id: _mts_mts_planshet , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'МТС Планшет')#интернет для планшетов
TarifClass.create(id: _mts_mts_planshet_online , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'МТС Планшет Онлайн')#интернет для планшетов
TarifClass.create(id: _mts_unlimited_internet_on_day , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Интернет на день')#интернет для планшетов
TarifClass.create(id: _mts_unlimited_sms , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Безлимитные SMS')#смс пакет - месячный
TarifClass.create(id: _mts_free_journey , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Свободное путешествие')#смс пакет - месячный
TarifClass.create(id: _mts_single_country , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: 'Единая страна')#
TarifClass.create(id: _mts_100_sms_smart_mini , operator_id: 1030, privacy_id: 2, standard_service_id: 42, name: '100 SMS Smart mini')#

#Теле, частные, тарифы
TarifClass.create(id: _tele_black, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Черный')
TarifClass.create(id: _tele_very_black, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Очень черный')
TarifClass.create(id: _tele_orange, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Оранжевый')
TarifClass.create(id: _tele_yellow, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Желтый')
TarifClass.create(id: _tele_green, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Зеленый')

TarifClass.create(id: _tele_most_black, operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 40, name: 'Самый черный')

#Теле, роуминг
TarifClass.create(id: _tele_country_rouming , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 41, name: 'Путешествия по России')
TarifClass.create(id: _tele_international_rouming , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 41, name: 'Путешествия по миру')
TarifClass.create(id: _tele_intra_countries_services , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 41, name: 'Звонки за границу')

#Теле, услуги
TarifClass.create(id: _tele_sms_svoboda , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'SMS-свобода')#смс пакет - дневной
TarifClass.create(id: _tele_internet_from_phone , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Интернет с телефона')
TarifClass.create(id: _tele_paket_interneta , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Пакет интернета')
TarifClass.create(id: _tele_portfel_interneta , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Портфель интернета')
TarifClass.create(id: _tele_day_in_net , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'День в сети')
TarifClass.create(id: _tele_zero_everywhere , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Везде ноль')

TarifClass.create(id: _tele_internet_abroad , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Интернет за рубежом')
TarifClass.create(id: _tele_talks_without_limits , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Разговоры без границ')
TarifClass.create(id: _tele_simple_geography , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Простая география')
TarifClass.create(id: _tele_day_sms , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'День СМС')
TarifClass.create(id: _tele_add_speed_100mb , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Добавить скорости 100Mb')
TarifClass.create(id: _tele_add_speed_3gb , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Добавить скорости 3Gb')
TarifClass.create(id: _tele_chemodan_interneta , operator_id: Category::Operator::Const::Tele2, privacy_id: 2, standard_service_id: 42, name: 'Чемодан интернета')
