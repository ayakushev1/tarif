CategoryType.delete_all
CategoryType.create(id: 0, name: "location")
CategoryType.create(id: 2, name: "operator")
CategoryType.create(id: 3, name: "legal_or_person")
CategoryType.create(id: 4, name: "standard_service")
CategoryType.create(id: 5, name: "base_service")
CategoryType.create(id: 6, name: "service_direction")
CategoryType.create(id: 7, name: "param_value_type")
CategoryType.create(id: 8, name: "param_source")
CategoryType.create(id: 9, name: "unit")
CategoryType.create(id: 14, name: "comparison_operator")
CategoryType.create(id: 15, name: "param_source_type")
CategoryType.create(id: 16, name: "field_display_type")
CategoryType.create(id: 17, name: "value_choose_option")
CategoryType.create(id: 18, name: "service_category_type")
CategoryType.create(id: 19, name: "operator_type")
CategoryType.create(id: 20, name: "user_service_status")
CategoryType.create(id: 21, name: "relation types")
CategoryType.create(id: 22, name: "phone usage patterns")
CategoryType.create(id: 23, name: "priority_type")
CategoryType.create(id: 24, name: "priority_relation")
CategoryType.create(id: 25, name: "general_priority")
CategoryType.create(id: 26, name: "tarif_class_general_service_categories")
CategoryType.create(id: 27, name: "customer_info_type")
CategoryType.create(id: 28, name: "customer_demand_type")
CategoryType.create(id: 29, name: "customer_demand_status")

CategoryLevel.delete_all
CategoryLevel.create(id: 0,type_id: 0, level: 0, name: "world")
CategoryLevel.create(id: 1,type_id: 0, level: 1, name: "continent")
CategoryLevel.create(id: 2,type_id: 0, level: 2, name: "country")
CategoryLevel.create(id: 3,type_id: 0, level: 3, name: "region")
CategoryLevel.create(id: 20,type_id: 9, level: 0, name: "unit type")
CategoryLevel.create(id: 21,type_id: 9, level: 1, name: "unit")

Customer::Category.delete_all
Customer::Category.create(id: 1, type_id: 27, name: "general_info")
Customer::Category.create(id: 2, type_id: 27, name: "cash_info")
Customer::Category.create(id: 3, type_id: 27, name: "service_used_info")
Customer::Category.create(id: 4, type_id: 27, name: "calls_generation_params")
Customer::Category.create(id: 5, type_id: 27, name: "calls_details_params")
Customer::Category.create(id: 6, type_id: 27, name: "calls_parsing_params")
Customer::Category.create(id: 7, type_id: 27, name: "tarif_optimization_params")
Customer::Category.create(id: 8, type_id: 27, name: "service_choices")
Customer::Category.create(id: 9, type_id: 27, name: "services_select")
Customer::Category.create(id: 10, type_id: 27, name: "service_categories_select")
Customer::Category.create(id: 11, type_id: 27, name: "tarif_optimization_final_results")
Customer::Category.create(id: 12, type_id: 27, name: "tarif_optimization_minor_results")
Customer::Category.create(id: 13, type_id: 27, name: "tarif_optimization_process_status")

Category.delete_all
Category.create(id: 1, type_id: 3, level_id: nil, parent_id: nil, name: "Legal")
Category.create(id: 2, type_id: 3, level_id: nil, parent_id: nil, name: "Person")

Category.create(id: 40, type_id: 4, level_id: nil, parent_id: nil, name: "Тариф")
Category.create(id: 41, type_id: 4, level_id: nil, parent_id: nil, name: "Общая услуга")
Category.create(id: 42, type_id: 4, level_id: nil, parent_id: nil, name: "Специальная услуга")
Category.create(id: 43, type_id: 4, level_id: nil, parent_id: nil, name: "Опция тарифа")
Category.create(id: 44, type_id: 4, level_id: nil, parent_id: nil, name: "Тестовые")
Category.create(id: 45, type_id: 4, level_id: nil, parent_id: nil, name: "Для специальных задач")

Category.create(id: _calls, type_id: 5, level_id: nil, parent_id: nil, name: "Звонок")
Category.create(id: _sms, type_id: 5, level_id: nil, parent_id: nil, name: "СМС")
Category.create(id: _mms, type_id: 5, level_id: nil, parent_id: nil, name: "ММС")
Category.create(id: _wap, type_id: 5, level_id: nil, parent_id: nil, name: "wap")
Category.create(id: _2g, type_id: 5, level_id: nil, parent_id: nil, name: "2G")
Category.create(id: _3g, type_id: 5, level_id: nil, parent_id: nil, name: "3G")
Category.create(id: _4g, type_id: 5, level_id: nil, parent_id: nil, name: "4G")
Category.create(id: _cdma, type_id: 5, level_id: nil, parent_id: nil, name: "CDMA")
Category.create(id: _wifi, type_id: 5, level_id: nil, parent_id: nil, name: "WiFi")
Category.create(id: _periodic, type_id: 5, level_id: nil, parent_id: nil, name: "periodic")
Category.create(id: _one_time, type_id: 5, level_id: nil, parent_id: nil, name: "one_time")

