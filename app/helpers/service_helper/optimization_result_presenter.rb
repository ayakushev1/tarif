class ServiceHelper::OptimizationResultPresenter
  attr_reader :user_id
  attr_reader :service_set_based_on_tarif_sets_or_tarif_results, :level_to_show_tarif_result_by_parts, :use_price_comparison_in_current_tarif_set_calculation,
              :max_tarif_set_count_per_tarif
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    init_output_choices(options)
  end
  
  def results
    Customer::Stat.get_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    })
  end
  
  def init_output_choices(options = {})
#    @tarif_count = options[:tarif_count].to_i
    @service_set_based_on_tarif_sets_or_tarif_results = options[:service_set_based_on_tarif_sets_or_tarif_results]
    @level_to_show_tarif_result_by_parts = options[:show_zero_tarif_result_by_parts] == 'true' ? -1.0 : 0.0
    @use_price_comparison_in_current_tarif_set_calculation = options[:use_price_comparison_in_current_tarif_set_calculation] == 'true' ? true : false
    @max_tarif_set_count_per_tarif = options[:max_tarif_set_count_per_tarif].to_i
  end
  
  def service_sets_array
    service_set_price = {}; service_set_count = {}; stat_results = {}; identical_services = {}; tarifs = {} 
    case service_set_based_on_tarif_sets_or_tarif_results
    when 'final_tarif_sets_by_parts'
      prepared_service_sets.each do |service_set_id, prepared_final_tarif_set|
        service_set_price[service_set_id] = prepared_final_tarif_set['service_set_price']
        service_set_count[service_set_id] = prepared_final_tarif_set['service_set_count']
        stat_results[service_set_id] = prepared_final_tarif_set['stat_results']
        identical_services[service_set_id] = prepared_final_tarif_set['identical_services']
      end if prepared_service_sets
    when 'cons_tarif_results'
#      raise(StandardError, cons_tarif_results_by_parts)
      cons_tarif_results_by_parts.each do |service_set_id, service_sets_result|
        service_set_price[service_set_id] ||= 0.0
#        service_set_count[service_set_id] ||= 0
#        service_sets_result.each do |part, part_result|
#          service_set_price[service_set_id] += (part_result['price_value'] || 0.0).to_f.round(2)
#          service_set_count[service_set_id] += (part_result['call_id_count'] || 0).to_i
#        end if service_sets_result
      end if cons_tarif_results_by_parts
    else
      tarif_results.each do |service_set_id, service_sets_result|
        service_set_price[service_set_id] ||= 0.0
