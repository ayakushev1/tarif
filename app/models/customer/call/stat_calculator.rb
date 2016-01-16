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
          
          raise(StandardError) if Customer::Call.where(query_constructor.categories_where_hash[criteria_value]).size < 0 and criteria_value
          
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
  
  def update_customer_calls_with_global_categories(query_constructor)
    calls_stat_category_sql = []
    calls_stat_categories.each do |calls_stat_category_id, calls_stat_category_criteria|
      where_condition = []
      calls_stat_category_criteria[:categories].each do |criteria_type, criteria_value|        
        where_condition << query_constructor.categories_where_hash[criteria_value] if criteria_value
      end
      call_types = calls_stat_category_criteria[:call_types].map{|s| "\"#{s}\""}.join(', ')
      fields = [
        "'#{calls_stat_category_criteria[:name]}' as calls_stat_category",
        "#{calls_stat_category_id}::integer as order",
        "#{calls_stat_category_id}::integer as global_category_id",
        "'[#{call_types}]' as call_types",
        "#{calls_stat_functions_string(calls_stat_category_criteria[:stat_functions])}",
      ]
      Customer::Call.where(:call_run_id => call_run_id).where(calculation_scope_where_hash).
        where("description->>'accounting_period' = '#{accounting_period}'").
        select(fields.join(', ')).where(where_condition.join(' and ')).update_all(:global_category_id => calls_stat_category_criteria[:order])
    end
  end
  
  def calculate_calls_stat(query_constructor)
    sql = calculate_calls_stat_sql(query_constructor)
#    raise(StandardError, sql)
    Customer::Call.find_by_sql(sql) unless sql.blank?
  end
  
  def calculate_calls_stat_sql(query_constructor)
    calls_stat_category_sql = []
    calls_stat_categories.each do |calls_stat_category_id, calls_stat_category_criteria|
      where_condition = []
      calls_stat_category_criteria[:categories].each do |criteria_type, criteria_value|        
        where_condition << query_constructor.categories_where_hash[criteria_value] if criteria_value
      end
      call_types = calls_stat_category_criteria[:call_types].map{|s| "\"#{s}\""}.join(', ')
      fields = [
        "'#{calls_stat_category_criteria[:name]}' as calls_stat_category",
        "#{calls_stat_category_id}::integer as order",
        "#{calls_stat_category_id}::integer as global_category_id",
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
      :operator => ['own_operator', 'not_own_operator'],
#      :fixed => ['fixed']
    }
  end
  
  def self.global_category_ids
    new().calls_stat_categories.keys
  end
  
  def groupped_global_categories(group_by_1 = [])
    group_by = group_by_1.blank? ? category_group_keys : group_by_1
    result_hash = {}
    calls_stat_categories.each do |calls_stat_category_id, category|
      name = {}
      name_string = global_category_group_name(calls_stat_category_id, group_by)
      
      group_by.each do |group|
        name[group] =tr(category[:call_types][category_group_indexes[group]]) if category_group_indexes[group] and category
      end
