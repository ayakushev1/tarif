class Calls::HistoryParser::OperatorProcessor::Tele < Calls::HistoryParser::OperatorProcessor::Operator
  def internet_number(row)
    row[row_column_index[:service]]
  end    
  
  def phone_number(row, service)
    row[row_column_index[:number_called]]
  end
  
  def sub_service(row, service)
    service[:service]
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
      [Category::Operator::Const::FixedlineOperator, _fixed_line]

    when (row[row_column_index[:service]] =~ /насвоего/i or row[row_column_index[:number_called]] =~ /tele2/i)
      [Category::Operator::Const::Beeline, _mobile]

    when row[row_column_index[:service]] =~ /исходящийна|исходящее|междугор/i
      operator_id, operator_index = find_operator(partner_items(row))
      operator_id ? [operator_id, _mobile] : [nil, nil]

    when (row[row_column_index[:service]] =~ /мжнр\/роум/i)
      find_partner_operator_and_type(row, country_id)

    else
      find_partner_operator_and_type(row, country_id)
    end
    
  end
  
  def rouming_items(row)
    take_out_special_symbols(row[row_column_index[:service]])
  end
  
  def rouming_criteria(rouming, row, region_id, home_region_id)
    case rouming
    when :own_region
      !rouming_criteria(:home_region, row, region_id, home_region_id) and !rouming_criteria(:own_country, row, region_id, home_region_id) and
      !rouming_criteria(:international, row, region_id, home_region_id)
    when :home_region
      ((row[row_column_index[:service]] + " " + row[row_column_index[:service]]) =~ /Домашний/)
    when :own_country
      (row and row[row_column_index[:service]] =~ /рег\. моб\. бл \(другой регион\)|\(рег\)|регион/i)
    when :international
      (row and row[row_column_index[:service]] =~ /мжнр\/роум/i)
    end
     
  end
  
  def base_service_criteria
    {
      _calls => [
        {:service => /входящий|исходящий/i}, {:number_called => /входящий|исходящий/i},
      ],
      _sms => [
        {:service => /SMS/i}, {:number_called => /SMS/i},
      ],
      _mms => [
        {:service => /MMS/i}, {:number_called => /MMS/i},
#        {:service => /мжнр\/роум/i, :service => /ммс/i},
      ],
      _3g => [
        {:service => /GPRS|интернет-трафик|интернет|трафик/i}, {:number_called => /GPRS|интернет-трафик|интернет|трафик/i},
      ],
    }
  end
  
  def base_subservice_criteria
    {
      _inbound => [
        {:service => /входящий|входящее/i},
      ],
      _outbound => [
        {:service => /^SMS|^MMS|исходящий|исходящее/i},
      ],
      _unspecified_direction => [
        {:service => /GPRS|интернет-трафик|интернет|трафик/i}, {:number_called => /GPRS|интернет-трафик|интернет|трафик/i},
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
    vol = row[row_column_index[:duration]]
    case
    when (row_service(row) and [_sms, _mms].include?(row_service(row)[:base_service]) )
      vol = 1         
    when row[row_column_index[:number_called]] =~ /трафик/i
      vol = row[row_column_index[:duration]].to_f
    end
    vol
  end
  
  def cost(row)
    row[row_column_index[:cost]].to_f
  end
  
  def row_date(row)
    result = nil
    begin
      result = DateTime.strptime(row[row_column_index[:date]], "%d.%m.%y".freeze) if row[row_column_index[:date]]
      result = "invalid_date".freeze if !result
    rescue StandardError
      result = "invalid_date".freeze
    end    
#    raise(StandardError) if row[row_column_index[:date]] == '10.10.15'
    result
  end
  
  def correct_table_heads
      [
        [["Дата".freeze, "и".freeze, "время".freeze, "план".freeze, "Типсоединения".freeze, "Номер".freeze, "в".freeze, "секундах".freeze, "в".freeze, "минутах".freeze, "стоимость".freeze, "по".freeze, "оплате".freeze], ["тарифу".freeze]],
        ]
#    [
#      {date: "date:", time: "time:", tarif_name: "tarif_name:", service: "service:", number_called: "number_called:", duration: "duration:", duration_min: "duration_min", 
#        tarif_price: "tarif_price", cost: "cost"},
#    ]
    
  end

  def find_column_indexes(table_heads)
    if local_check_of_heads(table_heads)
      @row_column_index = {
          :date => 0,
          :time => 1,
          :tarif_name => 2,
          :service => 3,
          :number_called => 4,
          :duration => 5,
          :duration_min => 6,
          :tarif_price => 7,
          :cost => 8,
        }
    else
      nil
    end
  end
  
  def table_filtrs
    {
      :pdf => {
        :head_count => 2,
        :head_column => 8,
        :body => 0,
        :body_column => 8,
      },
    }    
  end

  def local_check_of_heads(table_heads)
    max_search_row = [100, table_heads.size].min
    i = 0
    while (i < max_search_row)
      if correct_table_heads.include?(table_heads[i...i + 2]) 
        return true
      end
      i += 1
    end
  end
  

end
