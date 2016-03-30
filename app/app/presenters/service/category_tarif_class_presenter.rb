module Service::CategoryTarifClassPresenter

  def category_groups_presenter(full_category_groups)
    result = []; geo_names = []
    criteria_value_names = criteria_value_names_from_full_category_groups(full_category_groups)
    prev_service_category = nil
    full_category_groups.each do |category_group|
      temp = []
      price_to_show = true
      category_group.service_category_tarif_classes.each do |service_category|
        temp = category_presenter(service_category, prev_service_category)         
        temp << ((category_group.price_lists and category_group.price_lists.first.formulas and price_to_show) ? price_presenter(category_group.price_lists.first.formulas.first) : nil)
        result << temp
        geo_names << [nil, 
          (service_category.service_category_rouming_id ? criteria_value_names[service_category.service_category_rouming_id] : nil), 
          (service_category.service_category_geo_id ? criteria_value_names[service_category.service_category_geo_id] : nil), nil, nil]
        price_to_show = false
        prev_service_category = service_category        
      end if category_group.service_category_tarif_classes            
    end if full_category_groups
    {:result => result_with_colspan(result), :geo_names => geo_names}
  end
  
  def result_with_colspan(result_without_colspan_1)
#    return result_without_colspan
    result = []
    result_without_colspan = result_without_colspan_1.reverse
    result_without_colspan[0].each_index do |col|
      current_row_span = 1
      result_without_colspan.each_index do |row|
        result[row] ||= []
        if result_without_colspan[row][col] or (col > 0 and col < 4 and col != 1 and result[row][col-1][1])
          result[row][col] = [result_without_colspan[row][col], current_row_span]
          current_row_span = 1
        else          
          result[row][col] = [nil, nil]
          current_row_span += 1
        end
      end
    end if result_without_colspan[0]
    result.reverse!
    
    if true and result[0] and result[0][1..3] == [[nil, nil], [nil, nil], [nil, nil]]
      [[result[0][0]] + [["", 1], ["", 1], ["", 1]] + [result[0][4]]] + result[1..result.size]
    else
      result
    end    
  end  
  
  def category_presenter(service_category, prev_service_category)
    curr_category = to_compare_format(service_category)
    prev_category = prev_service_category ? to_compare_format(prev_service_category) : [nil, nil, nil, nil]
    category_items_to_show = case
    when curr_category == prev_category
      [nil, nil, nil, nil]
    when curr_category[0..2] == prev_category[0..2]
      [nil, nil, nil, service_category.service_category_partner_type.try(:name)]
    when curr_category[0..1] == prev_category[0..1]
      [nil, nil, service_category.service_category_geo.try(:name), service_category.service_category_partner_type.try(:name)]
    when curr_category[0] == prev_category[0]
      [nil, service_category.service_category_rouming.try(:name), service_category.service_category_geo.try(:name), service_category.service_category_partner_type.try(:name)]
    when (curr_category[0] != prev_category[0] and curr_category[1] == prev_category[1] and true) 
      [first_show_item_choicer(service_category), nil, service_category.service_category_geo.try(:name), service_category.service_category_partner_type.try(:name)]
    else
      [first_show_item_choicer(service_category), service_category.service_category_rouming.try(:name), service_category.service_category_geo.try(:name), service_category.service_category_partner_type.try(:name)]
    end
  end
  
  def first_show_item_choicer(service_category)
    case
    when service_category.service_category_one_time_id
      service_category.service_category_one_time.try(:name) 
    when service_category.service_category_periodic_id
      service_category.service_category_periodic.try(:name) 
    else
      service_category.service_category_calls.try(:name) || service_category.attributes
    end
  end
  
  def to_compare_format(service_category)
    [
      [service_category.service_category_one_time_id, service_category.service_category_periodic_id, service_category.service_category_calls_id].compact[0],
      service_category.service_category_rouming_id, service_category.service_category_geo_id, service_category.service_category_partner_type_id,
    ]
  end
  
  def geo_presenter(category_group_item, array_of_geo_names = [])
    case 
    when array_of_geo_names.size < 5
      array_of_geo_names.join(", ")
    else
      category_group_item ? show_as_popover(category_group_item, array_of_geo_names.join(", ")) : nil
    end
  end
  
  def show_as_popover(title, content)
    html = {
      :tabindex => "0", 
      :role => "button", 
      :'data-toggle' => "popover", 
      :'data-trigger' => "focus", 
      :'data-placement' => "right",
      :title => title, 
      :'data-content' => content,
      :'data-html' => true
    }
    
    content_tag(:a, html) do
      "#{title} ".html_safe + content_tag(:span, "", {:class => "fa fa-info-circle fa-1x", :'aria-hidden' =>true})
    end
  end
   
  def criteria_value_names_from_service_category_ids(service_category_ids = [])
#    _call_partner_phone_region_id = 9; _call_partner_phone_country_id = 10; _call_connect_region_id = 12; _call_connect_country_id = 13;
#    _in_array = 126;

    result = {}
    service_categories = Service::Category.where(:id => service_category_ids).includes(:criteria).
      where(:service_criteria => {:criteria_param_id => [9, 10, 12, 13], :comparison_operator_id => 126}).all
    category_ids = []
    
    service_categories.each do |service_category|    
      result[service_category.id] ||= []
      service_category.criteria.each do |criterium|
        if criterium.value and criterium.value.is_a?(Array) 
          category_ids += criterium.value 
          result[service_category.id] += criterium.value
        end 
      end
    end
        
    category_names = {}
    ::Category.select(:id, :name).where(:id => category_ids.uniq).each do |category|
      category_names[category.id] = category.name
    end
    
    result.each do |service_category_id, cat_ids|      
      result[service_category_id] = cat_ids.uniq.map{|cat_id| category_names[cat_id]}
    end
    
    result    
  end
  
  def criteria_value_names_from_full_category_groups(full_category_groups)
    service_category_ids = full_category_groups.map{|g| g.service_category_tarif_classes.map{|sc| [sc.service_category_rouming_id, sc.service_category_geo_id]}}.flatten
    criteria_value_names_from_service_category_ids(service_category_ids)
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
        "Включены в абонентскую плату #{formula.formula['params']['max_duration_minute']} минут в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPrice      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} штук составляет #{formula.formula['params']['price']} руб. в #{window_over}"
      else
        "Включены в абонентскую плату #{formula.formula['params']['max_count_volume']} штук в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}"
      else
        "Включены в абонентскую плату #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в абонентскую плату #{formula.formula['params']['max_duration_minute']} минут в #{window_over}, если услуга использовалась."
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} штук составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в абонентскую плату #{formula.formula['params']['max_count_volume']} штук в #{window_over}, если услуга использовалась."
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
      else
        "Включены в абонентскую плату #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}, если услуга использовалась."
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

