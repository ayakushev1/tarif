def access_methods_to_constant_countries  
#0 locations
  _world = 1590; _europe = 1591; _asia = 1592; _noth_america = 1593; _south_america = 1594; _africa = 1595; _australia_continent = 1596;
  _russia = 1100; _ukraiun = 1500;  

#2 operators
  _russian_operators = 3001; _foreign_operators = 3002
  _beeline = 1025; _megafon = 1028; _mts = 1030; _mts_ukrain = 1031; _fixed_line_operator = 1034; _other_rusian_operator = 1035
  _operators = [_beeline, _megafon, _mts]

_first_country_id = 1600; _first_country_operator_id = 3003;
_all_country_list_in_string = %w{
_australia _austria _azerbaijan _albania _algir _angilia _angola _andorra _antigua_and_barbuda _argentina _armenia _aruba _afganistan _bagam_islands
_bangldesh _barbados _bahrein _belarus _belis _belgium _benin _bermud_islands _bulgaria _bolivia _bosnia_and_herzegovina _botsvana _brasilia
_bruney _burkina_faso _burundy _butan _vatican _great_britain _hungary _venesuala _vietnam _gernsi _gabon _gaity _gainana _gambia _gana _gvadelupa
_gvatemala _gvinea _gvinea_bisay _germany _gibraltar _gonduras _honkong _grenada _greenland _greece _georgia _abkhazia _south_ossetia _guam
_denmark _gersi _dem_republick_kongo _dominika _dominiknskaya_republic _egypt _zambia _zimbabve _israel _india _indonezia _iordania _iraq _iran _ireland
_iceland _spain _italy _iemen _kobo_verde _kazakhstan _kayman_islands _kambodga _kamerun _canada _katar _kenia _cyprus _china _columbia
_komorskie_islands _kongo _north_korea _south_korea _kosta_rika _kot_d_ivar _cuba _kuveit _kyrgyzstan _laos _latvia _liberia _livan _livia
_lithuania _liechtenstein _luxembourg _men _mavrikiy _mavritania _magadaskar _mozambik _makao _macedonia _malavi _malazia _mali _maldiv_islands
_malta _morocco _martinika _mexica _moldova _monaco _mongolia _mianma _namibia _nepal _niger _nigeria _netherland_antil_island _netherlands
_nikaragya _new_zeland _new_kaledonia _norway _uae _oman _pakistan _palay _palestina _panama _papua_new_gvinea _paragvay _peru _poland
_portugal _puerto_riko _reunion_island _ruanda _romania _salvador _san_marino _san_tome_and_prinsipi _saudov_aravia _svazilend _seishel_island
_senegal _san_pier_and_mikelon_island _sent_kits_and_nevis _sent_luis_island _serbia _singapur _siria _slovakia _slovenia _somali _sudan _surinam
_usa _sierra_leone _tajikistan _tailand _taivan _tansania _terks_and_kaikos _togo _trinidad_and_tobago _tunis _turkmenistan _turkey _uganda
_uzbekistan _urugvai _the_faroe_islands _fidgi _fillipiny _finland _folklend_islands _france _french_gviana _french_polinesia _croatia
_center_africa_republic _chad _montenegro _czech_republic _chily _switzerland _sweden _shri_lanka _ekvador _ekvator_gvinea _eritria _estonia 
_efiopia _south_africa _yamayka _japan 
}
_all_country_list_in_string.each_index do |_i|
  send(:define_method, _all_country_list_in_string[_i].to_sym) {_first_country_id + _i}
  send(:define_method, "_operator#{_all_country_list_in_string[_i]}".to_sym) {_first_country_operator_id + _i}
end

