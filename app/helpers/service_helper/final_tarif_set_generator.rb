class ServiceHelper::FinalTarifSetGenerator  
  attr_reader :options             
  attr_accessor :final_tarif_sets, :tarif_sets_to_calculate_from_final_tarif_sets, :updated_tarif_results, :groupped_identical_services 
  attr_accessor :current_tarif_set_calculation_history 
  attr_accessor :tarif_sets_without_common_services, :tarif_sets, :services_that_depended_on, :service_description, :common_services, :common_services_by_parts,
                :cons_tarif_results_by_parts, :tarif_results, :cons_tarif_results
  
  attr_reader :use_short_tarif_set_name
         
  attr_reader :calculate_final_tarif_sets_first_without_common_services, :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results,
              :max_final_tarif_set_number, :eliminate_identical_tarif_sets
  
  def initialize(options = {} )
    @options = options
    
    set_generation_params(options)
  end
    
  def set_generation_params(options)
    @use_short_tarif_set_name = options[:use_short_tarif_set_name] == 'true' ? true : false
#TODO Разобраться как использовать цену для выбора final_tarif_sets в случае оптимизации без common_services (true case below)
    @calculate_final_tarif_sets_first_without_common_services = false      
    @eliminate_identical_tarif_sets = options[:eliminate_identical_tarif_sets] == 'true' ? true : false
    @if_update_tarif_sets_to_calculate_from_with_cons_tarif_results = options[:if_update_tarif_sets_to_calculate_from_with_cons_tarif_results] == 'true' ? true : false
    @max_final_tarif_set_number = options[:max_final_tarif_set_number].to_i < 1 ? 1000 : options[:max_final_tarif_set_number].to_i
  end
  
  def set_input_data(input_data)
    @tarif_sets_without_common_services = input_data[:tarif_sets_without_common_services]
    @tarif_sets = input_data[:tarif_sets]
    @services_that_depended_on = input_data[:services_that_depended_on]
    @service_description = input_data[:service_description]
    @common_services_by_parts = input_data[:common_services_by_parts]
    @common_services = input_data[:common_services]
    @service_description = input_data[:service_description]
    @cons_tarif_results_by_parts = input_data[:cons_tarif_results_by_parts]
    @tarif_results = input_data[:tarif_results]
    @cons_tarif_results = input_data[:cons_tarif_results]    
  end
  
  def calculate_final_tarif_sets(operator_1 = nil, tarif_1 = nil, background_process_informer_tarif = nil)
    tarif = tarif_1.to_s  
    operator = service_description[tarif]['operator_id'].to_s

    @final_tarif_sets = {}
#    raise(StandardError, @tarif_results['312_203']["own-country-rouming/mobile-connection"])
    tarif_sets_to_calculate_from = @calculate_final_tarif_sets_first_without_common_services ? tarif_sets_without_common_services : tarif_sets
    if if_update_tarif_sets_to_calculate_from_with_cons_tarif_results
      tarif_sets_to_calculate_from, updated_tarif_results = update_tarif_sets_to_calculate_from_with_cons_tarif_results(
        tarif_sets_to_calculate_from, operator)
    else
      updated_tarif_results = tarif_results.clone
    end

    current_uniq_service_sets, fobidden_info = calculate_final_tarif_sets_by_tarif(
      tarif_sets_to_calculate_from[tarif], operator, tarif, updated_tarif_results, background_process_informer_tarif)
    update_current_uniq_sets_with_periodic_part(current_uniq_service_sets, tarif_sets_to_calculate_from[tarif])
    load_current_uniq_service_sets_to_final_tarif_sets(current_uniq_service_sets, fobidden_info)

#TODO # проверить правильно ли исправил вариант (true, вариант считается чуть быстрее) когда in common_services есть новые parts    
    update_final_tarif_sets_with_common_services if calculate_final_tarif_sets_first_without_common_services 
    @tarif_sets_to_calculate_from_final_tarif_sets = tarif_sets_to_calculate_from
    @updated_tarif_results = updated_tarif_results
