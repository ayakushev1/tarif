class ServiceHelper::TarifOptimizator
#TODO - обновить в тарифах поля с month, day or week
  attr_reader :tarif_list_generator, :stat_function_collector, :query_constructor, :background_process_informer, :optimization_result_saver, 
              :performance_checker,
              :max_formula_order,
              :tarif_results, :tarif_results_ord, :prev_service_call_ids, :operator_id,
              :optimization_params, :options,
              :check_sql_before_running, :service_ids_batch_size, :execute_additional_sql
  attr_accessor :service_ids_to_calculate, :calls_count_by_parts
#настройки вывода результатов
  attr_reader  :save_tarif_results_ord, :output_call_ids_to_tarif_results
  
  def initialize(options = {})
    self.extend Helper
    @options = options
    @fq_tarif_region_id = options[:user_region_id] || 1133    
    @tarif_list_generator = ServiceHelper::TarifListGenerator.new()#(options)
    @background_process_informer = options[:background_process_informer] || ServiceHelper::BackgroundProcessInformer.new('tarif_optimization')
    @optimization_result_saver = ServiceHelper::OptimizationResultSaver.new()
    @performance_checker = ServiceHelper::PerformanceChecker.new()
    @tarif_results_ord = {}
    @tarif_results = {}
    @prev_service_call_ids = {}
    @optimization_params = {:common => ['multiple_use_of_tarif_option', 'auto_turbo_buttons'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['multiple_use_of_tarif_option']}
#    @optimization_params = {:common => ['single_use_of_tarif_option'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['single_use_of_tarif_option']}
    @check_sql_before_running = false
    @execute_additional_sql = false
    @service_ids_batch_size = 10
    @save_tarif_results_ord = true; @output_call_ids_to_tarif_results = false
  end
  
  def calculate_all_operator_tarifs
    tarif_list_generator.operators.each { |operator| calculate_one_operator_tarifs(operator) }
  end
  
  def calculate_one_operator_tarifs(operator)
    performance_checker.clean_history; 
    performance_checker.add_check_point('calculate_one_operator_tarifs', 1)

    optimization_result_saver.clean_output_results
    init_input_for_one_operator_tarif_calculation(operator)  
    calculate_calls_count_by_parts(operator)  
    
#    raise(StandardError, tarif_list_generator.all_tarif_parts_count[operator])
    background_process_informer.init(0.0, tarif_list_generator.all_tarif_parts_count[operator])

    [tarif_list_generator.tarif_options_slices, tarif_list_generator.tarifs_slices].each do |service_slice| 
      calculate_tarif_results(operator, service_slice)
    end
    
    save_tarif_results(operator)
#    ServiceHelper::OptimizationResultSaver.new.results
    background_process_informer.finish
    performance_checker.measure_check_point('calculate_one_operator_tarifs')
  end
  
  def init_input_for_one_operator_tarif_calculation(operator)
    performance_checker.add_check_point('init_input_for_one_operator_tarif_calculation', 2)
    @fq_tarif_operator_id = operator#tarif_list_generator.operators[operator_index]
    @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services_by_operator[operator], optimization_params)
    @query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_list_generator.all_services_by_operator[operator]} )
    @max_formula_order = ServiceHelper::MaxPriceFormulaOrderCollector.new(tarif_list_generator, operator)
    @operator_id = operator#tarif_list_generator.operators[operator_index]
    performance_checker.measure_check_point('init_input_for_one_operator_tarif_calculation')
  end
  
  def save_tarif_results(operator)
    performance_checker.add_check_point('save_tarif_results', 2)
    output = {
      operator.to_i => { 
        :operator => operator.to_i,
        :tarif_results => tarif_results,
        :tarif_results_ord => (save_tarif_results_ord ? tarif_results_ord : {}),
#        :prev_service_call_ids => prev_service_call_ids,
#        :max_tarifs_slice => tarif_list_generator.max_tarifs_slice,
#        :tarifs_slices => tarif_list_generator.tarifs_slices,
      }        
    } 
