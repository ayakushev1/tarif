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

CategoryLevel.delete_all
CategoryLevel.create(id: 0,type_id: 0, level: 0, name: "world")
CategoryLevel.create(id: 1,type_id: 0, level: 1, name: "continent")
CategoryLevel.create(id: 2,type_id: 0, level: 2, name: "country")
CategoryLevel.create(id: 3,type_id: 0, level: 3, name: "region")
CategoryLevel.create(id: 20,type_id: 9, level: 0, name: "unit type")
CategoryLevel.create(id: 21,type_id: 9, level: 1, name: "unit")

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

Category.create(id: 190, type_id: 21, level_id: nil, parent_id: nil, name: "home regions")
Category.create(id: 191, type_id: 21, level_id: nil, parent_id: nil, name: "operator country groups")
Category.create(id: 192, type_id: 21, level_id: nil, parent_id: nil, name: "main operator by country")

Category.create(id: 200, type_id: 22, level_id: nil, parent_id: nil, name: "in own regions")
Category.create(id: 201, type_id: 22, level_id: nil, parent_id: 200, name: "active user of calls")
Category.create(id: 202, type_id: 22, level_id: nil, parent_id: 200, name: "active user of sms")
Category.create(id: 203, type_id: 22, level_id: nil, parent_id: 200, name: "active user of internet")

Category.create(id: 210, type_id: 22, level_id: nil, parent_id: nil, name: "in home regions")
Category.create(id: 211, type_id: 22, level_id: nil, parent_id: 210, name: "active user of calls")
Category.create(id: 212, type_id: 22, level_id: nil, parent_id: 210, name: "active user of sms")
Category.create(id: 213, type_id: 22, level_id: nil, parent_id: 210, name: "active user of internet")
Category.create(id: 214, type_id: 22, level_id: nil, parent_id: 210, name: "no home region activity")

Category.create(id: 220, type_id: 22, level_id: nil, parent_id: nil, name: "in own country")
Category.create(id: 221, type_id: 22, level_id: nil, parent_id: 220, name: "active user of calls")
Category.create(id: 222, type_id: 22, level_id: nil, parent_id: 220, name: "active user of sms")
Category.create(id: 223, type_id: 22, level_id: nil, parent_id: 220, name: "active user of internet")
Category.create(id: 224, type_id: 22, level_id: nil, parent_id: 220, name: "no own country activity")

Category.create(id: 230, type_id: 22, level_id: nil, parent_id: nil, name: "abroad")
Category.create(id: 231, type_id: 22, level_id: nil, parent_id: 230, name: "active user of calls")
Category.create(id: 232, type_id: 22, level_id: nil, parent_id: 230, name: "active user of sms")
Category.create(id: 233, type_id: 22, level_id: nil, parent_id: 230, name: "active user of internet")
Category.create(id: 234, type_id: 22, level_id: nil, parent_id: 230, name: "no abroad activity")

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

