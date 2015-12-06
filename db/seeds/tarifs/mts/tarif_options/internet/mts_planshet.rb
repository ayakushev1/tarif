#МТС Планшет
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_mts_planshet, :name => 'МТС Планшет', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/tarifu/unlim_options/'},  
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :internet_comp => [_mts_internet_super, _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip]}, 
      :internet_smart => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb, _mts_super_bit],
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_mini_bit, _mts_unlimited_internet_on_day], :higher => []},
    :prerequisites => [_mts_mts_connect_4],
    :forbidden_tarifs => {:to_switch_on => [_mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4, _mts_smart_top, _mts_smart_nonstop], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )

#auto_turbo_buttons 

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => 450.0})

#Ежемесячная плата - скидка за подключение опции к тарифу Коннект
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => _stf_price_by_1_month, :price => -50.0})

#All Russia rouming, internet, with turbo-buttons
  category = {:name => '_sctcg_all_russia_rouming_internet', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _internet}
  @tc.add_one_service_category_tarif_class(category, {}, 
    {:calculation_order => 0, :price => 0.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'stf_mts_internet_mini', :description => '', 
     :formula => {
       :window_condition => "(4000.0 >= sum_volume)", :window_over => 'month', 
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
       :method => "price_formulas.price",
       
#       :auto_turbo_buttons  => {
#         :group_by => 'month',
#         :stat_params => {
#           :sum_volume => "sum((description->>'volume')::float)",
#           :count_of_usage_of_500 => "ceil((sum((description->>'volume')::float) - 4000.0) / 500.0)",
#           :count_of_usage_of_2000 => "ceil((sum((description->>'volume')::float) - 4000.0) / 2000.0)"},
#       :method => "price_formulas.price + case when count_of_usage_of_500 > 2.66667 then count_of_usage_of_2000 * 250.0 when count_of_usage_of_500 > 0.0 then count_of_usage_of_500 * 95.0 else 0.0 end",
#       }
     }, 
    } )

@tc.add_tarif_class_categories

#турбо-кнопки добавлены в опцию, а не отдельно
#TODO не добавлена кнопка "Турбо-ночи"

#Как и кто может подключить/отключить

#МТС Планшет
#Для подключения/отключения опции «МТС Планшет»:
#наберите 111835;
#отправьте на номер 111 SMS с текстом: 835 — для подключения;
#8350 — для отключения;
#воспользуйтесь Интернет-Помощником
#зайдите с вашего планшета с сим-картой МТС на сайт planshet.mts.ru и нажмите на кнопку «Подключить МТС Планшет»
#Для просмотра «Мобильного ТВ» скачайте и установите приложение «MTS TV»(из магазина приложений для вашей модели планшетного компьютера, по ссылке , либо наберите  )
#Скачать приложение «MTS TV»
#Запустите приложение «MTS TV» и выбирайте телеканал для просмотра.
#Опцию «МТС Планшет» могут подключить абоненты всех тарифных планов МТС, за исключением тарифных планов «SIM», «i-Онлайнер», «Онлайнер», «Супер Онлайнер», «Заботливый», 
#«Классный» и всех модификаций перечисленных тарифных планов
#(!) МТС рекомендует использовать опцию на тарифном плане «МТС Коннект»
#Стоимость исходящего SMS на номер 111 - 0 руб. при нахождении на территории Российской Федерации в сети МТС и в международном роуминге.

#Сколько стоит
#МТС Планшет
#Ежемесячная плата за опцию – 400 руб. (на тарифных планах «МТС Коннект»),  450 руб. (на прочих тарифных планах, кроме «МТС Коннект»)
#Интернет-трафик в период и в зоне действия опции – 0 руб./Мб.
#Отключение тарифной опции — бесплатно.
#В момент подключения опции «МТС Планшет» списывается плата за подключение в размере ежемесячной платы. Начиная со второго месяца использования опции, 
#списывается ежемесячная плата в день, соответствующий дате подключения тарифной опции.
#(!) МТС рекомендует использовать опцию на тарифном плане «МТС Коннект»
#Для абонентов тарифных планов «МТС Коннект» в день списания ежемесячной платы за опцию «МТС Планшет» проводится проверка баланса. 
#Если на счете недостаточно средств для списания ежемесячной платы, то доступ в Интернет блокируется. 
#При этом возможность пользоваться остальными сервисами, не зависящими от GPRS, сохраняется. 
#При пополнении счета на сумму, достаточную для списания ежемесячной платы, доступ в Интернет будет предоставлен в полном объеме.
#Для абонентов остальных тарифных планов в день списания ежемесячной платы за опцию «МТС Планшет» проверка баланса не проводится. 
#Плата за опцию списывается независимо от количества средств на счете.
#Настроить автоматическое пополнение счета
#В случае, если на момент списания номер заблокирован, плата будет списана в момент выхода из блокировки за текущий месяц, в котором произошла отмена блокировки. 
#За полный календарный месяц, в котором абонент фактически находился в блокировке, ежемесячная плата не взимается.
#Все цены указаны с учетом НДС.

