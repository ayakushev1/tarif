Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }
require 'roo'
#require 'open-uri'
require 'spreadsheet'

#require 'open-uri'
class Calls::HistoryParser::BlnXls
  attr_reader :call_history_file, :background_process_informer
  attr_reader :doc, :table_heads, :row_column_index
  attr_reader :unprocessed, :processed, :ignorred, :original_row_number
  attr_reader :operators, :countries, :regions, :operators_by_country, :operator_phone_numbers
  attr_reader :user_params, :parsing_params
  
  def initialize(call_history_file, user_params, parsing_params = {})
    @user_params = user_params
    @parsing_params = parsing_params
    @call_history_file = call_history_file
    @operator_phone_numbers = Calls::OperatorPhoneNumbers.new()
    @background_process_informer = parsing_params[:background_process_informer] || ServiceHelper::BackgroundProcessInformer.new('parsing_uploaded_file', user_params[:user_id])
    @doc = Roo::Spreadsheet.open(@call_history_file.path, extension: :xls)
    @unprocessed = []; @processed = []; @ignorred = []
    load_db_data
  end
  
  def load_db_data
    region_set = Category.regions.pluck(:id, :name, :parent_id)
    @regions = {:ids => region_set.map{|rs| rs[0].to_i}, :names => region_set.map{|rs| rs[1].mb_chars.downcase.to_s}, :country_ids => region_set.map{|rs| rs[2]}}
    country_set = Category.countries.pluck(:id, :name)
    @countries = {:ids => country_set.map{|rs| rs[0].to_i}, :names => country_set.map{|rs| rs[1].mb_chars.downcase.to_s}}
    operator_set = Category.operators.pluck(:id, :name)
    @operators = {:ids => operator_set.map{|rs| rs[0].to_i}, :names => operator_set.map{|rs| rs[1].mb_chars.downcase.to_s}}
    @operators_by_country = Relation.operators_by_country.pluck(:owner_id, :children)
  end
  
  def processed_percent    
    @processed_percent ||= processed.size.to_f * 100.0 / (parsing_params[:call_history_max_line_to_process] || 1.0).to_f    
  end
  
  def parse
#    load_db_data if regions.blank?
    max_row_number = (parsing_params[:call_history_max_line_to_process] || 1.0)
    return[{}] unless call_history_file
    return [{}] unless check_if_table_correct
    result = []
    background_process_informer.init(0.0, max_row_number) if background_process_informer
    update_step = [(parsing_params[:background_update_frequency] || 1), 1].max
    
    i = 0; doc_i = table_heads_row + 1
    while doc_i < doc_sheet.last_row and i < max_row_number
      date = row_date(doc_sheet.row(doc_i))
      if date == "invalid_date"
        doc_i += 1
        next
      end
      
      service = row_service(doc_sheet.row(doc_i)); dup_service = row_service(doc_sheet.row(doc_i + 1))
      if date == row_date(doc_sheet.row(doc_i + 1)) and service and service[:base_service] == _calls and dup_service and dup_service[:base_service] == _calls
        doc_inc = 2
        row, dup_row = dup_row_calls(doc_i)
        dup_row = nil
      else
        doc_inc = 1
        row = doc_sheet.row(doc_i)
      end
       
#      raise(StandardError, [row, row_date(doc_sheet.row(doc_i))]) if !date 
      if date.to_date.month.to_i >= user_params[:accounting_period_month].to_i and date.to_date.year.to_i >= user_params[:accounting_period_year].to_i
        row_result = parse_row(row, dup_row, date)
        result << row_result if row_result
        i += 1
      end 
      background_process_informer.increase_current_value(update_step) if background_process_informer and (doc_i + 1).divmod(update_step)[1] == 0
      doc_i += doc_inc
    end 
