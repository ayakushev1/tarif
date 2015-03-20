class TarifOptimization::TarifResultSimlifier  
  attr_reader :options             
  attr_accessor :updated_tarif_results, :groupped_identical_services 
  attr_accessor :tarif_sets, :services_that_depended_on, :operator, :tarif, :common_services, :common_services_by_parts,
                :cons_tarif_results_by_parts, :tarif_results, :cons_tarif_results
  
  attr_reader :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results,
              :eliminate_identical_tarif_sets
  
  def initialize(options = {} )
    @options = options    
    set_generation_params(options)
  end
    
  def set_generation_params(options)
    @eliminate_identical_tarif_sets = options[:eliminate_identical_tarif_sets] == 'true' ? true : false
    @if_update_tarif_sets_to_calculate_from_with_cons_tarif_results = options[:if_update_tarif_sets_to_calculate_from_with_cons_tarif_results] == 'true' ? true : false
  end
  
  def set_input_data(input_data)
    @tarif_sets = input_data[:tarif_sets]
    @services_that_depended_on = input_data[:services_that_depended_on]
    @operator = input_data[:operator]
    @tarif = input_data[:tarif]
    @common_services_by_parts = input_data[:common_services_by_parts]
    @common_services = input_data[:common_services]
    @cons_tarif_results_by_parts = input_data[:cons_tarif_results_by_parts]
    @tarif_results = input_data[:tarif_results]
    @cons_tarif_results = input_data[:cons_tarif_results]
  end
  
  def simplify_tarif_results_and_tarif_sets
    if if_update_tarif_sets_to_calculate_from_with_cons_tarif_results
      tarif_sets, tarif_results = update_tarif_sets_with_cons_tarif_results
    end

    [tarif_sets, tarif_results, groupped_identical_services]
  end
  
#tarif_results['200'].map{|p| p[1].map{|t| [t[1]['price_value'], t[1]['call_id_count']]}}

  def update_tarif_sets_with_cons_tarif_results
    excluded_tarif_sets = []
    tarifs = tarif_sets.keys.map(&:to_i)
#TODO проверить еще раз почему нельзя исключать common_services
    array_of_services_that_depended_on = services_that_depended_on.values.flatten
    services_to_not_excude = common_services[operator] + tarifs + array_of_services_that_depended_on
    sub_tarif_sets_with_zero_results_0 = calculate_sub_tarif_sets_with_zero_results_0(services_to_not_excude, array_of_services_that_depended_on)
    sub_tarif_sets_with_zero_results_1 = calculate_sub_tarif_sets_with_zero_results_1(services_to_not_excude)
    
    updated_tarif_sets = {}
    tarif_sets.each do |tarif, tarif_sets_by_tarif|
      updated_tarif_sets[tarif] ||= {}
      tarif_sets_by_tarif.each do |part, tarif_sets_by_tarif_by_part|
#        next if part == 'periodic'
        updated_tarif_sets[tarif][part] ||= {}
        tarif_sets_by_tarif_by_part.each do |tarif_set_id, services|
          if (services & sub_tarif_sets_with_zero_results_0).blank?
            if sub_tarif_sets_with_zero_results_1[tarif_set_id]
# Предполагается что tarif_set_id должен быть в первоначальном tarif_sets
              new_tarif_set_id = sub_tarif_sets_with_zero_results_1[tarif_set_id][:new_tarif_set_id]
              new_services = sub_tarif_sets_with_zero_results_1[tarif_set_id][:new_services]
              updated_tarif_sets[tarif][part][new_tarif_set_id] = new_services
            else
              updated_tarif_sets[tarif][part][tarif_set_id] = services 
            end            
          end
        end
        updated_tarif_sets[tarif].extract!(part) if updated_tarif_sets[tarif][part].blank?
      end
    end if tarif_sets
    
#    updated_tarif_results1 = tarif_results.clone
#    sub_tarif_sets_with_zero_results_1.each do |tarif_set_id|
#      updated_tarif_results1.extract!(tarif_set_id)
#    end

    updated_tarif_results = {}
    tarif_results.each do |tarif_set_id, tarif_result|
      updated_tarif_results[tarif_set_id] = tarif_result if !sub_tarif_sets_with_zero_results_1.include?(tarif_set_id)
    end if tarif_results
    
#    raise(StandardError)
    updated_tarif_sets = reorder_tarif_sets(updated_tarif_sets, updated_tarif_results)
