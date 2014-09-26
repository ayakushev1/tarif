class ServiceHelper::FinalTarifResultsPresenter
  attr_reader :user_id, :level_to_show_tarif_result_by_parts
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    @level_to_show_tarif_result_by_parts = options[:show_zero_tarif_result_by_parts] == 'true' ? -1.0 : 0.0
  end
  
  def results
    Customer::Stat.get_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    })
  end
  
  def customer_service_sets_array
    result = []
    prepared_service_sets.each do |service_set_id, prepared_service_set|
      result << {'service_sets_id' => service_set_id}.merge(prepared_service_set)
    end if prepared_service_sets
    result = result.compact
    new_result = []
    result.each do |f|
      additions = {}
      
      tarif_id = f['tarif'].to_s if f['tarif']
      
      additions['operator_name'] = (f['operator_description']['name'] if f and f['operator_description'])
      additions['tarif_name'] = (f['service_description'][tarif_id]['name'] if f and tarif_id and f['service_description'] and f['service_description'][tarif_id])
      additions['tarif_http'] = (f['service_description'][tarif_id]['http'] if f and tarif_id and f['service_description'] and f['service_description'][tarif_id])
      additions['tarif_cost'] = (f['service_set_price'].to_f.round(0) if f and f['service_set_price'])
      additions['service_set_count'] = (f['service_set_count'].to_i if f and f['service_set_count'])
        
      additions['services'] = (f['service_sets_id'].split('_') - [tarif_id]).map do |service_id|
        if f and f['service_description'] and f['service_description'][service_id]
          {
            'service_name' => f['service_description'][service_id]['name'], 
            'service_http' => f['service_description'][service_id]['http'],
            'service_type' => f['service_description'][service_id]['standard_service_id']
            }
        end        
      end.compact if f['service_sets_id']
      
      additions['common_services'] = additions['services'].map do |service|
        service if service['service_type'] == 41 #common_service
      end.compact
  
      additions['tarif_options'] = additions['services'].map do |service|
        service if service['service_type'] != 41 # common_service
      end.compact
  
      additions['identical_services'] = f['identical_services'].map do |identical_service_group|
        identical_services_for_one_group = identical_service_group.map do |service_ids|
          identical_services_for_one_tarif_set = service_ids.split('_').map do |service_id|
            if f and f['service_description'] and f['service_description'][service_id] 
              {'service_name' => f['service_description'][service_id]['name'],  'service_http' => f['service_description'][service_id]['http']}
            end
          end.compact if service_ids
          identical_services_for_one_tarif_set
        end.compact if identical_service_group
        identical_services_for_one_group
      end.compact if f['identical_services']
      
      if f and f['stat_results']
        additions['calls_volume'] = f['stat_results']['sum_duration_minute'].round(0) if f['stat_results']['sum_duration_minute']
        additions['sms_volume'] = f['stat_results']['count_volume'].round(0) if f['stat_results']['count_volume']
        additions['internet_volume'] = f['stat_results']['sum_volume'].round(0) if f['stat_results']['sum_volume']
      end

      new_result << f.merge(additions)
    end
    new_result.sort_by!{|item| item['service_set_price']}    
  end
  
  def customer_tarif_results_array(service_set_id)
    result = []
    prepared_tarif_results_1 = prepared_tarif_results
    prepared_tarif_results_1[service_set_id].each do |service_id, prepared_tarif_result|       
      if prepared_tarif_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_result['price_value'].to_f > level_to_show_tarif_result_by_parts
        result << {'service_id' => service_id}.merge(prepared_tarif_result)
      end
    end if prepared_tarif_results_1 and prepared_tarif_results_1[service_set_id]
    result = result.compact
    new_result = []
    result.each do |f|
      additions = {}
      
      service_id = f['service_id'].to_s if f['service_id']  
      additions['service_name'] = (f['service_description'][service_id]['name'] if f and service_id and f['service_description'] and f['service_description'][service_id])
      additions['service_http'] = (f['service_description'][service_id]['http'] if f and service_id and f['service_description'] and f['service_description'][service_id])
      additions['service_cost'] = (f['price_value'].to_f.round(0) if f and f['price_value'])
      additions['service_count'] = (f['call_id_count'].to_i if f and f['call_id_count'])
  
      if f and f['stat_results']
        additions['calls_volume'] = f['stat_results']['sum_duration_minute'].round(0) if f['stat_results']['sum_duration_minute']
        additions['sms_volume'] = f['stat_results']['count_volume'].round(0) if f['stat_results']['count_volume']
        additions['internet_volume'] = f['stat_results']['sum_volume'].round(0) if f['stat_results']['sum_volume']
      end
      new_result << f.merge(additions)
    end
    new_result
#    new_result.sort_by!{|item| (item['rouming'] || "") + (item['calls'] || "")}    
  end
    
  def customer_tarif_detail_results_array(service_set_id, service_id)
    result = []
    prepared_tarif_detail_results_1 = prepared_tarif_detail_results
    prepared_tarif_detail_results_1[service_set_id][service_id].each do |service_category_name, prepared_tarif_detail_result|       
      if prepared_tarif_detail_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_detail_result['price_value'].to_f > level_to_show_tarif_result_by_parts
        result << {'service_category_name' => service_category_name}.merge(prepared_tarif_detail_result)
      end
    end if prepared_tarif_detail_results_1 and prepared_tarif_detail_results_1[service_set_id] and prepared_tarif_detail_results_1[service_set_id][service_id]
    result = result.compact
    new_result = []
    result.each do |f|
      additions = {}
      if f and f['stat_results']        
        additions['calls_volume'] = f['stat_results']['sum_duration_minute'].round(0) if f['stat_results']['sum_duration_minute']
        additions['sms_volume'] = f['stat_results']['count_volume'].round(0) if f['stat_results']['count_volume']
        additions['internet_volume'] = f['stat_results']['sum_volume'].round(0) if f['stat_results']['sum_volume']
      end
      
      if f and f['service_category_description']
        additions['rouming'] = f['service_category_description']['service_category_rouming_id'].uniq.join(', ')    
        additions['geo'] = f['service_category_description']['service_category_geo_id'].uniq.join(', ')    
        additions['geo_details'] = f['service_category_description']['service_category_geo_id_details'].uniq.join(', ')    
        additions['partner'] = f['service_category_description']['service_category_partner_type_id'].uniq.join(', ')    
        additions['calls'] = f['service_category_description']['service_category_calls_id'].uniq.join(', ')    
        additions['fix'] = (f['service_category_description']['service_category_one_time_id'] + f['service_category_description']['service_category_periodic_id']).uniq.join(', ')    
      end
      new_result << f.merge(additions)
    end
    new_result.sort_by!{|item| (item['rouming'] || "") + (item['calls'] || "")}    
  end
      
  def prepared_service_sets
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'service_set')
  end
  
  def prepared_tarif_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'tarif_results')
  end
  
  def prepared_tarif_detail_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_results',
      :user_id => user_id,
    }, 'tarif_detail_results')
  end
  
end
