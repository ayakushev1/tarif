class ServiceHelper::FinalTarifResultPreparator
  
  def self.prepare_final_tarif_results_by_tarif(input_data)
    final_tarif_sets = input_data[:final_tarif_sets]
    operator = input_data[:operator]
    tarif = input_data[:tarif]
    
    prepared_final_tarif_results ||= {'service_set' => {}, 'tarif_results' => {}, 'tarif_detail_results' => {}, 'tarif_results_by_part' => {}, 'tarif_detail_results_by_part' => {}}
    final_tarif_sets.each do |service_set_id, final_tarif_set|
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
        prepared_final_tarif_results['service_set'][service_set_id]['identical_services'] << groupped_identical_services[tarif_set_by_part_id]['identical_services'] if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
        prepared_final_tarif_results['service_set'][service_set_id]['identical_services'].uniq!
        
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_price'] ||= 0.0
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_count'] ||= 0

        prepared_final_tarif_results['service_set'][service_set_id]['service_set_price'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
        prepared_final_tarif_results['service_set'][service_set_id]['service_set_count'] += (tarif_result_for_service_set_and_part['call_id_count'] || 0).to_i
        
      end if tarif_results_for_service_set_and_part
    end if final_tarif_set['tarif_sets_by_part']        
  end
  
  def self.prepare_tarif_result_part_of_final_tarif_set(prepared_final_tarif_results, service_set_id, final_tarif_set, input_data)
    tarif_results = input_data[:tarif_results]

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
        prepared_final_tarif_results['tarif_results'][service_set_id][tarif_id_from_tarif_results]['call_id_count'] += tarif_result_for_service_set_and_part['call_id_count']
        
        end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
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
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['call_id_count'] += price_value_detail['call_id_count']
          
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_name'] = price_value_detail['service_category_name']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_tarif_class_id'] = price_value_detail['service_category_tarif_class_id']
          prepared_final_tarif_results['tarif_detail_results'][service_set_id][s_id][sc_name]['service_category_group_id'] = price_value_detail['service_category_group_id']
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
        prepared_final_tarif_results['tarif_results_by_part'][service_set_id][tarif_class_id]['call_id_count'] += tarif_result_for_service_set_and_part['call_id_count']
        
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
          s_id = price_value_detail['tarif_class_id'].to_s
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
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_tarif_class_id'] ||= price_value_detail['service_category_tarif_class_id']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['service_category_group_id'] ||= price_value_detail['service_category_group_id']
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['month'] ||= price_value_detail['month']
  
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['price_value'] ||= 0.0
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['call_id_count'] ||= 0
  
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['price_value'] += (tarif_result_for_service_set_and_part['price_value'] || 0.0).to_f
          prepared_final_tarif_results['tarif_detail_results_by_part'][service_set_id][tarif_class_id][s_id]['call_id_count'] += tarif_result_for_service_set_and_part['call_id_count']
          
        end if tarif_result_for_service_set_and_part['price_values']
        
      end if tarif_results_for_service_set_and_part
    end if final_tarif_set and final_tarif_set['tarif_sets_by_part']
  end
  
end
