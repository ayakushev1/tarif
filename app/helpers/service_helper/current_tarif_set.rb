class ServiceHelper::CurrentTarifSet  
  attr_reader :tarif_sets_by_tarif, :cons_tarif_results_by_parts, :new_cons_tarif_results_by_parts, :tarif, :services_that_depended_on, :tarif_results
  attr_reader :parts, :tarif_sets_names_as_array, :tarif_sets_services_as_array, :tarif_sets_prices, :tarif_sets_counts
  attr_reader :max_part_index, :max_tarif_set_by_part_index, :tarif_price, :min_periodic_price, :services_that_depended_on_service_ids, :services_that_depended_on
  attr_reader :current_price, :best_possible_price
  attr_reader :current_part_index, :current_part, :current_tarif_set_by_part_index, :current_set_price
  attr_reader :history
  attr_reader :save_current_tarif_set_calculation_history, :part_sort_criteria_in_price_optimization,
              :use_price_comparison_in_current_tarif_set_calculation
  attr_reader :performance_checker
  
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
    @tarif_sets_by_tarif = options[:tarif_sets_by_tarif]
    @cons_tarif_results_by_parts = options[:cons_tarif_results_by_parts]
    @tarif = options[:tarif]
    @services_that_depended_on = options[:services_that_depended_on]
    @tarif_results = options[:tarif_results]
    @use_price_comparison_in_current_tarif_set_calculation = options[:use_price_comparison_in_current_tarif_set_calculation] == 'true' ? true : false
    @save_current_tarif_set_calculation_history = options[:save_current_tarif_set_calculation_history] == 'true' ? true : false
    @part_sort_criteria_in_price_optimization = options[:part_sort_criteria_in_price_optimization].to_sym
    @performance_checker = options[:performance_checker]
  end
  
  def init_calculation_params
  end
  
  def calculate_new_cons_tarif_results_by_parts
    @new_cons_tarif_results_by_parts = {}
    tarif_results.each do |tarif_set_id, tarif_result|
      new_cons_tarif_results_by_parts[tarif_set_id] ||= {}
      tarif_result.each do |part, tarif_result_by_part|
        new_cons_tarif_results_by_parts[tarif_set_id][part] ||= {'price_value' => 0.0, 'call_id_count' => 0}
        tarif_result_by_part.each do |service_id, tarif_result_by_part_by_service|
          new_cons_tarif_results_by_parts[tarif_set_id][part]['price_value'] += tarif_result_by_part_by_service['price_value'].to_f
          new_cons_tarif_results_by_parts[tarif_set_id][part]['call_id_count'] += tarif_result_by_part_by_service['call_id_count'].to_i
        end
      end
    end
  end
  
  def init_tarif_sets_as_array
    @tarif_price = 0.0
    if new_cons_tarif_results_by_parts.keys.include?(tarif)
      @tarif_price += new_cons_tarif_results_by_parts[tarif]['periodic']['price_value'].to_f if new_cons_tarif_results_by_parts[tarif] and new_cons_tarif_results_by_parts[tarif]['periodic']
      @tarif_price += new_cons_tarif_results_by_parts[tarif]['onetime']['price_value'].to_f if new_cons_tarif_results_by_parts[tarif] and new_cons_tarif_results_by_parts[tarif]['onetime']
    else
      periodic_fix_part = tarif_results.keys.map do |key| 
        if key.split('_').include?(tarif) and tarif_results[key].keys.include?('periodic') and tarif_results[key]['periodic'].keys.include?(tarif.to_i)
          @tarif_price += tarif_results[key]['periodic'][tarif.to_i]['price_value'].to_f
          break
        end
       end
      
      onetime_fix_part = tarif_results.keys.map do |key| 
        if key.split('_').include?(tarif) and tarif_results[key].keys.include?('onetime') and tarif_results[key]['onetime'].keys.include?(tarif.to_i)
          @tarif_price += tarif_results[key]['onetime'][tarif.to_i]['price_value'].to_f
          break
        end
       end       
    end

    @parts = (tarif_sets_by_tarif.keys - ['periodic', 'onetime']).sort_by do |part| 
      price_values = new_cons_tarif_results_by_parts.collect do |tarif_sets_name, new_cons_tarif_results_by_part| 
        result = 0.0
        result = new_cons_tarif_results_by_part[part]['price_value'].to_f if new_cons_tarif_results_by_part[part]
        result
      end.compact

      min_value = price_values.min
      max_value = price_values.max

      parts_sort_criteria(part_sort_criteria_in_price_optimization, part, min_value, max_value)
    end 

    @tarif_sets_names_as_array = []
    @tarif_sets_services_as_array = []
    @tarif_sets_prices = []
    @tarif_sets_counts = []
    parts.each_index do |part_index|
      part = parts[part_index]
      tarif_sets_by_part = tarif_sets_by_tarif[part]
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
    @tarif_sets_prices.each do |tarif_sets_prices_by_part|

    end     
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
      (max_value > 0) ? (1.0 - min_value / max_value) : 1.0
    when :reverse_min_value
      (-min_value)
    when :auto
      (tarif_price > 0.0) ? min_value : min_value
    else
      part
    end
  end
  
  def calculate_additional_values
    @services_that_depended_on_service_ids = services_that_depended_on.keys.map(&:to_i)
    @services_that_depended_on = services_that_depended_on

    @max_part_index = parts.size
    @max_tarif_set_by_part_index = tarif_sets_names_as_array.map{|ts| ts.size}
    all_services = tarif_sets_services_as_array.flatten
    all_services.uniq! if all_services
    @current_price = tarif_sets_prices.collect{|tarif_sets_price_by_parts| tarif_sets_price_by_parts.last}.sum + calculate_periodic_part_price_from_services(all_services)
    @prev_current_prices = [@current_price]
    @best_possible_price = 0.0
    @min_periodic_price = @tarif_price 
    
