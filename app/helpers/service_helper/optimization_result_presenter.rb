class ServiceHelper::OptimizationResultPresenter
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
    init_output_choices(options)
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

  def init_output_choices(options = {})
    @service_set_based_on_tarif_sets_or_tarif_results = options[:service_set_based_on_tarif_sets_or_tarif_results]
    @level_to_show_tarif_result_by_parts = options[:show_zero_tarif_result_by_parts] == 'true' ? -1.0 : 0.0
    @use_price_comparison_in_current_tarif_set_calculation = options[:use_price_comparison_in_current_tarif_set_calculation] == 'true' ? true : false
    @max_tarif_set_count_per_tarif = options[:max_tarif_set_count_per_tarif].to_i
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
  
  def service_sets_array
#    raise(StandardError, final_tarif_sets)
    service_set_price = {}; service_set_count = {}; stat_results = {}; identical_services = {}; tarifs = {} #fobidden = {}; fobidden_services = {}; tarif_sets_by_part = {}
#    raise(StandardError, @service_set_based_on_tarif_sets_or_tarif_results)
    case service_set_based_on_tarif_sets_or_tarif_results
    when 'final_tarif_sets'
      final_tarif_sets.each do |service_set_id, final_tarif_set|
        service_set_price[service_set_id] = 0        
        service_set_count[service_set_id] = 0        
        
        tarif_result_to_use = updated_tarif_results ? updated_tarif_results : tarif_results
        final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
          part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
          tarif_results_for_service_set_and_part = tarif_result_to_use[tarif_set_by_part_id][part] if tarif_result_to_use and tarif_result_to_use[tarif_set_by_part_id]
          tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part |
            
#            stat_results[service_set_id] ||= {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
#            tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
#              (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
#                stat_results[service_set_id][stat_key] ||= 0
#                stat_results[service_set_id][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
#              end if price_value_detail['all_stat']
#            end
            tarifs[service_set_id] = final_tarif_set['tarif']
            identical_services[service_set_id] ||= []            
            identical_services[service_set_id] << groupped_identical_services[tarif_set_by_part_id]['identical_services'] if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
            identical_services[service_set_id].uniq!
            
            service_set_price[service_set_id] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
            service_set_count[service_set_id] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
            
          end if tarif_results_for_service_set_and_part
        end if final_tarif_set['tarif_sets_by_part']        
#        fobidden[service_set_id] = final_tarif_set['fobidden']
#        fobidden_services[service_set_id] = final_tarif_set['fobidden_services']
#        tarif_sets_by_part[service_set_id] = final_tarif_set['tarif_sets_by_part']
      end if final_tarif_sets    
    when 'cons_tarif_results'
#      raise(StandardError, cons_tarif_results_by_parts)
      cons_tarif_results_by_parts.each do |service_set_id, service_sets_result|
        service_set_price[service_set_id] ||= 0.0
        service_set_count[service_set_id] ||= 0
        service_sets_result.each do |part, part_result|
          service_set_price[service_set_id] += (part_result['price_value'] || 0.0).to_f.round(2)
          service_set_count[service_set_id] += (part_result['call_id_count'] || 0).to_i
        end if service_sets_result
      end if tarif_results
    when 'source_to_calculate_final_tarif_sets'
      tarif_sets_to_calculate_from_final_tarif_sets.each do |tarif_id, service_sets_result|
        service_sets_result.each do |part, part_result|
          part_result.each do |service_set_id, services |
            service_set_price[service_set_id] = 0.0 #(tarif_result['price_value'] || 0.0).to_f.round(2)
            service_set_count[service_set_id] = 0#(tarif_result['call_id_count'] || 0).to_i
          end
        end if service_sets_result
      end if tarif_sets_to_calculate_from_final_tarif_sets
    when 'updated_tarif_results'
      updated_tarif_results.each do |service_set_id, service_sets_result|
        service_set_price[service_set_id] ||= 0.0
        service_set_count[service_set_id] ||= 0
        service_sets_result.each do |part, part_result|
          part_result.each do |tarif_id, tarif_result |
            identical_services[service_set_id] ||= []            
            identical_services[service_set_id] << groupped_identical_services[service_set_id]['identical_services'] if groupped_identical_services and groupped_identical_services[service_set_id]
            identical_services[service_set_id].uniq!

            service_set_price[service_set_id] += (tarif_result['price_value'] || 0.0).to_f.round(2)
            service_set_count[service_set_id] += (tarif_result['call_id_count'] || 0).to_i
          end
        end if service_sets_result
      end if updated_tarif_results
    else
      tarif_results.each do |service_set_id, service_sets_result|
        service_set_price[service_set_id] ||= 0.0
        service_set_count[service_set_id] ||= 0
        service_sets_result.each do |part, part_result|
          part_result.each do |tarif_id, tarif_result |
            service_set_price[service_set_id] += (tarif_result['price_value'] || 0.0).to_f.round(2)
            service_set_count[service_set_id] += (tarif_result['call_id_count'] || 0).to_i
          end
        end if service_sets_result
      end if tarif_results
    end
    
    result = []
    service_set_price.each do |service_set_id, service_sets_result|