#    raise(StandardError, eliminate_identical_tarif_sets)
    updated_tarif_sets, updated_tarif_results = group_identical_tarif_sets(updated_tarif_sets, updated_tarif_results, services_to_not_excude, eliminate_identical_tarif_sets) if eliminate_identical_tarif_sets

    updated_tarif_sets, updated_tarif_results = group_identical_tarif_sets(updated_tarif_sets, updated_tarif_results, services_to_not_excude, eliminate_identical_tarif_sets) if eliminate_identical_tarif_sets

    [updated_tarif_sets, updated_tarif_results]
  end
  
  def calculate_sub_tarif_sets_with_zero_results_0(services_to_not_excude, array_of_services_that_depended_on)
#TODO подумать какие еще наборы услуг добавить
    depended_on_services = services_that_depended_on.map{|d| d[1]}.flatten.uniq
    sub_tarif_sets_with_zero_results = []
    cons_tarif_results.each do |tarif_set_id, cons_tarif_result|
      if cons_tarif_result['price_value'].to_f == 0.0 #and cons_tarif_result['call_id_count'].to_i == 0
        services = tarif_set_id.split('_').map(&:to_i)
        sub_tarif_sets_with_zero_results += (services - services_to_not_excude - sub_tarif_sets_with_zero_results) if (services & depended_on_services).blank?
      end
    end if cons_tarif_results  
    sub_tarif_sets_with_zero_results
  end
  
  def calculate_sub_tarif_sets_with_zero_results_1(services_to_not_excude)
#TODO разобраться откуда появляются tarif_result_by_part_and_service['price_value'] типа string
    sub_tarif_sets_with_zero_results = {}
    tarif_results.each do |tarif_set_id, tarif_results_by_part|
      zero_tarif_ids = []
      non_zero_tarif_ids = []     
      tarif_results_by_part.each do |part, tarif_result_by_part|
        tarif_result_by_part.each do |service_id, tarif_result_by_part_and_service|        
          if tarif_result_by_part_and_service['price_value'].to_f == 0 # and tarif_result_by_part_and_service['call_id_count'].to_i == 0
            zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - zero_tarif_ids)
          else
            non_zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - non_zero_tarif_ids)
          end
        end
      end

      zero_tarif_ids = zero_tarif_ids - non_zero_tarif_ids - services_to_not_excude

      if !zero_tarif_ids.blank?
        new_services = tarif_set_id.split('_').map(&:to_i) - zero_tarif_ids
        new_tarif_set_id = tarif_set_id(new_services)
        sub_tarif_sets_with_zero_results[tarif_set_id] = {:new_tarif_set_id => new_tarif_set_id, :new_services => new_services} if !tarif_results[new_tarif_set_id].blank?
      end
    end 
    
    sub_tarif_sets_with_zero_results
  end
  
  def reorder_tarif_sets(updated_tarif_sets, updated_tarif_results)    
    reordered_tarif_sets = {}
    updated_tarif_sets.each do |tarif, updated_tarif_sets_by_tarif|
      reordered_tarif_sets[tarif] ||= {}
      updated_tarif_sets_by_tarif.each do |part, updated_tarif_sets_by_part|
        reordered_tarif_sets[tarif][part] ||= {}
        updated_tarif_sets_by_part.keys.sort_by! do |u| 
          (cons_tarif_results_by_parts[u] and cons_tarif_results_by_parts[u][part]) ? cons_tarif_results_by_parts[u][part]['price_value'].to_f : 10000000.0
        end.each do |ordered_tarif_set_by_part_key|
          reordered_tarif_sets[tarif][part][ordered_tarif_set_by_part_key] = updated_tarif_sets[tarif][part][ordered_tarif_set_by_part_key] 
        end
      end
    end
    reordered_tarif_sets
  end
  
  def group_identical_tarif_sets(updated_tarif_sets, updated_tarif_results, services_to_not_excude, eliminate_identical_tarif_sets)
    @groupped_identical_services = {}
    depended_service_list = services_that_depended_on.values.flatten.map(&:to_s)
    updated_tarif_set_list = []

    updated_cons_tarif_results = calculate_updated_cons_tarif_results(updated_tarif_results)
    groupped_tarif_results = updated_cons_tarif_results.group_by do |updated_cons_tarif_result| 
      updated_cons_tarif_result[1]['group_criteria'].to_s + '__' + updated_cons_tarif_result[1]['parts'].join('_')  
    end
    groupped_tarif_results.each do |key, groupped_tarif_result_ids|
      services_to_leave_in_tarif_set_index = 0
      if groupped_tarif_result_ids.size > 1 and eliminate_identical_tarif_sets
        identical_tarif_sets = groupped_tarif_result_ids.map{|g| g[0]}
        identical_services = find_identical_services(identical_tarif_sets)
        services_to_leave_in_tarif_set = services_to_not_excude.map(&:to_s) & identical_services         
        if !services_to_leave_in_tarif_set.blank?
          identical_tarif_sets.each_index do |identical_tarif_set_index|
            identical_tarif_set = identical_tarif_sets[identical_tarif_set_index]
            if (services_to_leave_in_tarif_set - identical_tarif_set.split('_')).blank?
              services_to_leave_in_tarif_set_index = identical_tarif_set_index
              break
            end
          end
        end
        identical_services_without_depended = identical_services - depended_service_list - [""]
        if identical_services_without_depended.size > 0
          groupped_identical_services[identical_tarif_sets[services_to_leave_in_tarif_set_index]] = {
            :identical_services => identical_services, :identical_tarif_sets => identical_tarif_sets}
        end        