#    raise(StandardError)
  end
  
  def set_initial_current_values
    @current_part_index = 0
    @current_part = parts[current_part_index] if parts
    @current_tarif_set_by_part_index = [0] if current_part and tarif_sets_by_tarif[current_part]
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
    return_prev_best_current_price(if_current_tarif_set_by_part_fobbiden)
    move_forward_based_on_price = if use_price_comparison_in_current_tarif_set_calculation
      current_price < best_possible_price 
#      current_price < (best_possible_price - [best_possible_price * 0.01, 5].max)
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
      @current_set_price = calculate_current_price_for_chosen_parts(current_part_index)
      if @current_price > current_set_price
        @prev_current_prices << @current_price
        @current_price = current_set_price 
      end
    else
      @current_set_price = nil
    end

    calculate_best_possible_price(current_part_index) if current_part_index > -1
    update_history if save_current_tarif_set_calculation_history
  end
  
  def return_prev_best_current_price(if_current_tarif_set_by_part_fobbiden)
    return if !if_current_tarif_set_by_part_fobbiden
    return if current_part_index != max_part_index - 1
    if @prev_current_prices.size > 1
      @current_price = @prev_current_prices.pop
    else
      @current_price = @prev_current_prices[0]
    end     
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
    result
  end
  
  def calculate_possible_best_price_for_unchosen_parts(start_part_index)
    result = 0.0
    (start_part_index..(max_part_index - 1)).each do |part_index|
      result += tarif_sets_prices[part_index][0]
    end

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
    tarif_sets_services.uniq! if tarif_sets_services
    
    calculate_periodic_part_price_from_services(tarif_sets_services)
  end

  def calculate_periodic_part_price_from_services(tarif_sets_services)
    periodic_part_price = 0.0
    counted_depended_on_services = []
    
    (tarif_sets_services & services_that_depended_on_service_ids).each do |main_depended_service|
      if !(tarif_sets_services & services_that_depended_on[main_depended_service.to_s]).blank?
        new_periodic_services = [main_depended_service] + services_that_depended_on[main_depended_service.to_s]
        new_tarif_set_id = tarif_set_id(new_periodic_services)
        
        periodic_part_price += new_cons_tarif_results_by_parts[new_tarif_set_id]['periodic']['price_value'].to_f if new_cons_tarif_results_by_parts[new_tarif_set_id] and 
          new_cons_tarif_results_by_parts[new_tarif_set_id]['periodic']
        periodic_part_price += new_cons_tarif_results_by_parts[new_tarif_set_id]['onetime']['price_value'].to_f if new_cons_tarif_results_by_parts[new_tarif_set_id] and 
          new_cons_tarif_results_by_parts[new_tarif_set_id]['onetime']
        counted_depended_on_services += new_periodic_services
      end
    end
    
    (tarif_sets_services - counted_depended_on_services).uniq.each do |service|
      periodic_part_price += new_cons_tarif_results_by_parts[tarif_set_id([service])]['periodic']['price_value'].to_f if 
        new_cons_tarif_results_by_parts[tarif_set_id([service])] and new_cons_tarif_results_by_parts[tarif_set_id([service])]['periodic']
      periodic_part_price += new_cons_tarif_results_by_parts[tarif_set_id([service])]['onetime']['price_value'].to_f if 
        new_cons_tarif_results_by_parts[tarif_set_id([service])] and new_cons_tarif_results_by_parts[tarif_set_id([service])]['onetime']
    end
    periodic_part_price
  end

  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end
  
end