_all_countries = [_australia, _austria, _azerbaijan, _albania, _algir, _angilia, _angola, _andorra, _antigua_and_barbuda, _argentina, _armenia, _aruba, _afganistan, _bagam_islands,
_bangldesh, _barbados, _bahrein, _belarus, _belis, _belgium, _benin, _bermud_islands, _bulgaria, _bolivia, _bosnia_and_herzegovina, _botsvana, _brasilia,
_bruney, _burkina_faso, _burundy, _butan, _vatican, _great_britain, _hungary, _venesuala, _vietnam, _gernsi, _gabon, _gaity, _gainana, _gambia, _gana, _gvadelupa,
_gvatemala, _gvinea, _gvinea_bisay, _germany, _gibraltar, _gonduras, _honkong, _grenada, _greenland ,_greece, _georgia, _abkhazia, _south_ossetia, _guam,
_denmark, _gersi, _dem_republick_kongo, _dominika, _dominiknskaya_republic, _egypt, _zambia, _zimbabve, _israel, _india, _indonezia, _iordania, _iraq, _iran, _ireland,
_iceland, _spain, _italy, _iemen, _kobo_verde, _kazakhstan, _kayman_islands, _kambodga, _kamerun, _canada, _katar, _kenia, _cyprus, _china, _columbia,
_komorskie_islands, _kongo, _north_korea, _south_korea, _kosta_rika, _kot_d_ivar, _cuba, _kuveit, _kyrgyzstan, _laos, _latvia, _liberia, _livan, _livia,
_lithuania, _liechtenstein, _luxembourg, _men, _mavrikiy, _mavritania, _magadaskar, _mozambik, _makao, _macedonia, _malavi, _malazia, _mali, _maldiv_islands,
_malta, _morocco, _martinika, _mexica, _moldova, _monaco, _mongolia, _mianma, _namibia, _nepal, _niger, _nigeria, _netherland_antil_island, _netherlands,
_nikaragya, _new_zeland, _new_kaledonia, _norway, _uae, _oman, _pakistan, _palay, _palestina, _panama, _papua_new_gvinea, _paragvay, _peru, _poland,
_portugal, _puerto_riko, _russia, _reunion_island, _ruanda, _romania, _salvador, _san_marino, _san_tome_and_prinsipi, _saudov_aravia, _svazilend, _seishel_island,
_senegal, _san_pier_and_mikelon_island, _sent_kits_and_nevis, _sent_luis_island, _serbia, _singapur, _siria, _slovakia, _slovenia, _somali, _sudan, _surinam,
_usa, _sierra_leone, _tajikistan, _tailand, _taivan, _tansania, _terks_and_kaikos, _togo, _trinidad_and_tobago, _tunis, _turkmenistan, _turkey, _uganda,
_uzbekistan, _ukraiun, _urugvai, _the_faroe_islands, _fidgi, _fillipiny, _finland, _folklend_islands, _france, _french_gviana, _french_polinesia, _croatia,
_center_africa_republic, _chad, _montenegro, _czech_republic, _chily, _switzerland, _sweden, _shri_lanka, _ekvador, _ekvator_gvinea, _eritria, _estonia, 
_efiopia, _south_africa, _yamayka, _japan]

#raise(StandardError, [_russia.methods])

_europe_countries = [
  _austria,  _albania, _andorra, _belgium, _bulgaria, _bosnia_and_herzegovina, _vatican, _great_britain, _hungary, _germany, _gibraltar,
  _greenland, _denmark, _greece, _ireland, _iceland, _spain, _italy, _cyprus, _latvia,
  _liechtenstein, _lithuania, _luxembourg, _macedonia, _malta, _monaco, _netherlands, _norway, _poland, _portugal,
  _romania, _san_marino, _serbia, _slovakia, _slovenia,  _turkey, _the_faroe_islands, _finland, _france, _croatia,
  _montenegro, _czech_republic, _switzerland, _sweden, _estonia,
  _gersi, _men, _gernsi, _russia, _belarus, _ukraiun, _moldova
  ]

_europe_countries_without_russia = _europe_countries - [_russia]