#      next if fobidden[service_set_id]
      result << {'short_set_id' => service_set_id.split('_').uniq.join('_'), 'service_sets_id' => service_set_id,  
        'service_set_price' => service_sets_result, 'service_set_count' => service_set_count[service_set_id], 
        'identical_services' => identical_services[service_set_id],
        #'tarif_sets_by_part' => (tarif_sets_by_part[service_set_id] || []).sort_by{|t| t[0]},
        'stat_results' => stat_results[service_set_id]#, 'fobidden' => fobidden[service_set_id], 
#        'fobidden_services' => (fobidden_services[service_set_id] || []).sort_by{|f| f[0]} 
        } 
    end
    result.sort_by!{|item| item['service_set_price']}
    result

=begin
    result_1 = []
    max_count_per_tarif = use_price_comparison_in_current_tarif_set_calculation ? max_tarif_set_count_per_tarif : 100000000
    count_per_tarif = {}
    current_tarif_set_count = 0
    result.each do |item|
      service_set_id = item['service_sets_id']
      if tarifs[service_set_id]
        count_per_tarif[tarifs[service_set_id]] ||= 0
        count_per_tarif[tarifs[service_set_id]] += 1
        next if count_per_tarif[tarifs[service_set_id]] > max_count_per_tarif
        result_1 << item
        current_tarif_set_count += 1
        break if current_tarif_set_count == max_count_per_tarif * tarif_count
      end
    end
    result_1