#    raise(StandardError) if key == "1456__own-country-rouming/sms_own-country-rouming/calls_own-country-rouming/mobile-connection_mms_periodic_onetime"
      end

      updated_tarif_set_list << groupped_tarif_result_ids[services_to_leave_in_tarif_set_index][0]
    end
    
    updated_tarif_sets, updated_tarif_results = update_tarif_sets_with_groupped_tarif_results(updated_tarif_sets, updated_tarif_results, updated_tarif_set_list)

#    raise(StandardError)
    [updated_tarif_sets, updated_tarif_results]
  end
  
  def calculate_updated_cons_tarif_results(updated_tarif_results)
    updated_cons_tarif_results = {}
    updated_tarif_results.each do |tarif_set_id, updated_tarif_result|
      updated_tarif_result.each do |part, updated_tarif_result_by_part|
        updated_cons_tarif_results[tarif_set_id] ||= {'price_value' => 0.0, 'call_id_count' => 0, 'group_criteria' => 0, 'parts' => [part]}
        updated_tarif_result_by_part.each do |service_id, updated_tarif_result_by_part_by_service|
          updated_cons_tarif_results[tarif_set_id]['price_value'] += updated_tarif_result_by_part_by_service['price_value'].to_f
          updated_cons_tarif_results[tarif_set_id]['call_id_count'] += updated_tarif_result_by_part_by_service['call_id_count'].to_i
          updated_cons_tarif_results[tarif_set_id]['parts'] << part
          updated_cons_tarif_results[tarif_set_id]['group_criteria'] += updated_tarif_result_by_part_by_service['price_value'].to_f.round(0).to_i #+
#          updated_cons_tarif_results[tarif_set_id]['group_criteria'] += (updated_tarif_result_by_part_by_service['price_value'].to_f / 5.0).round(0).to_i #+
#            updated_tarif_result_by_part_by_service['call_id_count'].to_i
        end
      end
    end
    updated_cons_tarif_results
  end
  
  def find_identical_services(groupped_tarif_result_ids)
    groupped_services_sets = groupped_tarif_result_ids.map{|groupped_tarif_result_id| groupped_tarif_result_id.split('_')}
    common_services = groupped_services_sets.reduce(:&)
    identical_services = groupped_services_sets.collect{|groupped_services_set| tarif_set_id(groupped_services_set - common_services)}
    identical_services
  end
  
  def update_tarif_sets_with_groupped_tarif_results(updated_tarif_sets, updated_tarif_results, updated_tarif_set_list)
    new_updated_tarif_sets = {}
    new_updated_tarif_results = {}
    excluded_tarif_result_ids = []
    updated_tarif_sets.each do |tarif, updated_tarif_sets_by_tarif|
      new_updated_tarif_sets[tarif] ||= {}
      updated_tarif_sets_by_tarif.each do |part, updated_tarif_sets_by_tarif_by_part|
        new_updated_tarif_sets[tarif][part] ||= {}
        if ['periodic', 'onetime'].include?(part)
          updated_tarif_sets_by_tarif_by_part.each do |tarif_set_id, services| 
            new_updated_tarif_sets[tarif][part][tarif_set_id] = services
          end
        else
          updated_tarif_sets_by_tarif_by_part.each do |tarif_set_id, services| 
            if updated_tarif_set_list.include?(tarif_set_id)
              new_updated_tarif_sets[tarif][part][tarif_set_id] = services
            else
              excluded_tarif_result_ids << tarif_set_id
            end
          end
        end
        new_updated_tarif_sets[tarif].extract!(part) if new_updated_tarif_sets[tarif][part].blank?
      end
    end if updated_tarif_sets

    new_updated_tarif_results = updated_tarif_results.clone
    excluded_tarif_result_ids.each do |tarif_set_id|
      new_updated_tarif_results.extract!(tarif_set_id)
    end
        
    [new_updated_tarif_sets, new_updated_tarif_results]
  end

  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end

  def tarif_set_id_with_part(tarif_ids, part)
    tarif_ids.collect {|tarif_id| "#{tarif_id}::#{part}" if tarif_id}.compact.join('_')
  end

end