_asia_countries = [_azerbaijan, _armenia, _afganistan, _bangldesh, _bahrein, _bruney, _butan, _vietnam, _honkong, _georgia, _abkhazia, _south_ossetia,
  _israel, _india, _indonezia, _iordania, _iraq, _iran, _iemen, _kazakhstan, _kambodga, _katar, _china, _north_korea, _south_korea, _kuveit, _kyrgyzstan,
  _laos, _livan, _makao, _malazia, _maldiv_islands, _mongolia, _mianma, _nepal, _new_zeland, _uae, _oman, _pakistan, _palestina, _saudov_aravia, _singapur, 
  _siria, _somali, _tajikistan, _tailand, _taivan, _turkmenistan, _turkey, _uzbekistan, _fillipiny, _shri_lanka, _japan]

_noth_america_countries = [_bagam_islands, _barbados, _belis, _bermud_islands, _gaity, _gainana, _gvadelupa, _gvatemala, _gonduras, _grenada, _dominika,
  _dominiknskaya_republic, _kayman_islands, _canada, _cuba, _martinika, _mexica, _netherland_antil_island, _nikaragya, _panama, _salvador, _sent_kits_and_nevis, 
  _sent_luis_island, _surinam, _usa, _trinidad_and_tobago, _french_gviana, _french_polinesia, _yamayka, ]

_south_america_countries = [_argentina, _bolivia, _brasilia, _venesuala, _columbia, _kosta_rika, _paragvay, _peru, _puerto_riko, _urugvai, _the_faroe_islands, 
  _folklend_islands, _chily, _ekvador, ]

_africa_countries = [_algir, _angilia, _angola, _aruba, _benin, _botsvana, _burkina_faso, _burundy, _gabon, _gambia, _gana, _gvinea, _gvinea_bisay, 
  _dem_republick_kongo, _egypt, _zambia, _zimbabve, _kobo_verde, _kamerun, _kenia, _komorskie_islands, _kongo, _kot_d_ivar, _liberia, _livia, _mavrikiy, _mavritania,
  _magadaskar, _mozambik, _malavi, _mali, _morocco, _namibia, _niger, _nigeria, _papua_new_gvinea, _ruanda, _svazilend, _seishel_island, _senegal, 
  _sudan, _sierra_leone, _tansania, _togo, _tunis, _uganda, _center_africa_republic, _chad, _ekvator_gvinea, _eritria, _efiopia, _south_africa, ]

_australia_countries = [_australia, _antigua_and_barbuda, _guam, _new_kaledonia, _palay, _reunion_island, _san_tome_and_prinsipi, _san_pier_and_mikelon_island, 
   _terks_and_kaikos, _fidgi, ]

_world_countries = _europe_countries + _asia_countries + _noth_america_countries + _south_america_countries + _africa_countries + _australia_countries

_world_countries_without_russia = _europe_countries_without_russia + _asia_countries + _noth_america_countries + _south_america_countries + _africa_countries