Category.create(id: _russian_operators, type_id: 2, level_id: nil, parent_id: nil, name: "Russian operators")
Category.create(id: _foreign_operators, type_id: 2, level_id: nil, parent_id: nil, name: "Foreign operators")
Category.create(id: 1020, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Djuice")
Category.create(id: 1021, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "life:)")
Category.create(id: 1022, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "PEOPLEnet")
Category.create(id: 1023, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "TELE2")
Category.create(id: 1024, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Utel")
Category.create(id: _beeline, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Билайн")
Category.create(id: 1026, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Енисейтелеком")
Category.create(id: 1027, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "КиевСтар")
Category.create(id: _megafon, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Мегафон")
Category.create(id: 1029, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Мотив")
Category.create(id: _mts, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "МТС")
Category.create(id: _mts_ukrain, type_id: 2, level_id: nil, parent_id: _foreign_operators, name: "МТС-Украина")
Category.create(id: 1032, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Скайлинк")
Category.create(id: 1033, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "СМАРТС")
Category.create(id: _fixed_line_operator, type_id: 2, level_id: nil, parent_id: _russian_operators, name: "Ростелеком Fixed line")


Category.create(id: 1101, type_id: 0, level_id: 3, parent_id: _russia, name: "Владимирская область")
Category.create(id: 1102, type_id: 0, level_id: 3, parent_id: _russia, name: "Волгоградская область")
Category.create(id: 1103, type_id: 0, level_id: 3, parent_id: _russia, name: "Ивановская область")
Category.create(id: 1104, type_id: 0, level_id: 3, parent_id: _russia, name: "Калининградская область")
Category.create(id: 1105, type_id: 0, level_id: 3, parent_id: _russia, name: "Калужская область")
Category.create(id: 1106, type_id: 0, level_id: 3, parent_id: _russia, name: "Кемеровская область")
Category.create(id: 1107, type_id: 0, level_id: 3, parent_id: _russia, name: "Краснодарский край")
Category.create(id: 1108, type_id: 0, level_id: 3, parent_id: _russia, name: "Красноярский край")
Category.create(id: 1109, type_id: 0, level_id: 3, parent_id: _russia, name: "Московская область")
Category.create(id: 1110, type_id: 0, level_id: 3, parent_id: _russia, name: "Нижегородская область")
Category.create(id: 1111, type_id: 0, level_id: 3, parent_id: _russia, name: "Новгородская область")
Category.create(id: 1112, type_id: 0, level_id: 3, parent_id: _russia, name: "Новосибирская область")
Category.create(id: 1113, type_id: 0, level_id: 3, parent_id: _russia, name: "Омская область")
Category.create(id: 1114, type_id: 0, level_id: 3, parent_id: _russia, name: "Пензенская область")
Category.create(id: 1115, type_id: 0, level_id: 3, parent_id: _russia, name: "Пермский край")
Category.create(id: 1116, type_id: 0, level_id: 3, parent_id: _russia, name: "Приморский край")
Category.create(id: 1117, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Башкортостан")
Category.create(id: 1118, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Саха (Якутия)")
Category.create(id: 1119, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Татарстан")
Category.create(id: 1120, type_id: 0, level_id: 3, parent_id: _russia, name: "Республика Удмуртия")
Category.create(id: 1121, type_id: 0, level_id: 3, parent_id: _russia, name: "Ростовская область")
Category.create(id: 1122, type_id: 0, level_id: 3, parent_id: _russia, name: "Самарская область")
Category.create(id: 1123, type_id: 0, level_id: 3, parent_id: _russia, name: "Ленинградская область")
Category.create(id: 1124, type_id: 0, level_id: 3, parent_id: _russia, name: "Саратовская область")
Category.create(id: 1125, type_id: 0, level_id: 3, parent_id: _russia, name: "Свердловская область")
Category.create(id: 1126, type_id: 0, level_id: 3, parent_id: _russia, name: "Ставропольский край")
Category.create(id: 1127, type_id: 0, level_id: 3, parent_id: _russia, name: "Тюменская область")
Category.create(id: 1128, type_id: 0, level_id: 3, parent_id: _russia, name: "Ульяновская область")
Category.create(id: 1129, type_id: 0, level_id: 3, parent_id: _russia, name: "Ханты-Мансийский АО")
Category.create(id: 1130, type_id: 0, level_id: 3, parent_id: _russia, name: "Челябинская область")
Category.create(id: 1131, type_id: 0, level_id: 3, parent_id: _russia, name: "Ямало-Ненецкий АО")
Category.create(id: 1132, type_id: 0, level_id: 3, parent_id: _russia, name: "Ярославская область")
Category.create(id: 1133, type_id: 0, level_id: 3, parent_id: _russia, name: "Москва")
Category.create(id: 1134, type_id: 0, level_id: 3, parent_id: _russia, name: "Санкт-Петербург")
Category.create(id: 1135, type_id: 0, level_id: 3, parent_id: _russia, name: "Екатеринбург")

Category.create(id: 1501, type_id: 0, level_id: 3, parent_id: _ukraiun, name: "регион Украины")

Category.create(id: _world, type_id: 0, level_id: 0, parent_id: nil, name: "World")

Category.create(id: _europe, type_id: 0, level_id: 1, parent_id: _world, name: "Europe")
Category.create(id: _asia, type_id: 0, level_id: 1, parent_id: _world, name: "Asia")
Category.create(id: _noth_america, type_id: 0, level_id: 1, parent_id: _world, name: "Noth America")
Category.create(id: _south_america, type_id: 0, level_id: 1, parent_id: _world, name: "South America")
Category.create(id: _africa, type_id: 0, level_id: 1, parent_id: _world, name: "Africa")
Category.create(id: _australia_continent, type_id: 0, level_id: 1, parent_id: _world, name: "Australia")

ctr = []
ctr << {:id => _ukraiun, :type_id => 0, :level_id => 2, :parent_id => _europe, :name => "Ukraine"}
ctr << {:id => _russia, :type_id => 0, :level_id => 2, :parent_id => _europe, :name => "Russia"}
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

