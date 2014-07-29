class ServiceHelper::CurrentTarifOptimizationResults
  attr_reader :tarif_optimizator, :performance_checker, :options
  attr_reader :service_ids_to_calculate, :cons_tarif_results, :cons_tarif_results_by_parts, :tarif_results, :tarif_results_ord, :prev_service_call_ids, 
              :prev_service_group_call_ids, :prev_service_call_ids_by_parts#, :calls_count_by_parts
  attr_reader :save_tarif_results_ord
  
  def initialize(tarif_optimizator, options = {})
    self.extend Helper
    @options = options
    @tarif_optimizator = tarif_optimizator
    
    @tarif_results_ord = {}
    @cons_tarif_results = {}
    @cons_tarif_results_by_parts = {}
    @tarif_results = {}
    @prev_service_call_ids = {}
    @prev_service_call_ids_by_parts = {}
    @prev_service_group_call_ids = {}
    init_inputs_from_tarif_optimizator
  end
  
  def init_inputs_from_tarif_optimizator
    @performance_checker = tarif_optimizator.performance_checker || ServiceHelper::PerformanceChecker.new()
    @save_tarif_results_ord = tarif_optimizator.save_tarif_results_ord || true
#    @operator_id = operator#tarif_list_generator.operators[operator_index]
  end
  
  def process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
    performance_checker.run_check_point('process_tarif_results_batch', 5) do
      executed_tarif_result_batch_sql.each do |stat|
        tarif_class_id = stat['tarif_class_id']
        tarif_set_id = stat['set_id']
        part = stat['part']
    
        process_tarif_results_batch_tarif_resuts_ord(tarif_set_id, tarif_class_id, part, stat, price_formula_order) if save_tarif_results_ord
        process_tarif_results_batch_tarif_resuts(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
        process_tarif_results_batch_prev_calls(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
        process_tarif_results_batch_prev_calls_by_parts(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
        process_tarif_results_batch_prev_group_calls(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
      end if executed_tarif_result_batch_sql
    end
  end
  
  def process_tarif_results_batch_tarif_resuts_ord(tarif_set_id, tarif_class_id, part, stat, price_formula_order)    
    tarif_results_ord[tarif_set_id] ||= {}; tarif_results_ord[tarif_set_id][part] ||= {}; tarif_results_ord[tarif_set_id][part][tarif_class_id] ||= {}
    tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order] = stat
    tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids'] = flatten_call_ids_as_string(stat['call_ids'])

    #raise(StandardError, tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids']) if ['276_203_283', '203_283'].include?(tarif_set_id) and 
    #tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids'].include?(5224) 
  end
  
  def process_tarif_results_batch_tarif_resuts(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
    tarif_results[tarif_set_id] ||= {}
    tarif_results[tarif_set_id][part] ||= {}
#    current_tarif_results_ord = tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]   
#    if price_formula_order == 0          
    if tarif_results[tarif_set_id][part][tarif_class_id].blank?
      tarif_results[tarif_set_id][part][tarif_class_id] = stat            

    else
      tarif_results[tarif_set_id][part][tarif_class_id]['call_id_count'] += stat['call_id_count'] #if tarif_optimizator.output_call_count_to_tarif_results
      tarif_results[tarif_set_id][part][tarif_class_id]['price_value'] += (stat['price_value'] || 0)
      tarif_results[tarif_set_id][part][tarif_class_id]['price_values'] << (stat['price_values'] || 0)
    end

    raise(StandardError, [stat['call_id_count'].to_i, 
      tarif_results[tarif_set_id][part][tarif_class_id]['call_id_count'].to_i,
      ]) if stat['price_values'].map{|p| p['service_category_name']}.include?('_sctcg__own_home_regions_calls_to_own_country_own_operator') and
      tarif_set_id == '200_309_' and part == 'own-country-rouming/calls' and tarif_class_id == 200
  end

  def process_tarif_results_batch_prev_calls(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
    prev_service_call_ids[tarif_set_id] ||= {};  
    prev_service_call_ids[tarif_set_id][part] ||= {};  
    prev_service_call_ids[tarif_set_id][part][tarif_class_id] ||= [] 
#    current_tarif_results_ord = tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]  
#    if price_formula_order == 0              
    if tarif_results[tarif_set_id][part][tarif_class_id].blank?
      prev_service_call_ids[tarif_set_id][part][tarif_class_id] = stat['call_ids']            
    else
      prev_service_call_ids[tarif_set_id][part][tarif_class_id] += stat['call_ids'] #if tarif_optimizator.output_call_ids_to_tarif_results
    end
    prev_service_call_ids[tarif_set_id][part][tarif_class_id] += (prev_service_call_ids[tarif_set_id][part][tarif_class_id] || [] )
    prev_service_call_ids[tarif_set_id][part][tarif_class_id].uniq!
  end

  def process_tarif_results_batch_prev_calls_by_parts(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
    prev_service_call_ids_by_parts[tarif_set_id] ||= {};   
    prev_service_call_ids_by_parts[tarif_set_id][part] ||= {}#[];   
#    current_tarif_results_ord = tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]  

    prev_service_call_ids_by_parts[tarif_set_id][part] ||= []
    prev_service_call_ids_by_parts[tarif_set_id][part] += prev_service_call_ids[tarif_set_id][part][tarif_class_id]
    prev_service_call_ids_by_parts[tarif_set_id][part].uniq!
  end

  def process_tarif_results_batch_prev_group_calls(tarif_set_id, tarif_class_id, part, stat, price_formula_order)
#    current_tarif_results_ord = tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]  
    stat['price_values'].each do |price_value| 
      next if !price_value['all_stat']
      category_group_id = price_value['service_category_group_id']
      month = price_value['all_stat']['month']
      raise(StandardError, [price_value.keys] ) unless category_group_id
      if category_group_id > -1
        prev_service_group_call_ids[tarif_set_id][part] ||= {}
        prev_service_group_call_ids[tarif_set_id][part][category_group_id] ||= {}
        prev_service_group_call_ids[tarif_set_id][part][category_group_id][month] ||= {}
        prev_service_group_call_ids[tarif_set_id][part][category_group_id][month]['call_ids'] ||= []
        prev_service_group_call_ids[tarif_set_id][part][category_group_id][month]['call_ids'] += (price_value['call_ids'] || [] )
        prev_service_group_call_ids[tarif_set_id][part][category_group_id][month]['call_ids'].uniq!
        
#TODO разобраться с price_formula
        price_formula_id = tarif_optimizator.stat_function_collector.service_group_stat[part][price_formula_order][category_group_id][:price_formula_id]
        price_formula = tarif_optimizator.stat_function_collector.price_formula(price_formula_id)

        price_formula['stat_params'].each  do |stat_key, stat_function| 
          prev_service_group_call_ids[tarif_set_id][part][category_group_id][month][stat_key] ||= 0
          if price_value["all_stat"][stat_key]# and price_value["all_stat"]['service_category_group_id'] == category_group_id
            prev_service_group_call_ids[tarif_set_id][part][category_group_id][month][stat_key] += price_value["all_stat"][stat_key]
          end 
        end if price_formula['stat_params']# stat_function_collector.service_stat[price_formula_order][:category_groups][:groups][category_group_id][:stat_params]
      end
    end unless stat['price_values'].blank? 
    
    raise(StandardError, [
#      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order],
#      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order].attributes,
      prev_service_call_ids[tarif_set_id][part][tarif_class_id],
      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids']
    ]) if tarif_set_id == '200_309_' and tarif_class_id == 200 and part == 'own-country-rouming/calls'
    
  end

  def set_current_results(current_service_slice)
    performance_checker.run_check_point('set_current_tarif_results', 3) do
      i = 0
      @service_ids_to_calculate = []#{:ids => [], :set_ids => [], :parts => []}
      current_service_slice[:ids].each do |service_id|      
        tarif_set_id = current_service_slice[:set_ids][i]
        prev_tarif_set_id = current_service_slice[:prev_set_ids][i]
        part = current_service_slice[:parts][i] 
        

        init_current_results_hashes_first_step(tarif_set_id)     
        if !(tarif_results[tarif_set_id] and tarif_results[tarif_set_id][part])
        end

        if !tarif_results[tarif_set_id] or !tarif_results[tarif_set_id][part] or !tarif_results[tarif_set_id][part][service_id]
#    raise(StandardError, tarif_results[tarif_set_id][part]) if part == "own-country-rouming/calls" and tarif_set_id == "276_200"
          init_current_results_hashes_second_step(tarif_set_id, part)
          set_current_service_ids_to_calculate(tarif_set_id, part, service_id)
          
          if tarif_results[prev_tarif_set_id] and tarif_results[prev_tarif_set_id][part]
            set_current_tarif_results_ord(tarif_set_id, prev_tarif_set_id, service_id) if save_tarif_results_ord
            set_current_prev_service_call_ids(tarif_set_id, prev_tarif_set_id, service_id)
            set_current_prev_service_group_call_ids(tarif_set_id, prev_tarif_set_id, service_id)
            set_current_prev_service_call_ids_by_parts(tarif_set_id, prev_tarif_set_id, service_id)
            set_current_tarif_results(tarif_set_id, prev_tarif_set_id, service_id)
    raise(StandardError, [service_id, prev_tarif_set_id, part, tarif_results[prev_tarif_set_id][part],
      current_service_slice]) if false and tarif_set_id == '312_203_283'  
          end
        end
        i += 1
#    raise(StandardError, [ tarif_results['203']]) if tarif_set_id == '203_283'  
      end if current_service_slice  
    end
  end
  
  def init_current_results_hashes_first_step(tarif_set_id)
    tarif_results_ord[tarif_set_id] ||= {} if save_tarif_results_ord
    prev_service_call_ids[tarif_set_id] ||= {}    
    prev_service_call_ids_by_parts[tarif_set_id] ||= {}    
    prev_service_group_call_ids[tarif_set_id] ||= {}    
    tarif_results[tarif_set_id] ||= {}
  end

  def init_current_results_hashes_second_step(tarif_set_id, part)
    tarif_results_ord[tarif_set_id][part] ||= {} if save_tarif_results_ord
    prev_service_call_ids[tarif_set_id][part] ||= {}
    prev_service_call_ids_by_parts[tarif_set_id][part] ||= []
    prev_service_group_call_ids[tarif_set_id][part] ||= {}
    tarif_results[tarif_set_id][part] ||= {}
  end
  
  def set_current_tarif_results_ord(tarif_set_id, prev_tarif_set_id, service_id)
    tarif_results_ord[prev_tarif_set_id].each do |part, prev_tarif_results_by_part|
      tarif_results_ord[tarif_set_id][part] ||= {}      
      prev_tarif_results_by_part.each do |key_ord, prev_tarif_results_ord_val|
        tarif_results_ord[tarif_set_id][part][key_ord] ||= {}
        prev_tarif_results_ord_val.each do |key, prev_tarif_result_ord| 
#          if tarif_results_ord[tarif_set_id][part][key_ord][key]
#            raise(StandardError) if tarif_results_ord[tarif_set_id][part][key_ord][key]['part'] != prev_tarif_result_ord['part']
#            raise(StandardError) if tarif_results_ord[tarif_set_id][part][key_ord][key]['tarif_class_id'] != prev_tarif_result_ord['tarif_class_id']
#            tarif_results_ord[tarif_set_id][part][key_ord][key]['call_ids'] += prev_tarif_result_ord['call_ids']
#            if tarif_results_ord[tarif_set_id][part][key_ord][key]['call_ids'].uniq!
#              tarif_results_ord[tarif_set_id][part][key_ord][key]['call_id_count'] = tarif_results_ord[tarif_set_id][part][key_ord][key]['call_ids'].count
#            end
#            tarif_results_ord[tarif_set_id][part][key_ord][key]['price_value'] += prev_tarif_result_ord['price_value']
#            tarif_results_ord[tarif_set_id][part][key_ord][key]['call_id_count'] += prev_tarif_result_ord['call_id_count']
#            raise(StandardError) if tarif_results_ord[tarif_set_id][part][key_ord][key]['set_id'] != prev_tarif_result_ord['set_id']
#            tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'] += prev_tarif_result_ord['price_values']

=begin            
            raise(StandardError) if tarif_results_ord[tarif_set_id][part][key_ord][key]['call_ids'].include?(5224) or tarif_results_ord[tarif_set_id][part][key_ord][key]['call_ids'].include?('5224')
            prev_tarif_result_ord['price_values'].each do |price_value_item|
              raise(StandardError) if price_value_item['call_ids'].include?(5224) or price_value_item['call_ids'].include?('5224')
              prev_price_value_item_uniq_key = "#{price_value_item['service_category_tarif_class_id']}_#{price_value_item['service_category_group_id']}_#{price_value_item['month']}_#{price_value_item['price_formula_id']}"
              tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'].each_index do |current_price_value_index|
                current_price_value_item = tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'][current_price_value_index]
                current_price_value_item_uniq_key = "#{current_price_value_item['service_category_tarif_class_id']}_#{current_price_value_item['service_category_group_id']}_#{current_price_value_item['month']}_#{current_price_value_item['price_formula_id']}"
                raise(StandardError) if current_price_value_item['call_ids'].include?(5224) or current_price_value_item['call_ids'].include?('5224')
                if current_price_value_item_uniq_key == prev_price_value_item_uniq_key
#                  tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'][current_price_value_index]['call_ids'] += price_value_item['call_ids']
#                  tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'][current_price_value_index]['call_ids'].uniq
                else
                  tarif_results_ord[tarif_set_id][part][key_ord][key]['price_values'] << price_value_item
                end 
              end              
            end
=end            
#          else
            tarif_results_ord[tarif_set_id][part][key_ord][key] = prev_tarif_result_ord
#          end               
        end
      end
    end          
  end
  
  def set_current_prev_service_call_ids(tarif_set_id, prev_tarif_set_id, service_id)
    tarif_results[prev_tarif_set_id].each do |part, prev_tarif_result_by_part| 
      prev_service_call_ids[tarif_set_id] ||= {}
      prev_tarif_result_by_part.each do |tarif_class_id, prev_tarif_result| 
        prev_service_call_ids[tarif_set_id][part] ||= {}
#TODO нужно ли правильно обрабатывать так как уже не пустой        #raise(StandardError, "prev_service_call_ids[tarif_set_id][part][tarif_class_id]") if prev_service_call_ids[tarif_set_id][part][tarif_class_id]
        prev_service_call_ids[tarif_set_id][part][tarif_class_id] = (prev_service_call_ids_by_parts[prev_tarif_set_id][part] || [] )
      end
    end
  end
  
  def set_current_prev_service_call_ids_by_parts(tarif_set_id, prev_tarif_set_id, service_id)
    tarif_results[prev_tarif_set_id].each do |part, prev_tarif_result_by_part|
      prev_service_call_ids_by_parts[tarif_set_id] ||= {} 
      prev_tarif_result_by_part.each do |tarif_class_id, prev_tarif_result| 
        prev_service_call_ids_by_parts[tarif_set_id][part] ||= []
        prev_service_call_ids_by_parts[tarif_set_id][part] += (prev_service_call_ids_by_parts[prev_tarif_set_id][part] || [] ) - prev_service_call_ids_by_parts[tarif_set_id][part]
      end
    end
  end
  
  def set_current_prev_service_group_call_ids(tarif_set_id, prev_tarif_set_id, service_id)
    prev_service_group_call_ids[tarif_set_id] ||= {}
    prev_service_group_call_ids[prev_tarif_set_id].each do |part, prev_service_group_call_ids_by_part|
      prev_service_group_call_ids[tarif_set_id][part] ||= {}
      begin
        prev_service_group_call_ids[tarif_set_id][part] = (prev_service_group_call_ids_by_part || [])
      rescue
        raise(StandardError, [prev_service_group_call_ids].join("\n"))
      end
#TODO нужно ли правильно обрабатывать так как уже не пустой      #raise(StandardError, "prev_service_group_call_ids[tarif_set_id][part]") if prev_service_group_call_ids[tarif_set_id][part]
      prev_service_group_call_ids[tarif_set_id][part] = (prev_service_group_call_ids_by_part || [])
    end
  end
  
  def set_current_service_ids_to_calculate(tarif_set_id, part, service_id)
    service_ids_to_calculate << {:ids =>service_id, :set_ids => tarif_set_id, :parts => part}
  end
  
  def set_current_tarif_results(tarif_set_id, prev_tarif_set_id, service_id)
#    tarif_results[tarif_set_id] ||= {}  
    tarif_results[prev_tarif_set_id].each do |part, prev_tarif_result_by_part|
      tarif_results[tarif_set_id][part] ||= {} 
      prev_tarif_result_by_part.each do |key, prev_tarif_result|
        tarif_results[tarif_set_id][part][key] ||= {} 
#TODO нужно ли правильно обрабатывать так как уже не пустой      #raise(StandardError, "prev_service_group_call_ids[tarif_set_id][part]") if prev_service_group_call_ids[tarif_set_id][part]
#        tarif_results[tarif_set_id][part][key]['price_values'] = prev_tarif_result['price_values']  
        tarif_results[tarif_set_id][part][key] = prev_tarif_result
#        tarif_results[tarif_set_id][part][key]['call_id_count'] = 0
#        tarif_results[tarif_set_id][part][key]['price_value'] = 0.0 
      end
    end    
  end

  def update_all_tarif_results_with_missing_prev_results
    performance_checker.run_check_point('update_all_tarif_results_with_missing_prev_results', 3) do
      tarif_results.keys.sort{|t| t.split('_').size}.each do |tarif_set_id|
        tarif_result = tarif_results[tarif_set_id]
        service_id = tarif_set_id.split('_')[0].to_i
        missed_parts = tarif_optimizator.tarif_list_generator.dependencies[service_id]['parts'] - tarif_results[tarif_set_id].keys
        current_tarif_set_size = tarif_set_id.split('_').count
        current_tarif_set = tarif_optimizator.tarif_list_generator.tarif_set_id(tarif_set_id.split('_')[0..(current_tarif_set_size - 1)])
        while current_tarif_set_size > 0 and !missed_parts.blank?
          #raise(StandardError, [])
          current_tarif_set = tarif_optimizator.tarif_list_generator.tarif_set_id(tarif_set_id.split('_')[0..(current_tarif_set_size - 1)])
          
          tarif_results[current_tarif_set].each do |part, prev_tarif_result_by_part|
            tarif_results[tarif_set_id] ||= {}  
            prev_tarif_result_by_part.each do |key, prev_tarif_result|
              tarif_results[tarif_set_id][part] ||= {} 
              tarif_results[tarif_set_id][part][key] = prev_tarif_result if tarif_results[tarif_set_id][part][key].blank?
            end
          end if tarif_results[current_tarif_set]

          tarif_results_ord[current_tarif_set].each do |part, prev_tarif_results_by_part|
            tarif_results_ord[tarif_set_id][part] ||= {}
            prev_tarif_results_by_part.each do |key_ord, prev_tarif_results_ord_val|
              tarif_results_ord[tarif_set_id][part][key_ord] ||= {}
              prev_tarif_results_ord_val.each do |key, prev_tarif_result_ord| 
                tarif_results_ord[tarif_set_id][part][key_ord][key] = prev_tarif_result_ord if false 
              end
            end
          end if tarif_results_ord[current_tarif_set] and save_tarif_results_ord

          missed_parts = (tarif_optimizator.tarif_list_generator.dependencies[service_id]['parts'] - tarif_results[current_tarif_set].keys) if tarif_results[current_tarif_set]
          current_tarif_set_size -= 1
          
        end
      end
    end 
  end

  def calculate_all_cons_tarif_results_by_parts
    tarif_results.each do |tarif_set_id, tarif_results_by_parts|
      cons_tarif_results[tarif_set_id] = {'call_id_count' => 0, 'price_value' => 0.0}
      cons_tarif_results_by_parts[tarif_set_id] = {}
      tarif_results_by_parts.each do |part, tarif_results_by_parts_by_tarif|
        cons_tarif_results_by_parts[tarif_set_id][part] = {'call_id_count' => 0, 'price_value' => 0.0}
        tarif_results_by_parts_by_tarif.each do |tarif_id, tarif_result_by_parts_by_tarif|
          cons_tarif_results[tarif_set_id]['call_id_count'] += tarif_result_by_parts_by_tarif['call_id_count']
          cons_tarif_results[tarif_set_id]['price_value'] += tarif_result_by_parts_by_tarif['price_value']
          cons_tarif_results_by_parts[tarif_set_id][part]['call_id_count'] += tarif_result_by_parts_by_tarif['call_id_count']
          cons_tarif_results_by_parts[tarif_set_id][part]['price_value'] += tarif_result_by_parts_by_tarif['price_value']
        end
      end        
    end
  end

#TODO - преобразовать в разовый обработчик как другие
  def find_prev_group_call_ids(set_id, part, service_category_group_id)
    excluded_group_call_ids_by_part = prev_service_group_call_ids[set_id][part]
    excluded_call_ids_for_category_group = excluded_group_call_ids_by_part[service_category_group_id] if excluded_group_call_ids_by_part
    prev_group_call_ids = [];     
    excluded_call_ids_for_category_group.each do |month, prev_stat_fun_values_by_month|
      prev_group_call_ids += prev_stat_fun_values_by_month['call_ids']
    end if excluded_call_ids_for_category_group    
    prev_group_call_ids 
  end

#TODO - преобразовать в разовый обработчик как другие
  def prev_stat_function_values(price_formula_id, set_id, part, service_category_group_id)
    excluded_group_call_ids_by_part = prev_service_group_call_ids[set_id][part]
    excluded_call_ids_for_category_group = excluded_group_call_ids_by_part[service_category_group_id] if excluded_group_call_ids_by_part
#TODO разобраться с price_formula
    price_formula = tarif_optimizator.stat_function_collector.price_formula(price_formula_id)
    prev_stat_values_string = [] 
    
    excluded_call_ids_for_category_group.each do |month, prev_stat_fun_values_by_month|
      str = ["#{month || -1}", "'{#{(prev_stat_fun_values_by_month['call_ids'] || []).join(', ')} }'"]
      price_formula['stat_params'].each do |stat_key, stat_function|
        str << "#{prev_stat_fun_values_by_month[stat_key.to_s] || 'null'}" 
      end if price_formula['stat_params']
      prev_stat_values_string << "(#{str.join(', ')})"
    end if excluded_call_ids_for_category_group

    if prev_stat_values_string.blank?
      prev_stat_values_string = ['-1', "'{}'"]
      price_formula['stat_params'].each do |stat_key, stat_function|
        prev_stat_values_string << '0.0' 
      end if price_formula['stat_params']

      prev_stat_values_string = ["( #{ prev_stat_values_string.join(', ') } )"]
    end     
    prev_stat_values_string 
  end
  
  module Helper
    def flatten_call_ids_as_string(call_ids_as_string)
      null = nil
      eval(call_ids_as_string).flatten.compact unless call_ids_as_string.blank?
    end
  end  
end

