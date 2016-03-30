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
      service_set_name = final_tarif_set['service_ids'.freeze].join('_'.freeze)
      service_ids = final_tarif_set['service_ids'.freeze].uniq
      common_services = final_tarif_set['common_services'.freeze][input_data[:operator].to_s] & service_ids
      tarif_options = service_ids - common_services - [tarif_id]
      
      service_set_result[service_set_id] ||= {
        'run_id'.freeze => input_data[:run_id], 'operator_id'.freeze => input_data[:operator], 'tarif_id'.freeze => tarif_id, 'service_set_id'.freeze => service_set_id,
        'service_ids'.freeze => service_ids, 'identical_services'.freeze => [], 'common_services'.freeze => common_services, 'tarif_options'.freeze => tarif_options,
        'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'stat_results'.freeze => {}}

      process_final_tarif_set_tarif_sets_by_part(service_set_result, service_result, agregate_result, category_result, service_set_id, input_data)
         
      service_set_result[service_set_id].merge!({
        "call_id_count".freeze => service_set_result[service_set_id]['stat_results'.freeze]["call_id_count".freeze],
        "categ_ids".freeze => service_set_result[service_set_id]['stat_results'.freeze]["categ_ids".freeze],
        "count_volume".freeze => service_set_result[service_set_id]['stat_results'.freeze]["count_volume".freeze],
        "sum_volume".freeze => service_set_result[service_set_id]['stat_results'.freeze]["sum_volume".freeze],
        "sum_duration_minute".freeze => service_set_result[service_set_id]['stat_results'.freeze]["sum_duration_minute".freeze],})
      service_set_result[service_set_id].extract!('stat_results'.freeze)
      service_sets_array << service_set_result[service_set_id]
      
      service_result.each do |service_id, result|
        service_result[service_id].merge!({
          "call_id_count".freeze => service_result[service_id]['stat_results'.freeze]["call_id_count".freeze],
          "categ_ids".freeze => service_result[service_id]['stat_results'.freeze]["categ_ids".freeze],
          "count_volume".freeze => service_result[service_id]['stat_results'.freeze]["count_volume".freeze],
          "sum_volume".freeze => service_result[service_id]['stat_results'.freeze]["sum_volume".freeze],
          "sum_duration_minute".freeze => service_result[service_id]['stat_results'.freeze]["sum_duration_minute".freeze],})
        service_result[service_id].extract!('stat_results'.freeze)
        services_array << service_result[service_id]
        
        category_result[service_id].each do |sc_name, sc_resutl|
          category_result[service_id][sc_name].merge!({
            "call_id_count".freeze => category_result[service_id][sc_name]['stat_results'.freeze]["call_id_count".freeze],
            "categ_ids".freeze => category_result[service_id][sc_name]['stat_results'.freeze]["categ_ids".freeze],
            "count_volume".freeze => category_result[service_id][sc_name]['stat_results'.freeze]["count_volume".freeze],
            "sum_volume".freeze => category_result[service_id][sc_name]['stat_results'.freeze]["sum_volume".freeze],
            "sum_duration_minute".freeze => category_result[service_id][sc_name]['stat_results'.freeze]["sum_duration_minute".freeze],})
          category_result[service_id][sc_name].extract!('stat_results'.freeze)
          categories_array << category_result[service_id][sc_name]
        end
      end      
      raise(StandardError, [
        "",
        "final_tarif_set #{final_tarif_set}",
        "input_data[:final_tarif_sets] #{input_data[:final_tarif_sets]}",
        "service_set_result[service_set_id] #{service_set_result[service_set_id]}",
        "service_result #{service_result}",
        "",
      ].join("\n\n")) if false and service_set_id == "174_178_102_493_102_174_178_102_493_174_178_102_174_179_102_493"

      agregate_result.each do |sc_name, result|
        agregate_result[sc_name].merge!({
          "call_id_count".freeze => agregate_result[sc_name]['stat_results'.freeze]["call_id_count".freeze],
          "categ_ids".freeze => agregate_result[sc_name]['stat_results'.freeze]["categ_ids".freeze],
          "count_volume".freeze => agregate_result[sc_name]['stat_results'.freeze]["count_volume".freeze],
          "sum_volume".freeze => agregate_result[sc_name]['stat_results'.freeze]["sum_volume".freeze],
          "sum_duration_minute".freeze => agregate_result[sc_name]['stat_results'.freeze]["sum_duration_minute".freeze],})
        agregate_result[sc_name].extract!('stat_results'.freeze)
        agregates_array << agregate_result[sc_name]
      end      
    end      
#    raise(StandardError, service_sets_array)
    [service_sets_array, services_array, categories_array, agregates_array]
  end
  
  def self.process_final_tarif_set_tarif_sets_by_part(service_set_result, service_result, agregate_result, category_result, service_set_id, input_data)
    input_data[:final_tarif_sets][service_set_id]['tarif_sets_by_part'.freeze].each do |tarif_set_by_part|
      part = tarif_set_by_part[0]; tarif_set_by_part_id = tarif_set_by_part[1]
      tarif_results = input_data[:tarif_results]
      tarif_results_for_service_set_and_part = tarif_results[tarif_set_by_part_id][part] if tarif_results and tarif_results[tarif_set_by_part_id]

      raise(StandardError, [
        "",
#        "final_tarif_set #{final_tarif_set}",
        "input_data[:final_tarif_sets] #{input_data[:final_tarif_sets]}",
        "service_set_result[service_set_id] #{service_set_result[service_set_id]}",
        "service_result #{service_result}",
        "tarif_results_for_service_set_and_part #{tarif_results_for_service_set_and_part}",
        "input_data[:final_tarif_sets][service_set_id]['tarif_sets_by_part'.freeze] #{input_data[:final_tarif_sets][service_set_id]['tarif_sets_by_part'.freeze]}",
        "tarif_set_by_part #{tarif_set_by_part}",
        "part #{part}",
        "tarif_set_by_part_id #{tarif_set_by_part_id}",
        "tarif_results[tarif_set_by_part_id][part] #{tarif_results and tarif_results[tarif_set_by_part_id][part]}",
        "",
      ].join("\n\n")) if false and tarif_set_by_part == ["onetime", "102_493"] and service_set_id == "174_178_102_493_102_174_178_102_493_174_178_102_174_179_102_493"
      
      tarif_results_for_service_set_and_part.each do |service_id, tarif_result_for_service_set_and_part |
        stat_detail_keys_to_exclude = ['month'.freeze, 'call_ids'.freeze]
        
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

    tarif_result_for_service_set_and_part['price_values'.freeze].each do |price_value_detail|
#            raise(StandardError, [tarif_result_for_service_set_and_part['price_values']])  
      (price_value_detail['all_stat'.freeze].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'.freeze][stat_key].is_a?(Array)
          service_set_result[service_set_id]['stat_results'.freeze][stat_key] ||= []
          service_set_result[service_set_id]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key].uniq - service_set_result[service_set_id]['stat_results'.freeze][stat_key])
        else
          service_set_result[service_set_id]['stat_results'.freeze][stat_key] ||= 0
          service_set_result[service_set_id]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat'.freeze]
    end
    
    groupped_identical_services = input_data[:groupped_identical_services].dup
    
    service_set_result[service_set_id]['identical_services'.freeze] << 
      groupped_identical_services[tarif_set_by_part_id].stringify_keys['identical_services'.freeze] if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
    service_set_result[service_set_id]['identical_services'.freeze].uniq!

    service_set_result[service_set_id]['price'.freeze] += (tarif_result_for_service_set_and_part['price_value'.freeze] || 0.0).to_f
    service_set_result[service_set_id]['call_id_count'.freeze] += (tarif_result_for_service_set_and_part['call_id_count'.freeze] || 0).to_i
    