#    raise(StandardError, [output[:result][:tarif_results] ])#.join("\n\n") )
    optimization_result_saver.save(output)
    performance_checker.measure_check_point('save_tarif_results')
  end
  
  def calculate_calls_count_by_parts(operator)
    performance_checker.add_check_point('calculate_calls_count_by_parts', 2)
    @calls_count_by_parts ||= {}   
    i = 0
    where_condition = false
    tarif_list_generator.uniq_parts_criteria_by_operator[operator].each do |uniq_part_criteria_by_operator|
      where_part = []
      uniq_part_criteria_by_operator.each do |category_name, category_value|
        if category_value.is_a?(Array)
          where_part_array = []
          category_value.each {|category| where_part_array << query_constructor.categories_where_hash[category]}
          where_part << "( #{where_part_array.join(' or ')} )"
        else
          where_part << query_constructor.categories_where_hash[category_value]
        end        
      end

      part = tarif_list_generator.uniq_parts_by_operator[operator][i]
      where_condition = where_part.join(' and ') if !where_part.blank?

      calls_count_by_parts[part] = Customer::Call.where( where_condition ).count(:id)
      i += 1
    end
    performance_checker.measure_check_point('calculate_calls_count_by_parts')
  end 
  
  def calculate_tarif_results(operator, service_slice)
    performance_checker.add_check_point('calculate_tarif_results', 2)
    service_slice_id = 0    
    begin
      set_current_tarif_results(operator, service_slice_id, service_slice)
      (max_formula_order.max_order_by_operator + 1).times do |price_formula_order|
        calculate_tarif_results_batches(price_formula_order)
      end            
      service_slice_id += 1
    end while service_ids_to_calculate[:ids].count > 0
    performance_checker.measure_check_point('calculate_tarif_results')
  end
  
  def calculate_tarif_results_batches(price_formula_order)
    performance_checker.add_check_point('calculate_tarif_results_batches', 3)
    batch_count = 1    
    while batch_count <= ( service_ids_to_calculate[:ids].count / service_ids_batch_size + 1) 
      batch_low_limit = service_ids_batch_size * (batch_count - 1)
      batch_high_limit = [batch_low_limit + service_ids_batch_size - 1, service_ids_to_calculate[:ids].count - 1].min
      
      calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
      
      batch_count += 1
    
#      raise(StandardError, [(service_ids_batch_high_limit - service_ids_batch_low_limit + 1), background_process_informer.current_values]) if service_ids_batch_count == 2     
      background_process_informer.increase_current_value(batch_high_limit - batch_low_limit + 1) 
    end  
    performance_checker.measure_check_point('calculate_tarif_results_batches')
  end
  
  def calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
    performance_checker.add_check_point('calculate_tarif_results_batch', 4)
    sql = calculate_service_part_sql(
      service_ids_to_calculate[:ids][batch_low_limit..batch_high_limit], 
      service_ids_to_calculate[:set_ids][batch_low_limit..batch_high_limit], 
      price_formula_order, 
      service_ids_to_calculate[:parts][batch_low_limit..batch_high_limit]
      )
#    raise(StandardError, [batch_low_limit, batch_high_limit, service_ids_to_calculate[:ids].count] ) if false 
    executed_tarif_result_batch_sql = execute_tarif_result_batch_sql(sql)     
#    performance_checker.add_check_point('transfer_executed_tarif_result_batch_sql_to_process_tarif_results_batch', 5)
    process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
    performance_checker.measure_check_point('calculate_tarif_results_batch')
  end
  
  def execute_tarif_result_batch_sql(sql)
    raise(StandardError, sql) if false
    performance_checker.add_check_point('execute_tarif_result_batch_sql', 5)
    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if false and check_sql_before_running and !sql.blank? 
    rescue => e
      raise(StandardError, [service_ids_to_calculate[:ids].count, sql.split(' ').size, e])
    end
    
    result = Customer::Call.find_by_sql(sql) unless sql.blank?
    performance_checker.measure_check_point('execute_tarif_result_batch_sql')
    result
  end
  
  def process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
