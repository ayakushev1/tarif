class TarifOptimization::FinalTarifResultPreparator2
  
  def self.prepare_service_sets(input_data)
    final_tarif_sets = input_data[:final_tarif_sets]
    tarif_results = input_data[:tarif_results]
    groupped_identical_services = input_data[:groupped_identical_services] 
    tarif_id = input_data[:tarif_id]
    
    service_sets_array = []; services_array = []; agregates_array = []; categories_array = [];
    service_set_result = {};    

    final_tarif_sets.each do |service_set_id, final_tarif_set|    
      final_tarif_set.stringify_keys!

      service_result = {}; agregate_result = {};  category_result = {};
      service_set_name = final_tarif_set['service_ids'].join('_')
      service_ids = final_tarif_set['service_ids'].uniq
      common_services = final_tarif_set['common_services'][input_data[:operator].to_s] & service_ids
      tarif_options = service_ids - common_services - [tarif_id]
      
      service_set_result[service_set_id] ||= {
        'run_id' => input_data[:run_id], 'operator_id' => input_data[:operator], 'tarif_id' => tarif_id, 'service_set_id' => service_set_id,
        'service_ids' => service_ids, 'identical_services' => [], 'common_services' => common_services, 'tarif_options' => tarif_options,
        'price' => 0.0, 'call_id_count' => 0, 'stat_results' => {}}

      process_final_tarif_set_tarif_sets_by_part(service_set_result, service_result, agregate_result, category_result, service_set_id, input_data)
         
      service_set_result[service_set_id].merge!({
        "call_id_count" => service_set_result[service_set_id]['stat_results']["call_id_count"],
        "count_volume" => service_set_result[service_set_id]['stat_results']["count_volume"],
        "sum_volume" => service_set_result[service_set_id]['stat_results']["sum_volume"],
        "sum_duration_minute" => service_set_result[service_set_id]['stat_results']["sum_duration_minute"],})
      service_set_result[service_set_id].extract!('stat_results')
      service_sets_array << service_set_result[service_set_id]
      
      service_result.each do |service_id, result|
        service_result[service_id].merge!({
          "call_id_count" => service_result[service_id]['stat_results']["call_id_count"],
          "count_volume" => service_result[service_id]['stat_results']["count_volume"],
          "sum_volume" => service_result[service_id]['stat_results']["sum_volume"],
          "sum_duration_minute" => service_result[service_id]['stat_results']["sum_duration_minute"],})
        service_result[service_id].extract!('stat_results')
        services_array << service_result[service_id]
        
        category_result[service_id].each do |sc_name, sc_resutl|
          category_result[service_id][sc_name].merge!({
            "call_id_count" => category_result[service_id][sc_name]['stat_results']["call_id_count"],
            "count_volume" => category_result[service_id][sc_name]['stat_results']["count_volume"],
            "sum_volume" => category_result[service_id][sc_name]['stat_results']["sum_volume"],
            "sum_duration_minute" => category_result[service_id][sc_name]['stat_results']["sum_duration_minute"],})
          category_result[service_id][sc_name].extract!('stat_results')
          categories_array << category_result[service_id][sc_name]
        end
      end      

      agregate_result.each do |sc_name, result|
        agregate_result[sc_name].merge!({
          "call_id_count" => agregate_result[sc_name]['stat_results']["call_id_count"],
          "count_volume" => agregate_result[sc_name]['stat_results']["count_volume"],
          "sum_volume" => agregate_result[sc_name]['stat_results']["sum_volume"],
          "sum_duration_minute" => agregate_result[sc_name]['stat_results']["sum_duration_minute"],})
        agregate_result[sc_name].extract!('stat_results')
        agregates_array << agregate_result[sc_name]
      end      
    end      