#    raise(StandardError, service_set_result[service_set_id]['identical_services']) if groupped_identical_services and groupped_identical_services[tarif_set_by_part_id]
#    identical_service_ids = service_set_result[service_set_id]['identical_services'].flatten.map do |identical_service_name|
#      identical_service_name.split('_')
#    end.flatten.uniq

  end
  
  def self.process_service_result(service_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

    service_result[service_id] ||= {
      'run_id'.freeze => input_data[:run_id], 'tarif_id'.freeze =>  input_data[:tarif_id], 'service_set_id'.freeze => service_set_id, 'service_id'.freeze => service_id,
      'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'stat_results'.freeze => {}}
    
    stat_detail_keys_to_exclude = ['month'.freeze, 'call_ids'.freeze]
    
    tarif_result_for_service_set_and_part['price_values'.freeze].each do |price_value_detail|            
      (price_value_detail['all_stat'.freeze].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'.freeze][stat_key].is_a?(Array)
          service_result[service_id]['stat_results'.freeze][stat_key] ||= []
          service_result[service_id]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key].uniq - service_result[service_id]['stat_results'.freeze][stat_key])
        else
          service_result[service_id]['stat_results'.freeze][stat_key] ||= 0
          service_result[service_id]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat'.freeze]
    end if tarif_result_for_service_set_and_part['price_values'.freeze]
    
    service_result[service_id]['price'.freeze] += (tarif_result_for_service_set_and_part['price_value'.freeze] || 0.0).to_f
    service_result[service_id]['call_id_count'.freeze] += (tarif_result_for_service_set_and_part['call_id_count'.freeze] || 0).to_i
  end

  def self.process_category_result(agregate_result, category_result, service_set_id, tarif_set_by_part_id,
          service_id, tarif_result_for_service_set_and_part, stat_detail_keys_to_exclude, input_data)

    category_result[service_id] ||= {}
    
    stat_detail_keys_to_exclude = ['month'.freeze, 'call_ids'.freeze]
    
    tarif_result_for_service_set_and_part['price_values'].each do |price_value_detail|
      category_details = tarif_detail_results_description(price_value_detail, input_data)
      all_categories = []
      ['service_category_rouming_id'.freeze, 'service_category_geo_id'.freeze, 'service_category_partner_type_id'.freeze,
        'service_category_calls_id'.freeze, 'service_category_one_time_id'.freeze, 'service_category_periodic_id'.freeze, ].collect do |category|
          all_categories += category_details[category].map(&:to_s)
       end         
      sc_name = all_categories.join('_'.freeze)

      category_result[service_id][sc_name] ||= {
        'run_id'.freeze => input_data[:run_id], 'tarif_id'.freeze =>  input_data[:tarif_id], 'service_set_id'.freeze => service_set_id, 'service_id'.freeze => service_id,
        'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'stat_results'.freeze => {}}

      agregate_result[sc_name] ||= {
        'run_id'.freeze => input_data[:run_id], 'tarif_id'.freeze =>  input_data[:tarif_id], 'service_set_id'.freeze => service_set_id,
        'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'stat_results'.freeze => {}}

      (price_value_detail['all_stat'].keys - stat_detail_keys_to_exclude).each do |stat_key|
        if price_value_detail['all_stat'][stat_key].is_a?(Array)
          category_result[service_id][sc_name]['stat_results'.freeze][stat_key] ||= []
          category_result[service_id][sc_name]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'][stat_key].uniq - category_result[service_id][sc_name]['stat_results'.freeze][stat_key]) 

          agregate_result[sc_name]['stat_results'.freeze][stat_key] ||= []
          agregate_result[sc_name]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key].uniq - agregate_result[sc_name]['stat_results'.freeze][stat_key]) 
        else
          category_result[service_id][sc_name]['stat_results'.freeze][stat_key] ||= 0
          category_result[service_id][sc_name]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key] || 0).round(2)

          agregate_result[sc_name]['stat_results'.freeze][stat_key] ||= 0
          agregate_result[sc_name]['stat_results'.freeze][stat_key] += (price_value_detail['all_stat'.freeze][stat_key] || 0).round(2)
        end
      end if price_value_detail['all_stat'.freeze]
    
      category_result[service_id][sc_name]['price'.freeze] += (price_value_detail['price_value'.freeze] || 0.0).to_f
      category_result[service_id][sc_name]['call_id_count'.freeze] += (price_value_detail['call_id_count'.freeze] || 0).to_i
      
