#Макси БИТ за границей
@tc = TarifCreator.new(_mts)
@tc.create_tarif_class({
  :id => _mts_maxi_bit_abroad, :name => 'Макси БИТ за границей', :operator_id => _mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/discount_roaming/bit_abroad/maxi_bit/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {:bit_abroad => [_mts_bit_abroad, _mts_maxi_bit_abroad, _mts_super_bit_abroad]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

_sctcg_bit_abrod_1_rouming_internet = {:name => '_sctcg_bit_abrod_1_rouming_internet', :service_category_rouming_id => _sc_mts_rouming_in_bit_abrod_option_countries_1, :service_category_calls_id => _internet}
_sctcg_bit_abrod_2_rouming_internet = {:name => '_sctcg_bit_abrod_2_rouming_internet', :service_category_rouming_id => _sc_mts_rouming_in_bit_abrod_option_countries_2, :service_category_calls_id => _internet}
_sctcg_bit_abrod_3_rouming_internet = {:name => '_sctcg_bit_abrod_3_rouming_internet', :service_category_rouming_id => _sc_mts_rouming_in_bit_abrod_option_countries_3, :service_category_calls_id => _internet}
_sctcg_bit_abrod_4_rouming_internet = {:name => '_sctcg_bit_abrod_4_rouming_internet', :service_category_rouming_id => _sc_mts_rouming_in_bit_abrod_option_countries_4, :service_category_calls_id => _internet}

#bit_abrod_1 rouming, internet
  @tc.add_one_service_category_tarif_class(_sctcg_bit_abrod_1_rouming_internet, {}, 
    {:calculation_order => 0, :price => 8.571428571, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '_stf_bit_abrod_1_rouming_internet', :description => '', 
     :formula => {
       :window_condition => "(70.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 70.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

#bit_abrod_2 rouming, internet
  @tc.add_one_service_category_tarif_class(_sctcg_bit_abrod_2_rouming_internet, {}, 
    {:calculation_order => 0, :price => 8.571428571, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '_stf_bit_abrod_2_rouming_internet', :description => '', 
     :formula => {
       :window_condition => "(70.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 70.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

#bit_abrod_3 rouming, internet
  @tc.add_one_service_category_tarif_class(_sctcg_bit_abrod_3_rouming_internet, {}, 
    {:calculation_order => 0, :price => 8.571428571, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '_stf_bit_abrod_3_rouming_internet', :description => '', 
     :formula => {
       :window_condition => "(70.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 70.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

#bit_abrod_4 rouming, internet
  @tc.add_one_service_category_tarif_class(_sctcg_bit_abrod_4_rouming_internet, {}, 
    {:calculation_order => 0, :price => 220.0, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '_stf_bit_abrod_4_rouming_internet', :description => '', 
     :formula => {
       :window_condition => "(10.0 >= sum_volume)", :window_over => 'day',
       :stat_params => {:sum_volume => "sum((description->>'volume')::float)"},
       :method => "case when sum_volume > 0.0 then price_formulas.price else 0.0 end",
       
       :multiple_use_of_tarif_option => {
         :group_by => 'day',
         :stat_params => {:tarif_option_count_of_usage => "ceil(sum((description->>'volume')::float) / 10.0)", :sum_volume => "sum((description->>'volume')::float)"},
         :method => "price_formulas.price * tarif_option_count_of_usage" } } } )

@tc.add_tarif_class_categories

#Способы подключения/отключения
#наберите на своем мобильном телефоне *111*2223#вызов
#отправьте бесплатное SMS на номер 111 с текстом 2223 - для подключения (с текстом 22230 - для отключения).

#Сколько стоит
#Стоимость 1 Мб интернет-трафика за границей – 0 руб.
#Плата за подключение опции – 0 руб.
#Ежесуточная плата списывается только в случае фактического выхода в Интернет за границей, а именно - при осуществлении первой интернет-сессии в сутки. 
#Если в течение суток вы не воспользовались доступом в Интернет, то ежесуточная плата не списывается.

#Списание платы за каждые сутки использования опции отображается в детализации и счетах как «Internet_Category_R01» и «Выход в Интернет категория R01».

#Условия предоставления
#1.Предложение действительно для абонентов всех тарифных планов, не содержащих в своем названии «Классный», «Заботливый».
#2.Ежесуточная плата списывается только при осуществлении первой интернет-сессии за текущие сутки (период с 3:00 текущего дня по 3:00 следующего дня по времени домашнего региона абонента). 
#Если вы подключили опцию, но, находясь в роуминге, не использовали доступ в Интернет, ежесуточная плата не списывается.
#3.Если вы подключили опцию, но пользуетесь доступом в Интернет в России или в домашнем регионе, а не за границей, тарификация интернет-трафика осуществляется в соответствии с вашим тарифным планом.
#4.Если на вашем номере подключена услуга «Запрет GPRS-роуминга», то при подключении опции «БИТ за границей» услуга «Запрет GPRS-роуминга» автоматически отключиться, 
#сервис GPRS-/EDGE-/3G-роуминга в международном и национальном роуминге будет предоставлен согласно условиям опции «БИТ за границей».
#5.В опцию «БИТ за границей» включен интернет-трафик по точкам доступа (APN): internet.mts.ru, wap.mts.ru, blackberry.net; трафик по другим APN в данную опцию не включается.
#6.«Воспользоваться опцией для выхода в Интернет в зарубежных поездках можно при подключенных бесплатных услугах «Легкий роуминг и международный доступ», либо «Легкий роуминг и международный доступ 2012», либо «Международный и национальный роуминг» и «GPRS». 
#Чтобы проверить наличие данных услуг, воспользуйтесь Интернет-Помощником или отправьте SMS с текстом 0 на номер 8111.

#Ограничения
#1.При использовании опции действует суточная квота трафика. После исчерпания квоты доступ в Интернет ограничивается до 3:00 следующих суток. 
#При исчерпании квоты возможно бесплатно воспользоваться мобильными версиями Интернет-Помощника и сайта МТС.
#2.Счетчик квоты обнуляется в 3:00 каждые сутки (по времени домашнего региона абонента).
#3.Чтобы разово получить информацию о текущем статусе опции «БИТ за границей», наберите на своем мобильном телефоне *111*217#(вызов).
#4.Если вы использовали менее установленной квоты за текущие сутки, с 3:00 следующего дня вам вновь доступен полный объем квоты на максимальной скорости. 
#При первой интернет-сессии в следующие сутки будет списана ежесуточная плата за выход в Интернет – 200/2000 руб. (в зависимости от страны пребывания).

#Как снять ограничения
#Если вам недостаточно дневной квоты опции «БИТ за границей», подключите опцию «Турбо-кнопка за границей на 1 час» или «Макси БИТ за границей» или «Супер БИТ за границей». 
#Опции «БИТ за границей», «Макси БИТ за границей» и «Супер БИТ за границей» взаимоисключаемы между собой.
#При достижении дневной квоты вы всегда можете отключить и подключить заново опцию «БИТ за границей», набрав *212#(вызов), при этом все скоростные ограничение снимаются. 
#В случае повторного подключения опции и выхода в Интернет в течение одних суток ежесуточная плата будет списана еще раз
