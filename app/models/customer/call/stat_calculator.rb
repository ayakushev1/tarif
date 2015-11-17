Dir[Rails.root.join("db/seeds/definitions/01_service_categories.rb")].sort.each { |f| require f }

class Customer::Call::StatCalculator
  attr_reader :user_id, :accounting_period, :call_run_id, :calculation_scope, :calculation_scope_where_hash
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    @accounting_period = options[:accounting_period]
    @call_run_id = options[:call_run_id]
    @calculation_scope = {:where_hash => {}}
    @calculation_scope_where_hash = 'true'
  end
  
  def calculate_calculation_scope(query_constructor, selected_service_categories)
    @calculation_scope = {:where_hash => {}}
    selected_service_categories.each do |part, selected_service_categories_by_part|
      service_categories_where_condition = ['false']
      selected_service_categories_by_part.each do |service_category_name, service_category_criteria|
        service_category_where_condition = ['true']
        service_category_criteria.each do |criteria_type, criteria_value|
          service_category_where_condition << query_constructor.categories_where_hash[criteria_value] if criteria_value
        end if service_category_criteria
        service_categories_where_condition << "(#{service_category_where_condition.join(' and ')})"
      end if selected_service_categories_by_part
      calculation_scope[:where_hash][part] = "(#{service_categories_where_condition.join(' or ')})"
    end if selected_service_categories
    calculation_scope[:parts] = calculation_scope[:where_hash].keys + ['onetime', 'periodic']
    @calculation_scope_where_hash = calculate_calculation_scope_where_hash
#    raise(StandardError, @calculation_scope_where_hash)
  end

  def calculate_calculation_scope_where_hash
    where_hash = ['false'] 
    where_hash << calculation_scope[:where_hash].collect { |part, where_hash_by_part| where_hash_by_part } if calculation_scope[:where_hash]
    where_hash.join(' or ')
  end
  
  def calculate_calls_stat(query_constructor)
    sql = calculate_calls_stat_sql(query_constructor)
