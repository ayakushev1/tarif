class TarifOptimization::FinalTarifSetGenerator  
  attr_reader :options             
  attr_accessor :final_tarif_sets 
  attr_accessor :current_tarif_set_calculation_history 
  attr_accessor :tarif_sets, :services_that_depended_on, :operator, :common_services, :common_services_by_parts,
                :cons_tarif_results_by_parts, :tarif_results, :cons_tarif_results, :groupped_identical_services,
                :performance_checker, :background_process_informer_tarif
  
  attr_reader :use_short_tarif_set_name
         
  attr_reader :max_tarif_set_count_per_tarif, :save_current_tarif_set_calculation_history
  
  def initialize(options = {} )
    @options = options    
    set_generation_params(options)
  end
    
  def set_generation_params(options)
    @use_short_tarif_set_name = options[:use_short_tarif_set_name] == 'true' ? true : false
#TODO Разобраться как использовать цену для выбора final_tarif_sets в случае оптимизации без common_services (true case below)
    @max_tarif_set_count_per_tarif = options[:max_tarif_set_count_per_tarif].to_i > 0 ? options[:max_tarif_set_count_per_tarif].to_i : 100 
    @save_current_tarif_set_calculation_history = options[:save_current_tarif_set_calculation_history] == 'true' ? true : false
  end
  
  def set_input_data(input_data)
    @tarif_sets = input_data[:tarif_sets].try(:stringify_keys)
    @services_that_depended_on = input_data[:services_that_depended_on].stringify_keys
    @operator = input_data[:operator]
    @common_services_by_parts = input_data[:common_services_by_parts].stringify_keys
    @common_services = input_data[:common_services].stringify_keys
    @cons_tarif_results_by_parts = input_data[:cons_tarif_results_by_parts]
    @tarif_results = input_data[:tarif_results]
    @cons_tarif_results = input_data[:cons_tarif_results]    
    @groupped_identical_services = input_data[:groupped_identical_services] #TODO убрать
    @performance_checker = input_data[:performance_checker]        
  end
  
  def calculate_final_tarif_sets(operator_1 = nil, tarif_1 = nil, background_process_informer_tarif = nil)
    @background_process_informer_tarif = background_process_informer_tarif
    tarif = tarif_1.to_s  

    @final_tarif_sets = {}

    current_uniq_service_sets = nil; fobidden_info = nil; best_current_uniq_service_sets = nil
    current_uniq_service_sets, fobidden_info, best_current_uniq_service_sets = calculate_final_tarif_sets_by_tarif(
      tarif_sets[tarif], operator, tarif, tarif_results)
    
    dd = {}
    current_uniq_service_sets.each{|k, v| dd[k] = v[:price] if !v[:fobidden] and v[:price] and v[:price] < 2100.0 }
    
    update_current_uniq_sets_with_periodic_part(current_uniq_service_sets, tarif_sets[tarif], best_current_uniq_service_sets)    


    raise(StandardError, [
      "",
      "tarif_sets[tarif], #{tarif_sets[tarif]}",
      "current_uniq_service_sets #{current_uniq_service_sets}",
      "@final_tarif_sets #{@final_tarif_sets}",      
      "best_current_uniq_service_sets #{best_current_uniq_service_sets}",
      "",
    ].join("\n\n")) if false
    ddd = {}
    current_uniq_service_sets.each{|k, v| ddd[k] = v[:price] if !v[:fobidden] and v[:price] and v[:price] < 2100.0 }

    load_current_uniq_service_sets_to_final_tarif_sets(current_uniq_service_sets, fobidden_info)

    raise(StandardError, [
      "",
      "tarif_sets[tarif], #{tarif_sets[tarif]}",
      "current_uniq_service_sets #{current_uniq_service_sets["174_102_442_102_174_102_442_174_102_442_174_102_444"]}",
      "@final_tarif_sets #{@final_tarif_sets}",      
      "tarif_results #{tarif_results and tarif_results}",
      "dd #{dd}}",
      "ddd #{ddd}}",
      "best_current_uniq_service_sets #{best_current_uniq_service_sets}",
      "",
    ].join("\n\n")) if false
    
  end
  
  def calculate_final_tarif_sets_by_tarif(tarif_sets_by_tarif, operator, tarif, tarif_results)
    best_current_uniq_service_sets = {:prices => [100000000000.0], :set_ids => [tarif.to_s]}
    current_uniq_service_sets = {}
    fobidden_info = {}
    
    
    current_tarif_set = nil
    current_tarif_set = TarifOptimization::CurrentTarifSet.new({
        :tarif_sets_by_tarif => tarif_sets_by_tarif, 
        :cons_tarif_results_by_parts => cons_tarif_results_by_parts, 
        :tarif => tarif.to_s,
        :services_that_depended_on => services_that_depended_on, 
        :tarif_results => tarif_results,
        :use_price_comparison_in_current_tarif_set_calculation => options[:use_price_comparison_in_current_tarif_set_calculation],
        :save_current_tarif_set_calculation_history => options[:save_current_tarif_set_calculation_history],
        :part_sort_criteria_in_price_optimization => options[:part_sort_criteria_in_price_optimization],
        :performance_checker => performance_checker,
      })