#    performance_checker.measure_check_point('transfer_executed_tarif_result_batch_sql_to_process_tarif_results_batch')
    performance_checker.add_check_point('process_tarif_results_batch', 5)
    executed_tarif_result_batch_sql.each do |stat|     
      tarif_class_id = stat['tarif_class_id']
      tarif_set_id = stat['set_id']
      part = stat['part']
      
      tarif_results_ord[tarif_set_id] ||= {}
      tarif_results_ord[tarif_set_id][part] ||= {}
      tarif_results_ord[tarif_set_id][part][tarif_class_id] ||= {}

      tarif_results[tarif_set_id][part] ||= {}
      
      prev_service_call_ids[tarif_set_id][part] ||= {} 
      prev_service_call_ids[tarif_set_id][part][tarif_class_id] ||= [] 

      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order] = stat
      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids'] = flatten_call_ids_as_string(stat['call_ids'])
      current_tarif_results_ord = tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]  

      if price_formula_order == 0              
        tarif_results[tarif_set_id][part][tarif_class_id] = current_tarif_results_ord            
      else
        tarif_results[tarif_set_id][part][tarif_class_id]['call_ids'] += current_tarif_results_ord['call_ids']
        tarif_results[tarif_set_id][part][tarif_class_id]['call_id_count'] += current_tarif_results_ord['call_id_count']
        tarif_results[tarif_set_id][part][tarif_class_id]['price_value'] += (current_tarif_results_ord['price_value'] || 0)             
      end
      
      prev_service_call_ids[tarif_set_id][part][tarif_class_id] += (tarif_results[tarif_set_id][part][tarif_class_id]['call_ids'] || [] )
      prev_service_call_ids[tarif_set_id][part][tarif_class_id].uniq!
      prev_service_call_ids[tarif_set_id][part][:ids] ||= []
      prev_service_call_ids[tarif_set_id][part][:ids] += prev_service_call_ids[tarif_set_id][part][tarif_class_id]
      prev_service_call_ids[tarif_set_id][part][:ids].uniq!
      dup = prev_service_call_ids[tarif_set_id][part][:ids] - prev_service_call_ids[tarif_set_id][part][:ids].uniq
      
      current_tarif_results_ord['price_values'].each do |price_value|            
        category_group_id = price_value['service_category_group_id']
        month = price_value['all_stat']['month']
        raise(StandardError, [price_value.keys] ) unless category_group_id
        if category_group_id > -1
          prev_service_call_ids[tarif_set_id][part][:category_groups] ||= {}
          prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id] ||= {}
          prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month] ||= {}
          prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month]['call_ids'] ||= []
          prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month]['call_ids'] += (price_value['call_ids'] || [] )
          prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month]['call_ids'].uniq!
          
          price_formula_id = stat_function_collector.service_group_stat[part][price_formula_order][category_group_id][:price_formula_id]
          price_formula = stat_function_collector.price_formula(price_formula_id)

          price_formula['stat_params'].each  do |stat_key, stat_function| 
            prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month][stat_key] ||= 0
            if price_value["all_stat"][stat_key]# and price_value["all_stat"]['service_category_group_id'] == category_group_id
              prev_service_call_ids[tarif_set_id][part][:category_groups][category_group_id][month][stat_key] += price_value["all_stat"][stat_key]
            end 
          end if price_formula['stat_params']# stat_function_collector.service_stat[price_formula_order][:category_groups][:groups][category_group_id][:stat_params]
        end
      end
    end if executed_tarif_result_batch_sql
    performance_checker.measure_check_point('process_tarif_results_batch')
  end
  
  def set_current_tarif_results(operator, service_slice_id, service_slice)
    performance_checker.add_check_point('set_current_tarif_results', 3)
    i = 0
    @service_ids_to_calculate = {:ids => [], :set_ids => [], :parts => []}
    
#    raise(StandardError, [operator, service_slice_id, service_slice[operator][service_slice_id][:ids] ]) #if !service_slice[operator][service_slice_id]
    
    service_slice[operator][service_slice_id][:ids].each do |service_id|      
      tarif_set_id = service_slice[operator][service_slice_id][:set_ids][i]
      prev_tarif_set_id = service_slice[operator][service_slice_id][:prev_set_ids][i]

      part = service_slice[operator][service_slice_id][:parts][i]      