#      category_result[service_id][sc_name]['call_ids'] = price_value_detail['call_ids']
      category_result[service_id][sc_name]['categ_ids'.freeze] += (price_value_detail['categ_ids'.freeze] || []).uniq
      category_result[service_id][sc_name]['service_category_name'.freeze] = sc_name
      category_result[service_id][sc_name]['rouming_ids'.freeze] = category_details['service_category_rouming_id'.freeze]
      category_result[service_id][sc_name]['geo_ids'.freeze] = category_details['service_category_geo_id'.freeze]
      category_result[service_id][sc_name]['partner_ids'.freeze] = category_details['service_category_partner_type_id'.freeze]
      category_result[service_id][sc_name]['calls_ids'.freeze] = category_details['service_category_calls_id'.freeze]
      category_result[service_id][sc_name]['one_time_ids'.freeze] = category_details['service_category_one_time_id'.freeze]
      category_result[service_id][sc_name]['periodic_ids'.freeze] = category_details['service_category_periodic_id'.freeze]
      category_result[service_id][sc_name]['fix_ids'.freeze] = category_details['service_category_one_time_id'.freeze] + category_details['service_category_periodic_id'.freeze]

      category_result[service_id][sc_name]['rouming_names'.freeze] = category_details['service_category_rouming_name'.freeze]
      category_result[service_id][sc_name]['geo_names'.freeze] = category_details['service_category_geo_name'.freeze]
      category_result[service_id][sc_name]['partner_names'.freeze] = category_details['service_category_partner_type_name'.freeze]
      category_result[service_id][sc_name]['calls_names'.freeze] = category_details['service_category_calls_name'.freeze]
      category_result[service_id][sc_name]['one_time_names'.freeze] = category_details['service_category_one_time_name'.freeze]
      category_result[service_id][sc_name]['periodic_names'.freeze] = category_details['service_category_periodic_name'.freeze]
      category_result[service_id][sc_name]['fix_names'.freeze] = category_details['service_category_one_time_name'.freeze] + category_details['service_category_periodic_name'.freeze]

      category_result[service_id][sc_name]['rouming_details'.freeze] = category_details['service_category_rouming_id_details'.freeze]
      category_result[service_id][sc_name]['geo_details'.freeze] = category_details['service_category_geo_id_details'.freeze]
      category_result[service_id][sc_name]['partner_details'.freeze] = []


      agregate_result[sc_name]['price'.freeze] += (price_value_detail['price_value'.freeze] || 0.0).to_f
      agregate_result[sc_name]['call_id_count'.freeze] += (price_value_detail['call_id_count'.freeze] || 0).to_i
      