#    raise(StandardError)
  end
  
  def calculate_final_tarif_sets_by_tarif(tarif_sets_to_calculate_from_by_tarif, operator, tarif, updated_tarif_results, background_process_informer_tarif = nil)
    current_uniq_service_sets = {}
    fobidden_info = {}
    
    current_tarif_set = ServiceHelper::CurrentTarifSet.new({
        :tarif_sets_to_calculate_from_by_tarif => tarif_sets_to_calculate_from_by_tarif, 
        :cons_tarif_results_by_parts => cons_tarif_results_by_parts, 
        :tarif => tarif.to_s,
        :final_tarif_set_generator => self, 
        :updated_tarif_results => updated_tarif_results,
        :calculate_final_tarif_sets_first_without_common_services => calculate_final_tarif_sets_first_without_common_services,
        :use_price_comparison_in_current_tarif_set_calculation => options[:use_price_comparison_in_current_tarif_set_calculation],
        :save_current_tarif_set_calculation_history => options[:save_current_tarif_set_calculation_history],
        :part_sort_criteria_in_price_optimization => options[:part_sort_criteria_in_price_optimization],
      })
#    current_tarif_set.next_tarif_set_by_part(false)
        
    while !current_tarif_set.current_tarif_set_by_part_index.blank? do
#      raise(StandardError, [current_tarif_set_by_part_index, tarif_sets_services_as_array])
      current_part = current_tarif_set.current_part
      current_services = current_tarif_set.current_services
      current_tarif_set_by_part_services = current_tarif_set.current_tarif_set_by_part_services
      current_tarif_set_by_part_name = tarif_set_id(current_tarif_set_by_part_services)
      
      common_services_to_exclude = (common_services_by_parts[operator][current_part] || [])
      tarif_sets_by_part_services_list = tarif_sets_to_calculate_from_by_tarif[current_part].
        collect{|tarif_set_by_part_id, services| services - common_services_to_exclude}.collect{|f| tarif_set_id(f).to_sym}
      
      if current_tarif_set.current_part_index == 0
        current_uniq_service_sets[current_tarif_set_by_part_name] = {
          :service_ids => current_tarif_set_by_part_services, :tarif_sets_by_part => [[current_part, current_tarif_set_by_part_name]], :tarif => tarif}              
        fobidden_info[current_tarif_set_by_part_name] = init_fobidden_info(tarif_sets_by_part_services_list, current_tarif_set_by_part_services - common_services_to_exclude, tarif.to_s.to_sym)
      else
        uniq_service_set = current_tarif_set_by_part_services[0..(current_tarif_set_by_part_services.size - current_services.size - 1)] 
        uniq_service_set_id = tarif_set_id(uniq_service_set)
        tarif_set_by_part_id = tarif_set_id(current_services)
        
        current_uniq_service_sets[current_tarif_set_by_part_name] ||= {}
        current_uniq_service_sets[current_tarif_set_by_part_name][:service_ids] = current_tarif_set_by_part_services
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif] = tarif
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] ||= []
        
        current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden] = check_if_final_tarif_set_is_fobidden(
          fobidden_info, tarif_sets_by_part_services_list, current_tarif_set_by_part_name, uniq_service_set_id, tarif_set_by_part_id, current_services - common_services_to_exclude,
            current_uniq_service_sets, uniq_service_set, tarif_sets_to_calculate_from_by_tarif) 

        existing_tarif_sets_by_part = (current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] || [])                
        prev_tarif_sets_by_part = (current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] || [])
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] = 
          (existing_tarif_sets_by_part + prev_tarif_sets_by_part + [[current_part, tarif_set_by_part_id]]).uniq  
      end
      
#      raise(StandardError) if !current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden]
      current_tarif_set.next_tarif_set_by_part(current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden])
        
      background_process_informer_tarif.increase_current_value(1) if background_process_informer_tarif

    end 
#    raise(StandardError, current_uniq_service_sets)
    @current_tarif_set_calculation_history = current_tarif_set.history
#    raise(StandardError, [current_tarif_set.history.size, current_tarif_set.history].join("\n")) if tarif.to_i == 203
    current_uniq_service_sets.each do |current_uniq_service_set_id, current_uniq_service_set|
      if current_uniq_service_set[:fobidden]
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end        
      if current_uniq_service_set[:tarif_sets_by_part].size < current_tarif_set.max_part_index
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end
    end
    [current_uniq_service_sets, fobidden_info]
  end

#tarif_results['200'].map{|p| p[1].map{|t| [t[1]['price_value'], t[1]['call_id_count']]}}

  def update_tarif_sets_to_calculate_from_with_cons_tarif_results(tarif_sets_to_calculate_from, operator)
    excluded_tarif_sets = []
    tarifs = tarif_sets_to_calculate_from.keys.map(&:to_i)