#    raise(StandardError, [operator, service_slice_id, service_slice]) #if !service_slice[operator][service_slice_id]
      tarif_results[tarif_set_id] ||= {}
      tarif_results_ord[tarif_set_id] ||= {}
      prev_service_call_ids[tarif_set_id] ||= {}
      
      unless tarif_results[tarif_set_id][part]
        tarif_results[tarif_set_id][part] ||= {}
        tarif_results_ord[tarif_set_id][part] ||= {}
        prev_service_call_ids[tarif_set_id][part] ||= {:category_groups => {}, :ids => []}

        if tarif_results[prev_tarif_set_id] and tarif_results[prev_tarif_set_id][part]
          tarif_results[prev_tarif_set_id][part].each do |key, prev_tarif_result| 
            tarif_results[tarif_set_id][part][key] = prev_tarif_result
            prev_service_call_ids[tarif_set_id][part][key] = (tarif_results[prev_tarif_set_id][part][key]['call_ids'] || [] )
            prev_service_call_ids[tarif_set_id][part][:ids] += prev_service_call_ids[tarif_set_id][part][key]
          end
          prev_service_call_ids[tarif_set_id][part][:category_groups] = (prev_service_call_ids[prev_tarif_set_id][part][:category_groups] || [])

          tarif_results_ord[prev_tarif_set_id][part].each do |key_ord, prev_tarif_results_ord_val|
            tarif_results_ord[tarif_set_id][part][key_ord] ||= {}
            prev_tarif_results_ord_val.each {|key, prev_tarif_result_ord| tarif_results_ord[tarif_set_id][part][key_ord][key] = prev_tarif_result_ord }
          end          
        end

#          raise(StandardError, [prev_service_call_ids ]) if service_id == 282 and part == 'onetime'# and tarif_set_id == '204_282__' 
#        raise(StandardError, [tarif_set_id, prev_service_call_ids.keys, prev_service_call_ids[tarif_set_id] ]) if service_id == 276 and tarif_set_id == '276_277_293' 

        service_ids_to_calculate[:ids] << service_id
        service_ids_to_calculate[:set_ids] << tarif_set_id
        service_ids_to_calculate[:parts] << part
      end
      i += 1
    end  if service_slice[operator][service_slice_id]  
  
    raise(StandardError, ["\n", service_slice[operator][service_slice_id],
      stat_function_collector.tarif_class_parts, "\n"].join("\n\n")) if false and service_slice[operator][service_slice_id] and 
        service_slice[operator][service_slice_id][:ids].include?(200) #, tarif_results, prev_service_call_ids
    performance_checker.measure_check_point('set_current_tarif_results')
  end
  
  def calculate_service_part_sql(service_list, set_id_list = [], price_formula_order, parts_list)
    performance_checker.add_check_point('calculate_service_part_sql', 5)
    sql = calculate_service_list_sql(service_list, set_id_list, prev_service_call_ids, price_formula_order, parts_list) 

    fields = [
      'part', 
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      '(price_values::json) as price_values',
      'set_id'
    ]
    
    sql = "with calculate_service_list_sql as (#{sql}) select #{fields.join(', ')} from calculate_service_list_sql" unless sql.blank?

    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, set_id, price_formula_order, e])
    end
    performance_checker.measure_check_point('calculate_service_part_sql')
    sql
  end
  
  def calculate_service_list_sql(service_list, set_id_list = [], prev_service_call_ids, price_formula_order, parts_list)
    i = -1
    sql = service_list.collect do |service_id| 
      i += 1 
      next if !service_id 
      part = parts_list[i]
      next if !max_formula_order.max_order_by_service_and_part[part] or !max_formula_order.max_order_by_service_and_part[part][service_id]
      next if price_formula_order > max_formula_order.max_order_by_service_and_part[part][service_id]
      next if !tarif_list_generator.dependencies[service_id]['parts'].include?(part)
      prev_call_ids_count = 0 
      tarif_results[set_id_list[i]][part].each { |service_id_1, tarif_results_value |  prev_call_ids_count += tarif_results_value['call_id_count'] }
      next if !(calls_count_by_parts[part] == 0) and prev_call_ids_count == calls_count_by_parts[part] 

#        raise(StandardError, [!tarif_list_generator.dependencies[service_id]['parts'].include?(part), 
#              set_id_list, set_id_list[i], service_id, part, prev_service_call_ids]) unless prev_service_call_ids[set_id_list[i]][part]

      sql_1 = service_cost_sql(service_id, set_id_list[i], prev_service_call_ids[set_id_list[i]], price_formula_order, part)
      sql_1 unless sql_1.blank?      
    end.compact.join(' union ')

    fields = [
      'part', 
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      'price_values',
#        '(price_values::json) as price_values',
      'set_id'
    ]
    
    sql = "(with service_cost_sql as (#{sql}) select #{fields.join(', ')} from service_cost_sql)" unless sql.blank?
