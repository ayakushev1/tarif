Content::Category.delete_all
Content::Category.create(id: _cntt_demo_results, type_id: 30, name: "demo_results")

Content::Category.create(id: _cnts_draft, type_id: 31, name: "draft")
Content::Category.create(id: _cnts_reviewed, type_id: 31, name: "reviewed")
Content::Category.create(id: _cnts_published, type_id: 31, name: "published")
Content::Category.create(id: _cnts_hidden, type_id: 31, name: "hidden")

Content::Category.create(id: _cntkr_own_region, type_id: 32, name: "Регион регистрации")
Content::Category.create(id: _cntkr_home_region, type_id: 32, name: "Домашний регион")
Content::Category.create(id: _cntkr_own_country, type_id: 32, name: "По России за пределами домашнего региона")
Content::Category.create(id: _cntkr_abroad, type_id: 32, name: "За границей")

Content::Category.create(id: _cntks_calls, type_id: 33, name: "Звонки")
Content::Category.create(id: _cntks_sms, type_id: 33, name: "СМС")
Content::Category.create(id: _cntks_mms, type_id: 33, name: "ММС")
Content::Category.create(id: _cntks_internet, type_id: 33, name: "Интернет")

Content::Category.create(id: _cntkd_to_own_home_regions, type_id: 34, name: "В домашний регион")
Content::Category.create(id: _cntkd_to_russia, type_id: 34, name: "По России")
Content::Category.create(id: _cntkd_to_abroad, type_id: 34, name: "За границу")

Content::Category.create(id: _cntkui_zero, type_id: 35, name: "Нулевая")
Content::Category.create(id: _cntkui_low, type_id: 35, name: "Низкая")
Content::Category.create(id: _cntkui_medium, type_id: 35, name: "Средняя")
Content::Category.create(id: _cntkui_high, type_id: 35, name: "Высокая")
Content::Category.create(id: _cntkui_very_high, type_id: 35, name: "Очень высокая")