#Не предоставляется на тарифе ULTRA

#Условия предоставления опции

#МТС Планшет Онлайн Мобильный Интернет в рамках опции действует для абонентов г. Москва и Московской области на всей территории России в зоне действия сети МТС.
#При превышении месячной квоты трафика 4 Гб доступ в Интернет приостанавливается. В 03:00 даты следующего календарного месяца, аналогичной дате подключения опции, 
#ежемесячная квота трафика обновляется. В случае, если в следующем календарном месяце отсутствует дата, аналогичная дате подключения, лимит трафика контролируется и учитывается 
#до последнего числа календарного месяца.
#Для удобства самых активных пользователей Интернета в рамках опции реализован сервис, который помогает быстро снять ограничения скорости при исчерпании квоты трафика.
=begin 
Достаточно воспользоваться кнопкой на диалоговой странице interceptor.mts.ru, которая отобразится автоматически при установлении ограничений по скорости.
При нахождении на территории Петропавловск-Камчатского, Магаданского, Якутского, Южно-Сахалинского, Норильского регионов, а также Чукотского автономного округа 
максимальная скорость ограничивается 128 Кбит/с в пределах месячной квоты трафика.
Фактическая скорость может отличаться от заявленной и зависит от технических параметров сети мобильной связи МТС и от других обстоятельств, влияющих на качество связи.
Квота трафика в рамках опции единая и расходуется в сетях 2G/3G/4G.
Точка доступа (APN): только internet.mts.ru или wap.mts.ru.
Интернет-опция не действует при выходе на сайты с премиальной тарификацией.
Автоматический переход между сетями 4G LTE (TDD/FDD) и 3G/2G возможен только из сети 4G LTE (TDD/FDD) в сети 3G/2G; обратный переход без разрыва соединения невозможен. 
Автоматический переход между сетями 4G LTE TDD и 4G LTE FDD без разрыва соединения невозможен. В сети 4G отсутствует возможность совершения и приема голосового вызова и 
отправки/получения SMS. При совершении и приеме голосового вызова и отправки/получения SMS, устройство автоматически переходит в сети 3G/2G.
МТС Планшет
Мобильный Интернет в рамках опции «МТС Планшет»Мобильный Интернет в рамках опции «МТС Планшет» действует для абонентов г. Москвы и Московской области по всей 
России в зоне действия сети МТС
При превышении месячной квоты трафика 4 Гб доступ в Интернет приостанавливается. В 03.00 даты, аналогичной дате подключения опции следующего календарного месяца ежемесячная 
квота трафика обновляется. В случае, когда в следующем календарном месяце отсутствует дата, аналогичная дате подключения, лимит трафика контролируется и учитывается 
до последнего числа календарного месяца.
Для удобства самых активных пользователей Интернета в рамках опции «МТС Планшет» реализован сервис, который помогает вам быстро снять ограничения скорости при исчерпании 
квоты трафика с помощью нажатия кнопки на диалоговой странице interceptor.mts.ru, которая отобразится автоматически при установлении ограничений по скорости.
При нахождении на территории Петропавловск-Камчатского, Магаданского, Якутского, Южно-Сахалинского, Норильского регионов, а также Чукотского автономного округа максимальная 
скорость ограничивается 128 Кбит/с в пределах месячной квоты трафика.
Фактическая скорость может отличаться от заявленной и зависит от технических параметров сети мобильной связи МТС и от других обстоятельств, влияющих на качество связи.
Квота трафика в рамках опции единая и расходуется в сетях 2G/3G/4G
Точка доступа (APN): только internet.mts.ru или wap.mts.ru.
Интернет-опции не действуют при выходе на сайты с премиальной тарификацией
Автоматический переход между сетями 4G LTE (TDD/FDD) и 3G/2G возможен только из сети 4G LTE (TDD/FDD) в сети 3G/2G, обратный переход без разрыва соединения невозможен. 
Автоматический переход между сетями 4G LTE TDD и 4G LTE FDD без разрыва соединения невозможен. В сети 4G отсутствует возможность совершения и приёма голосового вызова и 
отправки/получения SMS. При совершении и приёме голосового вызова и отправки/получения SMS, устройство автоматически переходит в сети 3G/2G.
«Мобильное ТВ» в рамках опции «МТС Планшет» Сервис «Мобильное ТВ» включен в ежемесячную плату опции «МТС Планшет», для просмотра телеканалов достаточно установить приложение 
«MTS TV»
В рамках опции «МТС Планшет» Интернет-трафик (через точку доступа internet.mts.ru и wap.mts.ru ) при просмотре телеканалов бесплатен при нахождении абонента на всей территории 
России.
Ограничения скорости не распространяются на просмотр «Мобильного ТВ», квоты в рамках опции «МТС Планшет» не расходуются.
Скачать приложение «MTS TV» можно из магазина приложений для вашей модели планшетного компьютера, либо по ссылке
При загрузке приложения «MTS TV» при нахождении абонента на всей территории России GPRS-трафик не тарифицируется при скачивании приложения с сайта МТС.
При скачивании приложения «MTS TV» из магазинов приложений, например, Apple App Store, Android Market и прочих, трафик расходуется из месячной квоты.
При нахождении абонента в международном роуминге Интернет-трафик при просмотре телеканалов и загрузке приложения «MTS TV» оплачивается по роуминговыми тарифам.
Объем загружаемого приложения «MTS TV» зависит от операционной системы абонентского оборудования и не превышает 5 Мб.
Для просмотра каналов абонент должен находиться в зоне действия сети 3G/4G или Wi-Fi.
Скачивая приложение «MTS TV», пользователь приложения получает право использовать его на одном абонентском устройстве в личных или служебных целях.
Абонент может удалить приложение «MTS TV», как и любое приложение, установленное на телефон, самостоятельно.
Абонент самостоятельно с помощью абонентского устройства выбирает способ просмотра (в том числе с помощью установки или использования на абонентском устройстве приоритетов 
по выбору сети) – через сеть 3G/4G или через Wi-Fi.
Просмотр через сеть Wi-Fi доступен везде, где есть сеть Wi-Fi, в любых сетях Wi-Fi. Интернет-трафик при просмотре телеканалов через сеть Wi-Fi оплачивается абонентом 
самостоятельно по тарифам оператора сети Wi-Fi.
Со списком каналов можно ознакомиться в приложении «MTS TV». Для отображения полного списка каналов на главном экране необходимо в пункте меню «Список каналов» отметить все каналы.
Для использования опции на абонентском номере должна быть подключена услуга GPRS.
Качество предоставления услуги определяется скоростью передачи данных: минимально необходимая скорость для просмотра - 150 Кбит/с;
для просмотра в нормальном качестве - 300-400 Кбит/с;
просмотр в максимальном качестве - от 550 Кбит/с.