#    raise(StandardError, [sql])
    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, set_id, price_formula_order, e])
    end

    performance_checker.add_check_point('calculate_service_list_sql', 6)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('calculate_service_list_sql')
    sql
  end

  def service_cost_sql(service_id, set_id = nil, excluded_call_ids = [], price_formula_order, part)
    raise(StandardError, [stat_function_collector.tarif_class_parts[service_id]]) unless part
    fields = [
      "'#{part}'::text as part", 
      'tarif_class_id', 
      'json_agg(call_ids)::text as call_ids', 
      'sum(price_value) as price_value',
      'sum(call_id_count) as call_id_count',
      '(json_agg(row_to_json(service_categories_cost_sql_result)))::text as price_values',
      "'#{set_id || -1}' as set_id"
    ]    
    sql = service_categories_cost_sql(service_id, set_id, excluded_call_ids, price_formula_order, part)    
    sql = "(select #{fields.join(', ')} from (#{sql}) as service_categories_cost_sql_result group by tarif_class_id, set_id)"  unless sql.blank?
#    raise(StandardError, [sql]) if sql.blank?
    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, set_id, price_formula_order, e])
    end

    performance_checker.add_check_point('service_cost_sql', 7)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('service_cost_sql')
    sql
  end
  
  def service_categories_cost_sql(service_id, set_id = nil, excluded_call_ids = [], price_formula_order, part)  
    result = [] 
        
    stat_function_collector.service_group_ids[part][price_formula_order][service_id].each do |service_category_group_id|        
      stat_details = stat_function_collector.service_group_stat[part][price_formula_order][service_category_group_id]      
      
      if price_formula_order < (max_formula_order.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)
      
        service_category_tarif_class_ids = calculate_service_category_ids_for_category_group_and_set_id(service_category_group_id, set_id, price_formula_order, part)
        service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(service_category_tarif_class_ids, set_id)
      
        price_formula_id = stat_details[:price_formula_id]
        
        result << service_category_cost_sql(calculate_base_stat_sql(service_category_tarif_class_ids), service_category_tarif_class_ids[0], service_category_group_id, price_formula_id, service_id, excluded_call_ids[part])
      end
    end if stat_function_collector.service_group_ids[part] and stat_function_collector.service_group_ids[part][price_formula_order] and stat_function_collector.service_group_ids[part][price_formula_order][service_id]

    stat_function_collector.service_stat[part][price_formula_order][service_id].each do |stat_details_key, stat_details|
      if price_formula_order < (max_formula_order.max_order_by_price_list_and_part[part][stat_details[:price_lists_id]] + 1)
             
        service_category_tarif_class_ids = service_category_tarif_class_ids_after_condition_if_tarif_option_included(stat_details[:service_category_tarif_class_ids], set_id)
#        service_category_group_id = stat_details[:service_category_group_id]
        price_formula_id = stat_details[:price_formula_id]
        
        result << service_category_cost_sql(calculate_base_stat_sql(service_category_tarif_class_ids), service_category_tarif_class_ids[0], -1, price_formula_id, service_id, excluded_call_ids[part])
      end
    end if stat_function_collector.service_stat[part] and stat_function_collector.service_stat[part][price_formula_order] and stat_function_collector.service_stat[part][price_formula_order][service_id]

    sql = result.compact.join(' union ')
    sql = "with united_service_categories_cost_sql as (#{sql} ) select *, all_stat::json as all_stat from united_service_categories_cost_sql" unless sql.blank?
