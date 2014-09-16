class ServiceHelper::AdditionalOptimizationInfoPresenter
  attr_reader :name, :output_model, :results, :operator, :user_id, :tarif_count
  attr_reader :service_set_based_on_tarif_sets_or_tarif_results, :level_to_show_tarif_result_by_parts, :use_price_comparison_in_current_tarif_set_calculation,
              :max_tarif_set_count_per_tarif
  
  def initialize(operator, options = {}, input = nil, name = nil)
    @operator = operator
    @name = name || 'default_output_results_name'
    @user_id = options[:user_id] || 0
    @tarif_count = options[:tarif_count].to_i
    @output_model = Customer::Stat.where(:result_type => 'optimization_results').where(:result_name => @name, :user_id => @user_id)
    init_results(input)
  end
  
  def init_results(input = nil)
    if input
      @results = input[name]       
    else
      @results ||= {}
      output_model.select("result as #{name}").each do |result_item|
        result_item.attributes[name].each do |result_type, result_value|
#          raise(StandardError, [result_value, result_type, name])
          if result_value.is_a?(Hash)
            @results[result_type] ||= {}
            @results[result_type].merge!(result_value)
          else
            @results[result_type] = result_value
          end
        end
      end
    end
  end
  
  def get_optimization_results(name1, name2)
    @model ||= {}
    @model[name1] ||= {}    
    local_results ||= {}
    @model[name1][name2] ||= Customer::Stat.where(:result_type => 'optimization_results').where(:result_name => name1, :user_id => user_id).select("result as #{name1}")
#    raise(StandardError, model.to_sql)
    @model[name1][name2].each do |result_item|
      result_item.attributes[name1].each do |result_type, result_value|
        if result_value.is_a?(Hash)
          local_results[result_type] ||= {}
          local_results[result_type].merge!(result_value)
        else
          local_results[result_type] = result_value
        end
      end
    end
    local_results[name2] if local_results
  end

  def current_tarif_set_calculation_history
    return @current_tarif_set_calculation_history if @current_tarif_set_calculation_history
    @current_tarif_set_calculation_history = get_optimization_results('final_tarif_sets', 'current_tarif_set_calculation_history')
#    raise(StandardError)
  end

  def performance_results
    results ? results['performance_results'] || [{}] : [{}]
  end
  
  def calls_stat_array(group_by)
#    group_by = ['rouming', 'service', nil, nil]
    if group_by.blank?
      (calls_stat || []).collect{|row| row if row['count'] > 0}.compact.sort_by{|row| row['order']} || []
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
      result.sort_by{|r| r['name_string']}
    end    
  end
  
  def service_packs_by_parts_array
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
    results['calls_stat'] if results
  end
  
  def service_packs_by_parts
    results['service_packs_by_parts'] if results
  end
  
  def used_memory_by_output
    if results and results['used_memory_by_output']
      total = {'objects' => 0, 'bytes' => 0, 'loops' => 0}
      results['used_memory_by_output'].each do |name, value|
        total['objects'] += value['objects'] || 0
        total['bytes'] += value['bytes'] || 0
        total['loops'] += value['loops'] || 0
      end      
      output = []
      {'total' => total}.merge(results['used_memory_by_output']).each do |name, value|
        output << {'name' => name}.merge(value)
      end
      output
    else
      [{}]
    end      
  end
  
end
