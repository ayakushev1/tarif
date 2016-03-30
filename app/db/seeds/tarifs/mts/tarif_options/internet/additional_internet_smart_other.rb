#Дополнительный пакет Smart Smart Nonstop, Plus, Top
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_additional_internet_smart_other, :name => 'Дополнительный пакет интернета Smart Nonstop, Plus, Top', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mobil_inet_and_tv/internet_phone/additionally_services/more_traffik/Internet_Smart/'},
  :dependency => {
    :categories => [_tcgsc_internet],
    :incompatibility => {
      :turbobuttons => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb,
        _mts_additional_internet_smart_mini, _mts_additional_internet_smart, _mts_additional_internet_smart_other,
        _mts_turbo_button_100_mb, _mts_turbo_button_500_mb, _mts_turbo_button_2_gb, _mts_turbo_button_5_gb],
      :internet_smart => [_mts_additional_internet_500_mb, _mts_additional_internet_1_gb, _mts_super_bit,
        _mts_additional_internet_smart_mini, _mts_additional_internet_smart, _mts_additional_internet_smart_other],
      :internet_comp => [_mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip]}, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mts_smart_plus, _mts_smart_top, _mts_smart_nonstop],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )

#Добавление новых service_category_group
  #internet included in tarif
scg_mts_additional_internet_smart_other = @tc.add_service_category_group(
    {:name => 'scg_mts_additional_internet_smart_other' }, 
    {:name => "price for scg_mts_additional_internet_smart_other"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth, 
      :formula => {:params => {:max_sum_volume => 1000.0, :price => 100.0} } } )


#All Russia rouming, Internet
  category = {:name => '_sctcg_all_russia_internet', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_additional_internet_smart_other[:id])

  category = {:name => '_sctcg_all_russia_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}
  @tc.add_grouped_service_category_tarif_class(category, scg_mts_additional_internet_smart_other[:id])

@tc.add_tarif_class_categories

#TODO добавить порядок расчета опций и тарифов. Многие опции используются после исчерпания лимитов основного тарифа
#Эта опция должна считаться после тарифа

#Опции «Дополнительный пакет 500 Мб»
#Тарифная опция: «Дополнительный пакет 500 Мб»
#Объем трафика: 500 Мб в месяц
#Стоимость: 75 руб./мес.

#Как подключить / отключить
#Есть два способа подключения / отключения опции «Дополнительный пакет 500 Мб»:
#наберите на своем мобильном телефоне *111*526# ;
#отправьте SMS на номер 111 с текстом: 526 – для подключения;
#5260 – для отключения.

#Первое предоставление пакета осуществляется в момент подключения опций, далее пакет предоставляется каждый месяц в полном объеме, в день, соответствующий дате подключения опции.
#Чтобы проверить остаток трафика, наберите *111*217# вызов.

#Условия предоставления опций 

#Опции может подключить абонент тарифов Smart mini, Smart, Smart+ и «Smart+ на год», использующий как базовые объемы интернет-опции, предоставляемые по тарифу, 
#так и имеющий дополнительно подключенные безлимитные Интернет-опции.
#Опции периодические: предоставляются каждый месяц до тех пор, пока абонент их не отключит.
#В случае смены тарифного плана (в том числе на другие тарифные планы линейки Smart) опции отключаются; необходимо их повторное подключение.
#Плата за первый месяц использования опций списывается в момент их подключения. Далее списание платы осуществляется каждый месяц, начиная со второго, 
#в полном объеме, в дату, соответствующую дате подключения опции.
#В случае, если на момент списания номер заблокирован, плата будет списана в момент выхода из блокировки.
#В случае, когда в следующем календарном месяце отсутствует дата аналогичная дате подключения, ежемесячная плата списывается в последний день календарного месяца.
#За полный календарный месяц, в котором абонент фактически находился в блокировке, ежемесячная плата не взимается.

#Точки доступа (APN): internet.mts.ru, wap.mts.ru.
#Зона действия опций – домашний регион абонента.
#В случае, если у абонента подключена любая из опций «Везде как дома Smart» или «ВСР_Smart+», опции действуют в сети МТС на территории всей России.

#Порядок начисления интернет-трафика 
#При подключении опций дополнительный пакет трафика суммируется с базовым объема интернет-трафика, предоставляемого по тарифу, и абоненту каждый месяц начинает начисляться 
#увеличенный объем интернет-трафика (равный сумме базового и дополнительного пакетов).
#Первое предоставление увеличенного пакета осуществляется в момент подключения опций; далее – увеличенный пакет предоставляется каждый месяц, начиная со второго, в полном объеме, 
#в дату, соответствующую дате подключения опции.
#При этом, в день соответствующий дате подключения / перехода на тариф (если она не совпадает с датой подключения опций), базовый объем интернет-трафика, 
#предоставляемый по тарифу, не начисляется.
#При выходе на PDA-версию сайта МТС, Интернет-Помощник и другие бесплатные ресурсы тарификация, учет в квотах и ограничение скорости в рамках данных опций не происходит.

#Взаимодействие опций 
#Опции «Дополнительный пакет 500 Мб» и «Дополнительный пакет 1 Гб» взаимоисключаются между собой, а также с опциями «СуперБИТ», «МТС Планшет», «Безлимит-Mini», 
#«Безлимит-Maxi», «Безлимит-Super», «Безлимит-VIP», «Интернет-Mini», «Интернет-Maxi», «Интернет-Maxi+», «Интернет-Super», 
#«Интернет-VIP» (включая все модификации перечисленных опций).
