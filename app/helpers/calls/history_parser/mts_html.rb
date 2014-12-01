Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }
require 'nokogiri'
require 'open-uri'
class Calls::HistoryParser::MtsHtml
  attr_reader :call_history_file, :background_process_informer
  attr_reader :doc, :table_heads, :row_column_index
  attr_reader :unprocessed, :processed, :ignorred, :original_row_number
  attr_reader :operators, :countries, :regions, :operators_by_country, :operator_phone_numbers, :categories
  attr_reader :user_params, :parsing_params
  
  def initialize(call_history_file, user_params, parsing_params = {})
    @user_params = user_params
    @parsing_params = parsing_params
    @call_history_file = call_history_file
    @operator_phone_numbers = Calls::OperatorPhoneNumbers.new()
    @background_process_informer = parsing_params[:background_process_informer] || ServiceHelper::BackgroundProcessInformer.new('parsing_uploaded_file', user_params[:user_id])
    @doc = Nokogiri::HTML(@call_history_file) do |config|
      config.nonet
    end    
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
    @categories = {} 
    ::Category.all.each { |o| categories[o.id] = o.name }
  end
  
  def processed_percent    
    @processed_percent ||= processed.size.to_f * 100.0 / (parsing_params[:call_history_max_line_to_process] || 1.0).to_f    
  end
  
  def parse
#    load_db_data if regions.blank?
    max_row_number = parsing_params[:call_history_max_line_to_process]
    return[{}] unless call_history_file
    return [{}] unless check_if_table_correct
    result = []
    background_process_informer.init(0.0, max_row_number) if background_process_informer
    update_step = [parsing_params[:background_update_frequency], 1].max
    
    call_details_doc = doc.css('table table tbody tr')
    
    i = 0; doc_i = 0
    while call_details_doc and call_details_doc[doc_i] and i < max_row_number
      row = call_details_doc[doc_i].css('td').to_a.map{|column| column.text}

      date = row_date(row)
      if date.to_date.month.to_i >= user_params[:accounting_period_month].to_i and date.to_date.year.to_i == user_params[:accounting_period_year].to_i
        result << parse_row(row, date) 
        i += 1
      end 
      background_process_informer.increase_current_value(update_step) if background_process_informer and (doc_i + 1).divmod(update_step)[1] == 0
      doc_i += 1
    end 
    result.compact!