#      raise(StandardError, [name_string, name])
      result_hash[name_string] ||= name.merge({'name_string' => name_string, 'categ_ids' => []})
      result_hash[name_string]['categ_ids'] += (([calls_stat_category_id] || []) - result_hash[name_string]['categ_ids'])
    end
    result_hash
  end
  
  def global_category_group_name(global_category_id, group_by_1 = [])
    group_by = group_by_1.blank? ? category_group_keys : group_by_1
    calls_stat_category = calls_stat_categories[global_category_id]
    group_by.collect do |group|
      calls_stat_category[:call_types][category_group_indexes[group]] if category_group_indexes[group] and calls_stat_category
    end.compact.join('_') 
  end
  
  def category_group_indexes
    {'rouming' => 0, 'service' => 1, 'direction' => 2, 'geo' => 3, 'operator' => 4, 'fixed' => 5}
  end
  
  def category_group_keys
    ['rouming', 'service', 'direction', 'geo', 'operator', 'fixed']
  end
  
  def calls_stat_categories
    {
     0 => {:order => 0, :name => 'own_home_regions_calls_incoming', 
       :call_types => ['own_home_regions', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     1 => {:order => 1, :name => 'own_home_regions_calls_to_own_home_regions_to_own_operator', 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_home_regions', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_own_operator}},
        
     2 => {:order => 2, :name => 'own_home_regions_calls_to_own_home_regions_not_own_operator', 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_home_regions', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_not_own_operator}}, 

     3 => {:order => 3, :name => 'own_home_regions_calls_to_own_country_own_operator',
       :call_types => ['own_home_regions', 'calls', 'out', 'own_country', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_own_operator}},
        
     4 => {:order => 4, :name => 'own_home_regions_calls_to_own_country_not_own_operator', 
       :call_types => ['own_home_regions', 'calls', 'out', 'own_country', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_not_own_operator}}, 

     5 => {:order => 5,  :name => 'own_home_regions_calls_sic_country',
       :call_types => ['own_home_regions', 'calls', 'out', 'sic_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_sic, :operator => _service_to_not_own_operator}},
        
     6 => {:order => 6,  :name => 'own_home_regions_calls_europe',
       :call_types => ['own_home_regions', 'calls', 'out', 'europe'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_europe, :operator => _service_to_not_own_operator}},
        
     7 => {:order => 7,  :name => 'own_home_regions_calls_other_country',
       :call_types => ['own_home_regions', 'calls', 'out', 'other_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _calls_out, :geo => _service_to_mts_other_countries, :operator => _service_to_not_own_operator}}, 

     8 => {:order => 8,  :name => 'own_home_regions_sms_incoming',
       :call_types => ['own_home_regions', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_in, :geo => nil, :operator => nil}},
       
     9 => {:order => 9,  :name => 'own_home_regions_sms_to_own_home_regions',
       :call_types => ['own_home_regions', 'sms', 'out', 'own_home_regions'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_own_and_home_regions}},
        
     10 => {:order => 10,  :name => 'own_home_regions_sms_to_own_country',
       :call_types => ['own_home_regions', 'sms', 'out', 'own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_own_country}},
        
     11 => {:order => 11,  :name => 'own_home_regions_sms_to_not_own_country',
       :call_types => ['own_home_regions', 'sms', 'out', 'not_own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _sms_out, :geo => _service_to_not_own_country}},
        
     12 => {:order => 12,  :name => 'own_home_regions_mms_incoming',
       :call_types => ['own_home_regions', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _mms_in}},
       
     13 => {:order => 13,  :name => 'own_home_regions_mms_outcoming',
       :call_types => ['own_home_regions', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _mms_out, :geo => nil, :operator => nil}},
       
     14 => {:order => 14,  :name => 'own_home_regions_internet',
       :call_types => ['own_home_regions', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _own_and_home_regions_rouming, :service => _internet}},
        

     15 => {:order => 15,  :name => 'own_country_calls_incoming',
       :call_types => ['own_country', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     16 => {:order => 16, :name => 'own_country_calls_to_own_home_regions_to_own_operator', 
       :call_types => ['own_country', 'calls', 'out', 'own_home_regions', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_own_operator}},
        
     17 => {:order => 17,  :name => 'own_country_calls_to_own_home_regions_not_own_operator',
       :call_types => ['own_country', 'calls', 'out', 'own_home_regions', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_and_home_regions, :operator => _service_to_not_own_operator}}, 

     18 => {:order => 18,  :name => 'own_country_calls_to_own_country_own_operator',
       :call_types => ['own_country', 'calls', 'out', 'own_country', 'own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_own_operator}},
        
     19 => {:order => 19,  :name => 'own_country_calls_to_own_country_not_own_operator',
       :call_types => ['own_country', 'calls', 'out', 'own_country', 'not_own_operator'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_own_country, :operator => _service_to_not_own_operator}}, 

     20 => {:order => 20,  :name => 'own_country_calls_sic_country',
       :call_types => ['own_country', 'calls', 'out', 'sic_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_sic, :operator => _service_to_not_own_operator}},
        
     21 => {:order => 21,  :name => 'own_country_calls_europe',
       :call_types => ['own_country', 'calls', 'out', 'europe'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_europe, :operator => _service_to_not_own_operator}},
        
     22 => {:order => 22,  :name => 'own_country_calls_other_country',
       :call_types => ['own_country', 'calls', 'out', 'other_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _own_country_rouming, :service => _calls_out, :geo => _service_to_mts_other_countries, :operator => _service_to_not_own_operator}}, 

     23 => {:order => 23,  :name => 'own_country_sms_incoming',
       :call_types => ['own_country', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_in, :geo => nil, :operator => nil}},
       
     24 => {:order => 24,  :name => 'own_country_sms_to_own_home_regions',
       :call_types => ['own_country', 'sms', 'out', 'own_home_regions'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_own_and_home_regions}},
        
     25 => {:order => 25,  :name => 'own_country_sms_to_own_country',
       :call_types => ['own_country', 'sms', 'out', 'own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_own_country}},
        
     26 => {:order => 26,  :name => 'own_country_sms_to_not_own_country',
       :call_types => ['own_country', 'sms', 'out', 'not_own_country'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _sms_out, :geo => _service_to_not_own_country}},
        
     27 => {:order => 27,  :name => 'own_country_mms_incoming',
       :call_types => ['own_country', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _mms_in}},
       
     28 => {:order => 28,  :name => 'own_country_mms_outcoming',
       :call_types => ['own_country', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _own_country_rouming, :service => _mms_out, :geo => nil, :operator => nil}},
       
     29 => {:order => 29,  :name => 'own_country_internet',
       :call_types => ['own_country', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _own_country_rouming, :service => _internet}},

       
     30 => {:order => 30,  :name => 'all_world_calls_incoming',
       :call_types => ['all_world', 'calls', 'in'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_in, :geo => nil, :operator => nil}},
       
     31 => {:order => 31,  :name => 'all_world_calls_to_russia',
       :call_types => ['all_world', 'calls', 'out', 'to_russia'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_russia, :operator => nil}},
        
     32 => {:order => 32,  :name => 'all_world_calls_to_rouming_country',
       :call_types => ['all_world', 'calls', 'out', 'to_rouming_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_rouming_country, :operator => nil}},
        
     33 => {:order => 33,  :name => 'all_world_calls_to_not_rouming_country',
       :call_types => ['all_world', 'calls', 'out', 'to_not_rouming_country'], :stat_functions => [:count, :sum_duration],
       :categories => {:rouming => _all_world_rouming, :service => _calls_out, :geo => _sc_service_to_not_rouming_not_russia, :operator => nil}},
        
     34 => {:order => 34,  :name => 'all_world_sms_incoming',
       :call_types => ['all_world', 'sms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _sms_in, :geo => nil, :operator => nil}},

     35 => {:order => 35,  :name => 'all_world_sms_outcoming',
       :call_types => ['all_world', 'sms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _sms_out, :geo => nil, :operator => nil}},

     36 => {:order => 36,  :name => 'all_world_mms_incoming',
       :call_types => ['all_world', 'mms', 'in'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _mms_in, :geo => nil, :operator => nil}},

     37 => {:order => 37,  :name => 'all_world_mms_outcoming',
       :call_types => ['all_world', 'mms', 'out'], :stat_functions => [:count, :count_volume],
       :categories => {:rouming => _all_world_rouming, :service => _mms_out, :geo => nil, :operator => nil}},

     38 => {:order => 38,  :name => 'all_world_internet',
       :call_types => ['all_world', 'internet'], :stat_functions => [:count, :sum_volume],
       :categories => {:rouming => _all_world_rouming, :service => _internet}},
    }    
  end


  def tr(word)
    dictionary = {
      'rouming' => 'Роуминг', 'service' => 'Услуга', 'direction' => 'Направление связи', 'geo' => 'Куда', 'operator' => 'На какого оператора', 
      'count' => 'Кол-во услуг', 'sum duration' => 'Звонки, мин', 'count volume' => 'СМС и ММС, шт', 'sum volume' => 'Интернет, Мб',
      'calls'=> 'звонки', 'sms'=> 'смс', 'mms'=> 'ммс', 'internet'=> 'интернет',
      'in'=> 'входящие', 'out'=> 'исходящие', 
      'own_home_regions' => 'собственный и домашний регион', 'own_country' => 'Россия', 'all_world' => 'за границей',
      'to_not_rouming_country' => 'За пределы страны нахождения', 'not_own_country' => 'за пределы России',
      'to_russia' => 'в Россию', 'europe' => 'в европу',
      'own_operator' => 'на своего оператора',  'not_own_operator' => 'на чужого оператора',
      'fixed' => 'Постоянные оплаты'
    }
    if word and dictionary[word.to_s]
      dictionary[word.to_s]
    else
      word
    end
  end


end

