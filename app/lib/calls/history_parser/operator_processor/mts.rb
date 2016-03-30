class Calls::HistoryParser::OperatorProcessor::Mts < Calls::HistoryParser::OperatorProcessor::Operator
  def internet_number(row)
    row[row_column_index[:number]]
  end
  
  def phone_number(row, service)
    row[row_column_index[:number]]
  end
  
  def sub_service(row, service)
    (row[row_column_index[:number]] =~ /<--/) ? _inbound : _outbound
  end
  
  def partner_row_column
    row_column_index[:partner]
  end

  def partner_criteria(rouming, row, region_id)
    case rouming
    when :own_region
      row[row_column_index[:partner]].blank?      
    when :home_region
      false
    when :own_country
      region_id
    when :international
      !partner_criteria(:own_region, row, region_id) and !partner_criteria(:home_region, row, region_id) and !partner_criteria(:own_country, row, region_id)      
    end
  end
  
  def find_partner_operator_and_type_by_criteria(row, country_id)
    find_partner_operator_and_type(row, country_id)
  end
    
  def rouming_items(row)
    take_out_special_symbols(row[row_column_index[:rouming]])
  end
  
  def rouming_criteria(rouming, row, region_id, home_region_id)
    case rouming
    when :own_region
      row[row_column_index[:rouming]].blank? 
    when :home_region
      row[row_column_index[:rouming]] =~ /Домашний|Москва - Область|Города Подмосковья/
    when :own_country
      (region_id and (region_id != home_region_id))
    when :international
      !rouming_criteria(:own_region, row, region_id, home_region_id) and !rouming_criteria(:home_region, row, region_id, home_region_id) and !rouming_criteria(:own_country, row, region_id, home_region_id)      
    end
  end
  
  def base_service_criteria
    {
      _calls => [
        {:service => /Телеф\.|cfu|cfac|cf busy|cf nrepl|cf nreach|cw|ch|ct|mpty/i},
      ],
      _sms => [
        {:service => /sms|Vam Zvonili\:|Abonent v seti\:/i},
      ],
      _mms => [
        {:service => /mms/i},
      ],
      _3g => [
        {:service => /Данные|HSDPA \(3G\)|gprs|4G/i},
      ],
      _periodic => [
        {:service => /MTS numbers/i}
      ]
    }
  end
  
  def base_subservice_criteria
    {
      _inbound => [
        {:service => /sms i|ct|mpty|mms i|Vam Zvonili\:|Abonent v seti\:/i}
      ],
      _outbound => [
        {:service => /sms o|mms o/i}
      ],
      _unspecified_direction => [
        {:service => /Данные|HSDPA \(3G\)|gprs|4G|MTS numbers/i}
      ],
      nil => [
        {:service => /Телеф\./i}
      ],
    }
  end
  
  def duration(row)
    dur = row[row_column_index[:duration]].split(':')
    dur.size == 2 ? dur[0].to_f * 60 + dur[1].to_f : 0.0
  end
  
  def volume(row)
    vol = row[row_column_index[:duration]].sub!(/Kb/, '')
    vol ? (vol.to_f / 1000.0) : row[row_column_index[:duration]].to_i
  end
  
  def cost(row)
    row[row_column_index[:cost]].to_f
  end
  
  def row_date(row)
    result = nil
    begin
      result = "#{row[row_column_index[:date]]} #{row[row_column_index[:time]]} #{row[row_column_index[:gmt]]}".to_datetime
      result = "invalid_date".freeze if !result
    rescue StandardError
      result = "invalid_date".freeze
    end    
    result    
  end
  
  def correct_table_heads
    [
      {date:"Дата".freeze, time: "Время".freeze, gmt: "GMT*".freeze, number: "Номер".freeze, rouming: "Зона вызова".freeze, 
        partner: "Зона направления вызова/номер сессии".freeze, service: "Услуга".freeze, duration: "Длительность".freeze, cost: "Стоимость без НДС".freeze},
      {date:"Дата".freeze, time: "Время".freeze, gmt: "GMT*".freeze, number: "Номер".freeze, rouming: "Зона вызова".freeze, 
        partner: "Зона направления вызова/номер сессии".freeze, service: "Услуга".freeze, duration: "Длительность/Объем (мин.:сек.)/(Kb)".freeze, cost: "Стоимость руб.".freeze},
    ]
  end
  
  def table_filtrs
    {
      :html => {
        :head => 'table table thead tr'.freeze,
        :head_column => 'th'.freeze,
        :body => 'table table tbody tr'.freeze,
        :body_column => 'td'.freeze,
      },
      :xls => {
        :body => 0,
      },
    }    
  end

end