#    raise(StandardError, service_sets_array)
    [service_sets_array, services_array, categories_array, agregates_array]
  end
  
  def self.process_final_tarif_set_tarif_sets_by_part(service_set_result, service_result, agregate_result, category_result, service_set_id, input_data)
    input_data[:final_tarif_sets][service_set_id]['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results = input_data[:tarif_results]
      tarif_results_for_service_set_and_part =tarif_results [tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]
      
      tarif_results_for_service_set_and_part.each do |service_id, tarif_result_for_service_set_and_part |
        stat_detail_keys_to_exclude = ['month', 'call_ids']
        
        process_service_set_result(service_set_result, service_set_id, tarif_set_by_part_id,
          tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

        process_service_result(service_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

        process_category_result(agregate_result, category_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

      end if tarif_results_for_service_set_and_part
#        raise(StandardError, service_set_result['stat_results'].keys)
      
    end #if final_tarif_set['tarif_sets_by_part']      
  end
  
  def self.process_service_set_result(service_set_result, service_set_id, tarif_set_by_part_id,
      tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

    tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
#            raise(StandardError, [tarif_result_for_service_set_and_part['price_values']])  
      (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'][stat_key].is_a?(Array)
          service_set_result[service_set_id]['stat_results'][stat_key] ||= []
          service_set_result[service_set_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
        else
          service_set_result[service_set_id]['stat_results'][stat_key] ||= 0
          service_set_result[service_set_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat']
    end
    
    groupped_identical_services = input_data[:groupped_identical_services].dup
    
    service_set_result[service_set_id]['identical_services'] << 
      groupped_identical_services[tarif_set_by_part_id].stringify_keys['identical_services'] if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
    service_set_result[service_set_id]['identical_services'].uniq!

    service_set_result[service_set_id]['price'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
    service_set_result[service_set_id]['call_id_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
    
#    raise(StandardError, service_set_result[service_set_id]['identical_services']) if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
#    identical_service_ids = service_set_result[service_set_id]['identical_services'].flatten.map do |identical_service_name|
#      identical_service_name.split('_')
#    end.flatten.uniq

  end
  
  def self.process_service_result(service_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

    service_result[service_id] ||= {
      'run_id' => input_data[:run_id], 'tarif_id' =>  input_data[:tarif_id], 'service_set_id' => service_set_id, 'service_id' => service_id,
      'price' => 0.0, 'call_id_count' => 0, 'stat_results' => {}}
    
    stat_detail_keys_to_exclude = ['month', 'call_ids']
    
    tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|            
      (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'][stat_key].is_a?(Array)
          service_result[service_id]['stat_results'][stat_key] ||= []
          service_result[service_id]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
        else
          service_result[service_id]['stat_results'][stat_key] ||= 0
          service_result[service_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat']
    end if tarif_result_for_service_set_and_part['price_values']
    
    service_result[service_id]['price'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
    service_result[service_id]['call_id_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
  end

  def self.process_category_result(agregate_result, category_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

    category_result[service_id] ||= {}
    
    stat_detail_keys_to_exclude = ['month', 'call_ids']
    
    tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
      category_details = tarif_detail_results_description(price_value_detail, input_data)
      all_categories = []
      ['service_category_rouming_id', 'service_category_geo_id', 'service_category_partner_type_id',
        'service_category_calls_id', 'service_category_one_time_id', 'service_category_periodic_id', ].collect do |category|
          all_categories += category_details[category].map(&:to_s)
       end         
      sc_name = all_categories.join('_')

      category_result[service_id][sc_name] ||= {
        'run_id' => input_data[:run_id], 'tarif_id' =>  input_data[:tarif_id], 'service_set_id' => service_set_id, 'service_id' => service_id,
        'price' => 0.0, 'call_id_count' => 0, 'stat_results' => {}}

      agregate_result[sc_name] ||= {
        'run_id' => input_data[:run_id], 'tarif_id' =>  input_data[:tarif_id], 'service_set_id' => service_set_id,
        'price' => 0.0, 'call_id_count' => 0, 'stat_results' => {}}

      (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'][stat_key].is_a?(Array)
          category_result[service_id][sc_name]['stat_results'][stat_key] ||= []
          category_result[service_id][sc_name]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)

          agregate_result[sc_name]['stat_results'][stat_key] ||= []
          agregate_result[sc_name]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
        else
          category_result[service_id][sc_name]['stat_results'][stat_key] ||= 0
          category_result[service_id][sc_name]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)

          agregate_result[sc_name]['stat_results'][stat_key] ||= 0
          agregate_result[sc_name]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat']
    
      category_result[service_id][sc_name]['price'] += (price_value_detail['price_value'] || 0.0).to_f
      category_result[service_id][sc_name]['call_id_count'] += (price_value_detail['call_id_count'] || 0).to_i
      
#      category_result[service_id][sc_name]['call_ids'] = price_value_detail['call_ids']
      category_result[service_id][sc_name]['service_category_name'] = sc_name
      category_result[service_id][sc_name]['rouming_ids'] = category_details['service_category_rouming_id']
      category_result[service_id][sc_name]['geo_ids'] = category_details['service_category_geo_id']
      category_result[service_id][sc_name]['partner_ids'] = category_details['service_category_partner_type_id']
      category_result[service_id][sc_name]['calls_ids'] = category_details['service_category_calls_id']
      category_result[service_id][sc_name]['one_time_ids'] = category_details['service_category_one_time_id']
      category_result[service_id][sc_name]['periodic_ids'] = category_details['service_category_periodic_id']
      category_result[service_id][sc_name]['fix_ids'] = category_details['service_category_one_time_id'] + category_details['service_category_periodic_id']

      category_result[service_id][sc_name]['rouming_names'] = category_details['service_category_rouming_name']
      category_result[service_id][sc_name]['geo_names'] = category_details['service_category_geo_name']
      category_result[service_id][sc_name]['partner_names'] = category_details['service_category_partner_type_name']
      category_result[service_id][sc_name]['calls_names'] = category_details['service_category_calls_name']
      category_result[service_id][sc_name]['one_time_names'] = category_details['service_category_one_time_name']
      category_result[service_id][sc_name]['periodic_names'] = category_details['service_category_periodic_name']
      category_result[service_id][sc_name]['fix_names'] = category_details['service_category_one_time_name'] + category_details['service_category_periodic_name']

      category_result[service_id][sc_name]['rouming_details'] = category_details['service_category_rouming_id_details']
      category_result[service_id][sc_name]['geo_details'] = category_details['service_category_geo_id_details']
      category_result[service_id][sc_name]['partner_details'] = []


      agregate_result[sc_name]['price'] += (price_value_detail['price_value'] || 0.0).to_f
      agregate_result[sc_name]['call_id_count'] += (price_value_detail['call_id_count'] || 0).to_i
      
#      agregate_result[sc_name]['call_ids'] = price_value_detail['call_ids']
      agregate_result[sc_name]['service_category_name'] = sc_name
      agregate_result[sc_name]['rouming_ids'] = category_details['service_category_rouming_id']
      agregate_result[sc_name]['geo_ids'] = category_details['service_category_geo_id']
      agregate_result[sc_name]['partner_ids'] = category_details['service_category_partner_type_id']
      agregate_result[sc_name]['calls_ids'] = category_details['service_category_calls_id']
      agregate_result[sc_name]['one_time_ids'] = category_details['service_category_one_time_id']
      agregate_result[sc_name]['periodic_ids'] = category_details['service_category_periodic_id']
      agregate_result[sc_name]['fix_ids'] = category_details['service_category_one_time_id'] + category_details['service_category_periodic_id']

      agregate_result[sc_name]['rouming_names'] = category_details['service_category_rouming_name']
      agregate_result[sc_name]['geo_names'] = category_details['service_category_geo_name']
      agregate_result[sc_name]['partner_names'] = category_details['service_category_partner_type_name']
      agregate_result[sc_name]['calls_names'] = category_details['service_category_calls_name']
      agregate_result[sc_name]['one_time_names'] = category_details['service_category_one_time_name']
      agregate_result[sc_name]['periodic_names'] = category_details['service_category_periodic_name']
      agregate_result[sc_name]['fix_names'] = category_details['service_category_one_time_name'] + category_details['service_category_periodic_name']

      agregate_result[sc_name]['rouming_details'] = category_details['service_category_rouming_id_details']
      agregate_result[sc_name]['geo_details'] = category_details['service_category_geo_id_details']
      agregate_result[sc_name]['partner_details'] = []

    end 

  end

  
  def self.tarif_detail_results_description(price_value_detail, input_data)
    categories = input_data[:categories]
    tarif_categories = input_data[:tarif_categories]
    tarif_category_groups = input_data[:tarif_category_groups]
    tarif_class_categories_by_category_group = input_data[:tarif_class_categories_by_category_group]
    service_category_tarif_class_id = price_value_detail['service_category_tarif_class_id']
    service_category_group_id = price_value_detail['service_category_group_id']

    service_category_description = { 
      'service_category_rouming_id' => [], 'service_category_rouming_name' => [], 'service_category_rouming_id_details' => [],
      'service_category_geo_id' => [], 'service_category_geo_name' => [], 'service_category_geo_id_details' => [],      
      'service_category_partner_type_id' => [], 'service_category_partner_type_name' => [],'service_category_partner_type_id_details' => [],
      'service_category_calls_id' => [], 'service_category_calls_name' => [], 
      'service_category_one_time_id' => [], 'service_category_one_time_name' => [], 
      'service_category_periodic_id' => [], 'service_category_periodic_name' => [],
      }
       
    return service_category_description if !service_category_group_id
    
    tarif_categories_to_go = (service_category_group_id < 0) ? 
      [service_category_tarif_class_id.to_s] : tarif_class_categories_by_category_group[service_category_group_id.to_s].map(&:to_s)

    tarif_categories_to_go.each do |tcsc_id|
      tarif_category = tarif_categories[tcsc_id]#.attributes

#      raise(StandardError, [tarif_category['service_category_rouming_id'] , categories])     

      if tarif_category['service_category_rouming_id'] and categories[tarif_category['service_category_rouming_id'].to_s]
        rouming_name = categories[tarif_category['service_category_rouming_id'].to_s]['name']
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_rouming_id'].to_i).
          where.not(:value => nil).pluck(:value)
#          raise(StandardError, eval_strings)  if !eval_strings.blank? and !(['услуги в страну нахождения (роуминга)', 'услуги в СНГ', 'услуги за пределы России и страны нахождения (роуминга)', 'услуги за пределы России, СНГ и страны нахождения (роуминга)', 'услуги в Россию'].include?(rouming_name))
        if !eval_strings.blank?# and !eval_strings[0].blank?
          detailed_rouming_name = if eval_strings.is_a?(Array)
            country_ids = eval_strings
            country_names = Category.where(:id => country_ids).pluck(:name)
             "#{country_names.join(', ')}"
          else
            'не могу показать список, сообщите администратору'
          end          
        end
        
        service_category_description['service_category_rouming_id'] << tarif_category['service_category_rouming_id']
        service_category_description['service_category_rouming_name'] << categories[tarif_category['service_category_rouming_id'].to_s]['name']
        service_category_description['service_category_rouming_id_details'] << (detailed_rouming_name || '')
      end

      if tarif_category['service_category_geo_id'] and categories[tarif_category['service_category_geo_id'].to_s]
        geo_name = categories[tarif_category['service_category_geo_id'].to_s]['name']
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_geo_id'].to_i).
          where.not(:value => nil).pluck(:value)
#          raise(StandardError, eval_strings)  if !eval_strings.blank? and !(['услуги в страну нахождения (роуминга)', 'услуги в СНГ', 'услуги за пределы России и страны нахождения (роуминга)', 'услуги за пределы России, СНГ и страны нахождения (роуминга)', 'услуги в Россию'].include?(geo_name))
        if !eval_strings.blank?# and !eval_strings[0].blank?
          detailed_geo_name = if eval_strings.is_a?(Array)
            country_ids = eval_strings
            country_names = Category.where(:id => country_ids).pluck(:name)
             "#{country_names.join(', ')}"
          else
            'не могу показать список, сообщите администратору'
          end          
        end
        
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_geo_id'].to_i).
          where.not(:eval_string => nil).pluck(:eval_string)
        if !eval_strings.blank? and !eval_strings[0].blank?
          detailed_geo_name = if eval_strings[0] =~ /operator_country_groups_by_group_id/
            country_ids = eval(eval_strings[0])
            country_names = Category.where(:id => country_ids).pluck(:name)
             "#{country_names.join(', ')}"
          else
            'не могу показать список, сообщите администратору'
          end          
        end
        
        service_category_description['service_category_geo_id'] << tarif_category['service_category_geo_id']
        service_category_description['service_category_geo_name'] << geo_name
        service_category_description['service_category_geo_id_details'] << (detailed_geo_name || '')
      end
        

      service_category_description['service_category_partner_type_id'] << tarif_category['service_category_partner_type_id']
      service_category_description['service_category_partner_type_name'] << categories[tarif_category['service_category_partner_type_id'].to_s]['name'] if 
        tarif_category['service_category_partner_type_id'] and categories[tarif_category['service_category_partner_type_id'].to_s]

      service_category_description['service_category_calls_id'] << tarif_category['service_category_calls_id']
      service_category_description['service_category_calls_name'] << categories[tarif_category['service_category_calls_id'].to_s]['name'] if 
        tarif_category['service_category_calls_id'] and categories[tarif_category['service_category_calls_id'].to_s]

      service_category_description['service_category_one_time_id'] << tarif_category['service_category_one_time_id']
      service_category_description['service_category_one_time_name'] << categories[tarif_category['service_category_one_time_id'].to_s]['name'] if 
        tarif_category['service_category_one_time_id'] and categories[tarif_category['service_category_one_time_id'].to_s]

      service_category_description['service_category_periodic_id'] << tarif_category['service_category_periodic_id']
      service_category_description['service_category_periodic_name'] << categories[tarif_category['service_category_periodic_id'].to_s]['name'] if 
        tarif_category['service_category_periodic_id'] and categories[tarif_category['service_category_periodic_id'].to_s]
    end
    
    service_category_description.each do |key, value|
      service_category_description[key].uniq! if service_category_description[key].is_a?(Array)
    end
  end
  

end
