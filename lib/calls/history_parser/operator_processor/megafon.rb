class Calls::HistoryParser::OperatorProcessor::Megafon < Calls::HistoryParser::OperatorProcessor::Operator
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
    row_column_index[:service]
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
    when row[row_column_index[:service]] =~ /городской/i
      [_fixed_line_operator, _fixed_line]

    when row[row_column_index[:service]] =~ /С МегаФон|С номеров МегаФон|С номеров Единой сети МегаФон|На МегаФон|На номера МегаФон|На номера Единой сети МегаФон/i
      [_megafon, _mobile]

    when row[row_column_index[:service]] =~ /(на мобильные номера|с мобильных номеров|вх\.|исх\.)\/(.*)/i
      operator_id, operator_index = find_operator(partner_items(row))
      operator_id ? [operator_id, _mobile] : [nil, nil]

    when (row[row_column_index[:service]] =~ /мжнр\/роум/i)
      find_partner_operator_and_type(row, country_id)

    else
      find_partner_operator_and_type(row, country_id)
    end    
  end

  def rouming_items(row)
    take_out_special_symbols(row[row_column_index[:rouming]])
  end
  
  def rouming_criteria(rouming, row, region_id, home_region_id)
    case rouming
    when :own_region
      row[row_column_index[:rouming]].blank?      
    when :home_region
      row[row_column_index[:rouming]] =~ /МО/
    when :own_country
      (region_id and (region_id != home_region_id)) or
      row[row_column_index[:rouming]] =~ /Центральный филиал ОАО \"МегаФон\"|Северо-Западный филиал ОАО \"МегаФон\"|Дальневосточный филиал ОАО \"МегаФон\"|
        aaaaa|Кавказский филиал ОАО \"МегаФон\"|Поволжский филиал ОАО \"МегаФон\"|Сибирский филиал ОАО \"МегаФон\"|Уральский филиал ОАО \"МегаФон\"|
        aaaaa|Столичный филиал ОАО \"МегаФон\"/
    when :international
      !rouming_criteria(:own_region, row, region_id, home_region_id) and !rouming_criteria(:home_region, row, region_id, home_region_id) and !rouming_criteria(:own_country, row, region_id, home_region_id)      
    end
  end
  
  def base_service_criteria
    {
      _calls => [
        {:service => /на мобильные номера|с мобильных номеров|Входящий|Исходящий|На МегаФон|С МегаФон|С номеров МегаФон|На номера МегаФон|
          aaaaa|С номеров Единой сети МегаФон|На номера Единой сети МегаФон|Исх\./i},
      ],
      _sms => [
        {:service => /Исходящее SMS|Входящее SMS/i},
      ],
      _mms => [
        {:service => /mms/i},
      ],
      _3g => [
        {:service => /Мобильный интернет|Данные|HSDPA \(3G\)|gprs|4G/i},
      ],
      _periodic => [
        {:service => /ыыыы/i}
      ]
    }
  end
  
  def base_subservice_criteria
    {
      _inbound => [
        {:service => /с мобильных номеров|Входящий|Входящее SMS|С МегаФон|С номеров МегаФон|С номеров Единой сети МегаФон/i}
      ],
      _outbound => [
        {:service => /на мобильные номера|Исходящий|Исходящее SMS|На МегаФон|На номера МегаФон|На номера Единой сети МегаФон|Исх\./i}
      ],
      _unspecified_direction => [
        {:service => /Мобильный интернет|Данные|HSDPA \(3G\)|gprs|4G/i}
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
    result = ""
    begin
      date = Date.strptime(row[row_column_index[:date]], '%d.%m.%y')
#      date += 2000 if date.year < 1000
      result = "#{date} #{row[row_column_index[:time]]}}".to_datetime
      result = "invalid_date" if !result
    rescue ArgumentError
      result = "invalid_date"
    end    
    result
    
  end

  def correct_table_heads
    ["Дата", "Время", "Абонентский номер, адрес электронной почты, точка доступа", "Прод/ Объем", "Единица тарификации (мин, сек, шт, Kb, Mb)",
      "Вид услуги",  "Место вызова",  "Стоимость (с НДС),  руб."]
  end
  
  def row_column_index(table_heads = [])
    @row_column_index ||= {
      :date => table_heads.index("Дата"),
      :time => table_heads.index("Время"),
      :number => table_heads.index("Абонентский номер, адрес электронной почты, точка доступа"),
      :rouming => table_heads.index("Место вызова"),
      :service => table_heads.index("Вид услуги"),
      :duration => table_heads.index("Прод/ Объем"),
      :tarification_unit => table_heads.index("Единица тарификации (мин, сек, шт, Kb, Mb)"),
      :cost => table_heads.index("Стоимость (с НДС),  руб."),
    }
  end
  
  def table_filtrs
    {
      :html => {
        :head => "body table [style='height:56px']",
        :head_column => 'td',
        :body => 'body table tr',
        :body_column => 'td',
      },
    }    
  end

end