#    raise(StandardError, [result, part, price_formula_order, service_id, stat_function_collector.service_group_ids]) if sql.blank?
    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, set_id, price_formula_order, e])
    end

    performance_checker.add_check_point('service_categories_cost_sql', 8)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('service_categories_cost_sql')
    raise(StandardError, [sql, 
      performance_checker.results['service_categories_cost_sql']['duration'], performance_checker.results['service_categories_cost_sql']['max_duration'], 
      performance_checker.show_stat].join("\n\n")) if performance_checker.results['service_categories_cost_sql']['duration'] > 0.1
    sql
  end
  
  def calculate_service_category_ids_for_category_group_and_set_id(service_category_group_id, set_id = nil, price_formula_order, part)
    service_category_tarif_class_ids = []

    service_category_by_group_and_service_id = stat_function_collector.service_category_by_group_and_service_id[part][price_formula_order][service_category_group_id]
    group_tarif_class_ids = (service_category_by_group_and_service_id.keys & set_id.split('_').collect{|i| i.to_i} )
    
    group_tarif_class_ids.each do |group_tarif_class_id|
      service_category_tarif_class_ids += (service_category_by_group_and_service_id[group_tarif_class_id] + [])
    end        
    service_category_tarif_class_ids = [-1] if service_category_tarif_class_ids.blank?
    service_category_tarif_class_ids        
  end

  def service_category_tarif_class_ids_after_condition_if_tarif_option_included(service_category_tarif_class_ids, set_id)
    result = []
    service_category_tarif_class_ids.each do |service_category_tarif_class_id|
      next if service_category_tarif_class_id == -1
      raise(StandardError, [set_id, service_category_tarif_class_id]) if !query_constructor.tarif_class_categories[service_category_tarif_class_id]
      condition_field = query_constructor.tarif_class_categories[service_category_tarif_class_id].conditions  
      if condition_field and condition_field['tarif_set_must_include_tarif_options'] and 
        (condition_field['tarif_set_must_include_tarif_options'] & set_id.split('_').map{|s| s.to_i}).count == 0
      else
        result << service_category_tarif_class_id
      end
    end
  end
  
  def calculate_base_stat_sql(service_category_tarif_class_ids)
    performance_checker.add_check_point('calculate_base_stat_sql', 9)
    result = Customer::Call.where(query_constructor.joined_tarif_classes_category_where_hash(service_category_tarif_class_ids))
    performance_checker.measure_check_point('calculate_base_stat_sql')
    result
  end

  def service_category_cost_sql(base_stat_sql, service_category_tarif_class_id, service_category_group_id, price_formula_id, service_id, excluded_call_ids = [])
    excluded_call_ids_for_category_group = excluded_call_ids[:category_groups][service_category_group_id] if excluded_call_ids and excluded_call_ids[:category_groups]
    raise(StandardError, prev_service_call_ids) unless true#excluded_call_ids
    price_formula = stat_function_collector.price_formula(price_formula_id)
    
    stat_sql_fields = ["coalesce(month, -1)::integer as month", "coalesce(call_ids, '{}') as call_ids", "coalesce(call_id_count, 0) as call_id_count",]
    price_formula['stat_params'].each { |stat_key, stat_function| stat_sql_fields << "coalesce(#{stat_key}, 0) as #{stat_key}" } if price_formula['stat_params']
    
    fields = if service_category_group_id > -1
      ["sctc_2.tarif_class_id", "price_lists.service_category_group_id", "-1 as service_category_tarif_class_id", "service_category_groups.name as service_category_name"]
    else
      ["sctc_1.tarif_class_id", "-1 as service_category_group_id", 
        "case when sctc_1.id = #{ service_category_tarif_class_id} then sctc_1.id else sctc_3.id end as service_category_tarif_class_id",
        "case when sctc_1.id = #{ service_category_tarif_class_id} then sctc_1.name else sctc_3.name end as service_category_name",]
    end
      
    fields = (fields + [       
      "month", "call_ids", "call_id_count", 
      "#{price_formula_id} as price_formula_id", 
#      "#{price_formula_order} as price_formula_calculation_order",
      "#{stat_function_collector.price_formula_string(price_formula_id)} as price_value",
#      "#{price_formula_order} as price_formula_order",
      "row_to_json(stat_sql)::text as all_stat"      
    ]).join(', ')
    
    service_category_choice_sql = service_category_choice_sql(base_stat_sql, price_formula_id, excluded_call_ids, excluded_call_ids_for_category_group)

    sql = [
      "with",
      "fixed_input as ( select 1 ),",
      "service_category_choice_sql as ( #{service_category_choice_sql} ),",
      "stat_sql as ( select #{stat_sql_fields.join(', ')} from fixed_input left outer join service_category_choice_sql on true )",
      "select distinct #{fields}",
      "from stat_sql, price_formulas",
      "LEFT OUTER JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id",
     
      "LEFT OUTER JOIN price_lists ON price_lists.id = price_formulas.price_list_id",
      "LEFT OUTER JOIN service_category_tarif_classes sctc_1 ON sctc_1.id = price_lists.service_category_tarif_class_id",

      "LEFT OUTER JOIN service_category_tarif_classes sctc_3 ON sctc_3.as_tarif_class_service_category_id = sctc_1.id",

      "LEFT OUTER JOIN service_category_groups ON service_category_groups.id = price_lists.service_category_group_id",
      "LEFT OUTER JOIN service_category_tarif_classes sctc_2 ON sctc_2.as_standard_category_group_id = service_category_groups.id",

      "where",
      "price_formulas.id = #{price_formula_id} and ",
#      "price_formulas.calculation_order = #{price_formula_order} and",
      "price_lists.tarif_list_id is null and",
      "(",
      "(sctc_2.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id = #{ service_category_group_id } ) or",      
      "(sctc_1.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_1.id = #{ service_category_tarif_class_id || -1} ) or ",
      "(sctc_3.tarif_class_id = #{service_id} and sctc_2.as_standard_category_group_id is null and sctc_3.id = #{ service_category_tarif_class_id || -1} )",
      ")",  
    ].join(' ')
    sql = "(#{sql})"

    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, e])
    end
    
    performance_checker.add_check_point('service_category_cost_sql', 9)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('service_category_cost_sql')
    raise(StandardError, [sql, 
      performance_checker.results['service_category_cost_sql']['duration'], performance_checker.results['service_category_cost_sql']['max_duration'], 
      performance_checker.show_stat].join("\n\n")) if performance_checker.results['service_category_cost_sql']['duration'] > 110.05
    sql
  end

  def service_category_choice_sql(base_stat_sql, price_formula_id, excluded_call_ids = {}, excluded_call_ids_for_category_group = [])
    excluded_call_ids ||= {}
    sql = if !stat_function_collector.price_formula(price_formula_id)['window_condition'].blank?
      service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids, excluded_call_ids_for_category_group, :window)
    elsif !stat_function_collector.price_formula(price_formula_id)['tarif_condition'].blank?
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids[:ids], :tarif)
    else
      first_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids[:ids], :group)
    end

    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [service_id, set_id, price_formula_order, e])
    end
    
    performance_checker.add_check_point('service_category_choice_sql', 10)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('service_category_choice_sql')
    sql
  end 

  def service_category_accumulated_stat_sql(base_stat_sql, price_formula_id, excluded_call_ids = {}, excluded_call_ids_for_category_group = [], check_out_call_ids) 
