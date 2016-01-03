module Service::CategoryTarifClassPresenter
  def categories_to_hash(categories)
#    categories_to_process = categories.select("service_category_one_time_id, service_category_periodic_id, service_category_rouming_id, 
#      service_category_calls_id, service_category_geo_id, service_category_partner_type_id").distinct

    temp = {}
    categories.each do |cat|
      case
      when cat.service_category_one_time_id
        temp[cat.service_category_one_time.name] = {} 
      when cat.service_category_periodic_id
        temp[cat.service_category_periodic.name] = {} 
      else
        temp[cat.service_category_calls.name] ||= {} 
        temp[cat.service_category_calls.name][cat.service_category_rouming.name] ||= {} 
        if cat.service_category_geo_id
          temp[cat.service_category_calls.name][cat.service_category_rouming.name][cat.service_category_geo.name] ||= {}
          temp[cat.service_category_calls.name][cat.service_category_rouming.name][cat.service_category_geo.name][cat.service_category_partner_type.name] ||= {} if cat.service_category_partner_type_id
        else
          temp[cat.service_category_calls.name][cat.service_category_rouming.name][cat.service_category_partner_type.name] ||= {} if cat.service_category_partner_type_id
        end         
      end
    end if categories
    temp
  end
  
  def nested_hash_to_s(nested_hash)           
    nested_hash.keys.map do |key|
      content_tag(:div, :style => "display: table-row;") do
        if nested_hash[key].blank?
          content_tag(:div, key, :style => "display: table-cell;")
        else
          content_tag(:div, key + ", " , :style => "display: table-cell;") + content_tag(:div, nested_hash_to_s(nested_hash[key]), :style => "display: table-cell; padding-left: 5px; padding-top: 5px;")  
        end
      end
    end.sum
  end
  
  def formula_presenter(formula)
    content_tag(:div, :style => "display: table-row;") do
      content_tag(:div, formula.calculation_order, :style => "display: table-cell; padding-left: 5px; padding-top: 5px;") +
      content_tag(:div, price_presenter(formula), :style => "display: table-cell; padding-left: 5px; padding-top: 5px;")
    end
  end
  
  def price_presenter(formula)
    window_over = formula.formula['window_over'] == 'day' ? 'день' : 'месяц'
    group_by = formula.formula['auto_turbo_buttons'].try(:group_by) == 'day' ? 'день' : 'месяц'
    group_by = formula.formula['multiple_use_of_tarif_option'].try(:group_by) == 'day' ? 'день' : 'месяц' if !group_by
    
    case formula.standard_formula_id
    when Price::StandardFormula::Const::PriceByMonth
      "Ежемесячная плата составляет #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::PriceByItem
      "Плата за подключение составляет #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::PriceBySumDurationSecond
      "Стоимость составляет #{formula.formula['params']['price']} руб. за секунду"
    when Price::StandardFormula::Const::PriceByCountVolumeItem
      "Стоимость составляет #{formula.formula['params']['price']} руб. за штуку"
    when Price::StandardFormula::Const::PriceBySumVolumeMByte
      "Стоимость составляет #{formula.formula['params']['price']} руб. за Мб"
    when Price::StandardFormula::Const::PriceBySumVolumeKByte
      "Стоимость составляет #{formula.formula['params']['price']} руб. за Кб"
    when Price::StandardFormula::Const::PriceBySumDuration
      "Стоимость составляет #{formula.formula['params']['price']} руб. за минуту"
    when Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny
      "Стоимость составляет #{formula.formula['params']['price']} руб. в день, если услуга использовалась."
    when Price::StandardFormula::Const::PriceByMonthIfUsed
      "Стоимость составляет #{formula.formula['params']['price']} руб. в месяц, если услуга использовалась."
    when Price::StandardFormula::Const::PriceByItemIfUsed
      "Стоимость составляет #{formula.formula['params']['price']} руб. в месяц, если опция использовалась."
    when Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. в #{window_over}"
      else
        "Включены в стоимость #{formula.formula['params']['max_duration_minute']} минут в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPrice      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} штук составляет #{formula.formula['params']['price']} руб. в #{window_over}"
      else
        "Включены в стоимость #{formula.formula['params']['max_count_volume']} штук в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}"
      else
        "Включены в стоимость #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в стоимость #{formula.formula['params']['max_duration_minute']} минут в #{window_over}, если услуга использовалась."
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} штук составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в стоимость #{formula.formula['params']['max_count_volume']} штук в #{window_over}, если услуга использовалась."
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в стоимость #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}, если услуга использовалась."
      end      
    when Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice
      "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. за минуту"
    when Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice
      "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} шт. составляет #{formula.formula['params']['price']} руб. за штуку"
    when Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice
      "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. за Мб"
    when Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice
      "Стоимость дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay
      "Стоимость дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб.. Трафик доступен в течении суток."
    when Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth
      "Стоимость каждых дополнительных #{formula.formula['params']['max_count_volume']} шт. составляет #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseDay
      "Стоимость каждых дополнительных #{formula.formula['params']['max_count_volume']} шт. составляет #{formula.formula['params']['price']} руб. Объем доступен в течении суток."
    when Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth
      "Стоимость каждых дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay
      "Стоимость каждых дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб.. Трафик доступен в течении суток."
    when Price::StandardFormula::Const::TwoStepPriceMaxDurationMinute
      "Стоимость первых #{formula.formula['params']['duration_minute_1']} мин звонка составляет #{formula.formula['params']['price_0']} руб. за минуту. 
       Последующие минуты стоят #{formula.formula['params']['price_1']} руб. за минуту. 
       Цены действуют для первых #{formula.formula['params']['max_duration_minute']} мин в #{window_over}."
    when Price::StandardFormula::Const::TwoStepPriceDurationMinute
      "Стоимость первых #{formula.formula['params']['duration_minute_1']} мин звонка составляет #{formula.formula['params']['price_0']} руб. за минуту. 
       Последующие минуты стоят #{formula.formula['params']['price_1']} руб. за минуту."
    when Price::StandardFormula::Const::ThreeStepPriceDurationMinute
      "Стоимость первых #{formula.formula['params']['duration_minute_1']} мин звонка составляет #{formula.formula['params']['price_0']} руб. за минуту.
       Стоимость между #{formula.formula['params']['duration_minute_1']} и #{formula.formula['params']['duration_minute_2']} мин звонка составляет #{formula.formula['params']['price_1']} руб. за минуту. 
       Последующие минуты стоят #{formula.formula['params']['price_2']} руб. за минуту."
    else
      content_tag(:div, :style => "display: table-row;") do
        content_tag(:div, formula.attributes, :style => "display: table-cell; padding-left: 5px; padding-top: 5px;") +
        content_tag(:div, formula.standard_formula.attributes, :style => "display: table-cell; padding-left: 5px; padding-top: 5px;")
      end
    end
  end
end

