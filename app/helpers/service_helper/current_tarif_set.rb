class ServiceHelper::CurrentTarifSet  
  attr_reader :tarif_sets_to_calculate_from_by_tarif, :cons_tarif_results_by_parts, :tarif
  attr_reader :parts, :tarif_sets_names_as_array, :tarif_sets_services_as_array, :tarif_sets_prices, :tarif_sets_counts
  attr_reader :max_part_index, :max_tarif_set_by_part_index, :min_periodic_price, :current_price, :best_possible_price
  attr_reader :current_part_index, :current_part, :current_tarif_set_by_part_index
  attr_reader :history
  
  def initialize(tarif_sets_to_calculate_from_by_tarif, cons_tarif_results_by_parts, tarif)
    @tarif_sets_to_calculate_from_by_tarif = tarif_sets_to_calculate_from_by_tarif
    @cons_tarif_results_by_parts = cons_tarif_results_by_parts
    @tarif = tarif
    @history = []
    init_tarif_sets_as_array
    calculate_max_values
    set_initial_current_values
    update_history
#    raise(StandardError)    
  end
  
  def init_tarif_sets_as_array
    @parts = tarif_sets_to_calculate_from_by_tarif.keys.sort - ['periodic']
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
        tarif_sets_prices_by_part << cons_tarif_results_by_parts[tarif_sets_name][part]['price_value'].to_f
        tarif_sets_counts_by_part << cons_tarif_results_by_parts[tarif_sets_name][part]['call_id_count'].to_i
      end
      @tarif_sets_prices << tarif_sets_prices_by_part
      @tarif_sets_counts << tarif_sets_counts_by_part
    end
#    raise(StandardError)
  end
  
  def calculate_max_values
    @max_part_index = parts.size
    @max_tarif_set_by_part_index = tarif_sets_names_as_array.map{|ts| ts.size}
    @current_price = tarif_sets_prices.collect{|tarif_sets_price_by_parts| tarif_sets_price_by_parts.last}.sum
    @best_possible_price = 0.0
    @min_periodic_price = cons_tarif_results_by_parts[tarif]['periodic']['price_value'].to_f
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
    i = 0
    current_tarif_set_by_part_index.each do |tsi| 
      result += tarif_sets_services_as_array[i][tsi]
      i += 1
    end       
    result
  end

  def next_tarif_set_by_part(if_current_tarif_set_by_part_fobbiden)
    if if_current_tarif_set_by_part_fobbiden or current_part_index == (max_part_index - 1) or current_price < best_possible_price
      if current_tarif_set_by_part_index[current_part_index] < (max_tarif_set_by_part_index[current_part_index] - 1)
        move_down
        raise(StandardError) if current_tarif_set_by_part_index.size != current_part_index + 1   #best_possible_price == 0.0
      else
        move_back_and_down
        raise(StandardError) if current_tarif_set_by_part_index and current_tarif_set_by_part_index.size != current_part_index + 1   #best_possible_price == 0.0
      end
    else
      move_forward
      raise(StandardError) if current_tarif_set_by_part_index and current_tarif_set_by_part_index.size != current_part_index + 1   #best_possible_price == 0.0
    end
    raise(StandardError) if current_tarif_set_by_part_index and current_tarif_set_by_part_index.size != current_part_index + 1   
    @current_part = parts[current_part_index]
    if current_part_index == max_part_index - 1
      new_price = calculate_current_price_for_chosen_parts(current_part_index)
      @current_price = new_price if @current_price > new_price 
    end
    calculate_best_possible_price(current_part_index) if current_part_index > -1
    update_history
#    raise(StandardError) if current_price > best_possible_price
  end
  
  def update_history
    count = if history.blank?
      0
    else
      history.last[:count]
    end    
    history << {
      :count => count + 1,
      :current_part_index => current_part_index,
      :current_price => current_price,
      :best_possible_price => best_possible_price,
      :current_tarif_set_by_part_index_to_s => current_tarif_set_by_part_index.to_s,
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
  end
  
  def calculate_current_price_for_chosen_parts(upper_part_index)
    result = 0.0
    current_tarif_set_by_part_index[0..upper_part_index].each_index do |part_index|
      result += tarif_sets_prices[part_index][current_tarif_set_by_part_index[part_index]]
    end
    result
  end
  
  def calculate_possible_best_price_for_unchosen_parts(start_part_index)
    result = 0.0
    current_tarif_set_by_part_index[start_part_index..(max_part_index - 1)].each_index do |part_index|
      result += tarif_sets_prices[part_index][0]
    end
    result
  end
  
end