#    raise(StandardError, sql)
    Customer::Call.find_by_sql(sql) unless sql.blank?
  end
  
  def calculate_calls_stat_sql(query_constructor)
    calls_stat_category_sql = []
    calls_stat_categories.each do |calls_stat_category_name, calls_stat_category_criteria|
      where_condition = []
      calls_stat_category_criteria[:categories].each do |criteria_type, criteria_value|        
        where_condition << query_constructor.categories_where_hash[criteria_value] if criteria_value
      end
      call_types = calls_stat_category_criteria[:call_types].map{|s| "\"#{s}\""}.join(', ')
      fields = [
        "'#{calls_stat_category_name}' as calls_stat_category",
        "#{calls_stat_category_criteria[:order]}::integer as order",
        "'[#{call_types}]' as call_types",
        "#{calls_stat_functions_string(calls_stat_category_criteria[:stat_functions])}",
      ]
      calls_stat_category_sql << Customer::Call.where(:call_run_id => call_run_id).where(calculation_scope_where_hash).
        where("description->>'accounting_period' = '#{accounting_period}'").
        select(fields.join(', ')).where(where_condition.join(' and ')).to_sql
    end
    calls_stat_category_sql.join(' union ')
  end

  def calculate_calls_count_by_parts(query_constructor, uniq_parts_by_operator, uniq_parts_criteria_by_operator)
    calls_count_by_parts ||= {}   
    i = 0
    where_condition = false
    uniq_parts_criteria_by_operator.each do |uniq_part_criteria_by_operator|
      where_part = []
      uniq_part_criteria_by_operator.each do |category_name, category_value|
        if category_value.is_a?(Array)
          where_part_array = []
          category_value.each {|category| where_part_array << query_constructor.categories_where_hash[category]}
          where_part << "( #{where_part_array.join(' or ')} )"
        else
          where_part << query_constructor.categories_where_hash[category_value]
        end        
      end

      part = uniq_parts_by_operator[i]
      where_condition = where_part.join(' and ') if !where_part.blank?

      calls_count_by_parts[part] = Customer::Call.where( where_condition ).where(calculation_scope_where_hash).count(:id)
      i += 1
    end
    calls_count_by_parts
  end 
  
  def calls_stat_functions_string(stat_functions_names)
    result = []
    calls_stat_functions.keys.each do |name|
      if stat_functions_names.include?(name)
        result << "#{calls_stat_functions[name]} as #{name}"
      else
        result << "0 as #{name}"
      end       
    end
    result.join(', ')
  end
  
  def calls_stat_functions
    {
      :count => "count(*)",
      :sum_duration => "sum((description->>'duration')::float)/60.0",
      :count_volume => "count(description->>'volume')",
#      :count_volume => "count((description->>'volume')::integer)",
      :sum_volume => "sum((description->>'volume')::float)",
      :cost => "sum((description->>'cost')::float)",
     }
  end
  
  def calls_stat_types
    {
      :rouming => ['own_home_regions', 'own_country', 'all_world'],
      :service => ['calls', 'sms', 'mms', 'internet'],
      :geo => ['own_home_regions', 'own_country', 'sic_country', 'europe', 'all_world'],
      :operator => ['own_operator', 'not_own_operator']
    }
  end
  
  def calls_stat_categories
    {
     'own_home_regions_calls_incoming' => {:order => 0, 
       :call_types => ['own_home_regions', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     'own_home_regions_calls_to_own_home_regions_to_own_operator' => {:order => 1, 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_home_regions', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_own_operator}},
        
     'own_home_regions_calls_to_own_home_regions_not_own_operator' => {:order => 2, 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_home_regions', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_not_own_operator}}, 

     'own_home_regions_calls_to_own_country_own_operator' => {:order => 3, 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_country', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_own_operator}},
        
     'own_home_regions_calls_to_own_country_not_own_operator' => {:order => 4, 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_country', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_not_own_operator}}, 

     'own_home_regions_calls_sic_country' => {:order => 5, 
       :call_types => ['own_home_regions', 'calls', 'out', 'sic_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_sic, :operator => _service_to_not_own_operator}},
        
     'own_home_regions_calls_europe' => {:order => 6, 
       :call_types => ['own_home_regions', 'calls', 'out', 'europe'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_europe, :operator => _service_to_not_own_operator}},
        
     'own_home_regions_calls_other_country' => {:order => 7, 
       :call_types => ['own_home_regions', 'calls', 'out', 'other_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_other_countries, :operator => _service_to_not_own_operator}}, 

     'own_home_regions_sms_incoming' => {:order => 8, 
       :call_types => ['own_home_regions', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_in, :geo => nil, :operator => nil}},
       
     'own_home_regions_sms_to_own_home_regions' => {:order => 9, 
       :call_types => ['own_home_regions', 'sms', 'out', 'own_home_regions'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_own_and_home_regions}},
        
     'own_home_regions_sms_to_own_country' => {:order => 10, 
       :call_types => ['own_home_regions', 'sms', 'out', 'own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_own_country}},
        
     'own_home_regions_sms_to_not_own_country' => {:order => 11, 
       :call_types => ['own_home_regions', 'sms', 'out', 'not_own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_not_own_country}},
        
     'own_home_regions_mms_incoming' => {:order => 12, 
       :call_types => ['own_home_regions', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _mms_in}},
       
     'own_home_regions_mms_outcoming' => {:order => 13, 
       :call_types => ['own_home_regions', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _mms_out, :geo => nil, :operator => nil}},
       
     'own_home_regions_internet' => {:order => 14, 
       :call_types => ['own_home_regions', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _internet}},
        

     'own_country_calls_incoming' => {:order => 15, 
       :call_types => ['own_country', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     'own_country_calls_to_own_home_regions_to_own_operator' => {:order => 16, 
       :call_types => ['own_country', 'calls', 'out', 'own_home_regions', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_own_operator}},
        
     'own_country_calls_to_own_home_regions_not_own_operator' => {:order => 17, 
       :call_types => ['own_country', 'calls', 'out', 'own_home_regions', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_not_own_operator}}, 

     'own_country_calls_to_own_country_own_operator' => {:order => 18, 
       :call_types => ['own_country', 'calls', 'out', 'own_country', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_own_operator}},
        
     'own_country_calls_to_own_country_not_own_operator' => {:order => 19, 
       :call_types => ['own_country', 'calls', 'out', 'own_country', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_not_own_operator}}, 

     'own_country_calls_sic_country' => {:order => 20, 
       :call_types => ['own_country', 'calls', 'out', 'sic_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_sic, :operator => _service_to_not_own_operator}},
        
     'own_country_calls_europe' => {:order => 21, 
       :call_types => ['own_country', 'calls', 'out', 'europe'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_europe, :operator => _service_to_not_own_operator}},
        
     'own_country_calls_other_country' => {:order => 22, 
       :call_types => ['own_country', 'calls', 'out', 'other_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_other_countries, :operator => _service_to_not_own_operator}}, 

     'own_country_sms_incoming' => {:order => 23, 
       :call_types => ['own_country', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_in, :geo => nil, :operator => nil}},
       
     'own_country_sms_to_own_home_regions' => {:order => 24, 
       :call_types => ['own_country', 'sms', 'out', 'own_home_regions'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_own_and_home_regions}},
        
     'own_country_sms_to_own_country' => {:order => 25, 
       :call_types => ['own_country', 'sms', 'out', 'own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_own_country}},
        
     'own_country_sms_to_not_own_country' => {:order => 26, 
       :call_types => ['own_country', 'sms', 'out', 'not_own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_not_own_country}},
        
     'own_country_mms_incoming' => {:order => 27, 
       :call_types => ['own_country', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _mms_in}},
       
     'own_country_mms_outcoming' => {:order => 28, 
       :call_types => ['own_country', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _mms_out, :geo => nil, :operator => nil}},
       
     'own_country_internet' => {:order => 29, 
       :call_types => ['own_country', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _own_country_rouming, :service => _internet}},

       
     'all_world_calls_incoming' => {:order => 30, 
       :call_types => ['all_world', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     'all_world_calls_to_russia' => {:order => 31, 
       :call_types => ['all_world', 'calls', 'out', 'to_russia'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_russia, :operator => nil}},
        
     'all_world_calls_to_rouming_country' => {:order => 32, 
       :call_types => ['all_world', 'calls', 'out', 'to_rouming_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_rouming_country, :operator => nil}},
        
     'all_world_calls_to_not_rouming_country' => {:order => 33, 
       :call_types => ['all_world', 'calls', 'out', 'to_not_rouming_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_not_rouming_not_russia, :operator => nil}},
        
     'all_world_sms_incoming' => {:order => 34, 
       :call_types => ['all_world', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _sms_in, :geo => nil, :operator => nil}},

     'all_world_sms_outcoming' => {:order => 35, 
       :call_types => ['all_world', 'sms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _sms_out, :geo => nil, :operator => nil}},

     'all_world_mms_incoming' => {:order => 36, 
       :call_types => ['all_world', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _mms_in, :geo => nil, :operator => nil}},

     'all_world_mms_outcoming' => {:order => 37, 
       :call_types => ['all_world', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _mms_out, :geo => nil, :operator => nil}},

     'all_world_internet' => {:order => 38, 
       :call_types => ['all_world', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _all_world_rouming, :service => _internet}},
       

    }    
  end
end