#TODO проверить еще раз почему нельзя исключать common_services
    services_to_not_excude = common_services[operator] + tarifs

    sub_tarif_sets_with_zero_results_0 = calculate_sub_tarif_sets_with_zero_results_0(services_to_not_excude)
    sub_tarif_sets_with_zero_results_1 = calculate_sub_tarif_sets_with_zero_results_1(services_to_not_excude)
    updated_tarif_sets = {}
    tarif_sets_to_calculate_from.each do |tarif, tarif_sets_to_calculate_from_by_tarif|
      updated_tarif_sets[tarif] ||= {}
      tarif_sets_to_calculate_from_by_tarif.each do |part, tarif_sets_to_calculate_from_by_tarif_by_part|
#        next if part == 'periodic'
        updated_tarif_sets[tarif][part] ||= {}
        
        tarif_sets_to_calculate_from_by_tarif_by_part.each do |tarif_set_id, services|
          if (services & sub_tarif_sets_with_zero_results_0).blank?
            if sub_tarif_sets_with_zero_results_1[tarif_set_id]
# Предполагается что tarif_set_id должен быть в первоначальном tarif_sets_to_calculate_from
#              new_tarif_set_id = sub_tarif_sets_with_zero_results_1[tarif_set_id][:new_tarif_set_id]
#              new_services = sub_tarif_sets_with_zero_results_1[tarif_set_id][:new_services]
#              updated_tarif_sets[tarif][part][new_tarif_set_id] = new_services
            else
              updated_tarif_sets[tarif][part][tarif_set_id] = services 
            end            
          end
        end
        updated_tarif_sets[tarif].extract!(part) if updated_tarif_sets[tarif][part].blank?
      end
    end if tarif_sets_to_calculate_from
    
    updated_tarif_results = tarif_results.clone
    sub_tarif_sets_with_zero_results_1.each do |tarif_set_id|
      updated_tarif_results.extract!(tarif_set_id)
    end
    
#    raise(StandardError) if !updated_tarif_results.keys.include?('312_204')
#    raise(StandardError, [updated_tarif_results['336'].keys, nil,nil, tarif_results['336'].keys, nil,nil,nil, sub_tarif_sets_with_zero_results_1])
#    raise(StandardError, [updated_tarif_sets['200'], nil, tarif_sets_to_calculate_from['200'], nil, nil, sub_tarif_sets_with_zero_results_1])
    updated_tarif_sets = reorder_tarif_sets_to_calculate_from(updated_tarif_sets, updated_tarif_results)
#    raise(StandardError) if !updated_tarif_results.keys.include?('312_204')
    updated_tarif_sets, updated_tarif_results = group_identical_tarif_sets_to_calculate_from(updated_tarif_sets, updated_tarif_results, services_to_not_excude) if eliminate_identical_tarif_sets
#    raise(StandardError) if !updated_tarif_results.keys.include?('312_204')
#    raise(StandardError, [updated_tarif_results['336'].keys, nil,nil, tarif_results['336'].keys, nil,nil,nil, sub_tarif_sets_with_zero_results_1])
#    raise(StandardError, [updated_tarif_results.keys, nil,nil, tarif_results.keys, nil,nil,nil, sub_tarif_sets_with_zero_results_1])
    [updated_tarif_sets, updated_tarif_results]
  end
  
  def calculate_sub_tarif_sets_with_zero_results_0(services_to_not_excude)
#TODO подумать какие еще наборы услуг добавить
    depended_on_services = services_that_depended_on.map{|d| d[1]}.flatten.uniq
    sub_tarif_sets_with_zero_results = []
    cons_tarif_results.each do |tarif_set_id, cons_tarif_result|
      if cons_tarif_result['call_id_count'].to_i == 0 and cons_tarif_result['price_value'].to_f == 0.0
        services = tarif_set_id.split('_').map(&:to_i)
        sub_tarif_sets_with_zero_results += (services - services_to_not_excude - sub_tarif_sets_with_zero_results) if (services & depended_on_services).blank?
      end
    end if cons_tarif_results  
#    raise(StandardError, [sub_tarif_sets_with_zero_results])
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
          if tarif_result_by_part_and_service['call_id_count'].to_i == 0 and tarif_result_by_part_and_service['price_value'].to_f == 0
            zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - zero_tarif_ids)
          else
            non_zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - non_zero_tarif_ids)