Category.create(id: 70, type_id: 6, level_id: nil, parent_id: nil, name: "Исходящий")
Category.create(id: 71, type_id: 6, level_id: nil, parent_id: nil, name: "Входящий")
Category.create(id: 72, type_id: 6, level_id: nil, parent_id: nil, name: "Без категории")

Category.create(id: 3, type_id: 7, level_id: nil, parent_id: nil, name: "boolean")
Category.create(id: 4, type_id: 7, level_id: nil, parent_id: nil, name: "integer")
Category.create(id: 5, type_id: 7, level_id: nil, parent_id: nil, name: "string")
Category.create(id: 6, type_id: 7, level_id: nil, parent_id: nil, name: "text")
Category.create(id: 7, type_id: 7, level_id: nil, parent_id: nil, name: "decimal")
Category.create(id: 8, type_id: 7, level_id: nil, parent_id: nil, name: "list")
Category.create(id: 9, type_id: 7, level_id: nil, parent_id: nil, name: "reference")
Category.create(id: 10, type_id: 7, level_id: nil, parent_id: nil, name: "datetime")
Category.create(id: 11, type_id: 7, level_id: nil, parent_id: nil, name: "json")
Category.create(id: 12, type_id: 7, level_id: nil, parent_id: nil, name: "array")

Category.create(id: 15, type_id: 8, level_id: nil, parent_id: nil, name: "User phones")
Category.create(id: 16, type_id: 8, level_id: nil, parent_id: nil, name: "User service description")
Category.create(id: 17, type_id: 8, level_id: nil, parent_id: nil, name: "Operator service description")
Category.create(id: 18, type_id: 8, level_id: nil, parent_id: nil, name: "Used service description")
Category.create(id: 19, type_id: 8, level_id: nil, parent_id: nil, name: "Tarif service description")

Category.create(id: 75,type_id: 9, level_id: 20, parent_id: nil, name: "characteristic_unit")
Category.create(id: 76,type_id: 9, level_id: 20, parent_id: nil, name: "trafic_unit")
Category.create(id: 77,type_id: 9, level_id: 20, parent_id: nil, name: "cost_unit")
Category.create(id: 78,type_id: 9, level_id: 20, parent_id: nil, name: "date_time_unit")
Category.create(id: 79,type_id: 9, level_id: 20, parent_id: nil, name: "trafic_speed_unit")

Category.create(id: 80, type_id: 9, level_id: 21, parent_id: 76, name: "Байт")
Category.create(id: 81, type_id: 9, level_id: 21, parent_id: 76, name: "Кб")
Category.create(id: 82, type_id: 9, level_id: 21, parent_id: 76, name: "Мб")
Category.create(id: 83, type_id: 9, level_id: 21, parent_id: 76, name: "Гб")

Category.create(id: 90, type_id: 9, level_id: 21, parent_id: 77, name: "RUR")
Category.create(id: 91, type_id: 9, level_id: 21, parent_id: 77, name: "USD")
Category.create(id: 92, type_id: 9, level_id: 21, parent_id: 77, name: "EUR")
Category.create(id: 93, type_id: 9, level_id: 21, parent_id: 77, name: "Grivna")
Category.create(id: 94, type_id: 9, level_id: 21, parent_id: 77, name: "GBP")

Category.create(id: 95, type_id: 9, level_id: 21, parent_id: 78, name: "секунда")
Category.create(id: 96, type_id: 9, level_id: 21, parent_id: 78, name: "минута")
Category.create(id: 97, type_id: 9, level_id: 21, parent_id: 78, name: "час")
Category.create(id: 98, type_id: 9, level_id: 21, parent_id: 78, name: "сутки")
Category.create(id: 99, type_id: 9, level_id: 21, parent_id: 78, name: "неделя")
Category.create(id: 100, type_id: 9, level_id: 21, parent_id: 78, name: "месяц")
Category.create(id: 101, type_id: 9, level_id: 21, parent_id: 78, name: "год")

Category.create(id: 110, type_id: 9, level_id: 21, parent_id: 79, name: "Кб/с")
Category.create(id: 111, type_id: 9, level_id: 21, parent_id: 79, name: "Мб/с")
Category.create(id: 112, type_id: 9, level_id: 21, parent_id: 79, name: "Гб/с")