При подключении услуги через встроенные механизмы магазинов приложений (Apple App Store и пр.) плата взимается в соответствии с правилами и регламентами магазинов приложений 
и может отличаться по размеру, порядку и срокам списания от информации, указанной на сайте МТС.
Порядок и особенности подключения/отключения услуги через магазины приложений указаны в правилах и регламентах магазинов приложений.

Подробное описание «Мобильного ТВ»
Одновременное подключение «МТС Планшет» с другими опциями 
Опция «МТС Планшет» взаимоисключаемая с группой опций «БИТ», «БИТ+Мобильное ТВ», «СуперБИТ», 
«Безлимит-Mini/Maxi/Super/VIP», «Интернет-Mini/Maxi/Super/VIP» и всеми их модификациями, «Ipad Mini/Maxi/Super», «Безлимит на день по России», Пакетами трафика, 
а также «МТС Планшет 2013», «Безлимит-Start», «Бюджетный безлимит», «Безлимитный онлайн», «Интернет+», «Интернет-оптимизация», «Безлимитный ночной Интернет», 
«Интернет за копейки», «Безлимитный Интернет на ТП RED Energy», «Интернет без границ», «Безлимитный Интернет» и услугой «Мобильное ТВ».
Опция «МТС Планшет» не взаимоисключаема с опциями «БИТ Smart», «БИТ ULTRA», «БИТ MAXI», «СуперБИТ ULTRA», «Все, что нужно», «МиниБИТ», «Интернет на день», 
«Единый МиниБИТ» и всеми их модификациями.
При одновременном подключении опции «МТС Планшет» с опциями «БИТ Smart», «СуперБИТ ULTRA», «Все, что нужно» («Все, что нужно 900») «БИТ ULTRA», «БИТ MAXI», 
«МиниБИТ», «Интернет на день» действует опция «МТС Планшет»
При наличии опции «МТС Планшет» опции «БИТ Smart» и «СуперБИТ Smart» недоступны для подключения
Автоматическое информирование о достижении квот трафика
Все абоненты сети мобильной связи МТС, у которых подключена тарифная опция «МТС Планшет», по умолчанию при достижении месячных квот трафика получают SMS-уведомления 
о подключенной опции, действующем лимите и времени, оставшемся до восстановления скорости.