_all_country_list_in_array_with_russian_names = [
[_australia,  'Австралия',           14.9,  '*111*101*61#'],
[_austria,  'Австрия',             6.9,   '*111*101*43#'],
[_azerbaijan, 'Азербайджан',         11.5,  '*111*101*994#'],
[_albania,  'Албания',             12.9,  '*111*101*355#'],
[_algir, 'Алжир',               14.9,  '*111*101*213#'],
[_angilia, 'Ангилья',             29.9,  '*111*101*1264#'],
[_angola,  'Ангола',              14.9,  '*111*101*244#'],
[_andorra,  'Андорра',             9.9,   '*111*101*376#'],
[_antigua_and_barbuda, 'Антигуа и Барбуда',   14.9,  '*111*101*1268#'],
[_argentina,  'Аргентина',           14.9,  '*111*101*54#'],
[_armenia,  'Армения',             5.9,   '*111*101*374#'],
[_aruba,  'Аруба',               29.9,  '*111*101*297#'],
[_afganistan, 'Афганистан',          19.9,  '*111*101*93#'],
[_bagam_islands, 'Багамские о-ва',      14.9,  '*111*101*1242#'],
[_bangldesh,  'Бангладеш',           19.9,  '*111*101*880#'],
[_barbados, 'Барбадос',            14.9,  '*111*101*1246#'],
[_bahrein,  'Бахрейн',             19.9,  '*111*101*973#'],
[_belarus,  'Беларусь',            11.5,  '*111*101*375#'],
[_belis,  'Белиз',               29.9,  '*111*101*501#'],
[_belgium,  'Бельгия',             7.9,   '*111*101*32#'],
[_benin,  'Бенин',               29.9,  '*111*101*229#'],
[_bermud_islands, 'Бермудские о-ва',     14.9,  '*111*101*441#'],
[_bulgaria, 'Болгария',            12.9,  '*111*101*359#'],
[_bolivia,  'Боливия',             14.9,  '*111*101*591#'],
[_bosnia_and_herzegovina, 'Босния и Герцеговина', 12.9, '*111*101*387#'],
[_botsvana, 'Ботсвана',            29.9,  '*111*101*267#'],
[_brasilia, 'Бразилия',            14.9,  '*111*101*55#'],
[_bruney, 'Бруней',              19.9,  '*111*101*673#'],
[_burkina_faso, 'Буркина Фасо',        29.9,  '*111*101*226#'],
[_burundy,  'Бурунди',             14.9,  '*111*101*257#'],
[_butan,  'Бутан',               19.9,  '*111*101*975#'],
[_vatican,  'Ватикан',             7.9,   '*111*101*379#'],
[_great_britain,  'Великобритания',      6.9,   '*111*101*44#'],
[_hungary,  'Венгрия',             7.9,   '*111*101*36#'],
[_venesuala,  'Венесуэла',           14.9,  '*111*101*58#'],
[_vietnam,  'Вьетнам',             5.9,   '*111*101*84#'],
[_gernsi, 'Гернси'],
[_gabon,  'Габон',               14.9,  '*111*101*241#'],
[_gaity,  'Гаити',               29.9,  '*111*101*509#'],
[_gainana,  'Гайана',              29.9,  '*111*101*592#'],
[_gambia, 'Гамбия',              49.9,  '*111*101*220#'],
[_gana, 'Гана',                14.9,  '*111*101*233#'],
[_gvadelupa, 'Гваделупа',           29.9,  '*111*101*590#'],
[_gvatemala,  'Гватемала',           14.9,  '*111*101*502#'],
[_gvinea, 'Гвинея',              49.9,  '*111*101*224#'],
[_gvinea_bisay, 'Гвинея-Бисау',        49.9,  '*111*101*245#'],
[_germany,  'Германия',            6.9,   '*111*101*49#'],
[_gibraltar,  'Гибралтар',           19.9,  '*111*101*350#'],
[_gonduras, 'Гондурас',            14.9,  '*111*101*504#'],
[_honkong,  'Гонконг',             4.9,   '*111*101*852#'],
[_grenada,  'Гренада',             14.9,  '*111*101*1473#'],
[_greenland,  'Гренландия',          19.9,  '*111*101*299#'],
[_greece, 'Греция',              7.9,   '*111*101*30#'],
[_georgia,  'Грузия',              5.5,   '*111*101*995#'],
[_abkhazia, 'Абхазия',             5.5,   '*111*101*995#'],
[_south_ossetia,  'Южная Осетия',        5.5,   '*111*101*995#'],
[_guam, 'Гуам',                14.9,  '*111*101*1671#'],
[_denmark,  'Дания',               7.9,   '*111*101*45#'],
[_gersi, 'Герси'], 
[_dem_republick_kongo,  'Демократическая Республика Конго', 29.9, '*111*101*243#'],
[_dominika, 'Доминика',            29.9,  '*111*101*1768#'],
[_dominiknskaya_republic, 'Доминиканская Республика', 14.9, '*111*101*1809#'],
[_egypt,  'Египет',              14.9,  '*111*101*20#'],
[_zambia, 'Замбия',              14.9,  '*111*101*260#'],
[_zimbabve, 'Зимбабве',            29.9,  '*111*101*263#'],
[_israel, 'Израиль',             6.9,   '*111*101*972#'],
[_india,  'Индия',               9.9,   '*111*101*91#'],
[_indonezia,  'Индонезия',           19.9,  '*111*101*62#'],
[_iordania, 'Иордания',            19.9,  '*111*101*962#'],
[_iraq, 'Ирак',                19.9,  '*111*101*964#'],
[_iran, 'Иран',                19.9,  '*111*101*98#'],
[_ireland,  'Ирландия',            8.9,   '*111*101*353#'],
[_iceland,  'Исландия',            9.9,   '*111*101*354#'],
[_spain,  'Испания',             7.9,   '*111*101*34#'],
[_italy,  'Италия',              7.9,   '*111*101*39#'],
[_iemen, 'Йемен',               19.9,  '*111*101*967#'],
[_kobo_verde, 'Кабо-Верде',          29.9,  '*111*101*238#'],
[_kazakhstan, 'Казахстан',           5.5,   '*111*101*77#'],
[_kayman_islands, 'Каймановы о-ва',      14.9,  '*111*101*1345#'],
[_kambodga, 'Камбоджа',            19.9,  '*111*101*855#'],
[_kamerun,  'Камерун',             29.9,  '*111*101*237#'],
[_canada, 'Канада',              4.9,   '*111*101*1#'],
[_katar,  'Катар',               19.9,  '*111*101*974#'],
[_kenia,  'Кения',               14.9,  '*111*101*254#'],
[_cyprus, 'Кипр',                6.9,   '*111*101*357#'],
[_china,  'Китай',               4.9,   '*111*101*86#'],
[_columbia, 'Колумбия',            29.9,  '*111*101*57#'],
[_komorskie_islands, 'Коморские о-ва',      49.9,  '*111*101*269#'],
[_kongo,  'Конго',               49.9,  '*111*101*242#'],
[_north_korea, 'Корея Северная',      19.9,  '*111*101*850#'],
[_south_korea, 'Корея Южная',         5.9,   '*111*101*82#'],
[_kosta_rika, 'Коста-Рика',          14.9,  '*111*101*506#'],
[_kot_d_ivar, 'Кот-д’Ивуар',         29.9,  '*111*101*225#'],
[_cuba, 'Куба',                49.9,  '*111*101*53#'],
[_kuveit, 'Кувейт',              19.9,  '*111*101*965#'],
[_kyrgyzstan, 'Кыргызстан',          5.5,   '*111*101*996#'],
[_laos, 'Лаос',                19.9,  '*111*101*856#'],
[_latvia, 'Латвия',              8.9,   '*111*101*371#'],
[_liberia,  'Либерия',             29.9,  '*111*101*231#'],
[_livan, 'Ливан',               19.9,  '*111*101*961#'],
[_livia,  'Ливия',               29.9,  '*111*101*218#'],
[_lithuania,  'Литва',               8.9,   '*111*101*370#'],
[_liechtenstein,  'Лихтенштейн',         19.9,  '*111*101*423#'],
[_luxembourg, 'Люксембург',          7.9,   '*111*101*352#'],
[_men, 'Мэн'], 
[_mavrikiy, 'Маврикий',            14.9,  '*111*101*230#'],
[_mavritania, 'Мавритания',          29.9,  '*111*101*222#'],
[_magadaskar, 'Мадагаскар',          29.9,  '*111*101*261#'],
[_mozambik, 'Мозамбик',            29.9,  '*111*101*258#'],
[_makao,  'Макао',               4.9,   '*111*101*853#'],
[_macedonia,  'Македония',           12.9,  '*111*101*389#'],
[_malavi, 'Малави',              14.9,  '*111*101*265#'],
[_malazia,  'Малайзия',            19.9,  '*111*101*60#'],
[_mali, 'Мали',                29.9,  '*111*101*223#'],
[_maldiv_islands, 'Мальдивские о-ва',    19.9,  '*111*101*960#'],
[_malta,  'Мальта',              12.9,  '*111*101*356#'],
[_morocco, 'Марокко',             29.9,  '*111*101*212#'],
[_martinika,  'Мартиника',           49.9,  '*111*101*596#'],
[_mexica, 'Мексика',             14.9,  '*111*101*52#'],
[_moldova, 'Молдова',             5.9,   '*111*101*373#'],
[_monaco, 'Монако',              8.9,   '*111*101*377#'],
[_mongolia, 'Монголия',            9.9,   '*111*101*976#'],
#[_mts_countries_of_ms, 'Страны МТС',          3.9,   '*111*101*001#'],
[_mianma, 'Мьянма',              19.9,  '*111*101*95#'],
[_namibia, 'Намибия',             29.9,  '*111*101*264#'],
[_nepal, 'Непал',               19.9,  '*111*101*977#'],
[_niger, 'Нигер',               14.9,  '*111*101*227#'],
[_nigeria, 'Нигерия',             14.9,  '*111*101*234#'],
[_netherland_antil_island, 'Нидерландские Антильские о-ва', 14.9,  '*111*101*599#'],
[_netherlands, 'Нидерланды',          7.9,   '*111*101*31#'],
[_nikaragya, 'Никарагуа',           29.9,  '*111*101*505#'],
[_new_zeland, 'Новая Зеландия',      14.9,  '*111*101*64#'],
[_new_kaledonia, 'Новая Каледония',     14.9,  '*111*101*687#'],
[_norway, 'Норвегия',            7.9,   '*111*101*47#'],
[_uae,  'ОАЭ',                 19.9,  '*111*101*971#'],
[_oman, 'Оман',                19.9,  '*111*101*968#'],
[_pakistan, 'Пакистан',            19.9,  '*111*101*92#'],
[_palay, 'Палау',               29.9,  '*111*101*680#'],
[_palestina, 'Палестина',           19.9,  '*111*101*970#'],
[_panama, 'Панама',              14.9,  '*111*101*507#'],
[_papua_new_gvinea, 'Папуа-Новая Гвинея',  49.9,  '*111*101*675#'],
[_paragvay, 'Парагвай',            14.9,  '*111*101*595#'],
[_peru, 'Перу',                14.9,  '*111*101*51#'],
[_poland, 'Польша',              6.9,   '*111*101*48#'],
[_portugal, 'Португалия',          7.9,   '*111*101*351#'],
[_puerto_riko, 'Пуэрто-Рико',         14.9,  '*111*101*1787#'],
#[_russia, 'Россия'],
#[_russia_to_mts, 'Россия На МТС',       2.5,   '*111*101*7#'],
#[_russia_to_other_operator, 'Россия остальные',    3.5,   '*111*101*7#'],
[_reunion_island, 'Реюньон о-в',         29.9,  '*111*101*262#'],
[_ruanda, 'Руанда',              14.9,  '*111*101*250#'],
[_romania, 'Румыния',             7.9,   '*111*101*40#'],
[_salvador, 'Сальвадор',           29.9,  '*111*101*503#'],
[_san_marino, 'Сан-Марино',          12.9,  '*111*101*378#'],
[_san_tome_and_prinsipi, 'Сан-Томе и Принсипи', 49.9,  '*111*101*239#'],
[_saudov_aravia, 'Саудовская Аравия',   19.9,  '*111*101*966#'],
[_svazilend,  'Свазиленд',           29.9,  '*111*101*268#'],
[_seishel_island, 'Сейшельские о-ва',    14.9,  '*111*101*248#'],
[_senegal, 'Сенегал',             14.9,  '*111*101*221#'],
[_san_pier_and_mikelon_island, 'Сен-Пьер и Микелон о-в',  14.9,  '*111*101*508#'],
[_sent_kits_and_nevis, 'Сент-Китс и Невис',   29.9,  '*111*101*1869#'],
[_sent_luis_island, 'Сент-Люсия о-в',      14.9,  '*111*101*1758#'],
[_serbia, 'Сербия',              12.9,  '*111*101*381#'],
[_singapur, 'Сингапур',            5.9,   '*111*101*65#'],
[_siria, 'Сирия',               19.9,  '*111*101*963#'],
[_slovakia, 'Словакия',            8.9,   '*111*101*421#'],
[_slovenia, 'Словения',            8.9,   '*111*101*386#'],
[_somali, 'Сомали',              49.9,  '*111*101*252#'],
[_sudan, 'Судан',               14.9,  '*111*101*249#'],
[_surinam, 'Суринам',             29.9,  '*111*101*597#'],
[_usa, 'США',                 4.9,   '*111*101*1#'],
[_sierra_leone, 'Сьерра-Леоне',        49.9,  '*111*101*232#'],
[_tajikistan, 'Таджикистан',         5.5,   '*111*101*992#'],
[_tailand, 'Таиланд',             19.9,  '*111*101*66#'],
[_taivan, 'Тайвань',             9.9,   '*111*101*886#'],
[_tansania, 'Танзания',            14.9,  '*111*101*255#'],
[_terks_and_kaikos, 'Тёркс и Кайкос',      29.9,  '*111*101*1649#'],
[_togo, 'Того',                49.9,  '*111*101*228#'],
[_trinidad_and_tobago, 'Тринидад и Тобаго',   14.9,  '*111*101*1868#'],
[_tunis, 'Тунис',               29.9,  '*111*101*216#'],
[_turkmenistan, 'Туркменистан',        5.5,   '*111*101*993#'],
[_turkey, 'Турция',              6.9,   '*111*101*90#'],
[_uganda, 'Уганда',              14.9,  '*111*101*256#'],
[_uzbekistan, 'Узбекистан',          5.5,   '*111*101*998#'],
#[_ukraiun, 'Украина',             5.5,   '*111*101*380#'],
[_urugvai, 'Уругвай',             14.9,  '*111*101*598#'],
[_the_faroe_islands, 'Фарерские о-ва',      19.9,  '*111*101*298#'],
[_fidgi, 'Фиджи',               29.9,  '*111*101*679#'],
[_fillipiny, 'Филиппины',           19.9,  '*111*101*63#'],
[_finland, 'Финляндия',           6.9,   '*111*101*358#'],
[_folklend_islands, 'Фолклендские о-ва',   49.9,  '*111*101*500#'],
[_france, 'Франция',             6.9,   '*111*101*33#'],
[_french_gviana, 'Французская Гвиана',  29.9,  '*111*101*594#'],
[_french_polinesia, 'Французская Полинезия', 29.9,  '*111*101*689#'],
[_croatia, 'Хорватия',            8.9,   '*111*101*385#'],
[_center_africa_republic, 'Центрально-Африканская Республика',  49.9,  '*111*101*236#'],
[_chad, 'Чад',                 14.9,  '*111*101*235#'],
[_montenegro, 'Черногория',          12.9,  '*111*101*382#'],
[_czech_republic, 'Чехия',               8.9,   '*111*101*420#'],
[_chily, 'Чили',                14.9,  '*111*101*56#'],
[_switzerland, 'Швейцария',           8.9,   '*111*101*41#'],
[_sweden, 'Швеция',              6.9,   '*111*101*46#'],
[_shri_lanka, 'Шри-Ланка',           19.9,  '*111*101*94#'],
[_ekvador, 'Эквадор',             29.9,  '*111*101*593#'],
[_ekvator_gvinea, 'Экваториальная Гвинея', 29.9,  '*111*101*240#'],
[_eritria, ' Эритрея',             49.9,  '*111*101*291#'],
[_estonia, 'Эстония',             9.9,   '*111*101*372#'],
[_efiopia, 'Эфиопия',             29.9,  '*111*101*251#'],
[_south_africa, 'ЮАР',                 14.9,  '*111*101*27#'],
[_yamayka, 'Ямайка',              14.9,  '*111*101*1876#'],
[_japan, 'Япония',              9.9,   '*111*101*81#'],
]
  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_countries