#      agregate_result[sc_name]['call_ids'] = price_value_detail['call_ids']
      agregate_result[sc_name]['categ_ids'.freeze] += (price_value_detail['categ_ids'] || []).uniq
      agregate_result[sc_name]['service_category_name'.freeze] = sc_name
      agregate_result[sc_name]['rouming_ids'.freeze] = category_details['service_category_rouming_id'.freeze]
      agregate_result[sc_name]['geo_ids'.freeze] = category_details['service_category_geo_id'.freeze]
      agregate_result[sc_name]['partner_ids'.freeze] = category_details['service_category_partner_type_id'.freeze]
      agregate_result[sc_name]['calls_ids'.freeze] = category_details['service_category_calls_id'.freeze]
      agregate_result[sc_name]['one_time_ids'.freeze] = category_details['service_category_one_time_id'.freeze]
      agregate_result[sc_name]['periodic_ids'.freeze] = category_details['service_category_periodic_id'.freeze]
      agregate_result[sc_name]['fix_ids'.freeze] = category_details['service_category_one_time_id'.freeze] + category_details['service_category_periodic_id'.freeze]

      agregate_result[sc_name]['rouming_names'.freeze] = category_details['service_category_rouming_name'.freeze]
      agregate_result[sc_name]['geo_names'.freeze] = category_details['service_category_geo_name'.freeze]
      agregate_result[sc_name]['partner_names'.freeze] = category_details['service_category_partner_type_name'.freeze]
      agregate_result[sc_name]['calls_names'.freeze] = category_details['service_category_calls_name'.freeze]
      agregate_result[sc_name]['one_time_names'.freeze] = category_details['service_category_one_time_name'.freeze]
      agregate_result[sc_name]['periodic_names'.freeze] = category_details['service_category_periodic_name'.freeze]
      agregate_result[sc_name]['fix_names'.freeze] = category_details['service_category_one_time_name'.freeze] + category_details['service_category_periodic_name'.freeze]

      agregate_result[sc_name]['rouming_details'.freeze] = category_details['service_category_rouming_id_details'.freeze]
      agregate_result[sc_name]['geo_details'.freeze] = category_details['service_category_geo_id_details'.freeze]
      agregate_result[sc_name]['partner_details'.freeze] = []

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
      'service_category_rouming_id'.freeze => [], 'service_category_rouming_name'.freeze => [], 'service_category_rouming_id_details'.freeze => [],
      'service_category_geo_id'.freeze => [], 'service_category_geo_name'.freeze => [], 'service_category_geo_id_details'.freeze => [],      
      'service_category_partner_type_id'.freeze => [], 'service_category_partner_type_name'.freeze => [],'service_category_partner_type_id_details'.freeze => [],
      'service_category_calls_id'.freeze => [], 'service_category_calls_name'.freeze => [], 
      'service_category_one_time_id'.freeze => [], 'service_category_one_time_name'.freeze => [], 
      'service_category_periodic_id'.freeze => [], 'service_category_periodic_name'.freeze => [],
      }
       
    return service_category_description if !service_category_group_id
    
    tarif_categories_to_go = (service_category_group_id < 0) ? 
      [service_category_tarif_class_id.to_s] : tarif_class_categories_by_category_group[service_category_group_id.to_s].map(&:to_s)

    tarif_categories_to_go.each do |tcsc_id|
      tarif_category = tarif_categories[tcsc_id]#.attributes

