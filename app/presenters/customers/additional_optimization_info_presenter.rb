class Customers::AdditionalOptimizationInfoPresenter #ServiceHelper::AdditionalOptimizationInfoPresenter
  attr_reader :user_id, :demo_result_id
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    @demo_result_id = options[:demo_result_id]
  end
  
  def results
    Customer::Stat.get_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    })
  end
      
  def current_tarif_set_calculation_history
    Customer::Stat.get_named_results({
      :result_type => 'final_tarif_sets',
      :result_name => 'final_tarif_sets',
      :user_id => user_id,
    }, 'current_tarif_set_calculation_history') || [{}]
  end

  def performance_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    }, 'performance_results') || [{}]
  end
  
  def calls_stat_array(group_by)
#    group_by = ['rouming', 'service', nil, nil]
    if group_by.blank?
      result = (calls_stat || []).collect{|row| row if row['count'] > 0}.compact
      result = (false ? result.sort_by{|row| row['order']} : result) || []
      result
    else
      i = 0
      result_hash = {}
      (calls_stat || []).each do |row|
        name = {}
        call_types = eval(row['call_types'])
        name['rouming'] = call_types[0] if group_by.include?('rouming')
        name['service'] = call_types[1] if group_by.include?('service')
        name['direction'] = call_types[2] if group_by.include?('direction')
        name['geo'] = call_types[3] if group_by.include?('geo')
        name['operator'] = call_types[4] if group_by.include?('operator')

        name_string = name.keys.collect{|k| name[k] }.compact.join('_') 
        
        result_hash[name_string] ||= name.merge({'name_string' => name_string, 'count' => 0, 'sum_duration' => 0.0, 'count_volume' => 0, 'sum_volume' => 0.0})
        result_hash[name_string]['count'] += row['count'] || 0
        result_hash[name_string]['sum_duration'] += row['sum_duration'] || 0.0
        result_hash[name_string]['count_volume'] += row['count_volume'] || 0
        result_hash[name_string]['sum_volume'] += row['sum_volume'] || 0.0
        i += 1
      end
      
      result = []
      result_hash.each {|name, value| result << value if value['count'] > 0 }
      true ? result.sort_by!{|item| item['name_string']} : result
    end    
  end
  
  def service_packs_by_parts_array #(new, for tarif_set)
    result = []
    service_packs_by_parts.each do |tarif, services_by_tarif|
      temp_result = {:tarif => tarif}
      services_by_tarif.each do |part, services|
        temp_result.merge!({part => services.size})
#        temp_result.merge!({part => services.keys.size})
      end
      result << temp_result
    end if service_packs_by_parts
    result
  end
  
  def service_packs_by_parts_array_1 #(old, for service_pack)
    result = []
    service_packs_by_parts.each do |tarif, services_by_tarif|
      temp_result = {:tarif => tarif}
      services_by_tarif.each do |part, services|
        temp_result.merge!({part => services.size})
      end
      result << temp_result
    end if service_packs_by_parts
    result
  end
  
  def calls_stat
    result = Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    }, 'calls_stat')     
#    raise(StandardError, result)
    result
  end

  def service_packs_by_parts
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    }, 'service_packs_by_parts') 
  end
  
end
