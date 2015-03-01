Content::Article.delete_all

Content::Article.create(id: 1, author_id: 0, type_id: _cntt_demo_results, status_id: _cnts_published,
  title: "Рекомендация для активных пользователей всеми услугами связи при нахождении дома, или путешествуя по России и за границей",
  content: {
    usage_model: "Вы много звоните, отправляет смс и ммс, постоянно пользуетесь интернетом, находясь дома, путешествуя по России и за границей",
    summary: "Если модель использования мобильной связи совпадает с вашей, то предпочтительным вариантом является выбор тарифов Мегафон",
    body: "Основной причиной такой рекомендации является то, что тарифы в международном роуминге у Мегафона самые низкие",
  },
  key: {
    operators: [_mts, _beeline, _megafon],
    roumings: [_cntkr_own_region, _cntkr_home_region, _cntkr_own_country, _cntkr_abroad],
    services: [_cntks_calls, _cntks_sms, _cntks_mms, _cntks_internet],
    destinations: [_cntkd_to_own_home_regions, _cntkd_to_russia, _cntkd_to_abroad],
    intensities: {
      _cntks_calls: _cntkui_high,
      _cntks_sms: _cntkui_high,
      _cntks_mms: _cntkui_high,
      _cntks_internet: _cntkui_high,
    }
  }
)

Content::Article.create(id: 2, author_id: 0, type_id: _cntt_demo_results, status_id: _cnts_published,
  title: "Рекомендация для тех, кто пользуется звонками и смс только по необходимости и только в своем или домашнем регионе",
  content: {
    usage_model: "Вы мало звоните и отправляет смс, не пользуетесь интернетом. Вы не используете телефон, находясь за пределами своего или домашнего региона.
                  Вы звоните только в свой или домашний регион",
    summary: "Если модель использования мобильной связи совпадает с вашей, то предпочтительными вариантами являются следующие тарифы",
    body: "Основной причиной такой рекомендации является то, что ....",
  },
  key: {
    operators: [_mts, _beeline, _megafon],
    roumings: [_cntkr_own_region, _cntkr_home_region],
    services: [_cntks_calls, _cntks_sms],
    destinations: [_cntkd_to_own_home_regions],
    intensities: {
      _cntks_calls: _cntkui_low,
      _cntks_sms: _cntkui_low,
      _cntks_mms: _cntkui_zero,
      _cntks_internet: _cntkui_zero,
    }
  }
)