#            raise(StandardError) if tarif_set_id == '200_292_' and non_zero_tarif_ids.include?(292)
          end
        end
      end
      zero_tarif_ids = zero_tarif_ids - non_zero_tarif_ids - services_to_not_excude
#      raise(StandardError) if tarif_set_id == '281_329'
      if !zero_tarif_ids.blank?
        new_services = tarif_set_id.split('_').map(&:to_i) - zero_tarif_ids
        new_tarif_set_id = tarif_set_id(new_services)
        sub_tarif_sets_with_zero_results[tarif_set_id] = {:new_tarif_set_id => new_tarif_set_id, :new_services => new_services} if !tarif_results[new_tarif_set_id].blank?
      end
    end 
    sub_tarif_sets_with_zero_results
  end
  
  def reorder_tarif_sets_to_calculate_from(updated_tarif_sets, updated_tarif_results)    
    reordered_tarif_sets = {}
    updated_tarif_sets.each do |tarif, updated_tarif_sets_by_tarif|
      reordered_tarif_sets[tarif] ||= {}
      updated_tarif_sets_by_tarif.each do |part, updated_tarif_sets_by_part|
        reordered_tarif_sets[tarif][part] ||= {}
        updated_tarif_sets_by_part.keys.sort_by!{|u| cons_tarif_results_by_parts[u][part]['price_value'].to_f }.each do |ordered_tarif_set_by_part_key|
          reordered_tarif_sets[tarif][part][ordered_tarif_set_by_part_key] = updated_tarif_sets[tarif][part][ordered_tarif_set_by_part_key] 
        end
      end
    end
    reordered_tarif_sets
  end
  
  def group_identical_tarif_sets_to_calculate_from(updated_tarif_sets, updated_tarif_results, services_to_not_excude)
    @groupped_identical_services = {}
    updated_tarif_set_list = []
    updated_cons_tarif_results = calculate_updated_cons_tarif_results(updated_tarif_results)
    groupped_tarif_results = updated_cons_tarif_results.group_by do |updated_cons_tarif_result| 
      updated_cons_tarif_result[1]['group_criteria'].to_s + '__' + updated_cons_tarif_result[1]['parts'].join('_')  
    end
    groupped_tarif_results.each do |key, groupped_tarif_result_ids|
      services_to_leave_in_tarif_set_index = 0
      if groupped_tarif_result_ids.size > 1
        identical_tarif_sets = groupped_tarif_result_ids.map{|g| g[0]}
        identical_services = find_identical_services(identical_tarif_sets)
        services_to_leave_in_tarif_set = services_to_not_excude.map(&:to_s) & identical_services         
        if !services_to_leave_in_tarif_set.blank?
          identical_tarif_sets.each_index do |identical_tarif_set_index|
            identical_tarif_set = identical_tarif_sets[identical_tarif_set_index]
#            raise(StandardError) if identical_tarif_set == '312_204'
            if (services_to_leave_in_tarif_set - identical_tarif_set.split('_')).blank?
              services_to_leave_in_tarif_set_index = identical_tarif_set_index
              break
            end
          end
        end
#        raise(StandardError) if identical_tarif_sets.include?('312_204')
        groupped_identical_services[identical_tarif_sets[services_to_leave_in_tarif_set_index]] = {:identical_services => identical_services, :identical_tarif_sets => identical_tarif_sets}        
      end
      updated_tarif_set_list << groupped_tarif_result_ids[services_to_leave_in_tarif_set_index][0]
#      raise(StandardError)
    end
    updated_tarif_sets, updated_tarif_results = update_tarif_sets_with_groupped_tarif_results(updated_tarif_sets, updated_tarif_results, updated_tarif_set_list)