Category.create(id: 115, type_id: 9, level_id: 21, parent_id: 75, name: "шт.")

Category.create(id: 120, type_id: 14, level_id: nil, parent_id: nil, name: "=")
Category.create(id: 121, type_id: 14, level_id: nil, parent_id: nil, name: "!=")
Category.create(id: 122, type_id: 14, level_id: nil, parent_id: nil, name: "<")
Category.create(id: 123, type_id: 14, level_id: nil, parent_id: nil, name: "<=")
Category.create(id: 124, type_id: 14, level_id: nil, parent_id: nil, name: ">")
Category.create(id: 125, type_id: 14, level_id: nil, parent_id: nil, name: "=>")
Category.create(id: 126, type_id: 14, level_id: nil, parent_id: nil, name: "in")
Category.create(id: 127, type_id: 14, level_id: nil, parent_id: nil, name: "not_in")

Category.create(id: 130, type_id: 15, level_id: nil, parent_id: nil, name: "original")
Category.create(id: 131, type_id: 15, level_id: nil, parent_id: nil, name: "intermediate")
Category.create(id: 132, type_id: 15, level_id: nil, parent_id: nil, name: "input")

Category.create(id: 135, type_id: 16, level_id: nil, parent_id: nil, name: "value")
Category.create(id: 136, type_id: 16, level_id: nil, parent_id: nil, name: "list")
Category.create(id: 137, type_id: 16, level_id: nil, parent_id: nil, name: "table")
Category.create(id: 138, type_id: 16, level_id: nil, parent_id: nil, name: "string")
Category.create(id: 139, type_id: 16, level_id: nil, parent_id: nil, name: "query")

Category.create(id: 150, type_id: 17, level_id: nil, parent_id: nil, name: "field")
Category.create(id: 151, type_id: 17, level_id: nil, parent_id: nil, name: "single_value")
Category.create(id: 152, type_id: 17, level_id: nil, parent_id: nil, name: "multiple_value")
Category.create(id: 153, type_id: 17, level_id: nil, parent_id: nil, name: "value_param_is_criterium_param")

Category.create(id: 160, type_id: 18, level_id: nil, parent_id: nil, name: "common")
Category.create(id: 161, type_id: 18, level_id: nil, parent_id: nil, name: "specific")

Category.create(id: 170, type_id: 19, level_id: nil, parent_id: nil, name: "mobile")
Category.create(id: 171, type_id: 19, level_id: nil, parent_id: nil, name: "fixed line")

Category.create(id: 175, type_id: 20, level_id: nil, parent_id: nil, name: "subscribed")
Category.create(id: 176, type_id: 20, level_id: nil, parent_id: nil, name: "unsubscribed")
Category.create(id: 177, type_id: 20, level_id: nil, parent_id: nil, name: "expired")

Category.create(id: _operator_home_regions, type_id: 21, level_id: nil, parent_id: nil, name: "home regions")
Category.create(id: _operator_country_groups, type_id: 21, level_id: nil, parent_id: nil, name: "operator country groups")
Category.create(id: _main_operator_by_country, type_id: 21, level_id: nil, parent_id: nil, name: "main operator by country")
Category.create(id: _operator_region_groups, type_id: 21, level_id: nil, parent_id: nil, name: "operator country region groups")
Category.create(id: _operator_partner_groups, type_id: 21, level_id: nil, parent_id: nil, name: "operator's partner groups")

Category.create(id: 200, type_id: 22, level_id: nil, parent_id: nil, name: "В своем регионе")#"in own regions")
Category.create(id: 201, type_id: 22, level_id: nil, parent_id: 200, name: "Много говорю по телефону")#"active user of calls")
Category.create(id: 202, type_id: 22, level_id: nil, parent_id: 200, name: "Отправляю много смс")#"active user of sms")
Category.create(id: 203, type_id: 22, level_id: nil, parent_id: 200, name: "Активно использую интернет")#"active user of internet")

Category.create(id: 210, type_id: 22, level_id: nil, parent_id: nil, name: "В домашнем регионе")#"in home regions")
Category.create(id: 211, type_id: 22, level_id: nil, parent_id: 210, name: "Много говорю по телефону")#"active user of calls")
Category.create(id: 212, type_id: 22, level_id: nil, parent_id: 210, name: "Отправляю много смс")#"active user of sms")
Category.create(id: 213, type_id: 22, level_id: nil, parent_id: 210, name: "Активно использую интернет")#"active user of internet")
Category.create(id: 214, type_id: 22, level_id: nil, parent_id: 210, name: "Не использую")#"no home region activity")