#      raise(StandardError, [tarif_category['service_category_rouming_id'] , categories])     

      if tarif_category['service_category_rouming_id'.freeze] and categories[tarif_category['service_category_rouming_id'.freeze].to_s]
        rouming_name = categories[tarif_category['service_category_rouming_id'.freeze].to_s]['name'.freeze]
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_rouming_id'.freeze].to_i).
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
        
        service_category_description['service_category_rouming_id'.freeze] << tarif_category['service_category_rouming_id'.freeze]
        service_category_description['service_category_rouming_name'.freeze] << categories[tarif_category['service_category_rouming_id'.freeze].to_s]['name'.freeze]
        service_category_description['service_category_rouming_id_details'.freeze] << (detailed_rouming_name || '')
      end

      if tarif_category['service_category_geo_id'.freeze] and categories[tarif_category['service_category_geo_id'.freeze].to_s]
        geo_name = categories[tarif_category['service_category_geo_id'.freeze].to_s]['name'.freeze]
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_geo_id'.freeze].to_i).
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
        
        eval_strings = Service::Criterium.where(:service_category_id => tarif_category['service_category_geo_id'.freeze].to_i).
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
        
        service_category_description['service_category_geo_id'.freeze] << tarif_category['service_category_geo_id'.freeze]
        service_category_description['service_category_geo_name'.freeze] << geo_name
        service_category_description['service_category_geo_id_details'.freeze] << (detailed_geo_name || '')
      end
        

      service_category_description['service_category_partner_type_id'.freeze] << tarif_category['service_category_partner_type_id'.freeze]
      service_category_description['service_category_partner_type_name'.freeze] << categories[tarif_category['service_category_partner_type_id'.freeze].to_s]['name'.freeze] if 
        tarif_category['service_category_partner_type_id'.freeze] and categories[tarif_category['service_category_partner_type_id'.freeze].to_s]

      service_category_description['service_category_calls_id'.freeze] << tarif_category['service_category_calls_id'.freeze]
      service_category_description['service_category_calls_name'.freeze] << categories[tarif_category['service_category_calls_id'.freeze].to_s]['name'.freeze] if 
        tarif_category['service_category_calls_id'.freeze] and categories[tarif_category['service_category_calls_id'.freeze].to_s]

      service_category_description['service_category_one_time_id'.freeze] << tarif_category['service_category_one_time_id'.freeze]
      service_category_description['service_category_one_time_name'.freeze] << categories[tarif_category['service_category_one_time_id'.freeze].to_s]['name'.freeze] if 
        tarif_category['service_category_one_time_id'.freeze] and categories[tarif_category['service_category_one_time_id'.freeze].to_s]

      service_category_description['service_category_periodic_id'.freeze] << tarif_category['service_category_periodic_id'.freeze]
      service_category_description['service_category_periodic_name'.freeze] << categories[tarif_category['service_category_periodic_id'.freeze].to_s]['name'.freeze] if 
        tarif_category['service_category_periodic_id'.freeze] and categories[tarif_category['service_category_periodic_id'.freeze].to_s]
    end
    
    service_category_description.each do |key, value|
      service_category_description[key].uniq! if service_category_description[key].is_a?(Array)
    end
  end
  

end
