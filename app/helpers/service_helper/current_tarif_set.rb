class ServiceHelper::CurrentTarifSet  
  attr_reader :tarif_sets_to_calculate_from_by_tarif, :cons_tarif_results_by_parts, :new_cons_tarif_results_by_parts, :tarif, :final_tarif_set_generator, :updated_tarif_results
  attr_reader :parts, :tarif_sets_names_as_array, :tarif_sets_services_as_array, :tarif_sets_prices, :tarif_sets_counts
  attr_reader :max_part_index, :max_tarif_set_by_part_index, :tarif_price, :min_periodic_price, :services_that_depended_on_service_ids, :services_that_depended_on
  attr_reader :current_price, :best_possible_price
  attr_reader :current_part_index, :current_part, :current_tarif_set_by_part_index, :current_set_price
  attr_reader :history
  attr_reader :save_current_tarif_set_calculation_history, :part_sort_criteria_in_price_optimization,
              :use_price_comparison_in_current_tarif_set_calculation, :calculate_final_tarif_sets_first_without_common_services
  
  def initialize(options)    
    @history = []
    init_input_data(options)
    init_calculation_params
    calculate_new_cons_tarif_results_by_parts
    init_tarif_sets_as_array
    calculate_additional_values
    set_initial_current_values
    update_history
#    raise(StandardError)    
  end
  
  def init_input_data(options)
    @tarif_sets_to_calculate_from_by_tarif = options[:tarif_sets_to_calculate_from_by_tarif]
    @cons_tarif_results_by_parts = options[:cons_tarif_results_by_parts]
    @tarif = options[:tarif]
    @final_tarif_set_generator = options[:final_tarif_set_generator]
    @updated_tarif_results = options[:updated_tarif_results]
    @calculate_final_tarif_sets_first_without_common_services = options[:calculate_final_tarif_sets_first_without_common_services]
    @use_price_comparison_in_current_tarif_set_calculation = options[:use_price_comparison_in_current_tarif_set_calculation] == 'true' ? true : false
    @save_current_tarif_set_calculation_history = options[:save_current_tarif_set_calculation_history] == 'true' ? true : false
    @part_sort_criteria_in_price_optimization = options[:part_sort_criteria_in_price_optimization].to_sym
  end
  
  def init_calculation_params
  end
  
  def calculate_new_cons_tarif_results_by_parts
#    raise(StandardError, [updated_tarif_results])
    @new_cons_tarif_results_by_parts = {}
    updated_tarif_results.each do |tarif_set_id, updated_tarif_result|
      new_cons_tarif_results_by_parts[tarif_set_id] ||= {}
      updated_tarif_result.each do |part, updated_tarif_result_by_part|
        new_cons_tarif_results_by_parts[tarif_set_id][part] ||= {'price_value' => 0.0, 'call_id_count' => 0}
        updated_tarif_result_by_part.each do |service_id, updated_tarif_result_by_part_by_service|
          new_cons_tarif_results_by_parts[tarif_set_id][part]['price_value'] += updated_tarif_result_by_part_by_service['price_value'].to_f
          new_cons_tarif_results_by_parts[tarif_set_id][part]['call_id_count'] += updated_tarif_result_by_part_by_service['call_id_count'].to_i
        end
      end
    end
#    raise(StandardError, [new_cons_tarif_results_by_parts])
  end
  
  def init_tarif_sets_as_array
    @tarif_price = new_cons_tarif_results_by_parts[tarif]['periodic']['price_value'].to_f
    @parts = tarif_sets_to_calculate_from_by_tarif.keys.sort_by do |part| 
      min_value = new_cons_tarif_results_by_parts.collect do |tarif_sets_name, new_cons_tarif_results_by_part| 
        new_cons_tarif_results_by_part[part]['price_value'].to_f if new_cons_tarif_results_by_part[part]
      end.compact.min
      max_value = new_cons_tarif_results_by_parts.collect do |tarif_sets_name, new_cons_tarif_results_by_part| 
        new_cons_tarif_results_by_part[part]['price_value'].to_f if new_cons_tarif_results_by_part[part]
      end.compact.max
      parts_sort_criteria(part_sort_criteria_in_price_optimization, part, min_value, max_value)
    end - ['periodic']
    @tarif_sets_names_as_array = []
    @tarif_sets_services_as_array = []
    @tarif_sets_prices = []
    @tarif_sets_counts = []
    parts.each_index do |part_index|
      part = parts[part_index]
      tarif_sets_by_part = tarif_sets_to_calculate_from_by_tarif[part]
      tarif_sets_names_as_array << tarif_sets_by_part.keys
      tarif_sets_services_as_array << tarif_sets_by_part.map{|ts| ts[1]}
      tarif_sets_prices_by_part = []
      tarif_sets_counts_by_part = []
      tarif_sets_names_as_array[part_index].each do |tarif_sets_name|
        tarif_sets_prices_by_part << new_cons_tarif_results_by_parts[tarif_sets_name][part]['price_value'].to_f
        tarif_sets_counts_by_part << new_cons_tarif_results_by_parts[tarif_sets_name][part]['call_id_count'].to_i
        
      end
      @tarif_sets_prices << tarif_sets_prices_by_part
      @tarif_sets_counts << tarif_sets_counts_by_part
    end