#    result.compact!
#    @background_process_informer.finish
    @processed = result
  end
  
  def parse_row(row, dup_row, date)
    service = row_service(row)
    return nil if !service
    number = row_number(row)
    roming = row_rouming(row, dup_row)
    return nil if !roming
    partner = row_partner(row, dup_row)
    return nil if !partner
    {
      :base_service_id => service[:base_service], 
      :base_subservice_id => (service[:subservice] || number[:subservice]), 
      :user_id => user_params[:user_id],
      :own_phone => {
        :number => user_params[:own_phone_number], 
        :operator_id => user_params[:operator_id],
        :region_id => user_params[:region_id], 
        :country_id => user_params[:country_id], 
        },
      :partner_phone => {
        :number => number[:number], 
        :operator_id => number[:operator_id] || partner[:operator_id], 
        :operator_type_id => number[:operator_type_id] || partner[:operator_type_id],
        :region_id => number[:region_id] || partner[:region_id], 
        :country_id => number[:country_id] || partner[:country_id], 
        },
      :connect => {
        :operator_id => roming[:operator_id],
        :region_id => roming[:region_id], 
        :country_id => roming[:country_id], 
        },
      :description => {
        :time => date.to_s, 
        :day => date.to_date.day, 
        :month => date.to_date.month, 
        :year => date.to_date.year, 
        :duration => duration(row),
        :volume => volume(row), 
        :cost => cost(row),
        :date => date.to_date.to_s,
        :date_number => (date.to_date.to_datetime.to_i / 86400.0).round(0),
        :accounting_period => "#{date.to_date.month}_#{date.to_date.year}"
        },
    }
  end
  
  def row_partner(row, dup_row)
    other_operator = (operators[:ids] - [user_params[:operator_id]])[0]
    beeline_operator_criteria = /рег. моб. бл|билайн (.*)|на рег. билайн|мобильный|(.*)билайн/i
    fixed_line_criteria = /городской/i
    other_operator_criteria_with_name = /(вх.|исх.)\/(.*)/i
    international_rouming_criteria = /мжнр\/роум/i
    international_calls_criteria = /международные звонки/i
    partner_items = take_out_special_symbols(row[row_column_index[:call_type]])
    partner_items += " " + take_out_special_symbols(dup_row[row_column_index[:call_type]]) if dup_row

    result = true
    
    operator_id, operator_type_id = case
    when (row[row_column_index[:call_type]] =~ fixed_line_criteria or (dup_row and dup_row[row_column_index[:call_type]] =~ fixed_line_criteria))
      [_fixed_line_operator, _fixed_line]
    when (row[row_column_index[:call_type]] =~ beeline_operator_criteria or (dup_row and dup_row[row_column_index[:call_type]] =~ beeline_operator_criteria))
      [_beeline, _mobile]
    when (row[row_column_index[:call_type]] =~ other_operator_criteria_with_name or (dup_row and dup_row[row_column_index[:call_type]] =~ other_operator_criteria_with_name))
      operator_id, operator_index = find_operator(partner_items)
      if operator_id
        [operator_id, _mobile]
      else
        unprocessed << {:unprocessed_column => :partner_operator, :value => partner_items, :row => [row, dup_row]} 
        result = nil
        [nil, nil]
      end
    when (row[row_column_index[:service]] =~ international_rouming_criteria)
      [nil, _mobile]
    else
      [other_operator, _mobile]
    end
    
    country_id = nil; region_id = nil
    case
    when (row[row_column_index[:service]] =~ international_calls_criteria or (dup_row and dup_row[row_column_index[:service]] =~ international_calls_criteria))
      country_id, country_index = find_country(partner_items)
      
      operator_id, operator_index = find_operator(partner_items)
      operator_id = find_operator_by_country(country_id) if country_id and !operator_id
      operator_type_id = (operator_id and operator_id == _fixed_line_operator) ? _fixed_line : _mobile

      if !operator_id
        unprocessed << {:unprocessed_column => :partner_operator, :value => dup_row[row_column_index[:call_type]], :row => dup_row} 
        result = nil
      end

      if !country_id
        unprocessed << {:unprocessed_column => :partner_region, :value => dup_row[row_column_index[:call_type]], :row => dup_row}
        result = nil
      end
    end
        
    result = {:operator_id => operator_id, :operator_type_id => operator_type_id, :region_id => region_id, :country_id => country_id } if result
  end
  
  def row_rouming(row, dup_row)
    any_country_rouming_criteria = /входящее смс/i
    
    result = true
    case
    when (row and row[row_column_index[:call_type]] =~ /рег. моб. бл \(другой регион\)|\(рег\)|регион/i)
      intranet_region = (regions[:ids] - [user_params[:region_id]])[0]
      {:operator_id => user_params[:operator_id], :region_id => intranet_region, :country_id => user_params[:country_id]}
    when (row and row[row_column_index[:service]] =~ /мжнр\/роум/i)
      rouming_items = take_out_special_symbols(row[row_column_index[:call_type]])

      region_id = nil
      operator_id, operator_index = find_operator(rouming_items)
      country_id, country_index = find_country(rouming_items)
      country_id, country_index = find_country_by_country_group(rouming_items) if !country_id
      country_id, country_index = find_country_by_country_group(['европа']) if !country_id and row[row_column_index[:call_type]] =~ any_country_rouming_criteria
      

      operator_id = find_operator_by_country(country_id) if country_id and country_id != _russia 
             
      if !operator_id
        unprocessed << {:unprocessed_column => :rouming_operator, :value => rouming_items, :row => row}
        result = nil
      end

      if !country_id
        unprocessed << {:unprocessed_column => :rouming_country, :value => rouming_items, :row => row}
        result = nil
      end
      result = {:operator_id => operator_id, :region_id => region_id, :country_id => country_id } if result
      result
    else
      {:operator_id => user_params[:operator_id], :region_id => user_params[:region_id], :country_id => user_params[:country_id]}
    end
  end
  
  def row_number(row)
    service = row_service(row)
    if service[:base_service] == _3g
      {:number => row[row_column_index[:number_init]], :subservice => _unspecified_direction}
    else
      phone = ((service[:subservice] == _inbound) ? row[row_column_index[:number_init]] : row[row_column_index[:number_called]])
      phone = "7#{phone.to_s}" if phone and phone.to_s.length == 10
      phone_range = operator_phone_numbers.find_range(phone)
      result = {:number => phone, :subservice => service[:subservice]}
      if phone_range
        result.merge!(phone_range)
      end
      result
    end
  end
  
  def row_service(row) 
    call_type = row[row_column_index[:call_type]]
    service = row[row_column_index[:service]]
    number_init = row[row_column_index[:number_init]]
    number_called = row[row_column_index[:number_called]]

    result = case 
    when service == 'Короткие сообщения'
      (call_type == 'SMS прием') ? {:base_service => _sms, :subservice => _inbound} : {:base_service => _sms, :subservice => _outbound}
    when service == 'MMS'
      case  
      when call_type == 'MMS'
        {:base_service => _3g, :subservice => _unspecified_direction}
      when call_type =~ /прием/
        {:base_service => _mms, :subservice => _inbound}
      else
        {:base_service => _mms, :subservice => _outbound}
      end
    when ['GPRS-Internet', 'Premium Rate GPRS Internet'].include?(service)
      {:base_service => _3g, :subservice => _unspecified_direction}
    when (service =~ /звонки/)
      case
      when (call_type =~ /исх/i)
        {:base_service => _calls, :subservice => _outbound} 
      when (call_type =~ /вх/i)
        {:base_service => _calls, :subservice => _inbound} 
      else
        {:base_service => _calls, :subservice => _unspecified_direction}
      end
    when (service =~ /мжнр\/роум/)
      base_service = case
      when (call_type =~ /смс/i)
        _sms
      when (call_type =~ /ммс/i)
        _mms
      when call_type =~ /входящий|исх./i
        _calls 
      else
        _3g
      end
      
      subservice = case
      when (call_type =~ /исх/i)
        _outbound 
      when (call_type =~ /вх/i)
        _inbound
      else
        _unspecified_direction
      end
      
      {:base_service => base_service, :subservice => subservice}
    else
      unprocessed << {:unprocessed_column => :service, :value => row[row_column_index[:service]], :row => row}
      {:base_service => nil, :subservice => nil}
    end
    
    if result[:base_service].blank?
      ignorred << {:ignorred_column => :service, :value => row[row_column_index[:service]], :row => row}
      nil
    else
      result
    end
     
  end
  
  def dup_row_calls(doc_i)
    row_1 = doc_sheet.row(doc_i); row_2 = doc_sheet.row(doc_i + 1)
    service_1 = row_service(row_1); service_2 = row_service(row_2)
    result = if service_1 and service_1[:base_service] == _calls  and service_2 and service_2[:base_service] == _calls
      case
      when [_inbound, _outbound].include?(service_1[:subservice]) 
        [row_1, row_2]
      when [_inbound, _outbound].include?(service_2[:subservice])
        [row_2, row_1]
      else
        unprocessed << {:unprocessed_column => :dup_call_type, :value => row_1[row_column_index[:call_type]], :row => row_1}
        unprocessed << {:unprocessed_column => :dup_call_type, :value => row_2[row_column_index[:call_type]], :row => row_2}
        [row_1, row_2]
      end
    else
      unprocessed << {:unprocessed_column => :dup_call_type, :value => row_1[row_column_index[:call_type]], :row => row_1}
      unprocessed << {:unprocessed_column => :dup_call_type, :value => row_2[row_column_index[:call_type]], :row => row_2}
      [row_1, row_2]
    end      
  end
  
  def take_out_special_symbols(string)
    result = string
    special_symbols = ['.', ':', ';']
    special_symbols.each{|sym| result = result.mb_chars.downcase.to_s.split(sym).join(' ')}
    result.squish.split(' ')
  end
  
  def find_operator_by_country(country_id)
    operators_by_country.each do |item|
      return item[1][0] if item[0] == country_id
    end
    nil
  end
  
  def find_operator(arr_of_string)
    arr_of_string.each do |str|
      operators[:names].each_index do |operator_index|         
        return [operators[:ids][operator_index], operator_index] if operators[:names][operator_index] == str
      end
    end
    [nil, nil]
  end
  
  def find_country(arr_of_string)
    arr_of_string.each do |str|
      countries[:names].each_index do |country_index|         
        return [countries[:ids][country_index], country_index] if countries[:names][country_index] == str
      end
    end
    [nil, nil]
  end
  
  def find_country_by_country_group(arr_of_string)
    country_groups = [['популярные страны', _egypt], ['снг', _ukraiun], ['европа', _france], ['северная америка', _usa], 
    ['южная америка', _brasilia], ['америка', _usa], ['азия', _tailand], ['африка', _egypt], ['австралия', _australia]]
    str = arr_of_string.join(' ')
    country_groups.each do |country_group|         
      return [country_group[1], 1] if str =~ /#{country_group[0]}/
    end
    [nil, nil]
  end
  
  def find_region(arr_of_string)
    speical_worlds = ['Республика', 'республика', 'область', 'край', 'автономный', 'автономная']
    (arr_of_string - speical_worlds).each do |str|
      regions[:names].each_index do |region_index|       
        return [regions[:ids][region_index], region_index] if (regions[:names][region_index].split(' ') - speical_worlds).include?(str)
      end
    end
    [nil, nil]
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
    result = ""
    begin
      result = "#{row[row_column_index[:date]]} #{row[row_column_index[:time]]}".to_datetime
      result = "invalid_date" if !result
    rescue ArgumentError
      result = "invalid_date"
    end    
    result
  end
  
  def check_if_table_correct
    result = true