#        service_set_count[service_set_id] ||= 0
#        service_sets_result.each do |part, part_result|
#          part_result.each do |tarif_id, tarif_result |
#            service_set_price[service_set_id] += (tarif_result['price_value'] || 0.0).to_f.round(2)
#            service_set_count[service_set_id] += (tarif_result['call_id_count'] || 0).to_i
#          end
#        end if service_sets_result
      end if tarif_results
    end
    
    result = []
    service_set_price.each do |service_set_id, service_sets_result|
      result << {
        'short_set_id' => service_set_id.split('_').uniq.join('_'), 
        'service_sets_id' => service_set_id,  
        'service_set_price' => service_sets_result, 
        'service_set_count' => service_set_count[service_set_id], 
        'identical_services' => identical_services[service_set_id],
        'stat_results' => stat_results[service_set_id], 
        } 
    end
    false ? result.sort_by!{|item| item['service_set_price']} : result
  end

  def tarif_results_array(service_set_id)
    result = []
    case service_set_based_on_tarif_sets_or_tarif_results
    when 'final_tarif_sets_by_parts'
      prepared_tarif_results_by_part_1 = prepared_tarif_results_by_part
      prepared_tarif_results_by_part_1[service_set_id].each do |service_id, prepared_tarif_result|       
        if prepared_tarif_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_result['price_value'].to_f > level_to_show_tarif_result_by_parts
          result << {'service_id' => service_id}.merge(prepared_tarif_result)
        end
      end if prepared_tarif_results_by_part_1 and prepared_tarif_results_by_part_1[service_set_id]
      result = result.compact
  #    result.sort_by!{|item| item['service_set_price']}    
    when 'cons_tarif_results'
      cons_tarif_results_by_parts[service_set_id].each do |part, tarif_result_by_part|
        temp_result = {
          'tarif_class_id' => "#{part}__#{tarif_result_by_part['tarif_class_id']}",
          'tarif_class_id_0' => tarif_result_by_part['tarif_class_id'],
          'price_value' => (tarif_result_by_part['price_value'] || 0.0).to_f,
          'call_id_count' => tarif_result_by_part['call_id_count'],
        } 
        result << temp_result if 
          tarif_result_by_part['call_id_count'].to_i > level_to_show_tarif_result_by_parts or 
          (tarif_result_by_part['price_value'] || 0.0).to_f > level_to_show_tarif_result_by_parts
        
      end if cons_tarif_results_by_parts and cons_tarif_results_by_parts[service_set_id]
      result = result.compact
    else
      tarif_results[service_set_id].each do |part, tarif_results_by_part|
        tarif_results_by_part.each do |service_id, tarif_result_by_part|
          temp_result = {
            'tarif_class_id' => "#{part}__#{tarif_result_by_part['tarif_class_id']}",
            'tarif_class_id_0' => tarif_result_by_part['tarif_class_id'],
            'price_value' => (tarif_result_by_part['price_value'] || 0.0).to_f,
            'call_id_count' => tarif_result_by_part['call_id_count'],
          } 
          result << temp_result if 
            tarif_result_by_part['call_id_count'].to_i > level_to_show_tarif_result_by_parts or 
            (tarif_result_by_part['price_value'] || 0.0).to_f > level_to_show_tarif_result_by_parts
        end          
      end if tarif_results and tarif_results[service_set_id]
      result = result.compact
    end
      false ? result.sort_by!{|r| r['tarif_class_id']} : result
  end

  def tarif_results_details_array(service_set_id, tarif_class_id_1)
    result = []
    if @service_set_based_on_tarif_sets_or_tarif_results == 'final_tarif_sets_by_parts'
      prepared_tarif_detail_results_by_part_1 = prepared_tarif_detail_results_by_part
      prepared_tarif_detail_results_by_part_1[service_set_id][tarif_class_id_1].each do |service_category_name, prepared_tarif_detail_result|       
        if prepared_tarif_detail_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_detail_result['price_value'].to_f > level_to_show_tarif_result_by_parts
          result << {'service_category_name' => service_category_name}.merge(prepared_tarif_detail_result)
        end
      end if prepared_tarif_detail_results_by_part_1 and prepared_tarif_detail_results_by_part_1[service_set_id] and 
        prepared_tarif_detail_results_by_part_1[service_set_id][tarif_class_id_1]
      result = result.compact
  #    result.sort_by!{|item| item['service_set_price']}    
    else
      if tarif_class_id_1
        tarif_results_details_by_month(service_set_id, tarif_class_id_1).each do |key, detail_group_by_month| 
          temp_result = detail_group_by_month
          result << temp_result if 
            detail_group_by_month['call_id_count'].to_i > level_to_show_tarif_result_by_parts or 
            (detail_group_by_month['price_value'] || 0.0).to_f > level_to_show_tarif_result_by_parts
        end
        result = result.compact
      else
        result = [{}]
      end
      
    end
  end
  
  def prepared_service_sets
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'service_set')
  end
  
  def prepared_tarif_results_by_part
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'tarif_results_by_part')
  end
  
  def prepared_tarif_detail_results_by_part
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'tarif_detail_results_by_part')
  end
  

  def final_tarif_sets
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'final_tarif_sets',
      :user_id => user_id,
    }, 'final_tarif_sets')
  end

  def groupped_identical_services
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'final_tarif_sets',
      :user_id => user_id,
    }, 'groupped_identical_services')
  end

  def tarif_sets
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    }, 'tarif_sets')
  end
  
  def tarif_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    }, 'tarif_results')
  end
  
  def cons_tarif_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    }, 'cons_tarif_results')
  end

  def cons_tarif_results_by_parts
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    }, 'cons_tarif_results_by_parts')
  end
  
  def tarif_results_ord
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    }, 'tarif_results_ord')
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