Category.create(id: 220, type_id: 22, level_id: nil, parent_id: nil, name: "В России, кроме домашнего региона")#"in own country")
Category.create(id: 221, type_id: 22, level_id: nil, parent_id: 220, name: "Много говорю по телефону")#"active user of calls")
Category.create(id: 222, type_id: 22, level_id: nil, parent_id: 220, name: "Отправляю много смс")#"active user of sms")
Category.create(id: 223, type_id: 22, level_id: nil, parent_id: 220, name: "Активно использую интернет")#"active user of internet")
Category.create(id: 224, type_id: 22, level_id: nil, parent_id: 220, name: "Не использую")#"no own country activity")

Category.create(id: 230, type_id: 22, level_id: nil, parent_id: nil, name: "Заграницей")#"abroad")
Category.create(id: 231, type_id: 22, level_id: nil, parent_id: 230, name: "Много говорю по телефону")#"active user of calls")
Category.create(id: 232, type_id: 22, level_id: nil, parent_id: 230, name: "Отправляю много смс")#"active user of sms")
Category.create(id: 233, type_id: 22, level_id: nil, parent_id: 230, name: "Активно использую интернет")#"active user of internet")
Category.create(id: 234, type_id: 22, level_id: nil, parent_id: 230, name: "Не использую")#"no abroad activity")

Category.create(id: 240, type_id: 22, level_id: nil, parent_id: nil, name: "Общая")#"general")
Category.create(id: 241, type_id: 22, level_id: nil, parent_id: 240, name: "Не выезжаю за пределы своего региона")#"home sitter")
Category.create(id: 242, type_id: 22, level_id: nil, parent_id: 240, name: "Не выезжаю за пределы домашнего региона")#"home and home region sitter")
Category.create(id: 243, type_id: 22, level_id: nil, parent_id: 240, name: "Часто путешествую по России")#"active Russia traveller")
Category.create(id: 244, type_id: 22, level_id: nil, parent_id: 240, name: "Часто выезжаю заграницу")#"active foreign country traveller")

Category.create(id: 300, type_id: 23, level_id: nil, parent_id: nil, name: "general priority")
Category.create(id: 301, type_id: 23, level_id: nil, parent_id: nil, name: "individual priority")
Category.create(id: 302, type_id: 23, level_id: nil, parent_id: nil, name: "dependent is required for main")
Category.create(id: 303, type_id: 23, level_id: nil, parent_id: nil, name: "main is incompatible with dependent")

Category.create(id: 310, type_id: 24, level_id: nil, parent_id: nil, name: "main has higher priority")
Category.create(id: 311, type_id: 24, level_id: nil, parent_id: nil, name: "main has lower priority")

Category.create(id: 320, type_id: 25, level_id: nil, parent_id: nil, name: "tarif_option")
Category.create(id: 321, type_id: 25, level_id: nil, parent_id: nil, name: "tarif_without_limits")
Category.create(id: 322, type_id: 25, level_id: nil, parent_id: nil, name: "tarif_with_limits")
Category.create(id: 323, type_id: 25, level_id: nil, parent_id: nil, name: "tarif_option_with_limits")
Category.create(id: 324, type_id: 25, level_id: nil, parent_id: nil, name: "common_service")

Category.create(id: 330, type_id: 26, level_id: nil, parent_id: nil, name: "calls")
Category.create(id: 331, type_id: 26, level_id: nil, parent_id: nil, name: "sms")
Category.create(id: 332, type_id: 26, level_id: nil, parent_id: nil, name: "mms")
Category.create(id: 333, type_id: 26, level_id: nil, parent_id: nil, name: "internet")

Category.create(id: 340, type_id: 28, level_id: nil, parent_id: nil, name: "Сообщение об ошибке на сайте")
Category.create(id: 341, type_id: 28, level_id: nil, parent_id: nil, name: "Информационный запрос")
Category.create(id: 342, type_id: 28, level_id: nil, parent_id: nil, name: "Предложение об улучшении предоставляемых услуг")
Category.create(id: 343, type_id: 28, level_id: nil, parent_id: nil, name: "Предложение о сотрудничестве")
Category.create(id: 344, type_id: 28, level_id: nil, parent_id: nil, name: "Жалоба")

Category.create(id: 350, type_id: 29, level_id: nil, parent_id: nil, name: "Получено от пользователя")
Category.create(id: 351, type_id: 29, level_id: nil, parent_id: nil, name: "В работе")
Category.create(id: 352, type_id: 29, level_id: nil, parent_id: nil, name: "Обработано")