#    raise(StandardError)
    [updated_tarif_sets, updated_tarif_results]
  end
  
  def calculate_updated_cons_tarif_results(updated_tarif_results)
    updated_cons_tarif_results = {}
    updated_tarif_results.each do |tarif_set_id, updated_tarif_result|
      updated_cons_tarif_results[tarif_set_id] ||= {'price_value' => 0.0, 'call_id_count' => 0, 'group_criteria' => 0, 'parts' => []}
      updated_tarif_result.each do |part, updated_tarif_result_by_part|
        updated_tarif_result_by_part.each do |service_id, updated_tarif_result_by_part_by_service|
          updated_cons_tarif_results[tarif_set_id]['price_value'] += updated_tarif_result_by_part_by_service['price_value'].to_f
          updated_cons_tarif_results[tarif_set_id]['call_id_count'] += updated_tarif_result_by_part_by_service['call_id_count'].to_i
          updated_cons_tarif_results[tarif_set_id]['parts'] << part
          updated_cons_tarif_results[tarif_set_id]['group_criteria'] += updated_tarif_result_by_part_by_service['price_value'].to_f * 1000.0.to_i +
            updated_tarif_result_by_part_by_service['call_id_count'].to_i
        end
      end
    end
    updated_cons_tarif_results
  end
  
  def find_identical_services(groupped_tarif_result_ids)
    groupped_services_sets = groupped_tarif_result_ids.map{|groupped_tarif_result_id| groupped_tarif_result_id.split('_')}
    common_services = groupped_services_sets.reduce(:&)
    identical_services = groupped_services_sets.collect{|groupped_services_set| tarif_set_id(groupped_services_set - common_services)}
#    raise(StandardError)
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
        updated_tarif_sets_by_tarif_by_part.each do |tarif_set_id, services|          
          if updated_tarif_set_list.include?(tarif_set_id)
            new_updated_tarif_sets[tarif][part][tarif_set_id] = services
          else
            excluded_tarif_result_ids << tarif_set_id
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

  def update_current_uniq_sets_with_periodic_part(current_uniq_service_sets, tarif_sets_to_calculate_from_by_tarif)
    services_that_depended_on_service_ids = services_that_depended_on.keys.map(&:to_i)    
    current_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
      if !uniq_service_set[:fobidden]
        counted_depended_on_services = []
        (uniq_service_set[:service_ids] & services_that_depended_on_service_ids).each do |main_depended_service|
          if !(uniq_service_set[:service_ids] & services_that_depended_on[main_depended_service.to_s]).blank?
            new_periodic_services = [main_depended_service] + services_that_depended_on[main_depended_service.to_s]
            new_tarif_set_id = tarif_set_id(new_periodic_services)
            current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['periodic', new_tarif_set_id] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
            counted_depended_on_services += new_periodic_services
          end
        end
        
        #raise(StandardError, [(uniq_service_set[:service_ids] - counted_depended_on_services)])
        (uniq_service_set[:service_ids] - counted_depended_on_services).uniq.each do |service|
          current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['periodic', tarif_set_id([service])] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
        end
      end
    end
  end
  
  def load_current_uniq_service_sets_to_final_tarif_sets(current_uniq_service_sets, fobidden_info)
    current_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
      fobidden_info_for_set = fobidden_info[uniq_service_set_id]

      if use_short_tarif_set_name
        short_service_set_id = tarif_set_id(uniq_service_set[:service_ids].uniq)
      else
        short_service_set_id = uniq_service_set_id
      end          
      
      if !uniq_service_set[:fobidden]
        if !use_short_tarif_set_name and (final_tarif_sets[short_service_set_id] and (uniq_service_set_id != final_tarif_sets[short_service_set_id][:full_set_name]))
          final_tarif_sets[uniq_service_set_id] = uniq_service_set.merge(:full_set_name => uniq_service_set_id)
        else
          final_tarif_sets[short_service_set_id] = uniq_service_set.merge(:full_set_name => uniq_service_set_id)  
        end
         
      end
    end
  end
  
  def init_fobidden_info(tarif_sets_by_part_services_list, services_without_common_services, tarif)
    services_without_common_services_name = tarif_set_id(services_without_common_services).to_sym
    current_fobidden_services_without_common_services = tarif_sets_by_part_services_list - [services_without_common_services_name]
    {
      :current_tarif_set_without_common_services => services_without_common_services_name,
      :current_fobidden_services_without_common_services => current_fobidden_services_without_common_services,
      :accumulated_forbidden_sets => current_fobidden_services_without_common_services,
      :tarif_sets_in_uniq_service_set_with_choice => (!current_fobidden_services_without_common_services.blank? ? [services_without_common_services_name] : []),
      :tarif_sets_in_uniq_service_set_with_no_choice => (current_fobidden_services_without_common_services.blank? ? 
        [services_without_common_services_name, tarif] : [tarif]),
      :accumulated_forbidden_sets_with_choice => current_fobidden_services_without_common_services,
      }
  end
  
  def check_if_final_tarif_set_is_fobidden(
    fobidden_info, tarif_sets_by_part_services_list, new_uniq_service_set_name, uniq_service_set_id, tarif_set_by_part_id, services_without_common_services,
      current_uniq_service_sets, uniq_service_set, tarif_sets_to_calculate_from_by_tarif) 
    services_without_common_services_name = tarif_set_id(services_without_common_services).to_sym
    fobidden_info[new_uniq_service_set_name] ||= {}
    fobidden_info[new_uniq_service_set_name][:current_tarif_set_without_common_services] = services_without_common_services_name
    fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services] = tarif_sets_by_part_services_list - [services_without_common_services_name]
    fc = fobidden_info[new_uniq_service_set_name]
    fp = fobidden_info[uniq_service_set_id]
    