=end    
  end

  def tarif_results_array(service_set_id)
    result = []
    case service_set_based_on_tarif_sets_or_tarif_results
    when 'final_tarif_sets'
      tarif_result_to_use = updated_tarif_results ? updated_tarif_results : tarif_results
      final_tarif_sets[service_set_id]['tarif_sets_by_part'].each do |tarif_set_by_part|
        part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
        tarif_results_for_service_set_and_part = tarif_result_to_use[tarif_set_by_part_id][part] if tarif_result_to_use and tarif_result_to_use[tarif_set_by_part_id]

        tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part|

        stat_results = {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|            
          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              stat_results[stat_key] ||= []
              stat_results[stat_key] += price_value_detail['all_stat'][stat_key].round(2)
            else
              stat_results[stat_key] ||= 0
              stat_results[stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']
        end
        
        result << {
#            'part' => part,
          'tarif_class_id' => "#{part}_#{service_set_id}__#{tarif_id_from_tarif_results}",
          'tarif_set_by_part_id' => tarif_set_by_part_id, 
          'tarif_class_id_0' => tarif_id_from_tarif_results,
          'price_value' => (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f,
          'call_id_count' => tarif_result_for_service_set_and_part['call_id_count'],
          'stat_results' => stat_results,
#            'tarif_results_keys' => tarif_result_to_use[tarif_set_by_part_id][part].keys,
#            'final_tarif_sets' => tarif_result_to_use[tarif_set_by_part_id][part][tarif_id_from_tarif_results]['price_values'],
#            'tarif_id_from_tarif_results' => tarif_result_for_service_set_and_part['price_values'],
#            'tarif_results_for_service_set_and_part' => (tarif_results_for_service_set_and_part['203'] ? tarif_results_for_service_set_and_part['203'].keys : nil) #final_tarif_sets[service_set_id]['tarif_sets_by_part'][service_set_id].map{|s| s if s[0] == "own-country-rouming/calls"},
          }
        end if tarif_results_for_service_set_and_part
      end if final_tarif_sets and final_tarif_sets[service_set_id] and final_tarif_sets[service_set_id]['tarif_sets_by_part']
    when 'cons_tarif_results'
      cons_tarif_results_by_parts[service_set_id].each do |part, tarif_result_by_part|
        result << {
#            'part' => part,
          'tarif_class_id' => "#{part}__#{tarif_result_by_part['tarif_class_id']}",
          'tarif_class_id_0' => tarif_result_by_part['tarif_class_id'],
          'price_value' => (tarif_result_by_part['price_value'] || 0.0).to_f,
          'call_id_count' => tarif_result_by_part['call_id_count'],
        }
      end if cons_tarif_results_by_parts and cons_tarif_results_by_parts[service_set_id]
    when 'source_to_calculate_final_tarif_sets'
      tarif_sets_to_calculate_from_final_tarif_sets.each do |tarif_id, service_sets_result|
        service_sets_result.each do |part, part_result|
          part_result.each do |service_set_id_1, services |
            result << {'service_set_id' => service_set_id_1, 'part' => part} if service_set_id_1 == service_set_id
          end
        end if service_sets_result
      end if tarif_sets_to_calculate_from_final_tarif_sets
    when 'updated_tarif_results'
      updated_tarif_results[service_set_id].each do |part, tarif_results_by_part|
        tarif_results_by_part.each do |service_id, tarif_result_by_part|
          result << {
#            'part' => part,
            'tarif_class_id' => "#{part}__#{tarif_result_by_part['tarif_class_id']}",
            'tarif_class_id_0' => tarif_result_by_part['tarif_class_id'],
            'price_value' => (tarif_result_by_part['price_value'] || 0.0).to_f,
            'call_id_count' => tarif_result_by_part['call_id_count'],
          }
        end          
      end if updated_tarif_results and updated_tarif_results[service_set_id]
    else
      tarif_results[service_set_id].each do |part, tarif_results_by_part|
        tarif_results_by_part.each do |service_id, tarif_result_by_part|
          result << {
#            'part' => part,
            'tarif_class_id' => "#{part}__#{tarif_result_by_part['tarif_class_id']}",
            'tarif_class_id_0' => tarif_result_by_part['tarif_class_id'],
            'price_value' => (tarif_result_by_part['price_value'] || 0.0).to_f,
            'call_id_count' => tarif_result_by_part['call_id_count'],
          }
        end          
      end if tarif_results and tarif_results[service_set_id]
    end
    result.collect{|r| r if 
      r['call_id_count'].to_i > level_to_show_tarif_result_by_parts or 
      r['price_value'].to_f > level_to_show_tarif_result_by_parts}.compact.sort_by!{|r| r['tarif_class_id']}
  end

  def tarif_results_details_array(service_set_id, tarif_class_id_1)
    details = []
    if @service_set_based_on_tarif_sets_or_tarif_results == 'final_tarif_sets'
      final_tarif_sets[service_set_id]['tarif_sets_by_part'].each do |tarif_set_by_part|
        part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
        tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]
        tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part |
          tarif_results_for_service_set_and_part[tarif_id_from_tarif_results]['price_values'].each do |price_value_detail|
            tarif_class_id_1_eqv = "#{part}_#{service_set_id}__#{tarif_id_from_tarif_results}"

            if tarif_class_id_1 == tarif_class_id_1_eqv

              stat_results = {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
               
              (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|  
                if price_value_detail['all_stat'][stat_key].is_a?(Array)
                  stat_results[stat_key] ||= []
                  stat_results[stat_key] += price_value_detail['all_stat'][stat_key].round(2)
                else
                  stat_results[stat_key] ||= 0
                  stat_results[stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
                end
              end if price_value_detail['all_stat']

#              details << price_value_detail
#=begin
              details << {
                'tarif_class_id_0' => price_value_detail['tarif_class_id'].to_s,
                'service_category_name' => price_value_detail['service_category_name'],
                'service_category_tarif_class_id' => price_value_detail['service_category_tarif_class_id'],
                'service_category_group_id' => price_value_detail['service_category_group_id'],
                'month' => price_value_detail['month'],
                'call_id_count' => price_value_detail['call_id_count'],
                'price_value' => (price_value_detail['price_value'] || 0.0).to_f,
                'stat_results' => stat_results,
                }
#=end
            end
          end
        end if tarif_results_for_service_set_and_part
      end if final_tarif_sets and final_tarif_sets[service_set_id] and final_tarif_sets[service_set_id]['tarif_sets_by_part']
    else
#        raise(StandardError, [tarif_class_id_1, tarif_results_ord])
      if tarif_class_id_1
        tarif_results_details_by_month(service_set_id, tarif_class_id_1).each {|key, detail_group_by_month| details << detail_group_by_month}
      else
        [{}]
      end
      
    end
    details.collect{|r| r if 
      r['call_id_count'].to_i > level_to_show_tarif_result_by_parts or 
      r['price_value'].to_f > level_to_show_tarif_result_by_parts}.compact
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
  
  def final_tarif_sets
    return @final_tarif_sets if @final_tarif_sets
    @final_tarif_sets = get_optimization_results('final_tarif_sets', 'final_tarif_sets')
  end

  def tarif_sets_to_calculate_from_final_tarif_sets
    return @tarif_sets_to_calculate_from_final_tarif_sets if @tarif_sets_to_calculate_from_final_tarif_sets
    @tarif_sets_to_calculate_from_final_tarif_sets = get_optimization_results('final_tarif_sets', 'tarif_sets_to_calculate_from_final_tarif_sets')
  end
  
  def updated_tarif_results
    return @updated_tarif_results if @updated_tarif_results
    @updated_tarif_results = get_optimization_results('final_tarif_sets', 'updated_tarif_results')
  end

  def groupped_identical_services
    return @groupped_identical_services if @groupped_identical_services
    @groupped_identical_services = get_optimization_results('final_tarif_sets', 'groupped_identical_services')
  end

  def current_tarif_set_calculation_history
    return @current_tarif_set_calculation_history if @current_tarif_set_calculation_history
    @current_tarif_set_calculation_history = get_optimization_results('final_tarif_sets', 'current_tarif_set_calculation_history')
#    raise(StandardError)
  end

  def tarif_sets
    results['tarif_sets'] if results
  end
  
  def tarif_results
    results['tarif_results'] if results    
  end
  
  def cons_tarif_results
    results['cons_tarif_results'] if results
  end

  def cons_tarif_results_by_parts
    results['cons_tarif_results_by_parts'] if results
  end
  
  def tarif_results_ord
    results['tarif_results_ord'] if results
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
  
  def max_tarifs_slice
    stat = results[operator.to_s] if results
    stat['max_tarifs_slice'][operator.to_s] if stat and stat['max_tarifs_slice']
  end

  def tarif_results_details(service_set_id, part, tarif_class_id)
    details = []
    part_result = tarif_results_ord[service_set_id][part] if tarif_results_ord and tarif_results_ord[service_set_id]
    part_result[tarif_class_id.to_s].each do |key, details_by_order|
      details += details_by_order['price_values']
    end if tarif_class_id and part_result and part_result[tarif_class_id]
    details
  end

  def tarif_results_details_by_month(service_set_id, tarif_class_id_1)
    part = tarif_class_id_1.split('__')[0]
    tarif_class_id = tarif_class_id_1.split('__')[1]
    details_group_by_month = {}
    tarif_results_details(service_set_id, part, tarif_class_id).each do |detail|
      if detail['service_category_name']
        details_group_by_month[detail['service_category_name']] ||= detail.merge('period count price' => [], 'call_id_count' => 0, 'price_value' => 0).keep_if{|k, v| !(k == 'month' )}
        details_group_by_month[detail['service_category_name']]['period count price'] << [detail['month'], detail['call_id_count'],  detail['price_value'] ]
        details_group_by_month[detail['service_category_name']]['call_id_count'] += detail['call_id_count']
        details_group_by_month[detail['service_category_name']]['price_value'] += (detail['price_value'] || 0.0).to_f
      end
    end  
    details_group_by_month
  end
  
end
