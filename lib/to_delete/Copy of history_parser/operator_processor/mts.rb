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
#    raise(StandardError)
    result = nil
    begin
      result = "#{row[row_column_index[:date]]} #{row[row_column_index[:time]]} #{row[row_column_index[:gmt]]}".to_datetime
      result = "invalid_date" if !result
    rescue StandardError
      result = "invalid_date"
    end    
    result    
  end
  
  def correct_table_heads
    {
      :html => ["", "Дата", "Время", "GMT*", "Номер", "Зона вызова", "Зона направления вызова/номер сессии", "Услуга", " ", "Длительность/Объем (мин.:сек.)/(Kb)", "Стоимость руб.", ""],
      :xls => ["Дата", "Время", "GMT*", "Номер", "Зона вызова", "Зона направления вызова/номер сессии", "Услуга", "", "Длительность", "Стоимость без НДС"]
    }    
  end
  
  def row_column_index(table_heads = [], file_processor_type = nil)
    @row_column_index ||= case file_processor_type
    when :html
      {
        :date => table_heads.index("Дата"),
        :time => table_heads.index("Время"),
        :gmt => table_heads.index("GMT*"),
        :number => table_heads.index("Номер"),
        :rouming => table_heads.index("Зона вызова"),
        :partner => table_heads.index("Зона направления вызова/номер сессии"),
        :service => table_heads.index("Услуга"),
        :special => table_heads.index(" "),
        :duration => table_heads.index("Длительность/Объем (мин.:сек.)/(Kb)"),
        :cost => table_heads.index("Стоимость руб."),
      }
    else # :xls
      {
        :date => table_heads.index("Дата"),
        :time => table_heads.index("Время"),
        :gmt => table_heads.index("GMT*"),
        :number => table_heads.index("Номер"),
        :rouming => table_heads.index("Зона вызова"),
        :partner => table_heads.index("Зона направления вызова/номер сессии"),
        :service => table_heads.index("Услуга"),
        :special => table_heads.index(""),
        :duration => table_heads.index("Длительность"),
        :cost => table_heads.index("Стоимость без НДС"),
       }
     end
  end
  
  def table_filtrs
    {
      :html => {
        :head => 'table table thead tr',
        :head_column => 'th',
        :body => 'table table tbody tr',
        :body_column => 'td',
      },
      :xls => {
        :head => 'table table thead tr',
        :head_column => 'th',
        :body => 0,
        :body_column => 'td',
      },
    }    
  end

end