#    current_tarif_set.next_tarif_set_by_part(false)
        
    i = 0
    while !current_tarif_set.current_tarif_set_by_part_index.blank? do
      
      current_part = nil; current_services = nil; current_tarif_set_by_part_services = nil; current_tarif_set_by_part_name = nil; 
      common_services_to_exclude = nil; tarif_sets_by_part_services_list = nil;
      current_part = current_tarif_set.current_part
      current_services = current_tarif_set.current_services
      current_tarif_set_by_part_services = current_tarif_set.current_tarif_set_by_part_services
      current_tarif_set_by_part_name = tarif_set_id(current_tarif_set_by_part_services)
      
      common_services_to_exclude = (common_services_by_parts[operator.to_s][current_part] || [])
      tarif_sets_by_part_services_list = tarif_sets_by_tarif[current_part].
        collect{|tarif_set_by_part_id, services| services - common_services_to_exclude}.collect{|f| tarif_set_id(f).freeze}#.to_sym}

      if current_tarif_set.current_part_index == 0
        current_uniq_service_sets[current_tarif_set_by_part_name] = {
          :service_ids => current_tarif_set_by_part_services, :tarif_sets_by_part => [[current_part, current_tarif_set_by_part_name]], :tarif => tarif}              
        fobidden_info[current_tarif_set_by_part_name] = init_fobidden_info(tarif_sets_by_part_services_list, current_tarif_set_by_part_services - common_services_to_exclude, tarif.to_s.freeze)#.to_sym)
      else
        uniq_service_set = nil; uniq_service_set_id = nil; tarif_set_by_part_id = nil;
        uniq_service_set = current_tarif_set_by_part_services[0..(current_tarif_set_by_part_services.size - current_services.size - 1)] 
        uniq_service_set_id = tarif_set_id(uniq_service_set)
        tarif_set_by_part_id = tarif_set_id(current_services)
        
        current_uniq_service_sets[current_tarif_set_by_part_name] ||= {}
        current_uniq_service_sets[current_tarif_set_by_part_name][:service_ids] = current_tarif_set_by_part_services
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif] = tarif
        current_uniq_service_sets[current_tarif_set_by_part_name][:price] = current_tarif_set.current_set_price
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] ||= []
        
        current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden] = check_if_final_tarif_set_is_fobidden(
          fobidden_info, tarif_sets_by_part_services_list, current_tarif_set_by_part_name, uniq_service_set_id, tarif_set_by_part_id, current_services - common_services_to_exclude,
            current_uniq_service_sets, uniq_service_set, tarif_sets_by_tarif) 

        existing_tarif_sets_by_part = (current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] || [])                
        prev_tarif_sets_by_part = (current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] || [])
        current_uniq_service_sets[current_tarif_set_by_part_name][:tarif_sets_by_part] = 
          (existing_tarif_sets_by_part + prev_tarif_sets_by_part + [[current_part, tarif_set_by_part_id]]).uniq  
        
        if !current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden]
          if current_uniq_service_sets[current_tarif_set_by_part_name][:price]
            price_index = best_current_uniq_service_sets[:prices].index{|price| current_uniq_service_sets[current_tarif_set_by_part_name][:price] < price }
            if price_index
              best_current_uniq_service_sets[:prices].insert(price_index, current_uniq_service_sets[current_tarif_set_by_part_name][:price])
              best_current_uniq_service_sets[:set_ids].insert(price_index, current_tarif_set_by_part_name)
            end
            if price_index and best_current_uniq_service_sets[:set_ids].size > max_tarif_set_count_per_tarif
              best_current_uniq_service_sets[:prices].pop
              best_current_uniq_service_sets[:set_ids].pop
            end
          end
        end
      end

      current_tarif_set.next_tarif_set_by_part(current_uniq_service_sets[current_tarif_set_by_part_name][:fobidden])
    end 
    
    @current_tarif_set_calculation_history = current_tarif_set.history if save_current_tarif_set_calculation_history

    current_uniq_service_sets.each do |current_uniq_service_set_id, current_uniq_service_set|
      if current_uniq_service_set[:fobidden]
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end        
      
      if current_uniq_service_set[:tarif_sets_by_part].size < current_tarif_set.max_part_index
        current_uniq_service_sets.extract!(current_uniq_service_set_id)
      end
    end
    
    [current_uniq_service_sets, fobidden_info, best_current_uniq_service_sets]
  end