#В запросах дальше поле 'month' выступает как название периода по которому идут расчеты       
    price_formula = stat_function_collector.price_formula(price_formula_id)#.formula

    stat_string_2 = ["first_stat_sql.*"]
    stat_string_4 = ["month", "array_agg(id) as call_ids", "count(id) as call_id_count", ]
    
    prev_group_call_ids = find_prev_group_call_ids(excluded_call_ids_for_category_group)
    
    price_formula['stat_params'].each do |stat_key, stat_function| 
      stat_string_2 << "current_#{stat_key} + coalesce(prev_#{stat_key}, 0) as #{stat_key}"
#      stat_string_2 << ( !prev_group_call_ids.blank? ? "current_#{stat_key} + coalesce(prev_#{stat_key}, 0) as #{stat_key}" :  "current_#{stat_key} as #{stat_key}" )
      stat_string_4 << "#{stat_function} as #{stat_key}"
    end if price_formula['stat_params']

    sql = [
      "with",
      "prev_sql (#{prev_service_category_accumulated_stat_sql(price_formula_id, excluded_call_ids_for_category_group)} ),",
      "first_stat_sql as ( #{first_stat_sql(base_stat_sql, price_formula_id, (excluded_call_ids[:ids] - prev_group_call_ids ), check_out_call_ids)} ),",
      
      "service_category_accumulated_ids_sql_2 as (select #{stat_string_2.join(', ')} from first_stat_sql",
      "left outer join prev_sql on first_stat_sql.month = prev_sql.month), ",
      
      "service_category_accumulated_stat_sql_3 as ",
      "(select array_agg(id) as group_call_ids, month from service_category_accumulated_ids_sql_2 where #{price_formula['window_condition']} group by month)",
      
      "select #{stat_string_4.join(', ')} from customer_calls, service_category_accumulated_stat_sql_3",
      "where id != all('{#{excluded_call_ids[:ids].join(', ')}}') and id = any(group_call_ids)",
      "group by month",
    ].join(' ')

    begin
      Customer::Call.connection.execute("select * from ( #{sql} ) as sss limit 1") if !sql.blank? and check_sql_before_running
    rescue => e
      raise(StandardError, [e])
    end
    
    performance_checker.add_check_point('service_category_accumulated_stat_sql', 11)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('service_category_accumulated_stat_sql')
    sql
  end
  
  def first_stat_sql(base_stat_sql, price_formula_id, all_excluded_call_ids, check_out_call_ids)
    price_formula = stat_function_collector.price_formula(price_formula_id)
    group_by = "extract(#{price_formula['group_by'] || 'month'} from (description->>'time')::timestamp)"
    case check_out_call_ids
    when :window
      fields = ["id", "extract(#{price_formula['window_over'] || 'month'} from (description->>'time')::timestamp) as month"]
      price_formula['stat_params'].each { |stat_key, stat_function| fields << "#{stat_function} over m as current_#{stat_key}" } if price_formula['stat_params']
    when :group
      fields = ["#{group_by} as month", "array_agg(id) as call_ids", "count(id) as call_id_count",]
      price_formula['stat_params'].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}" } if price_formula['stat_params']    
    when :tarif
      fields = ["#{group_by} as month", "'{}'::int[] as call_ids", "0 as call_id_count",]
      price_formula['stat_params'].each {|stat_key, stat_function| fields << "#{stat_function} as #{stat_key}" } if price_formula['stat_params']    
    else
      raise(StandardError, 'wrong check_out_call_ids in first_stat_sql')
    end

    sql = base_stat_sql.select("#{fields.join(', ')}").where.not(:id => all_excluded_call_ids)
      
    sql = if price_formula['window_over']
      "#{sql.to_sql} WINDOW m as (partition by extract(#{price_formula['window_over'] || 'month'} from (description->>'time')::timestamp) order by (description->>'time')::timestamp )"    
    else
      sql.group("month").to_sql
    end  

    performance_checker.add_check_point('first_stat_sql', 12)
    Customer::Call.connection.execute(sql) if execute_additional_sql
    performance_checker.measure_check_point('first_stat_sql')
    raise(StandardError, [check_out_call_ids, sql, 
      performance_checker.results['first_stat_sql']['duration'], performance_checker.results['first_stat_sql']['max_duration'], 
      performance_checker.show_stat].join("\n\n")) if performance_checker.results['first_stat_sql']['duration'] > 10.01
    sql
  end

  def prev_service_category_accumulated_stat_sql(price_formula_id, excluded_call_ids_for_service_category_group_id = []) 
    price_formula = stat_function_collector.price_formula(price_formula_id)
    stat_string_0 = ["month", "prev_month_ids"]
    
    stat_values_string = prev_stat_function_values(price_formula_id, excluded_call_ids_for_service_category_group_id)
    
    price_formula['stat_params'].each { |stat_key, stat_function| stat_string_0 << "prev_#{stat_key}" } if price_formula['stat_params']
    
    "#{stat_string_0.join(', ')} ) as (values #{stat_values_string.join(', ')}"
  end
  
  def find_prev_group_call_ids(excluded_call_ids_for_service_category_group_id)
    prev_group_call_ids = [];     
    excluded_call_ids_for_service_category_group_id.each do |month, prev_stat_fun_values_by_month|
      prev_group_call_ids += prev_stat_fun_values_by_month['call_ids']
    end if excluded_call_ids_for_service_category_group_id    
    prev_group_call_ids 
  end

  def prev_stat_function_values(price_formula_id, excluded_call_ids_for_service_category_group_id)
    price_formula = stat_function_collector.price_formula(price_formula_id)
    stat_values_string = [] 
    
    excluded_call_ids_for_service_category_group_id.each do |month, prev_stat_fun_values_by_month|
      str = ["#{month || -1}", "'{#{(prev_stat_fun_values_by_month['call_ids'] || []).join(', ')} }'"]
      price_formula['stat_params'].each do |stat_key, stat_function|
        str << "#{prev_stat_fun_values_by_month[stat_key.to_s] || 'null'}" 
      end if price_formula['stat_params']
      stat_values_string << "(#{str.join(', ')})"
    end if excluded_call_ids_for_service_category_group_id

    if stat_values_string.blank?
      stat_values_string = ['-1', "'{}'"]
      price_formula['stat_params'].each do |stat_key, stat_function|
        stat_values_string << '0.0' 
      end if price_formula['stat_params']

      stat_values_string = ["( #{ stat_values_string.join(', ') } )"]
    end     
    stat_values_string 
  end
  
    
  module Helper
    def array_of_hashes_to_hash(array_of_hashes, index_key)
      array_of_hashes.collect {|a| {a[index_key] => a } }
    end
  end

  def flatten_call_ids_as_string(call_ids_as_string)
    null = nil
    eval(call_ids_as_string).flatten.compact unless call_ids_as_string.blank?
  end
      
end