#    raise(StandardError, [new_cons_tarif_results_by_parts.keys - @tarif_sets_names_as_array.flatten])
  end
  
  def parts_sort_criteria(sort_type, part, min_value, max_value)
    case sort_type
    when :max_value
      max_value
    when :min_value
      min_value
    when :min_max_difference
      max_value - min_value
    when :min_max_difference_to_max_value
      max_value > 0 ? 1.0 - min_value / max_value : 1.0
    when :reverse_min_value
      -min_value
    when :auto
#      raise(StandardError)
      tarif_price > 0.0 ? (max_value > 0 ? 1.0 - min_value / max_value : 1.0) : min_value
    else
      part
    end
  end
  
  def calculate_additional_values
    @services_that_depended_on_service_ids = final_tarif_set_generator.services_that_depended_on.keys.map(&:to_i)
    @services_that_depended_on = final_tarif_set_generator.services_that_depended_on

    @max_part_index = parts.size
    @max_tarif_set_by_part_index = tarif_sets_names_as_array.map{|ts| ts.size}
    all_services = tarif_sets_services_as_array.flatten
    @current_price = tarif_sets_prices.collect{|tarif_sets_price_by_parts| tarif_sets_price_by_parts.last}.sum + calculate_periodic_part_price_from_services(all_services)
    @best_possible_price = 0.0
    @min_periodic_price = @tarif_price 
    
#    raise(StandardError)
  end
  
  def set_initial_current_values
    @current_part_index = 0
    @current_part = parts[current_part_index] if parts
    @current_tarif_set_by_part_index = [0] if current_part and tarif_sets_to_calculate_from_by_tarif[current_part]
  end
  
  def current_services
    tarif_sets_services_as_array[current_part_index][current_tarif_set_by_part_index[current_part_index]] || []
  end
  
  def current_tarif_set_by_part_services
    result = []
    current_tarif_set_by_part_index.each_index do |part_index|
      result += tarif_sets_services_as_array[part_index][current_tarif_set_by_part_index[part_index]]
    end if current_tarif_set_by_part_index
    result
  end

  def next_tarif_set_by_part(if_current_tarif_set_by_part_fobbiden)
    move_forward_based_on_price = if use_price_comparison_in_current_tarif_set_calculation
      current_price < best_possible_price
    else
      false
    end
    if if_current_tarif_set_by_part_fobbiden or current_part_index == (max_part_index - 1) or move_forward_based_on_price
      if current_tarif_set_by_part_index[current_part_index] < (max_tarif_set_by_part_index[current_part_index] - 1)
        move_down
      else
        move_back_and_down
      end
    else
      move_forward
    end
    raise(StandardError) if current_tarif_set_by_part_index and current_tarif_set_by_part_index.size != current_part_index + 1   
    @current_part = parts[current_part_index]
    if current_part_index == max_part_index - 1
      @current_set_price = calculate_current_price_for_chosen_parts(current_part_index)# + calculate_periodic_part_price(current_part_index)
      @current_price = current_set_price if @current_price > current_set_price 
    else
      @current_set_price = nil
    end
    calculate_best_possible_price(current_part_index) if current_part_index > -1
    update_history if save_current_tarif_set_calculation_history
