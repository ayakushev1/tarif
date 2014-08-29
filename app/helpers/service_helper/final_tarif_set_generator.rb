class ServiceHelper::FinalTarifSetGenerator  
  attr_reader :options             
  attr_accessor :final_tarif_sets                
  attr_accessor :tarif_sets_without_common_services, :tarif_sets, :services_that_depended_on, :service_description, :common_services, :common_services_by_parts 
  
  attr_reader :use_short_tarif_set_name
         
  attr_reader :calculate_final_tarif_sets_first_without_common_services, :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results,
              :max_final_tarif_set_number
  
  def initialize(options = {} )
    @options = options
    
    set_generation_params(options)
  end
    
  def set_generation_params(options)
    @use_short_tarif_set_name = options[:use_short_tarif_set_name] == 'true' ? true : false
    @calculate_final_tarif_sets_first_without_common_services = true      
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
  end
  
  def calculate_final_tarif_sets(cons_tarif_results = {}, tarif_results = {}, operator_1 = nil, tarif_1 = nil)
    @final_tarif_sets = {}
    tarif_sets_to_calculate_from = @calculate_final_tarif_sets_first_without_common_services ? tarif_sets_without_common_services : tarif_sets
    tarif_sets_to_calculate_from = update_tarif_sets_to_calculate_from_with_cons_tarif_results(
      tarif_sets_to_calculate_from, cons_tarif_results, tarif_results) if if_update_tarif_sets_to_calculate_from_with_cons_tarif_results
#    raise(StandardError, [tarif_sets_without_common_services['200'], tarif_sets_to_calculate_from['200']].join("\n"))  
    (operator_1 ? [operator_1] : operators).each do |operator|     
      (tarif_1 ? [tarif_1] : tarifs[operator]).each do |tarif_2|
        tarif = tarif_2.to_s  
        operator = service_description[tarif]['operator_id'].to_s
        current_uniq_service_sets, fobidden_info = calculate_final_tarif_sets_by_tarif(tarif_sets_to_calculate_from[tarif], operator, tarif)
        update_current_uniq_sets_with_periodic_part(current_uniq_service_sets, tarif_sets_to_calculate_from[tarif])
        load_current_uniq_service_sets_to_final_tarif_sets(current_uniq_service_sets, fobidden_info)
      end
    end
#TODO # проверить правильно ли исправил вариант (true, вариант считается чуть быстрее) когда in common_services есть новые parts    
    update_final_tarif_sets_with_common_services if calculate_final_tarif_sets_first_without_common_services 
  end
  
  def calculate_final_tarif_sets_by_tarif(tarif_sets_to_calculate_from_by_tarif, operator, tarif)
    parts, tarif_sets_names_as_array, tarif_sets_services_as_array = init_tarif_sets_as_array(tarif_sets_to_calculate_from_by_tarif)
    current_uniq_service_sets = {}
    fobidden_info = {}
    max_part_index = parts.size
    max_tarif_set_by_part_index = tarif_sets_names_as_array.map{|ts| ts.size}

    current_part_index = 0
    current_part = parts[current_part_index] if parts
    current_tarif_set_by_part_index = [0] if current_part and tarif_sets_to_calculate_from_by_tarif[current_part]
        
    while !current_tarif_set_by_part_index.blank? do
