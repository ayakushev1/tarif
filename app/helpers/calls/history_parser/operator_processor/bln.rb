class Calls::HistoryParser::OperatorProcessor::Bln < Calls::HistoryParser::OperatorProcessor::Operator
  def internet_number(row)
    row[row_column_index[:number_init]]
  end    
  
  def phone_number(row, service)
    ((service[:subservice] == _inbound) ? row[row_column_index[:number_init]] : row[row_column_index[:number_called]])
  end
  
  def sub_service(row, service)
    service[:subservice]
  end
  
  def partner_row_column
    row_column_index[:call_type]
  end

  def partner_criteria(rouming, row, region_id)
    case rouming
    when :own_region
      !partner_criteria(:home_region, row, region_id) and !partner_criteria(:own_country, row, region_id) and !partner_criteria(:international, row, region_id)       
    when :home_region
      false
    when :own_country
      region_id
    when :international
      row[row_column_index[:service]] =~ /международные звонки/i
    end
  end
  
  def find_partner_operator_and_type_by_criteria(row, country_id)
    case
    when row[row_column_index[:call_type]] =~ /городской/i
      [_fixed_line_operator, _fixed_line]

    when row[row_column_index[:call_type]] =~ /рег. моб. бл|билайн (.*)|на рег. билайн|мобильный|(.*)билайн/i
      [_beeline, _mobile]

    when row[row_column_index[:call_type]] =~ /(вх.|исх.)\/(.*)/i
      operator_id, operator_index = find_operator(partner_items(row))
      operator_id ? [operator_id, _mobile] : [nil, nil]

    when (row[row_column_index[:service]] =~ /мжнр\/роум/i)
      find_partner_operator_and_type(row, country_id)

    else
      find_partner_operator_and_type(row, country_id)
    end
    
  end
  
  def rouming_items(row)
    take_out_special_symbols(row[row_column_index[:call_type]])
  end
  
  def rouming_criteria(rouming, row, region_id, home_region_id)
    case rouming
    when :own_region
      !rouming_criteria(:home_region, row, region_id, home_region_id) and !rouming_criteria(:own_country, row, region_id, home_region_id) and
      !rouming_criteria(:international, row, region_id, home_region_id)
    when :home_region
      ((row[row_column_index[:call_type]] + " " + row[row_column_index[:service]]) =~ /Домашний/)
    when :own_country
      (row and row[row_column_index[:call_type]] =~ /рег. моб. бл \(другой регион\)|\(рег\)|регион/i)
    when :international
      (row and row[row_column_index[:service]] =~ /мжнр\/роум/i)
    end
  end
  
  def base_service_criteria
    {
      _calls => [
        {:service => /звонки/i, :call_type => nil},
        {:service => /мжнр\/роум/i, :call_type => /входящий|исх./i},
      ],
      _sms => [
        {:service => /SMS\/MMS/i, :call_type => /Входящее SMS|Исходящее SMS/i},
        {:service => /мжнр\/роум/i, :call_type => /смс/i},
      ],
      _mms => [
        {:service => /SMS\/MMS/i, :call_type => /Входящее MMS|Исходящее MMS|прием/i},
        {:service => /мжнр\/роум/i, :call_type => /ммс/i},
      ],
      _3g => [
        {:service => /GPRS|GPRS-Internet|Premium Rate GPRS Internet/i, :call_type => nil},
      ],
    }
  end
  
  def base_subservice_criteria
    {
      _inbound => [
        {:service => /SMS\/MMS/i, :call_type => /Входящее SMS|Входящее MMS/i},
        {:service => /прием/i, :call_type => nil},
        {:service => /звонки/i, :call_type => /вх/i},
        {:service => /мжнр\/роум/i, :call_type => /вх/i},
      ],
      _outbound => [
        {:service => /SMS\/MMS/i, :call_type => /Исходящее SMS|Исходящее MMS/i},
        {:service => /звонки/i, :call_type => /исх/i},
        {:service => /мжнр\/роум/i, :call_type => /исх/i},
      ],
      _unspecified_direction => [
        {:service => /GPRS|GPRS-Internet|Premium Rate GPRS Internet/i, :call_type => nil},
      ],
    }
  end
  
  def duration(row)
    dur = row[row_column_index[:duration]].split(':')
    case dur.size
    when 2, 3
      dur[0].to_f * 60 + dur[1].to_f
    else
      0.0
    end
  end
  
  def volume(row)
    vol = row[row_column_index[:volume]]
    vol = 1 if row_service(row) and [_sms, _mms].include?(row_service(row)[:base_service])
    vol
  end
  
  def cost(row)
    row[row_column_index[:cost]].to_f
  end
  
  def row_date(row)
    result = nil
    begin
      result = row[row_column_index[:date]].to_datetime if row[row_column_index[:date]]
      result = "invalid_date" if !result
    rescue ArgumentError
      result = "invalid_date"
    end    
    result
  end
  
  def correct_table_heads
    ["Дата и время", "Исходящий номер", "Входящий номер", "Услуга", 
      "Описание услуги", "Тип услуги", "Длительность, мин сек", "Стоимость. руб", "Размер сессии. МБ"]
  end
  
  def row_column_index(table_heads = [])
    @row_column_index ||= {
      :date => table_heads.index("Дата и время"),
      :time => table_heads.index("Дата и время"),
#      :gmt => table_heads.index("GMT*"),
      :number_init => table_heads.index("Исходящий номер"),
      :number_called => table_heads.index("Входящий номер"),
      :service => table_heads.index("Тип услуги"),
      :call_type => table_heads.index("Описание услуги"),
      :cost => table_heads.index("Стоимость. руб"),
      :duration => table_heads.index("Длительность, мин сек"),
      :volume => table_heads.index("Размер сессии. МБ"),      
#      :bs_number => table_heads.index("Номер БС"),
    }
  end
  
  def table_filtrs
    {
      :head => 'table table thead tr',
      :head_column => 'th',
      :body => 0,
      :body_column => 'td',
    }    
  end

end