#tarif_results['200'].map{|p| p[1].map{|t| [t[1]['price_value'], t[1]['call_id_count']]}}


  def update_current_uniq_sets_with_periodic_part(current_uniq_service_sets, tarif_sets_by_tarif, best_current_uniq_service_sets)
    services_that_depended_on_service_ids = services_that_depended_on.keys.map(&:to_i)    

    current_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
      if !uniq_service_set[:fobidden] and best_current_uniq_service_sets[:set_ids].include?(uniq_service_set_id)
        counted_depended_on_services = []
        (uniq_service_set[:service_ids] & services_that_depended_on_service_ids).each do |main_depended_service|
          driving_services = (uniq_service_set[:service_ids] & services_that_depended_on[main_depended_service.to_s])
          driving_services.each do |driving_service|
            new_periodic_services = [main_depended_service, driving_service]
            new_tarif_set_id = tarif_set_id(new_periodic_services)
            current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['periodic', new_tarif_set_id] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
            current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['onetime', new_tarif_set_id] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
            counted_depended_on_services += new_periodic_services
          end if driving_services
        end
        
        (uniq_service_set[:service_ids] - counted_depended_on_services).uniq.each do |service|
          current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['periodic', tarif_set_id([service])] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
          current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] << (['onetime', tarif_set_id([service])] - current_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part])
        end
      else
        current_uniq_service_sets[uniq_service_set_id][:fobidden] = true
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
      
#    raise(StandardError)
      if !uniq_service_set[:fobidden]
        if !use_short_tarif_set_name and (final_tarif_sets[short_service_set_id] and (uniq_service_set_id != final_tarif_sets[short_service_set_id][:full_set_name]))
          final_tarif_sets[uniq_service_set_id] = uniq_service_set.merge(:full_set_name => uniq_service_set_id, :common_services => common_services)
        else
          final_tarif_sets[short_service_set_id] = uniq_service_set.merge(:full_set_name => uniq_service_set_id, :common_services => common_services)  
        end         
      end
    end
  end
  
  def init_fobidden_info(tarif_sets_by_part_services_list, services_without_common_services, tarif)
    services_without_common_services_name = tarif_set_id(services_without_common_services).freeze#.to_sym
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
      current_uniq_service_sets, uniq_service_set, tarif_sets_by_tarif) 
    services_without_common_services_name = tarif_set_id(services_without_common_services).freeze#.to_sym
    fobidden_info[new_uniq_service_set_name] ||= {}
    fobidden_info[new_uniq_service_set_name][:current_tarif_set_without_common_services] = services_without_common_services_name
    fobidden_info[new_uniq_service_set_name][:current_fobidden_services_without_common_services] = tarif_sets_by_part_services_list - [services_without_common_services_name]
    fc = fobidden_info[new_uniq_service_set_name]
    fp = fobidden_info[uniq_service_set_id]
    
#TODO оптимизировать эту часть расчета
    tarif_ids_from_tarif_set = []; tarif_ids_from_current_part = []
    fp[:tarif_sets_in_uniq_service_set_with_choice].each {|tarif_set| tarif_ids_from_tarif_set += (tarif_set.to_s.freeze.split('_'.freeze).map(&:freeze) - tarif_ids_from_tarif_set) }
    tarif_sets_by_part_services_list.each {|tarif_set| tarif_ids_from_current_part += (tarif_set.to_s.freeze.split('_'.freeze).map(&:freeze) - tarif_ids_from_current_part) }
    absent_tarif_ids = tarif_ids_from_tarif_set - tarif_ids_from_current_part
    
    adjusted_tarif_sets_in_uniq_service_set_with_choice = []
    fp[:tarif_sets_in_uniq_service_set_with_choice].each do |tarif_set|
      adusted_tarif_set_ids = tarif_set.to_s.split('_') - absent_tarif_ids
      adjusted_tarif_sets_in_uniq_service_set_with_choice << tarif_set_id(adusted_tarif_set_ids).freeze#.to_sym
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
      "tarif_sets_by_tarif #{tarif_sets_by_tarif.map{|t| {t[0] => t[1].keys}}}",
      
#                  "new_check #{new_check}",
#                  "old_check #{old_check}"
#                ].join("\n")) if old_check != current_uniq_service_sets[new_uniq_service_set_name][:fobidden]
    ].join("\n")) if new_uniq_service_set_name == '200_200_200_200_200_200_200_294_329_309_200_200_200_294_329_'
    condition
  end
    
  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_'.freeze).freeze
  end

  def tarif_set_id_with_part(tarif_ids, part)
    tarif_ids.collect {|tarif_id| "#{tarif_id}::#{part.freeze}" if tarif_id}.compact.join('_'.freeze).freeze
  end

end