#      raise(StandardError, [current_tarif_set_by_part_index, tarif_sets_services_as_array])
      current_part = parts[current_part_index]
      current_services = tarif_sets_services_as_array[current_part_index][current_tarif_set_by_part_index[current_part_index]]
      current_tarif_set_by_part_services = []
      i = 0
      current_tarif_set_by_part_index.each do |tsi| 
        current_tarif_set_by_part_services += tarif_sets_services_as_array[i][tsi]
        i += 1
      end       
      current_tarif_set_by_part_name = tarif_set_id(current_tarif_set_by_part_services)
      
      common_services_to_exclude = (common_services_by_parts[operator][current_part] || [])
      tarif_sets_by_part_services_list = tarif_sets_to_calculate_from_by_tarif[current_part].
        collect{|tarif_set_by_part_id, services| services - common_services_to_exclude}.collect{|f| tarif_set_id(f).to_sym}
      
      if current_part_index == 0
        current_uniq_service_sets[current_tarif_set_by_part_name] = {:service_ids => current_tarif_set_by_part_services, :tarif_sets_by_part => [[current_part, current_tarif_set_by_part_name]], }              
        fobidden_info[current_tarif_set_by_part_name] = init_fobidden_info(tarif_sets_by_part_services_list, current_tarif_set_by_part_services - common_services_to_exclude, tarif.to_s.to_sym)
      else
        new_uniq_services = current_services
        new_uniq_service_set_services = current_tarif_set_by_part_services
        new_uniq_service_set_name = current_tarif_set_by_part_name
        
        uniq_service_set = new_uniq_service_set_services[0..(new_uniq_service_set_services.size - current_services.size - 1)] 
        uniq_service_set_id = tarif_set_id(uniq_service_set)
        tarif_set_by_part_id = tarif_set_id(current_services)
        
        current_uniq_service_sets[new_uniq_service_set_name] ||= {}
        current_uniq_service_sets[new_uniq_service_set_name][:service_ids] = new_uniq_service_set_services
        current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] ||= []
        
        current_uniq_service_sets[new_uniq_service_set_name][:fobidden] = check_if_final_tarif_set_is_fobidden(
          fobidden_info, tarif_sets_by_part_services_list, new_uniq_service_set_name, uniq_service_set_id, tarif_set_by_part_id, current_services - common_services_to_exclude,
            current_uniq_service_sets, uniq_service_set, tarif_sets_to_calculate_from_by_tarif) 

        existing_tarif_sets_by_part = (current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] || [])                
        prev_tarif_sets_by_part = (current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] || [])
        current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] = 
          (existing_tarif_sets_by_part + prev_tarif_sets_by_part + [[current_part, tarif_set_by_part_id]]).uniq  
      end


      current_part_index, current_tarif_set_by_part_index = calculate_next_tarif_set_by_part(
        parts, tarif_sets_names_as_array, current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden], max_part_index, max_tarif_set_by_part_index, current_part_index, current_tarif_set_by_part_index)

    end 