#    raise(StandardError, [table_heads, row_column_index, doc.worksheet('Sheet0').row(0), doc.worksheet('Sheet0').row(1), doc.worksheet('Sheet0').row(2)])
    result = false if table_heads_row == -1 #!= ['Дата звонка', 'Время звонка', 'Инициатор звонка', 'Набранный номер', 'Тип звонка', 'Услуга', 'Предварительная стоимость (без НДС)', 'Продолжительность', 'Объем (MB)', 'Номер БС']
    result 
  end
  
  def table_heads_row(test_row = nil)
    return @table_heads_row if @table_heads_row
    test_row = ['Дата звонка', 'Время звонка', 'Инициатор звонка', 'Набранный номер', 'Тип звонка', 'Услуга', 
      'Предварительная стоимость (без НДС)', 'Продолжительность', 'Объем (MB)', 'Номер БС'] if !test_row
    @table_heads_row = -1
#    return @table_heads_row if !doc.sheets.include?('Sheet0')
    max_search_row = 10
    i = doc_sheet.first_row
    while (i < max_search_row)
      if doc_sheet.row(i) == test_row
        @table_heads_row = i
        break
      end
      i += 1
    end
    @table_heads_row
  end
  
  def table_heads
    @table_heads ||= doc_sheet.row(table_heads_row)
  end
  
  def row_column_index
    @row_column_index ||= {
      :date => table_heads.index("Дата звонка"),
      :time => table_heads.index("Время звонка"),
#      :gmt => table_heads.index("GMT*"),
      :number_init => table_heads.index("Инициатор звонка"),
      :number_called => table_heads.index("Набранный номер"),
      :call_type => table_heads.index("Тип звонка"),
      :service => table_heads.index("Услуга"),
      :cost => table_heads.index("Предварительная стоимость (без НДС)"),
      :duration => table_heads.index("Продолжительность"),
      :volume => table_heads.index("Объем (MB)"),      
      :bs_number => table_heads.index("Номер БС"),
    }
    @row_column_index
  end
  
  def doc_sheet
    @doc_sheet ||= doc.sheet(0)
  end
  
end