Условия предоставления
«Турбо-кнопка 500 Мб» и «Турбо-кнопка 2 Гб»
Плата за опции списывается в момент подключения.
Стоимость исходящего SMS на номера 111 и 5340 - 0 руб. при нахождении на территории г. Москвы и Московской области. Во внутрисетевом, национальном и 
международном роуминге тарификация осуществляется согласно роуминговым тарифам на исходящие SMS.
В период действия опций расходуемый трафик не учитывается в месячной квоте подключенной Интернет-опции.
Зона действия: соответствует зоне действия основной интернет-опции.
Точка доступа (APN): internet.mts.ru, wap.mts.ru.
Опции «Турбо-кнопка 500 Мб» и «Турбо-кнопка 2 Гб» действуют в течение 30 дней с момента подключения, либо до исчерпания включенной квоты трафика (какое событие наступит ранее).
При одновременном (повторном) подключении в течение срока действия опции «Турбо-кнопка 500 Мб»/ «Турбо-кнопка 2 Гб» одной из опций «Турбо-кнопка 500 Мб» 
или «Турбо-кнопка 2 Гб» квоты трафика по опциям суммируются. Срок действия – 30 дней с момента подключения последней турбо-кнопки, либо до исчерпания 
суммированной квоты трафика (какое событие наступит ранее).
В случае одновременного подключения опции «Турбо-кнопка 500 Мб»/ «Турбо-кнопка 2 Гб» и опции «Интернет на день» тарификация за доступ в Интернет 
в рамках опции «Интернет на день» происходит один раз в сутки в момент первого выхода в Интернет. Плата за пользование опцией «Турбо-кнопка 500 Мб»/«Турбо-кнопка 2 Гб» 
списывается в момент ее подключения. Трафик расходуется в рамках опции «Турбо-кнопка 500 Мб»/«Турбо-кнопка 2 Гб» до завершения объема трафика в рамках квоты 
или в течение 30 дней с момента подключения «Турбо-кнопка 500 Мб»/«Турбо-кнопка 2 Гб» (какое событие наступит ранее), после чего начинают расходоваться квоты 
в рамках опции «Интернет на день».
Опции недоступны для подключения и использования, если не подключена любая из Интернет-опций: «Интернет-Mini», «Интернет-Maxi», «Интернет-Super», «Интернет-VIP», 
«Интернет-Maxi_2013», «Безлимит-Mini 2013», «Безлимит-Maxi 2013», «Безлимит-Super 2013», «Безлимит-VIP.», «Интернет-Mini 2013», «Интернет-Maxi 2013», 
«Интернет-Super 2013», «Интернет-VIP 2013», «МТС Планшет 2013», «Безлимит-Mini 2012», «Безлимит-Maxi 2012», «Безлимит-Super 2012», «Безлимит-VIP 2012», 
«МТС Планшет», «Интернет на день», «Безлимит на день по России», «Ipad Mini», «Ipad Maxi», «Ipad Super» и их модификаций.
Отображение в детализации разговоров: опция «Турбо-кнопка 500 Мб» – internet_turbo_500mb, «Турбо-кнопка 2 Гб» – internet_turbo_2gb.


Программа «20% возвращаются»
Зарегистрируйтесь в программе «20% возвращаются» и вы как обычно будете платить за номер мобильного Интернета, а мы каждый месяц будем возвращать 20% ваших начислений 
на счет мобильного телефона!

При нахождении на территории Петропавловск-Камчатского, Магаданского, Якутского, Южно-Сахалинского, Норильского регионов, а также Чукотского автономного округа 
максимальная скорость ограничивается 128 Кбит/с в пределах месячной квоты трафика. 

Все цены указаны с учетом НДС
=end