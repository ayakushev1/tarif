class ServiceHelper::FinalTarifResultPreparator
  
  def self.service_set_services_description(service_ids, service_description)
    service_set_services_description = {}
    service_ids.each do |service_id|
      service_set_services_description[service_id] = {'name' => nil, 'http' => nil}
      if service_description[service_id]
        service_set_services_description[service_id]['name'] = service_description[service_id]['name']
        service_set_services_description[service_id]['http'] = service_description[service_id]['features'].stringify_keys['http'] if service_description[service_id]['features']
        service_set_services_description[service_id]['standard_service_id'] = service_description[service_id]['standard_service_id']
      end
    end
    service_set_services_description
  end
  
  def self.prepare_final_tarif_results_by_tarif(input_data)
    final_tarif_sets = input_data[:final_tarif_sets]
    operator = input_data[:operator]
    tarif = input_data[:tarif]
    
    prepared_final_tarif_results ||= {'service_set' => {}, 'tarif_results' => {}, 'tarif_detail_results' => {}, 'tarif_results_by_part' => {}, 'tarif_detail_results_by_part' => {}}
    final_tarif_sets.each do |service_set_id, final_tarif_set|
      final_tarif_set.stringify_keys!
      raise(StandardError, "wrong tarif in final_tarif_set #{final_tarif_set['tarif']}. Should be #{tarif}") if tarif.to_s != final_tarif_set['tarif']
      prepared_final_tarif_results['service_set'][service_set_id] ||= {'service_set_price' => 0.0, 'service_set_count' => 0, 'tarif' => tarif, 'operator' => operator}
      
      prepare_service_set_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
      prepare_tarif_result_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
      prepare_tarif_detail_result_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
      prepare_tarif_result_part_of_final_tarif_set_by_part(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
      prepare_tarif_detail_result_part_of_final_tarif_set_by_part(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
      
    end if final_tarif_sets    
    prepared_final_tarif_results
  end
  
  def self.prepare_service_set_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]
    groupped_identical_services = input_data[:groupped_identical_services]    
    operator_description = input_data[:operator_description][input_data[:operator].to_s]
    operator_description = {'name' => operator_description['name']}
#    raise(StandardError, input_data[:operator_description])
    service_description = input_data[:service_description]
    
    prepared_final_tarif_results['service_set'][service_set_id] ||= {}
    final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]
      
      tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part |
        
        prepared_final_tarif_results['service_set'][service_set_id]['stat_results'] ||= {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              prepared_final_tarif_results['service_set'][service_set_id]['stat_results'][stat_key] ||= []
              prepared_final_tarif_results['service_set'][service_set_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            else
              prepared_final_tarif_results['service_set'][service_set_id]['stat_results'][stat_key] ||= 0
              prepared_final_tarif_results['service_set'][service_set_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']
        end

        prepared_final_tarif_results['service_set'][service_set_id]['identical_services'] ||= []            
        prepared_final_tarif_results['service_set'][service_set_id]['identical_services'] << 
          groupped_identical_services[tarif_set_by_part_id].stringify_keys['identical_services'] if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
        prepared_final_tarif_results['service_set'][service_set_id]['identical_services'].uniq!
        raise(StandardError) if tarif_id_from_tarif_results == -333
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_price'] ||= 0.0
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_count'] ||= 0

        prepared_final_tarif_results['service_set'][service_set_id]['service_set_price'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
        
        identical_service_ids = prepared_final_tarif_results['service_set'][service_set_id]['identical_services'].flatten.map do |identical_service_name|
          identical_service_name.split('_')
        end.flatten.uniq
        
        service_set_ids = (service_set_id.split('_') + identical_service_ids).uniq
#        raise(StandardError) if !prepared_final_tarif_results['service_set'][service_set_id]['identical_services'].blank?
        prepared_final_tarif_results['service_set'][service_set_id]['service_description'] = service_set_services_description(service_set_ids, service_description)
        prepared_final_tarif_results['service_set'][service_set_id]['operator_description'] = operator_description
#        raise(StandardError)
      end if tarif_results_for_service_set_and_part
    end if final_tarif_set['tarif_sets_by_part']        
  end
  
  def self.prepare_tarif_result_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]
    service_description = input_data[:service_description]

    prepared_final_tarif_results['tarif_results'][service_set_id]||= {}
    final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]

      tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part|
        
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results] ||= {}
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['stat_results'] ||= {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
        
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|            
          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['stat_results'][stat_key] ||= []
              prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
            else
              prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['stat_results'][stat_key] ||= 0
              prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']
        end if tarif_result_for_service_set_and_part['price_values']
        
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['price_value'] ||= 0.0
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['call_id_count'] ||= 0

        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['price_value'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['call_id_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
        
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['service_description'] = service_set_services_description([tarif_id_from_tarif_results.to_s], service_description)

        end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
  end
  
  def self.tarif_detail_results_description(price_value_detail, input_data)
    categories = input_data[:categories]
    tarif_categories = input_data[:tarif_categories]
    tarif_category_groups = input_data[:tarif_category_groups]
    tarif_class_categories_by_category_group = input_data[:tarif_class_categories_by_category_group]
    service_category_tarif_class_id = price_value_detail['service_category_tarif_class_id']
    service_category_group_id = price_value_detail['service_category_group_id']

    service_category_description = { 'service_category_rouming_id' => [], 'service_category_geo_id' => [], 'service_category_geo_id_details' => [],
      'service_category_partner_type_id' => [], 'service_category_calls_id' => [], 'service_category_one_time_id' => [], 'service_category_periodic_id' => [],}
       
    return service_category_description if !service_category_group_id
    
    tarif_categories_to_go = (service_category_group_id < 0) ? 
      [service_category_tarif_class_id.to_s] : tarif_class_categories_by_category_group[service_category_group_id.to_s].map(&:to_s)

    tarif_categories_to_go.each do |tcsc_id|
      tarif_category = tarif_categories[tcsc_id]#.attributes

#      raise(StandardError) if service_category_group_id    

      service_category_description['service_category_rouming_id'] << categories[tarif_category['service_category_rouming_id'].to_s]['name'] if 
        tarif_category['service_category_rouming_id'] and categories[tarif_category['service_category_rouming_id'].to_s]

      if tarif_category['service_category_geo_id'] and categories[tarif_category['service_category_geo_id'].to_s]
        geo_name = categories[tarif_category['service_category_geo_id'].to_s]['name']
#        raise(StandardError) if geo_name == 'услуги в Европу МТС'
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
        
        service_category_description['service_category_geo_id'] << geo_name
        service_category_description['service_category_geo_id_details'] << (detailed_geo_name || '')
      end
        

      service_category_description['service_category_partner_type_id'] << categories[tarif_category['service_category_partner_type_id'].to_s]['name'] if 
        tarif_category['service_category_partner_type_id'] and categories[tarif_category['service_category_partner_type_id'].to_s]

      service_category_description['service_category_calls_id'] << categories[tarif_category['service_category_calls_id'].to_s]['name'] if 
        tarif_category['service_category_calls_id'] and categories[tarif_category['service_category_calls_id'].to_s]

      service_category_description['service_category_one_time_id'] << categories[tarif_category['service_category_one_time_id'].to_s]['name'] if 
        tarif_category['service_category_one_time_id'] and categories[tarif_category['service_category_one_time_id'].to_s]

      service_category_description['service_category_periodic_id'] << categories[tarif_category['service_category_periodic_id'].to_s]['name'] if 
        tarif_category['service_category_periodic_id'] and categories[tarif_category['service_category_periodic_id'].to_s]
    end
    
    service_category_description
  end
  
  def self.prepare_tarif_detail_result_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]

    prepared_final_tarif_results['tarif_detail_results'][service_set_id] ||= {}
    final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]

      tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part|
        s_id = tarif_id_from_tarif_results        
        prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id] ||= {}
        stat_detail_keys_to_exclude = ['month', 'call_ids']
        
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
          sc_name = price_value_detail['service_category_name']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name] ||= {}
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['stat_results'] ||= {};             
          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['stat_results'][stat_key] ||= []
              prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
            else
              prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['stat_results'][stat_key] ||= 0
              prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']
        
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['price_value'] ||= 0.0
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['call_id_count'] ||= 0
  
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['price_value'] += (price_value_detail['price_value'] || 0.0).to_f
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['call_id_count'] += (price_value_detail['call_id_count'] || 0).to_i
          
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['call_ids'] = price_value_detail['call_ids']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_name'] = price_value_detail['service_category_name']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_tarif_class_id'] = price_value_detail['service_category_tarif_class_id']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_group_id'] = price_value_detail['service_category_group_id']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_description'] = tarif_detail_results_description(price_value_detail, input_data)

        end if tarif_result_for_service_set_and_part['price_values']
      end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
  end
 
  def self.prepare_tarif_result_part_of_final_tarif_set_by_part(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]

    prepared_final_tarif_results['tarif_results_by_part'][service_set_id] ||= {}
    final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]

      tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part|
        tarif_class_id = "#{part}_#{service_set_id}__#{tarif_id_from_tarif_results}"
        
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id] ||= {}
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['stat_results'] ||= {}; stat_detail_keys_to_exclude = ['month', 'call_ids']
        
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|            
          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['stat_results'][stat_key] ||= []
              prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
            else
              prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['stat_results'][stat_key] ||= 0
              prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']
        end if tarif_result_for_service_set_and_part['price_values']
        
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['part'] ||= part
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['tarif_class_id'] ||= tarif_class_id
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['tarif_set_by_part_id'] ||= tarif_set_by_part_id
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['tarif_class_id_0'] ||= tarif_id_from_tarif_results

        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['price_value'] ||= 0.0
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['call_id_count'] ||= 0

        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['price_value'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['call_id_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
        
        end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
  end

  def self.prepare_tarif_detail_result_part_of_final_tarif_set_by_part(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]

    prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id] ||= {}
    final_tarif_set['tarif_sets_by_part'].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]

      tarif_results_for_service_set_and_part.each do |tarif_id_from_tarif_results, tarif_result_for_service_set_and_part|
        tarif_class_id = "#{part}_#{service_set_id}__#{tarif_id_from_tarif_results}"
        
        prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id] ||= {}
        
        tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|            
          s_id = price_value_detail['service_category_name'].to_s
          stat_detail_keys_to_exclude = ['month', 'call_ids']
          
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id] ||= {}
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['stat_results'] ||= {};             

          (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
            if price_value_detail['all_stat'][stat_key].is_a?(Array)
              prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['stat_results'][stat_key] ||= []
              prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['stat_results'][stat_key] += price_value_detail['all_stat'][stat_key].round(2)
            else
              prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['stat_results'][stat_key] ||= 0
              prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['stat_results'][stat_key] += (price_value_detail['all_stat'][stat_key] || 0).round(2)
            end
          end if price_value_detail['all_stat']

          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['tarif_class_id_0'] ||= tarif_id_from_tarif_results
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_name'] ||= price_value_detail['service_category_name']
#          raise(StandardError) if prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_name'] != price_value_detail['service_category_name']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_tarif_class_id'] ||= price_value_detail['service_category_tarif_class_id']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_group_id'] ||= price_value_detail['service_category_group_id']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['month'] ||= price_value_detail['month']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['call_ids'] ||= price_value_detail['call_ids']
  
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['price_value'] ||= 0.0
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['call_id_count'] ||= 0
  
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['price_value'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['call_id_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
          
        end if tarif_result_for_service_set_and_part['price_values']
        
      end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
  end
  
end
