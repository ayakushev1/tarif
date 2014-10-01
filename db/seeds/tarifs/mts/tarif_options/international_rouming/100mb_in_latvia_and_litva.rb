#100 Мб в Литве и Латвии
@tc = ServiceHelper::TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_100mb_in_latvia_and_litva, :name => '100 Мб в Литве и Латвии', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {
    :http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/archive/100_mb/',
    :closed_to_switch_on => true},  
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [_mts_bit_abroad, _mts_maxi_bit_abroad, _mts_super_bit_abroad], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true,
  } } )

_sctcg_litva_and_latvia_rouming_internet = {:name => '_sctcg_litva_and_latvia_rouming_internet', :service_category_rouming_id => _sc_lithuania_and_latvia_rouming, :service_category_calls_id => _internet}

#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_day_fee, {}, {:standard_formula_id => _stf_fixed_price_if_used_in_1_day_duration, :price => 350.0})
  
#Intranet rouming, internet
  @tc.add_one_service_category_tarif_class(_sctcg_litva_and_latvia_rouming_internet, {}, 
    {:calculation_order => 0, :price => 350.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '_stf_litva_and_latvia_rouming_internet', :description => '', 
     :formula => {
       :window_condition => "(100.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 100.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

@tc.add_tarif_class_categories

#Подключите опцию «100 Мб в Литве и Латвии», и вы получите 100 Мб трафика всего за 350 рублей в сутки!

#Способы подключения/отключения
#воспользуйтесь Интернет-Помощником;
#наберите на своем мобильном телефоне *111*479#(вызов);
#отправьте SMS на номер 111 с текстом 479 для подключения (с текстом 47900 - для отключения).

#Сколько стоит
#Стоимость 1 Мб интернет-трафика при выходе в Интернет на территории Литвы и Латвии – 0 руб.
#Плата за подключение опции – 0 руб.
#Ежесуточная плата в размере 350 руб. списывается только в случае фактического выхода в Интернет на территории Литвы или Латвии, 
#а именно - при осуществлении первой интернет-сессии в сутки. Если в течение суток вы не воспользовались доступом в Интернет, ежесуточная плата не списывается.
#Списание платы за каждые сутки пользования опцией отображается в детализации и счетах как «Internet_Category_R01» и «Выход в Интернет категория R01»

#Условия предоставления
#1.Предложение действительно для абонентов мобильной связи всех тарифных планов.
#2.Ежесуточная плата списывается только при осуществлении первой интернет-сессии за текущие сутки (период с 03:00 текущего дня по 03:00 следующего дня 
#по времени домашнего региона абонента). Если вы подключили опцию, но, находясь на территории Литвы и Латвии, не пользовались доступом в Интернет, ежесуточная плата не списывается.
#3.Опция действует только при нахождении на территории Литвы и Латвии: если вы подключили опцию, но используете доступ в Интернет в России или в домашнем регионе, 
#а также за границей (за исключением Литвы и Латвии), тарификация интернет-трафика осуществляется в соответствии с тарифным планом.
#4.В опцию «100 Мб в Литве и Латвии» включен интернет-трафик через точку доступа (APN): internet.mts.ru, wap.mts.ru, blackberry.net; трафик по другим APN в данную опцию не включается.
#5.Воспользоваться доступом в Интернет в зарубежных поездках можно при подключенных бесплатных услугах «Международный и национальный роуминг» и «GPRS» 
#или «Легкий роуминг и международный доступ» и «GPRS». Чтобы проверить наличие данных услуг, воспользуйтесь Интернет-Помощником или отправьте SMS с текстом 0 на номер 8111.
#6.При одновременно подключенных опциях «100 Мб в Литве и Латвии» и одной из опций «БИТ за границей», «BIS за границей» на территории Литвы и Латвии тарификация 
#происходит согласно условиям опции «100 Мб в Литве и Латвии».
#7.Если на вашем абонентском номере подключена услуга «Запрет GPRS-роуминга», то при подключении опции «100 Мб в Литве и Латвии» услуга «Запрет GPRS-роуминга» 
#автоматически отключится, сервис GPRS-/EDGE-/3G-роуминга в международном и национальном роуминге будет предоставлен согласно условиям опции «100 Мб в Литве и Латвии».
#8.Если на вашем абонентском номере подключена услуга «Коннект за границей», то при подключении опции «100 Мб в Литве и Латвии» услуга «Коннект за границей» автоматически отключится.

#Ограничения

#1.При использовании опции действует суточная квота трафика – 100 Мб, при достижении которой скорость доступа в Интернет уменьшается до 0 Кбит/с до 03:00 следующих суток.
#2.Счетчик квоты обнуляется в 3:00 каждые сутки (по времени домашнего региона абонента).
#3.Чтобы разово получить информацию о текущем статусе опции «100 Мб в Литве и Латвии», наберите на своем мобильном телефоне *111*217#(вызов).
#4.Если вы использовали менее 100 Мб за текущие сутки, с 3:00 следующего дня вам вновь доступно 100 Мб на максимальной скорости. 
#При этом в момент совершения первой интернет-сессии в следующие сутки будет списана ежесуточная плата за выход в Интернет – 350 руб.

#Как снять ограничения
#При достижении дневной квоты вы всегда можете отключить и подключить заново опцию «100 Мб в Литве и Латвии», набрав на своем мобильном телефоне *111*479# 
#и следуя подсказкам меню. При этом все скоростные ограничения снимаются. 
#В случае повторного подключения опции и выхода в Интернет в течение одних суток ежесуточная плата будет списана еще раз.
