class Calls::HistoryParser::OperatorProcessor::Operator
  include Calls::HistoryParser::TextProcessorHelper
  include Calls::HistoryParser::DbSearchHelper

  attr_reader :user_params
  attr_reader :unprocessed, :processed, :ignorred, :row_column_index
  
  def initialize(user_params)
    @user_params = user_params
    @operator_phone_numbers = Calls::OperatorPhoneNumbers.new()
    @unprocessed = []; @processed = []; @ignorred = []
    @row_column_index = {}
    load_db_data
  end
  
  def parse_row(row, date)
    service = row_service(row)
    return nil if !service
    number = row_number(row)
    roming = row_rouming(row)
    return nil if !roming
    partner = row_partner(row)
    return nil if !partner
#    raise(StandardError) if row[row_column_index[:time]] =~ /14:42:46/
    processed << {
      :base_service_id => service[:base_service], 
      :base_subservice_id => (service[:subservice] || number[:subservice]), 
      :user_id => user_params[:user_id],
      :call_run_id => user_params[:call_run_id],
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
    region_id, region_index = find_region(partner_items(row))      
    country_id = find_partner_country(row, region_index)      
    operator_id, operator_type_id = find_partner_operator_and_type_by_criteria(row, country_id)
    
    case 
    when partner_criteria(:own_region, row, region_id)
      {:operator_id => user_params[:operator_id], :operator_type_id => _mobile, :region_id => user_params[:region_id], :country_id => user_params[:country_id]}

    when partner_criteria(:home_region, row, region_id)
      {:operator_id => user_params[:operator_id], :operator_type_id => _mobile, :region_id => user_params[:region_id], :country_id => user_params[:country_id]}

    when partner_criteria(:own_country, row, region_id)
      if region_id and !country_id
        unprocessed << {:unprocessed_column => :partner_country, :value => row[partner_row_column], :row => row}
        result = nil
      end       

      if !operator_id
        unprocessed << {:unprocessed_column => :partner_operator, :value => row[partner_row_column], :row => row} 
        result = nil
      end
      result = {:operator_id => operator_id, :operator_type_id => operator_type_id, :region_id => region_id, :country_id => country_id } if result

    when partner_criteria(:international, row, region_id)
      if !operator_id
        unprocessed << {:unprocessed_column => :partner_operator, :value => row[partner_row_column], :row => row} 
        result = nil
      end

      if !country_id
        unprocessed << {:unprocessed_column => :partner_region, :value => row[partner_row_column], :row => row}
        result = nil
      end
      result = {:operator_id => operator_id, :operator_type_id => operator_type_id, :region_id => region_id, :country_id => country_id } if result
    end    
  end
  
  def find_partner_operator_and_type(row, country_id)
    operator_id, operator_index = find_operator(partner_items(row))
    operator_id = find_operator_by_country(country_id) if country_id and !operator_id  
    operator_type_id = (operator_id and operator_id == Category::Operator::Const::FixedlineOperator) ? _fixed_line : _mobile
    [operator_id, operator_type_id]
  end

  def find_partner_country(row, region_index)
    country_id, country_index = find_country(partner_items(row))      
    country_id = regions[:country_ids][region_index] if region_index
    country_id
  end

  def partner_items(row)
    take_out_special_symbols(row[partner_row_column])
  end
        
  def row_rouming(row)
    region_id, region_index = find_region(rouming_items(row))
    region_id = (regions[:ids] - [user_params[:region_id]])[0] if !region_id 

    home_region_id = home_region_by_operator
    home_region_id = region_id if home_region_id.blank?
    
    case
    when rouming_criteria(:own_region, row, region_id, home_region_id) 
      {:operator_id => user_params[:operator_id], :region_id => user_params[:region_id], :country_id => user_params[:country_id]}
      
    when rouming_criteria(:home_region, row, region_id, home_region_id)
      {:operator_id => user_params[:operator_id], :region_id => home_region_id, :country_id => user_params[:country_id]}
      
    when rouming_criteria(:own_country, row, region_id, home_region_id)
      {:operator_id => user_params[:operator_id], :region_id => region_id, :country_id => user_params[:country_id]}
      
    when rouming_criteria(:international, row, region_id, home_region_id)
      country_id = find_rouming_country(row, region_index)
      if !country_id
        unprocessed << {:unprocessed_column => :rouming_country, :value => row[row_column_index[:rouming]], :row => row}
        result = nil
      end
             
      operator_id = find_rouming_operator(row, country_id)
      if !operator_id
        unprocessed << {:unprocessed_column => :rouming_operator, :value => row[row_column_index[:rouming]], :row => row}
        result = nil
      end

      result = {:operator_id => operator_id, :region_id => region_id, :country_id => country_id } if result
      result
    end
  end
  
  def find_rouming_country(row, region_index)
    country_id = regions[:country_ids][region_index] if region_index
    country_id, country_index = find_country(rouming_items(row)) if !country_id
    country_id, country_index = find_country_by_country_group(rouming_items(row)) if !country_id
    country_id, country_index = find_country_by_country_group(['европа']) if !country_id and rouming_items(row).join(' ') =~ /входящее смс/i
    country_id
  end
  
  def find_rouming_operator(row, country_id)
    operator_id, operator_index = find_operator(rouming_items(row))
#    raise(StandardError) if row.join(' ') =~ 'Astelit'
    operator_id = find_operator_by_country(country_id) if country_id and country_id != _russia and !operator_id 
    operator_id
  end
  
  def row_number(row)
    service = row_service(row)
    if service and service[:base_service] == _3g
      {:number => internet_number(row), :subservice => _unspecified_direction}
    else
      sub_service_id = sub_service(row, service)      
      phone = phone_number(row, service)
      phone = take_out_special_symbols_from_phone_number(phone) if phone
      
      phone_range = operator_phone_numbers.find_range(phone)
      result = {:number => phone, :subservice => sub_service_id}
      if phone_range
        result.merge!(phone_range)
      end
      result
    end
  end
  
  def row_service(row) 
    service = row_parser(row, base_service_criteria, :service, :service)
    subservice = row_parser(row, base_subservice_criteria, :service, :subservice)
    {:base_service => service, :subservice => subservice} if service
  end
  
  def row_parser(row, field_criteria, field_name, column_name)
    condition = false    
#    raise(StandardError) # if row[row_column_index[:time]] =~ /19:26:01/ and field_criteria.size == 3 
    field_criteria.each do |base_service, base_service_criteria_array|
      base_service_criteria_array.each do |service_criteria|
        condition = false
        service_criteria.each do |row_name, criteria|
          condition = true if criteria and row[row_column_index[row_name]] =~ criteria
          break if condition
        end
#        raise(StandardError) if (condition and row[row_column_index[:time]] =~ /18:22:33/ and column_name == :subservice) #and field_criteria.size == 3 and base_service == 71
        return base_service if condition
      end
    end
#    raise(StandardError) if column_name == :subservice
    unprocessed << {:unprocessed_column => column_name, :value => row[row_column_index[field_name]], :row => row} #if !condition    
#    ignorred << {:ignorred_column => column_name, :value => row[row_column_index[field_name]], :row => row} if field_name == :service
    nil
  end
  
  def find_column_indexes(table_heads_1)
    max_row_seach = 100
    table_heads = table_heads_1[0].is_a?(Array) ? table_heads_1 : [table_heads_1]
    
    table_heads[0..max_row_seach].each_with_index do |table_head, table_row|
      @row_column_index = {}
      
      correct_table_heads.each_with_index do |correct_table_head, correct_index|
        raise(StandardError, [table_head, correct_table_heads]) if table_row == 0 and correct_index == 1 and false
        correct_table_head.each do |local_name, out_name|
          @row_column_index[local_name] = table_head.index(out_name)
          break if !@row_column_index[local_name]
        end
        check = @row_column_index.values.compact.size == correct_table_head.keys.size
        return @row_column_index if check
      end
    end
    nil
  end
  
end