#TODO оптимизировать эту часть расчета
    tarif_ids_from_tarif_set = []; tarif_ids_from_current_part = []
    fp[:tarif_sets_in_uniq_service_set_with_choice].each {|tarif_set| tarif_ids_from_tarif_set += (tarif_set.to_s.split('_') - tarif_ids_from_tarif_set) }
    tarif_sets_by_part_services_list.each {|tarif_set| tarif_ids_from_current_part += (tarif_set.to_s.split('_') - tarif_ids_from_current_part) }
    absent_tarif_ids = tarif_ids_from_tarif_set - tarif_ids_from_current_part
    
    adjusted_tarif_sets_in_uniq_service_set_with_choice = []
    fp[:tarif_sets_in_uniq_service_set_with_choice].each do |tarif_set|
      adusted_tarif_set_ids = tarif_set.to_s.split('_') - absent_tarif_ids
      adjusted_tarif_sets_in_uniq_service_set_with_choice << tarif_set_id(adusted_tarif_set_ids).to_sym
    end
    
    new_allowed_tarif_sets_in_uniq_service_set_with_choice = adjusted_tarif_sets_in_uniq_service_set_with_choice - fp[:tarif_sets_in_uniq_service_set_with_choice]
    
    condition_1 = (fp[:accumulated_forbidden_sets_with_choice] - new_allowed_tarif_sets_in_uniq_service_set_with_choice - 
      fp[:tarif_sets_in_uniq_service_set_with_no_choice]).include?(services_without_common_services_name)
    condition_2 = !(((adjusted_tarif_sets_in_uniq_service_set_with_choice - fp[:tarif_sets_in_uniq_service_set_with_no_choice]) & 
      fc[:current_fobidden_services_without_common_services]).blank?)
    condition = (condition_1 or condition_2)