#    raise(StandardError, current_uniq_service_sets)
    current_uniq_service_sets.each do |current_uniq_service_set_id, current_uniq_service_set|
      if current_uniq_service_set[:fobidden]
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end        
      if current_uniq_service_set[:tarif_sets_by_part].size < max_part_index
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end
    end
    [current_uniq_service_sets, fobidden_info]
  end
  
  def init_tarif_sets_as_array(tarif_sets_to_calculate_from_by_tarif)
    parts = tarif_sets_to_calculate_from_by_tarif.keys - ['periodic']
    tarif_sets_names_as_array = []
    tarif_sets_services_as_array = []
    tarif_sets_to_calculate_from_by_tarif.each do |part, tarif_sets_by_part|
      tarif_sets_names_as_array << tarif_sets_by_part.keys
      tarif_sets_services_as_array << tarif_sets_by_part.map{|ts| ts[1]}
    end
    [parts, tarif_sets_names_as_array, tarif_sets_services_as_array]
  end
  
  def calculate_next_tarif_set_by_part(parts, tarif_sets_names_as_array, if_current_tarif_set_by_part_fobbiden, max_part_index, max_tarif_set_by_part_index, current_part_index, current_tarif_set_by_part_index)
    next_tarif_set_by_part_index = []
    if if_current_tarif_set_by_part_fobbiden
      if current_tarif_set_by_part_index[current_part_index] < (max_tarif_set_by_part_index[current_part_index] - 1)
        next_part_index = current_part_index
        next_tarif_set_by_part_index = current_tarif_set_by_part_index
        next_tarif_set_by_part_index[current_part_index] = current_tarif_set_by_part_index[current_part_index] + 1
      else
        next_part_index = current_part_index - 1
        if next_part_index > -1 and current_tarif_set_by_part_index[next_part_index] < (max_tarif_set_by_part_index[next_part_index] - 1)
          next_tarif_set_by_part_index = current_tarif_set_by_part_index[0..next_part_index]
          next_tarif_set_by_part_index[next_part_index] = current_tarif_set_by_part_index[next_part_index] + 1
        end
        while  (next_part_index > -1) and next_tarif_set_by_part_index.blank? do
          next_part_index = next_part_index - 1
          if next_part_index > -1 and current_tarif_set_by_part_index[next_part_index] < (max_tarif_set_by_part_index[next_part_index] - 1)
            next_tarif_set_by_part_index = current_tarif_set_by_part_index[0..next_part_index]
            next_tarif_set_by_part_index[next_part_index] = current_tarif_set_by_part_index[next_part_index] + 1
          end
        end
      end
    else
      if current_part_index < (max_part_index - 1)
        next_part_index = current_part_index + 1
        next_tarif_set_by_part_index = current_tarif_set_by_part_index << 0
      else
        if current_tarif_set_by_part_index[current_part_index] < (max_tarif_set_by_part_index[current_part_index] - 1)
          next_part_index = current_part_index
          next_tarif_set_by_part_index = current_tarif_set_by_part_index
          next_tarif_set_by_part_index[current_part_index] = current_tarif_set_by_part_index[current_part_index] + 1
        else
          next_part_index = current_part_index - 1
          if next_part_index > -1 and current_tarif_set_by_part_index[next_part_index] < (max_tarif_set_by_part_index[next_part_index] - 1)
            next_tarif_set_by_part_index = current_tarif_set_by_part_index[0..next_part_index]
            next_tarif_set_by_part_index[next_part_index] = current_tarif_set_by_part_index[next_part_index] + 1
          end
          while  (next_part_index > -1) and next_tarif_set_by_part_index.blank? do
            next_part_index = next_part_index - 1
            if next_part_index > -1 and current_tarif_set_by_part_index[next_part_index] < (max_tarif_set_by_part_index[next_part_index] - 1)
              next_tarif_set_by_part_index = current_tarif_set_by_part_index[0..next_part_index]
              next_tarif_set_by_part_index[next_part_index] = current_tarif_set_by_part_index[next_part_index] + 1
            end
          end
        end
      end
    end
    [next_part_index, next_tarif_set_by_part_index]
  end
  
  def calculate_final_tarif_sets_by_tarif_1(tarif_sets_to_calculate_from_by_tarif, operator, tarif)
    current_uniq_service_sets = {}
    fobidden_info = {}
    tarif_sets_to_calculate_from_by_tarif.each do |part, tarif_sets_by_part|
      next if part == 'periodic'
      common_services_to_exclude = (common_services_by_parts[operator][part] || [])
      if current_uniq_service_sets.blank?
        tarif_sets_by_part_services_list = tarif_sets_by_part.collect{|tarif_set_by_part_id, services| services - common_services_to_exclude}.collect{|f| tarif_set_id(f).to_sym}
        tarif_sets_by_part.each do |tarif_set_by_part_id, services|
          current_uniq_service_sets[tarif_set_by_part_id] = {:service_ids => services, :tarif_sets_by_part => [[part, tarif_set_by_part_id]], }              
          fobidden_info[tarif_set_by_part_id] = init_fobidden_info(tarif_sets_by_part_services_list, services - common_services_to_exclude, tarif.to_s.to_sym)
        end 
      else            
        prev_uniq_service_sets = {}
        current_uniq_service_sets.each do |current_uniq_service_set_id, current_uniq_service_set|
          prev_uniq_service_sets[current_uniq_service_set_id] = current_uniq_service_set if !current_uniq_service_set[:fobidden]
        end
        current_uniq_service_sets = {}
        prev_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
          tarif_sets_by_part_services_list = tarif_sets_by_part.collect{|tarif_set_by_part_id, services| services - common_services_to_exclude}.collect{|f| tarif_set_id(f).to_sym}
          tarif_sets_by_part.each do |tarif_set_by_part_id, services|
            next if part == 'periodic'
            new_uniq_services = services
            new_uniq_service_set_services = (uniq_service_set[:service_ids] + new_uniq_services)
            new_uniq_service_set_name = tarif_set_id(new_uniq_service_set_services)
            
            current_uniq_service_sets[new_uniq_service_set_name] ||= {}
            current_uniq_service_sets[new_uniq_service_set_name][:service_ids] = new_uniq_service_set_services
            current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] ||= []
            
            current_uniq_service_sets[new_uniq_service_set_name][:fobidden] = check_if_final_tarif_set_is_fobidden(
              fobidden_info, tarif_sets_by_part_services_list, new_uniq_service_set_name, uniq_service_set_id, tarif_set_by_part_id, services - common_services_to_exclude,
                current_uniq_service_sets, uniq_service_set, tarif_sets_to_calculate_from_by_tarif) 

            next if current_uniq_service_sets[new_uniq_service_set_name][:fobidden]
            
            existing_tarif_sets_by_part = (current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] || [])                
            prev_tarif_sets_by_part = (prev_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] || [])
            current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] = 
              (existing_tarif_sets_by_part + prev_tarif_sets_by_part + [[part, tarif_set_by_part_id]]).uniq  
              
          end
        end            
      end
    end if tarif_sets_to_calculate_from_by_tarif  
    [current_uniq_service_sets, fobidden_info]
  end
  
  def update_tarif_sets_to_calculate_from_with_cons_tarif_results(tarif_sets_to_calculate_from, cons_tarif_results, tarif_results)
#    raise(StandardError, [cons_tarif_results])
    sub_tarif_sets_with_zero_results_0 = calculate_sub_tarif_sets_with_zero_results_0(cons_tarif_results)