#    @background_process_informer.finish
    @processed = result
  end
  
  def parse_row(row, date)
    service = row_service(row)
    return nil if !service
    number = row_number(row)
    roming = row_rouming(row)
    return nil if !roming
    partner = row_partner(row)
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
        :operator => categories[user_params[:operator_id]],
        :region => categories[user_params[:region_id]],
        :country => categories[user_params[:country_id]],
        },
      :partner_phone => {
        :number => number[:number], 
        :operator_id => number[:operator_id] || partner[:operator_id], 
        :operator_type_id => number[:operator_type_id] || partner[:operator_type_id],
        :region_id => number[:region_id] || partner[:region_id], 
        :country_id => number[:country_id] || partner[:country_id], 
        :operator => categories[(number[:operator_id] || partner[:operator_id])],
        :operator_type => categories[(number[:operator_type_id] || partner[:operator_type_id])],
        :region => categories[(number[:region_id] || partner[:region_id])],
        :country => categories[(number[:country_id] || partner[:country_id])],
        },
      :connect => {
        :operator_id => roming[:operator_id],
        :region_id => roming[:region_id], 
        :country_id => roming[:country_id], 
        :operator => categories[roming[:operator_id]],
        :region => categories[roming[:region_id]],
        :country => categories[roming[:country_id]],
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
  
  def row_partner(row)
    result = true
#    raise(StandardError, [row[row_column_index[:partner]], !row[row_column_index[:partner]].blank?, ])
    if row[row_column_index[:partner]].blank?
      {:operator_id => user_params[:operator_id], :operator_type_id => _mobile, :region_id => user_params[:region_id], :country_id => user_params[:country_id]}
    else
      partner_items = take_out_special_symbols(row[row_column_index[:partner]]) 
      operator_id, operator_index = find_operator(partner_items)
      country_id, country_index = find_country(partner_items)
      region_id, region_index = find_region(partner_items)      
      
      country_id = regions[:country_ids][region_index] if region_index
      operator_id = find_operator_by_country(country_id) if country_id and !operator_id  
      operator_type_id = (operator_id and operator_id == _fixed_line_operator) ? _fixed_line : _mobile

      if !operator_id
        unprocessed << {:unprocessed_column => :partner_operator, :value => row[row_column_index[:partner]], :row => row} 
        result = nil
      end
      
      if region_id
        if !country_id
          unprocessed << {:unprocessed_column => :partner_country, :value => row[row_column_index[:partner]], :row => row}
          result = nil
        end
      else
        if !country_id
          unprocessed << {:unprocessed_column => :partner_region, :value => row[row_column_index[:partner]], :row => row}
          result = nil
        end
      end       
      result = {:operator_id => operator_id, :operator_type_id => operator_type_id, :region_id => region_id, :country_id => country_id } if result
    end      
  end
  
  def row_rouming(row)
    result = true
    if row[row_column_index[:rouming]].blank? or row[row_column_index[:rouming]] =~ /Домашний/
      {:operator_id => user_params[:operator_id], :region_id => user_params[:region_id], :country_id => user_params[:country_id]}
    else
      rouming_items = take_out_special_symbols(row[row_column_index[:rouming]])

      operator_id, operator_index = find_operator(rouming_items)
      country_id, country_index = find_country(rouming_items)
      region_id, region_index = find_region(rouming_items)

      country_id = regions[:country_ids][region_index] if region_index
      operator_id = find_operator_by_country(country_id) if country_id and country_id != _russia 
             
      if !operator_id
        unprocessed << {:unprocessed_column => :rouming_operator, :value => row[row_column_index[:rouming]], :row => row}
        result = nil
      end

      if region_id
        if !country_id
          unprocessed << {:unprocessed_column => :rouming_country, :value => row[row_column_index[:rouming]], :row => row}
          result = nil
        end
      else
        if !country_id
          unprocessed << {:unprocessed_column => :rouming_region, :value => row[row_column_index[:rouming]], :row => row}
          result = nil
        end
      end       
      result = {:operator_id => operator_id, :region_id => region_id, :country_id => country_id } if result
      result
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
  
  def find_region(arr_of_string)
    speical_worlds = ['Республика', 'республика', 'область', 'край', 'автономный', 'автономная']
    (arr_of_string - speical_worlds).each do |str|
      regions[:names].each_index do |region_index|       
        return [regions[:ids][region_index], region_index] if (regions[:names][region_index].split(' ') - speical_worlds).include?(str)
      end
    end
    [nil, nil]
  end
  
  def row_number(row)
    service = row_service(row)
    if service and service[:base_service] == _3g
      {:number => row[row_column_index[:number]], :subservice => _unspecified_direction}
    else
      sub_service_id = (row[row_column_index[:number]] =~ /<--/) ? _inbound : _outbound
      phone = row[row_column_index[:number]].sub(/<--/, '')
      phone_range = operator_phone_numbers.find_range(phone)
      result = {:number => phone, :subservice => sub_service_id}
      if phone_range
        result.merge!(phone_range)
      end
      result
    end
  end
  
  def row_service(row)    
    result = case row[row_column_index[:service]]
    when 'Телеф.'
      {:base_service => _calls, :subservice => nil}
    when 'sms i'
      {:base_service => _sms, :subservice => _inbound}
    when 'sms o'
      {:base_service => _sms, :subservice => _outbound}
    when 'Emrg'
      {:base_service => nil, :subservice => nil}
    when 'clip', 'clir'
      {:base_service => nil, :subservice => nil}
    when 'Факс'
      {:base_service => nil, :subservice => nil}
#TODO исправить
    when 'Данные', 'HSDPA (3G)', 'gprs', '4G'
      {:base_service => _3g, :subservice => _unspecified_direction}
    when 'cfa'
      {:base_service => nil, :subservice => nil}
    when 'cfu', 'cfac', 'cf busy', 'cf nrepl', 'cf nreach', 'cw', 'ch'
      {:base_service => _calls, :subservice => nil}
    when 'cba', 'cbao', 'cbo', 'cboi', 'cboih', 'cbai', 'cbi', 'cbiih', 'сгфп'
      {:base_service => nil, :subservice => nil}
    when 'ct', 'mpty'
      {:base_service => _calls, :subservice => _inbound}
    when 'mms.spb'
      {:base_service => _mms, :subservice => nil}
    when 'mms i'
      {:base_service => _mms, :subservice => _inbound}
    when 'mms o'
      {:base_service => _mms, :subservice => _outbound}
    when 'rbtfmb0', 'rbtcpyX*', 'rbtproX*', 'rbtcthX*'
      {:base_service => nil, :subservice => nil}
    when 'unknown U'
      {:base_service => nil, :subservice => nil}
    when 'Vam Zvonili:', 'Abonent v seti:'
      {:base_service => _sms, :subservice => _inbound}
    when 'MTS numbers'
      {:base_service => _periodic, :subservice => _unspecified_direction}
    when 'cug', 'LBS0_sms'
      {:base_service => nil, :subservice => nil}
    when 'LBS0_sms', 'LBS0_web', 'LBS5_sms', 'LBS5_web', 'LBS23'
      {:base_service => nil, :subservice => nil}
    when 'ussd'
      {:base_service => nil, :subservice => nil}
    when ''
      {:base_service => nil, :subservice => nil}
    else
      unprocessed << {:unprocessed_column => :service, :value => row[row_column_index[:service]], :row => row}
      @should_be_included_in_processed = false
      {:base_service => nil, :subservice => nil}
    end
    if result[:base_service].blank?
      ignorred << {:ignorred_column => :service, :value => row[row_column_index[:service]], :row => row}
      nil
    else
      result
    end
     
  end
  
  def sub_service(row)
    
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
    "#{row[row_column_index[:date]]} #{row[row_column_index[:time]]} #{row[row_column_index[:gmt]]}".to_datetime
  end
  
  def check_if_table_correct
    result = true
    result = false if table_heads != ["", "Дата", "Время", "GMT*", "Номер", "Зона вызова", "Зона направления вызова/номер сессии", "Услуга", " ", "Длительность/Объем (мин.:сек.)/(Kb)", "Стоимость руб.", ""]
    result = false if row_column_index.values.include?(nil)
    result 
  end
  
  def table_heads
    @table_heads ||= doc.css('table table thead tr').first.css('th').to_a.map{|head_item| head_item.text}
  end
  
  def table_rows(max_row_number = max_number_of_rows_to_process)
    result = []
    doc.css('table table tbody tr')[0, max_row_number].each do |row|
      result << row.css('td').to_a.map{|column| column.text}
    end
    @original_row_number = result.size
    result
  end
  
  def row_column_index
    @row_column_index ||= {
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
    @row_column_index
  end
  
end