#    raise(StandardError) if current_price < 1209.0 
#    @new_price
  end
  
  def update_history
    count = history.blank? ? 0 : history.last[:count]
    
    history << {
      :count => count + 1,
      :part_index => current_part_index,
#      :services => current_tarif_set_by_part_services.flatten,
      :current_price => current_price,
      :best_price => best_possible_price,
      :periodic => calculate_possible_best_price_for_unchosen_parts(current_part_index),
      :tarif_set_by_part_index => current_tarif_set_by_part_index.to_s,
    }
  end  
  
  def move_down
    @current_tarif_set_by_part_index[current_part_index] = current_tarif_set_by_part_index[current_part_index] + 1
  end
  
  def move_forward
    @current_part_index += 1
    @current_tarif_set_by_part_index << 0
  end
  
  def move_back_and_down
    next_part_index = current_part_index
    begin 
      next_part_index = next_part_index - 1
      if next_part_index > -1 and current_tarif_set_by_part_index[next_part_index] < (max_tarif_set_by_part_index[next_part_index] - 1)
        next_tarif_set_by_part_index = current_tarif_set_by_part_index[0..next_part_index]
        next_tarif_set_by_part_index[next_part_index] = next_tarif_set_by_part_index[next_part_index] + 1
      end
    end while  (next_part_index > -1) and next_tarif_set_by_part_index.blank?
    @current_part_index = next_part_index 
    @current_tarif_set_by_part_index = next_tarif_set_by_part_index
  end

  def calculate_best_possible_price(current_part_index)
    @best_possible_price = calculate_current_price_for_chosen_parts(current_part_index) + calculate_possible_best_price_for_unchosen_parts(current_part_index + 1)
    raise(StandardError) if tarif_sets_services_as_array[0..current_part_index].flatten.include?(tarif.to_i) and
      !tarif_sets_services_as_array[0..(current_part_index)].flatten.include?(tarif.to_i)
  end
  
  def calculate_current_price_for_chosen_parts(upper_part_index)
    result = 0.0
    current_tarif_set_by_part_index[0..upper_part_index].each_index do |part_index|
      result += tarif_sets_prices[part_index][current_tarif_set_by_part_index[part_index]]
    end
    result += calculate_periodic_part_price(upper_part_index)
    if tarif_sets_services_as_array[0..upper_part_index].flatten.include?(tarif.to_i)
#      result += tarif_price
    end
    result
  end
  
  def calculate_possible_best_price_for_unchosen_parts(start_part_index)
    result = 0.0
    (start_part_index..(max_part_index - 1)).each do |part_index|
      result += tarif_sets_prices[part_index][0]
    end
#      raise(StandardError)
    if !tarif_sets_services_as_array[0..(start_part_index - 1)].flatten.include?(tarif.to_i)
      result += tarif_price
    end
    result
  end

  def calculate_periodic_part_price(upper_part_index)
    tarif_sets_services = []
    current_tarif_set_by_part_index[0..upper_part_index].each_index do |part_index|
      tarif_sets_services += tarif_sets_services_as_array[part_index][current_tarif_set_by_part_index[part_index]]
    end if current_tarif_set_by_part_index
    tarif_sets_services.flatten!
    
    calculate_periodic_part_price_from_services(tarif_sets_services)
  end

  def calculate_periodic_part_price_from_services(tarif_sets_services)
    periodic_part_price = 0.0
    counted_depended_on_services = []
    
    (tarif_sets_services & services_that_depended_on_service_ids).each do |main_depended_service|
      if !(tarif_sets_services & services_that_depended_on[main_depended_service.to_s]).blank?
        new_periodic_services = [main_depended_service] + services_that_depended_on[main_depended_service.to_s]
        new_tarif_set_id = tarif_set_id(new_periodic_services)
        
        periodic_part_price += new_cons_tarif_results_by_parts[new_tarif_set_id]['periodic']['price_value'].to_f
        counted_depended_on_services += new_periodic_services
      end
    end
    
    (tarif_sets_services - counted_depended_on_services).uniq.each do |service|
      periodic_part_price += new_cons_tarif_results_by_parts[tarif_set_id([service])]['periodic']['price_value'].to_f if 
        new_cons_tarif_results_by_parts[tarif_set_id([service])] and new_cons_tarif_results_by_parts[tarif_set_id([service])]['periodic']
    end
#    raise(StandardError) if current_part_index == 9
    periodic_part_price
  end

  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end
  
end