#    sub_tarif_sets_with_zero_results_1 = calculate_sub_tarif_sets_with_zero_results_1(tarif_results)
    
    updated_tarif_sets = {}
    tarif_sets_to_calculate_from.each do |tarif, tarif_sets_to_calculate_from_by_tarif|
      updated_tarif_sets[tarif] ||= {}
      tarif_sets_to_calculate_from_by_tarif.each do |part, tarif_sets_to_calculate_from_by_tarif_by_part|
#        next if part == 'periodic'
        updated_tarif_sets[tarif][part] ||= {}
        tarif_sets_to_calculate_from_by_tarif_by_part.each do |tarif_set_id, services|          
#            raise(StandardError) if tarif_set_id == '200_294_297_309'
          if (services & sub_tarif_sets_with_zero_results_0).blank?
            sub_tarif_sets_with_zero_results_1 = calculate_sub_tarif_sets_with_zero_results_1(tarif_results, tarif_set_id)
            updated_tarif_sets[tarif][part][tarif_set_id] = services if !sub_tarif_sets_with_zero_results_1.include?(tarif_set_id)
          end
#          raise(StandardError, [sub_tarif_sets_with_zero_results_1]) if tarif_set_id == '200_293_281_294_329'
        end
        updated_tarif_sets[tarif].extract!(part) if updated_tarif_sets[tarif][part].blank?
      end
    end if tarif_sets_to_calculate_from
#    raise(StandardError, [tarif_sets_to_calculate_from['200'], updated_tarif_sets['200']].join("\n"))
    updated_tarif_sets
  end
  
  def calculate_sub_tarif_sets_with_zero_results_0(cons_tarif_results)
#TODO подумать какие еще наборы услуг добавить
    depended_on_services = services_that_depended_on.map{|d| d[1]}.flatten.uniq
    sub_tarif_sets_with_zero_results = []
    cons_tarif_results.each do |tarif_set_id, cons_tarif_result|
      if cons_tarif_result['call_id_count'] == 0 and cons_tarif_result['price_value'] == 0
        services = tarif_set_id.split('_').map(&:to_i)
        sub_tarif_sets_with_zero_results += (services - sub_tarif_sets_with_zero_results) if (services & depended_on_services).blank?
      end
    end if cons_tarif_results  
#    raise(StandardError, [sub_tarif_sets_with_zero_results_0, services_that_depended_on])
    sub_tarif_sets_with_zero_results
  end
  
  def calculate_sub_tarif_sets_with_zero_results_1(tarif_results, tarif_set_id)
    sub_tarif_sets_with_zero_results = []
    if tarif_results
      tarif_results_by_part =  tarif_results[tarif_set_id]
      zero_tarif_ids = []
      non_zero_tarif_ids = []     
      tarif_results_by_part.each do |part, tarif_result_by_part|
        tarif_result_by_part.each do |service_id, tarif_result_by_part_and_service|        
            raise(StandardError) if tarif_set_id == '200_294_297_309'
          if tarif_result_by_part_and_service['call_id_count'] == 0 and tarif_result_by_part_and_service['price_value'] == 0
            zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - zero_tarif_ids)
          else
            non_zero_tarif_ids += ([tarif_result_by_part_and_service['tarif_class_id'].to_i] - non_zero_tarif_ids)
          end
        end
      end
      zero_tarif_ids = zero_tarif_ids - non_zero_tarif_ids
      if !zero_tarif_ids.blank?
        new_services = tarif_set_id.split('_').map(&:to_i) - zero_tarif_ids
        new_tarif_set_id = tarif_set_id(new_services)
        sub_tarif_sets_with_zero_results << tarif_set_id if !tarif_results[new_tarif_set_id].blank?
      end
    end 
    sub_tarif_sets_with_zero_results
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
            current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << ['periodic', new_tarif_set_id]
            counted_depended_on_services += new_periodic_services
          end
        end
        
        #raise(StandardError, [(uniq_service_set[:service_ids] - counted_depended_on_services)])
        (uniq_service_set[:service_ids] - counted_depended_on_services).uniq.each do |service|
          current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << ['periodic', tarif_set_id([service])]
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
        else
          common_services_by_part_to_add = (common_services_by_parts[operator][part] || [])
          tarif_sets_by_part_with_common_services = common_services_by_part_to_add + tarif_sets_by_part[1].split('_')
          tarif_sets_by_part_with_common_services_id = tarif_set_id(tarif_sets_by_part_with_common_services)
        
          final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] <<
            [part, tarif_sets_by_part_with_common_services_id] 
        end
      end if final_tarif_set[:tarif_sets_by_part]      
    end
  end
  
  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end

  def tarif_set_id_with_part(tarif_ids, part)
    tarif_ids.collect {|tarif_id| "#{tarif_id}::#{part}" if tarif_id}.compact.join('_')
  end

end