Category.create(id: _russian_operators, type_id: 2, level_id: nil, parent_id: nil, name: "Russian operators")
Category.create(id: _foreign_operators, type_id: 2, level_id: nil, parent_id: nil, name: "Foreign operators")
Category.create(id: 1020, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Djuice")
Category.create(id: 1021, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "life:)")
Category.create(id: 1022, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "PEOPLEnet")
Category.create(id: _tele_2, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "TELE2")
Category.create(id: 1024, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Utel")
Category.create(id: _beeline, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Билайн")
Category.create(id: 1026, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Енисейтелеком")
Category.create(id: _kiev_star, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "КиевСтар")
Category.create(id: _megafon, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Мегафон")
Category.create(id: 1029, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Мотив")
Category.create(id: _mts, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "МТС")
Category.create(id: _mts_ukrain, type_id: 2, level_id: nil, parent_id: _foreign_operators, name: "МТС-Украина")
Category.create(id: 1032, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Скайлинк")
Category.create(id: 1033, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "СМАРТС")
Category.create(id: _fixed_line_operator, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Ростелеком")
Category.create(id: _other_rusian_operator, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Разный Русский оператор")
Category.create(id: 1036, type_id: 2, level_id: nil, parent_id: _foreign_operators, name: "Astelit")


Category.create(id: _altai_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Алтайский край")
Category.create(id: _amur_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Амурская область")
Category.create(id: _arhangelsk_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Архангельская область")
Category.create(id: _astrahan_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Астраханская область")
Category.create(id: _belgorod_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Белгородская область")
Category.create(id: _bryansk_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Брянская область")
Category.create(id: _vladimir_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Владимирская область")
Category.create(id: _vologda_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Вологодская область")
Category.create(id: _voroneg_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Воронежская область")
Category.create(id: _volgograd_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Волгоградская область")
Category.create(id: _birobidgan_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Еврейская автономная область")
Category.create(id: _ivanov_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Ивановская область")
Category.create(id: _irkutsk_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Иркутская область")
Category.create(id: _kaliningrad_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Калининградская область")
Category.create(id: _kamhatsky_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Камчатский край")
Category.create(id: _kaluga_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Калужская область")
Category.create(id: _kemerovo_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Кемеровская область")
Category.create(id: _kirov_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Кировская область")
Category.create(id: _kostroma_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Костромская область")
Category.create(id: 1120, type_id: 0, level_id: 3, parent_id: _russia, name: "Краснодарский край")
Category.create(id: 1121, type_id: 0, level_id: 3, parent_id: _russia, name: "Красноярский край")
Category.create(id: 1122, type_id: 0, level_id: 3, parent_id: _russia, name: "Курганская область")
Category.create(id: _kursk_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Курская область")
Category.create(id: 1124, type_id: 0, level_id: 3, parent_id: _russia, name: "Ленинградская область")
Category.create(id: 1125, type_id: 0, level_id: 3, parent_id: _russia, name: "Липецкая область")
Category.create(id: 1126, type_id: 0, level_id: 3, parent_id: _russia, name: "Магаданская область")
Category.create(id: 1127, type_id: 0, level_id: 3, parent_id: _russia, name: "Московская область")
Category.create(id: 1128, type_id: 0, level_id: 3, parent_id: _russia, name: "Мурманская область")
Category.create(id: _nigegorod_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Нижегородская область")
Category.create(id: 1130, type_id: 0, level_id: 3, parent_id: _russia, name: "Новгородская область")
Category.create(id: 1131, type_id: 0, level_id: 3, parent_id: _russia, name: "Новосибирская область")
Category.create(id: 1132, type_id: 0, level_id: 3, parent_id: _russia, name: "Омская область")
Category.create(id: 1133, type_id: 0, level_id: 3, parent_id: _russia, name: "Оренбургская область")
Category.create(id: _orel_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Орловская область")
Category.create(id: 1135, type_id: 0, level_id: 3, parent_id: _russia, name: "Пензенская область")
Category.create(id: 1136, type_id: 0, level_id: 3, parent_id: _russia, name: "Пермский край")
Category.create(id: 1137, type_id: 0, level_id: 3, parent_id: _russia, name: "Приморский край")
Category.create(id: 1138, type_id: 0, level_id: 3, parent_id: _russia, name: "Псковская область")
Category.create(id: 1139, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Адыгея")
Category.create(id: 1140, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Башкортостан")
Category.create(id: 1141, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Бурятия")
Category.create(id: 1142, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Дагестан")
Category.create(id: 1143, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Саха (Якутия)")
Category.create(id: 1144, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Татарстан")
Category.create(id: 1145, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Удмуртия")
Category.create(id: 1146, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Ингушетия")
Category.create(id: 1147, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Кабардино-Балкария")
Category.create(id: 1148, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Калмыкия")
Category.create(id: 1149, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Карачаево-Черкесия")
Category.create(id: 1150, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Карелия")
Category.create(id: 1151, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Коми")
Category.create(id: 1152, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Марий Эл")
Category.create(id: 1153, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Мордовия")
Category.create(id: 1154, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Северная Осетия")
Category.create(id: 1155, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Тыва Тува")
Category.create(id: 1156, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Хакасия")
Category.create(id: 1157, type_id: 0, level_id: 3, parent_id: _russia, name: "Ростовская область")
Category.create(id: _rezyan_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Рязанская область")
Category.create(id: 1159, type_id: 0, level_id: 3, parent_id: _russia, name: "Самарская область")
Category.create(id: 1160, type_id: 0, level_id: 3, parent_id: _russia, name: "Саратовская область")
Category.create(id: 1161, type_id: 0, level_id: 3, parent_id: _russia, name: "Сахалинская область")
Category.create(id: 1162, type_id: 0, level_id: 3, parent_id: _russia, name: "Свердловская область")
Category.create(id: _smolensk_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Смоленская область")
Category.create(id: 1164, type_id: 0, level_id: 3, parent_id: _russia, name: "Ставропольский край")
Category.create(id: 1165, type_id: 0, level_id: 3, parent_id: _russia, name: "Тамбовская область")
Category.create(id: _tver_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Тверская область")
Category.create(id: 1167, type_id: 0, level_id: 3, parent_id: _russia, name: "Томская область")
Category.create(id: _tula_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Тульская область")
Category.create(id: 1169, type_id: 0, level_id: 3, parent_id: _russia, name: "Тюменская область")
Category.create(id: 1170, type_id: 0, level_id: 3, parent_id: _russia, name: "Ульяновская область")
Category.create(id: 1171, type_id: 0, level_id: 3, parent_id: _russia, name: "Хабаровский край")
Category.create(id: 1172, type_id: 0, level_id: 3, parent_id: _russia, name: "Ханты-Мансийский автономный округ")
Category.create(id: 1173, type_id: 0, level_id: 3, parent_id: _russia, name: "Челябинская область")
Category.create(id: 1174, type_id: 0, level_id: 3, parent_id: _russia, name: "Чеченская Республика")
Category.create(id: 1175, type_id: 0, level_id: 3, parent_id: _russia, name: "Читинская область")
Category.create(id: 1176, type_id: 0, level_id: 3, parent_id: _russia, name: "Чувашская Республика")
Category.create(id: 1177, type_id: 0, level_id: 3, parent_id: _russia, name: "Чукотский автономный округ")
Category.create(id: 1178, type_id: 0, level_id: 3, parent_id: _russia, name: "Ямало-Ненецкий автономный округ")
Category.create(id: _yaroslav_region, type_id: 0, level_id: 3, parent_id: _russia, name: "Ярославская область")
Category.create(id: 1180, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Алтай")
Category.create(id: 1181, type_id: 0, level_id: 3, parent_id: _russia, name: "Забайкальский край")


Category.create(id: 1200, type_id: 0, level_id: 3, parent_id: _russia, name: "Абакан")
Category.create(id: 1201, type_id: 0, level_id: 3, parent_id: _russia, name: "Алания")
Category.create(id: 1202, type_id: 0, level_id: 3, parent_id: _russia, name: "Анадырь")
Category.create(id: 1203, type_id: 0, level_id: 3, parent_id: _russia, name: "Архангельск")
Category.create(id: 1204, type_id: 0, level_id: 3, parent_id: _russia, name: "Астрахань")
Category.create(id: 1205, type_id: 0, level_id: 3, parent_id: _russia, name: "Барнаул")
Category.create(id: 1206, type_id: 0, level_id: 3, parent_id: _russia, name: "Белгород")
Category.create(id: 1207, type_id: 0, level_id: 3, parent_id: _russia, name: "Биробиджан")
Category.create(id: 1208, type_id: 0, level_id: 3, parent_id: _russia, name: "Благовещенск ")
Category.create(id: _bryansk, type_id: 0, level_id: 3, parent_id: _russia, name: "Брянск")
Category.create(id: 1210, type_id: 0, level_id: 3, parent_id: _russia, name: "Великий Новгород")
Category.create(id: 1211, type_id: 0, level_id: 3, parent_id: _russia, name: "Владивосток")
Category.create(id: _vladimir, type_id: 0, level_id: 3, parent_id: _russia, name: "Владимир")
Category.create(id: 1213, type_id: 0, level_id: 3, parent_id: _russia, name: "Волгоград")
Category.create(id: 1214, type_id: 0, level_id: 3, parent_id: _russia, name: "Вологда")
Category.create(id: 1215, type_id: 0, level_id: 3, parent_id: _russia, name: "Воронеж")
Category.create(id: 1216, type_id: 0, level_id: 3, parent_id: _russia, name: "Грозный")
Category.create(id: 1217, type_id: 0, level_id: 3, parent_id: _russia, name: "Екатеринбург")
Category.create(id: _ivanovo, type_id: 0, level_id: 3, parent_id: _russia, name: "Иваново")
Category.create(id: 1219, type_id: 0, level_id: 3, parent_id: _russia, name: "Иркутск")
Category.create(id: 1220, type_id: 0, level_id: 3, parent_id: _russia, name: "Ижевск")
Category.create(id: 1221, type_id: 0, level_id: 3, parent_id: _russia, name: "Йошкар-Ола")
Category.create(id: 1222, type_id: 0, level_id: 3, parent_id: _russia, name: "Казань")
Category.create(id: 1223, type_id: 0, level_id: 3, parent_id: _russia, name: "Калининград")
Category.create(id: _kaluga, type_id: 0, level_id: 3, parent_id: _russia, name: "Калуга")
Category.create(id: 1225, type_id: 0, level_id: 3, parent_id: _russia, name: "Кемерово")
Category.create(id: 1226, type_id: 0, level_id: 3, parent_id: _russia, name: "Киров")
Category.create(id: _kostroma, type_id: 0, level_id: 3, parent_id: _russia, name: "Кострома")
Category.create(id: 1228, type_id: 0, level_id: 3, parent_id: _russia, name: "Краснодар")
Category.create(id: 1229, type_id: 0, level_id: 3, parent_id: _russia, name: "Красноярск")
Category.create(id: 1230, type_id: 0, level_id: 3, parent_id: _russia, name: "Курган")
Category.create(id: _kursk, type_id: 0, level_id: 3, parent_id: _russia, name: "Курск")
Category.create(id: 1232, type_id: 0, level_id: 3, parent_id: _russia, name: "Кызыл")
Category.create(id: 1233, type_id: 0, level_id: 3, parent_id: _russia, name: "Липецк")
Category.create(id: 1234, type_id: 0, level_id: 3, parent_id: _russia, name: "Магадан")
Category.create(id: 1235, type_id: 0, level_id: 3, parent_id: _russia, name: "Магас")
Category.create(id: 1236, type_id: 0, level_id: 3, parent_id: _russia, name: "Майкоп")
Category.create(id: 1237, type_id: 0, level_id: 3, parent_id: _russia, name: "Махачкала")
Category.create(id: 1238, type_id: 0, level_id: 3, parent_id: _russia, name: "Москва")
Category.create(id: 1239, type_id: 0, level_id: 3, parent_id: _russia, name: "Мурманск")
Category.create(id: 1240, type_id: 0, level_id: 3, parent_id: _russia, name: "Нальчик")
Category.create(id: _nigni_novgorod, type_id: 0, level_id: 3, parent_id: _russia, name: "Нижний Новгород")
Category.create(id: 1242, type_id: 0, level_id: 3, parent_id: _russia, name: "Новосибирск")
Category.create(id: 1243, type_id: 0, level_id: 3, parent_id: _russia, name: "Омск")
Category.create(id: 1244, type_id: 0, level_id: 3, parent_id: _russia, name: "Оренбург")
Category.create(id: _orel, type_id: 0, level_id: 3, parent_id: _russia, name: "Орел")
Category.create(id: 1246, type_id: 0, level_id: 3, parent_id: _russia, name: "Пенза")
Category.create(id: 1247, type_id: 0, level_id: 3, parent_id: _russia, name: "Петрозаводск")
Category.create(id: 1248, type_id: 0, level_id: 3, parent_id: _russia, name: "Петропавловск-Камчатский")
Category.create(id: 1249, type_id: 0, level_id: 3, parent_id: _russia, name: "Пермь")
Category.create(id: 1250, type_id: 0, level_id: 3, parent_id: _russia, name: "Псков")
Category.create(id: 1251, type_id: 0, level_id: 3, parent_id: _russia, name: "Ростов")
Category.create(id: _rezyan, type_id: 0, level_id: 3, parent_id: _russia, name: "Рязань")
Category.create(id: 1253, type_id: 0, level_id: 3, parent_id: _russia, name: "Салехард")
Category.create(id: 1254, type_id: 0, level_id: 3, parent_id: _russia, name: "Самара")
Category.create(id: 1255, type_id: 0, level_id: 3, parent_id: _russia, name: "Санкт-Петербург")
Category.create(id: 1256, type_id: 0, level_id: 3, parent_id: _russia, name: "Саранск")
Category.create(id: 1257, type_id: 0, level_id: 3, parent_id: _russia, name: "Саратов")
Category.create(id: _smolensk, type_id: 0, level_id: 3, parent_id: _russia, name: "Смоленск")
Category.create(id: 1259, type_id: 0, level_id: 3, parent_id: _russia, name: "Минеральные воды")
Category.create(id: 1260, type_id: 0, level_id: 3, parent_id: _russia, name: "Сыктывкар")
Category.create(id: 1261, type_id: 0, level_id: 3, parent_id: _russia, name: "Тамбов")
Category.create(id: _tver, type_id: 0, level_id: 3, parent_id: _russia, name: "Тверь")
Category.create(id: 1263, type_id: 0, level_id: 3, parent_id: _russia, name: "Томск")
Category.create(id: _tula, type_id: 0, level_id: 3, parent_id: _russia, name: "Тула")
Category.create(id: 1265, type_id: 0, level_id: 3, parent_id: _russia, name: "Тюмень")
Category.create(id: 1266, type_id: 0, level_id: 3, parent_id: _russia, name: "Улан-Удэ")
Category.create(id: 1267, type_id: 0, level_id: 3, parent_id: _russia, name: "Ульяновск")
Category.create(id: 1268, type_id: 0, level_id: 3, parent_id: _russia, name: "Уфа")
Category.create(id: 1269, type_id: 0, level_id: 3, parent_id: _russia, name: "Хабаровск")
Category.create(id: 1270, type_id: 0, level_id: 3, parent_id: _russia, name: "Чебоксары")
Category.create(id: 1271, type_id: 0, level_id: 3, parent_id: _russia, name: "Челябинск")
Category.create(id: 1272, type_id: 0, level_id: 3, parent_id: _russia, name: "Черкесск")
Category.create(id: 1273, type_id: 0, level_id: 3, parent_id: _russia, name: "Чита")
Category.create(id: 1274, type_id: 0, level_id: 3, parent_id: _russia, name: "Элиста")
Category.create(id: 1275, type_id: 0, level_id: 3, parent_id: _russia, name: "Югра")
Category.create(id: 1276, type_id: 0, level_id: 3, parent_id: _russia, name: "Южно-Сахалинск")
Category.create(id: 1277, type_id: 0, level_id: 3, parent_id: _russia, name: "Якутск")
Category.create(id: _yaroslav, type_id: 0, level_id: 3, parent_id: _russia, name: "Ярославль")
Category.create(id: 1279, type_id: 0, level_id: 3, parent_id: _russia, name: "Владикавказ")
Category.create(id: 1280, type_id: 0, level_id: 3, parent_id: _russia, name: "Горно-Алтайск")
Category.create(id: 1281, type_id: 0, level_id: 3, parent_id: _russia, name: "Ставрополь")


Category.create(id: 1501, type_id: 0, level_id: 3, parent_id: _ukraiun, name: "регион Украины")

Category.create(id: _world, type_id: 0, level_id: 0, parent_id: nil, name: "World")

Category.create(id: _europe, type_id: 0, level_id: 1, parent_id: _world, name: "Europe")
Category.create(id: _asia, type_id: 0, level_id: 1, parent_id: _world, name: "Asia")
Category.create(id: _noth_america, type_id: 0, level_id: 1, parent_id: _world, name: "Noth America")
Category.create(id: _south_america, type_id: 0, level_id: 1, parent_id: _world, name: "South America")
Category.create(id: _africa, type_id: 0, level_id: 1, parent_id: _world, name: "Africa")
Category.create(id: _australia_continent, type_id: 0, level_id: 1, parent_id: _world, name: "Australia")

ctr = []
ctr << {:id => _ukraiun, :type_id => 0, :level_id => 2, :parent_id => _europe, :name => "Украина"}
ctr << {:id => _russia, :type_id => 0, :level_id => 2, :parent_id => _europe, :name => "Россия"}
_all_country_list_in_array_with_russian_names.each do |country_array|
  parent_id = case
  when _europe_countries.include?(country_array[0]); _europe;
  when _asia_countries.include?(country_array[0]); _asia;
  when _noth_america_countries.include?(country_array[0]); _noth_america;
  when _south_america_countries.include?(country_array[0]); _south_america;
  when _africa_countries.include?(country_array[0]); _africa;
  when _australia_countries.include?(country_array[0]); _australia_continent;
  else 
    raise(StandardError, "country is not defined: #{country_array}")
  end

  ctr << {:id => country_array[0], :type_id => 0, :level_id => 2, :parent_id => parent_id, :name => country_array[1]}
end

i = _first_country_operator_id
_all_country_list_in_string.each do |country_name|
  ctr << {:id => i, :type_id => 2, :level_id => nil, :parent_id => _foreign_operators, :name => "operator#{country_name}"}
  i += 1
end

ActiveRecord::Base.transaction do
  Category.create(ctr)
end

#raise(StandardError, [Category.find(_operator_austria).name])#.join("\n"))