#    return condition if condition

    fobidden_info[new_uniq_service_set_name][:accumulated_forbidden_sets] = fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets]  
    fobidden_info[new_uniq_service_set_name][:tarif_sets_in_uniq_service_set_with_choice] = fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_choice]  
    fobidden_info[new_uniq_service_set_name][:tarif_sets_in_uniq_service_set_with_no_choice] = fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_no_choice]  
    fobidden_info[new_uniq_service_set_name][:accumulated_forbidden_sets_with_choice] = fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets_with_choice]

    fobidden_info[new_uniq_service_set_name][:accumulated_forbidden_sets] = fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets] + 
      fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services] if
        !fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets].include?(fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services])
    
    fobidden_info[new_uniq_service_set_name][:accumulated_forbidden_sets_with_choice] = fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets] +
      (fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services] - fobidden_info[uniq_service_set_id][:accumulated_forbidden_sets])
    
    fobidden_info[new_uniq_service_set_name][:tarif_sets_in_uniq_service_set_with_choice] = fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_choice] + 
      ([fobidden_info[new_uniq_service_set_name][:current_tarif_set_without_common_services]] - fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_choice]) if
        !fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services].blank?
    
    fobidden_info[new_uniq_service_set_name][:tarif_sets_in_uniq_service_set_with_no_choice] = fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_no_choice] + 
      ([fobidden_info[new_uniq_service_set_name][:current_tarif_set_without_common_services]] - fobidden_info[uniq_service_set_id][:tarif_sets_in_uniq_service_set_with_no_choice]) if
        fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services].blank?

    raise(StandardError, [
      "new_uniq_service_set_name #{new_uniq_service_set_name}",
      "condition_1 #{condition_1}",
      "condition_2 #{condition_2}",
      "condition #{condition}",
      "",
      "for condition_1",
      ":accumulated_forbidden_sets_with_choice #{fp[:accumulated_forbidden_sets_with_choice]}",
      "new_allowed_tarif_sets_in_uniq_service_set_with_choice #{new_allowed_tarif_sets_in_uniq_service_set_with_choice}", 
      ":tarif_sets_in_uniq_service_set_with_no_choice #{fp[:tarif_sets_in_uniq_service_set_with_no_choice]}",
      "services_without_common_services_name #{services_without_common_services_name}",
      "",
      "for condition_2",
      "tarif_ids_from_tarif_set #{tarif_ids_from_tarif_set}",
      "tarif_ids_from_current_part #{tarif_ids_from_current_part}",
      "adjusted_tarif_sets_in_uniq_service_set_with_choice #{adjusted_tarif_sets_in_uniq_service_set_with_choice}",
      ":tarif_sets_in_uniq_service_set_with_choice #{fp[:tarif_sets_in_uniq_service_set_with_choice]}",
      ":tarif_sets_in_uniq_service_set_with_no_choice #{fp[:tarif_sets_in_uniq_service_set_with_no_choice]}",
      ":current_fobidden_services_without_common_services #{fc[:current_fobidden_services_without_common_services]}",
      "",
      ":accumulated_forbidden_sets #{fp[:accumulated_forbidden_sets]}",
      ":current_tarif_set_without_common_services #{fc[:current_tarif_set_without_common_services]}",
      "",
      "tarif_sets_by_part_services_list #{tarif_sets_by_part_services_list}",
      "uniq_service_set[:tarif_sets_by_part] #{current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part]}",
      "current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] #{current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part]}",
      "tarif_sets_to_calculate_from_by_tarif #{tarif_sets_to_calculate_from_by_tarif.map{|t| {t[0] => t[1].keys}}}",
      
#                  "new_check #{new_check}",
#                  "old_check #{old_check}"
#                ].join("\n")) if old_check != current_uniq_service_sets[new_uniq_service_set_name][:fobidden]
    ].join("\n")) if new_uniq_service_set_name == '200_200_200_200_200_200_200_294_329_309_200_200_200_294_329_'
    condition
  end
  
  def update_final_tarif_sets_with_common_services
    dup_final_tarif_sets = final_tarif_sets.clone
    @final_tarif_sets = {}
    dup_final_tarif_sets.each do |final_tarif_set_id, final_tarif_set|
      operator = service_description[final_tarif_set_id.split('_')[0].to_s]['operator_id'].to_s      
      common_services_to_add = (common_services[operator] || [])
      final_tarif_set_services_with_common_services = common_services_to_add + final_tarif_set[:service_ids] 
      if use_short_tarif_set_name
        final_tarif_set_id_with_common_services = tarif_set_id(final_tarif_set_services_with_common_services.uniq)
      else
        final_tarif_set_id_with_common_services = tarif_set_id(final_tarif_set_services_with_common_services)
      end      

      final_tarif_sets[final_tarif_set_id_with_common_services] ||= {}
      final_tarif_sets[final_tarif_set_id_with_common_services][:service_ids] = final_tarif_set_services_with_common_services
      final_tarif_sets[final_tarif_set_id_with_common_services][:fobidden] = final_tarif_set[:fobidden]

      final_tarif_set[:tarif_sets_by_part].each do |tarif_sets_by_part|
        final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] ||= []
        part = tarif_sets_by_part[0]
        if part == 'periodic'
          (common_services_by_parts[operator][part] || []).each do |common_service|
            final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] <<
              [part, tarif_set_id(common_service)] 
          end
        end
#        else
          common_services_by_part_to_add = (common_services_by_parts[operator][part] || [])
          tarif_sets_by_part_with_common_services = common_services_by_part_to_add + tarif_sets_by_part[1].split('_')
          tarif_sets_by_part_with_common_services_id = tarif_set_id(tarif_sets_by_part_with_common_services)
        
          final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] <<
            [part, tarif_sets_by_part_with_common_services_id] 
#          raise(StandardError) if part == 'periodic'
#        end
      end if final_tarif_set[:tarif_sets_by_part]      
    end
#    raise(StandardError)
  end
  
  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end

  def tarif_set_id_with_part(tarif_ids, part)
    tarif_ids.collect {|tarif_id| "#{tarif_id}::#{part}" if tarif_id}.compact.join('_')
  end

end
