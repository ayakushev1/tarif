#TODO убрать part 'mms'
class ServiceHelper::TarifOptimizator
#TODO - обновить в тарифах поля с month, day or week
#дополнительные классы
  attr_reader :tarif_list_generator, :stat_function_collector, :query_constructor, :background_process_informer, :optimization_result_saver, :minor_result_saver,
              :performance_checker, :current_tarif_optimization_results, :tarif_optimization_sql_builder, :max_formula_order_collector, 
              :calls_stat_calculator
#входные данные              
  attr_reader :options, :operator_id, :fq_tarif_region_id  
# параметры оптимизации 
  attr_reader :optimization_params, :check_sql_before_running, :execute_additional_sql, :service_ids_batch_size
#настройки вывода результатов
  attr_reader  :save_tarif_results, :simplify_tarif_results, :save_tarif_results_ord, :analyze_memory_used, :output_call_ids_to_tarif_results, :output_call_count_to_tarif_results, 
               :analyze_query_constructor_performance
#local
  attr_reader :calls_count_by_parts, :controller
  
  def initialize(options = {})
    self.extend Helper
    init_input_data(options)
    init_output_params(options)
    init_additional_general_classes    
    init_optimization_params
  end
  
  def init_additional_general_classes
    @performance_checker = ServiceHelper::PerformanceChecker.new()
    performance_checker.clean_history;
    performance_checker.run_check_point('init_additional_general_classes', 1) do
      @controller = options[:controller]
      @background_process_informer = options[:background_process_informer] || ServiceHelper::BackgroundProcessInformer.new('tarif_optimization')
    end
  end
  
  def init_input_data(options)
    @options = options
    @fq_tarif_region_id = options[:user_region_id] || 1133
  end
  
  def init_optimization_params
    @optimization_params = {:common => ['multiple_use_of_tarif_option', 'auto_turbo_buttons'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['multiple_use_of_tarif_option']}
#    @optimization_params = {:common => ['single_use_of_tarif_option'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['single_use_of_tarif_option']}
    @check_sql_before_running = false
    @execute_additional_sql = false
    @service_ids_batch_size = (options[:service_ids_batch_size] ? options[:service_ids_batch_size].to_i : 10)
  end
  
  def init_output_params(options)
    @save_tarif_results = (options[:save_tarif_results] == 'true' ? true : false) 
    @simplify_tarif_results = (options[:simplify_tarif_results] == 'true' ? true : false) 
    @save_tarif_results_ord = (options[:save_tarif_results_ord] == 'true' ? true : false) 
    @analyze_memory_used = (options[:analyze_memory_used] == 'true' ? true : false) 
    @analyze_query_constructor_performance = (options[:analyze_query_constructor_performance] == 'true' ? true : false) 
    @output_call_ids_to_tarif_results = false; @output_call_count_to_tarif_results = false
  end
  
  def calculate_all_operator_tarifs
    tarif_list_generator.operators.each { |operator| calculate_one_operator_tarifs(operator) }
  end
  
  def calculate_one_operator_tarifs(operator)
    performance_checker.run_check_point('calculate_one_operator_tarifs', 1) do      
      init_input_for_one_operator_tarif_calculation(operator)      
      
      optimization_result_saver.clean_output_results; minor_result_saver.clean_output_results;
      
      performance_checker.run_check_point('calculate_calls_count_by_parts', 2) do
        @calls_count_by_parts = calls_stat_calculator.calculate_calls_count_by_parts(query_constructor, 
          tarif_list_generator.uniq_parts_by_operator[operator], tarif_list_generator.uniq_parts_criteria_by_operator[operator])
      end
      
      background_process_informer.init(0.0, tarif_list_generator.all_tarif_parts_count[operator])
  
      [tarif_list_generator.tarif_options_slices, tarif_list_generator.tarifs_slices].each do |service_slice| 
        calculate_tarif_results(operator, service_slice)
      end
      
      current_tarif_optimization_results.update_all_tarif_results_with_missing_prev_results
      current_tarif_optimization_results.calculate_all_cons_tarif_results_by_parts
      
      save_tarif_results(operator)
      
      clean_memory
      
      performance_checker.run_check_point('calculate_final_tarif_sets', 2) do
        tarif_list_generator.calculate_final_tarif_sets(current_tarif_optimization_results.cons_tarif_results)
      end
      
      performance_checker.run_check_point('save_final_tarif_sets', 2) do
        output = {operator.to_i => {:final_tarif_sets => tarif_list_generator.final_tarif_sets } } 
        ServiceHelper::OptimizationResultSaver.new('final_tarif_sets').save(output)
      end
      
      background_process_informer.finish
    end
    minor_result_saver.save({:calls_stat => calls_stat_calculator.calculate_calls_stat(query_constructor), :performance_results => performance_checker.show_stat_hash})
  end 
  
  def init_input_for_one_operator_tarif_calculation(operator)
    performance_checker.run_check_point('init_input_for_one_operator_tarif_calculation', 2) do
      @optimization_result_saver = ServiceHelper::OptimizationResultSaver.new()
      @minor_result_saver = ServiceHelper::OptimizationResultSaver.new('minor_results')
      @calls_stat_calculator = ServiceHelper::CallsStatCalculator.new()
      @tarif_optimization_sql_builder = ServiceHelper::TarifOptimizationSqlBuilder.new(self)
      performance_checker.run_check_point('@tarif_list_generator', 3) do
        @tarif_list_generator = ServiceHelper::TarifListGenerator.new(options[:services_by_operator] || {})
      end
      @current_tarif_optimization_results = ServiceHelper::CurrentTarifOptimizationResults.new(self)
#    raise(StandardError, [simplify_tarif_results, options[:simplify_tarif_results]])
      @fq_tarif_operator_id = operator#tarif_list_generator.operators[operator_index]
      @operator_id = operator#tarif_list_generator.operators[operator_index]
      performance_checker.run_check_point('@stat_function_collector', 3) do
        @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services_by_operator[operator], optimization_params)
      end
      performance_checker.run_check_point('@query_constructor', 3) do
        @query_constructor = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_list_generator.all_services_by_operator[operator], 
          :performance_checker => (analyze_query_constructor_performance ? performance_checker : nil)} )
      end
      @max_formula_order_collector = ServiceHelper::MaxPriceFormulaOrderCollector.new(tarif_list_generator, operator)
    end
  end
  
  def save_tarif_results(operator)
    output = {}
    performance_checker.run_check_point('save_tarif_results', 2) do
      output = {
        operator.to_i => {
          :operator => operator.to_i, 
          :tarif_sets => tarif_list_generator.tarif_sets,
          :cons_tarif_results => current_tarif_optimization_results.cons_tarif_results,
          :cons_tarif_results_by_parts => current_tarif_optimization_results.cons_tarif_results_by_parts,
          :tarif_results => current_tarif_optimization_results.tarif_results, 
          :tarif_results_ord => (save_tarif_results_ord ? current_tarif_optimization_results.tarif_results_ord : {}), 
          } } 

      optimization_result_saver.save(output)
    end

    performance_checker.run_check_point('memory_usage_analyze_for_output', 2) do      
      minor_result_saver.save({:used_memory_by_output => calculate_used_memory(output)})
    end if analyze_memory_used    
  end
  
  def calculate_used_memory(output)
    {
      :output => General::MemoryUsage.analyze(output),
      :cons_tarif_results => General::MemoryUsage.analyze(current_tarif_optimization_results.cons_tarif_results),
      :cons_tarif_results_by_parts => General::MemoryUsage.analyze(current_tarif_optimization_results.cons_tarif_results_by_parts),
      :prev_service_call_ids_by_parts => General::MemoryUsage.analyze(current_tarif_optimization_results.prev_service_call_ids_by_parts),
      :prev_service_group_call_ids => General::MemoryUsage.analyze(current_tarif_optimization_results.prev_service_group_call_ids),
      :optimization_result_saver => General::MemoryUsage.analyze(@optimization_result_saver),
      :minor_result_saver => General::MemoryUsage.analyze(@minor_result_saver),
      :calls_stat_calculator => General::MemoryUsage.analyze(@calls_stat_calculator),
      :tarif_optimization_sql_builder => General::MemoryUsage.analyze(@tarif_optimization_sql_builder),
      :current_tarif_optimization_results => General::MemoryUsage.analyze(@current_tarif_optimization_results),
      :stat_function_collector => General::MemoryUsage.analyze(@stat_function_collector),
      :query_constructor => General::MemoryUsage.analyze(@query_constructor),
      :max_formula_order_collector => General::MemoryUsage.analyze(@max_formula_order_collector),
      :tarif_list_generator => General::MemoryUsage.analyze(@tarif_list_generator),
      :max_formula_order_collector => General::MemoryUsage.analyze(@max_formula_order_collector),
      :performance_checker => General::MemoryUsage.analyze(@performance_checker),
      :controller => General::MemoryUsage.analyze(@controller),
      :background_process_informer => General::MemoryUsage.analyze(@background_process_informer),
    }
  end
  
  def clean_memory
    current_tarif_optimization_results = nil 
#TODO    tarif_optimization_sql_builder = nil #очищать только если для разных операторов вводятся разные данные
    current_tarif_optimization_results = nil
    query_constructor = nil
    max_formula_order_collector = nil
  end
  
  def calculate_tarif_results(operator, service_slice)
    performance_checker.run_check_point('calculate_tarif_results', 2) do
      service_slice_id = 0    
      begin
        break if !service_slice or !service_slice[operator] or !service_slice[operator][service_slice_id]
        current_tarif_optimization_results.set_current_results(service_slice[operator][service_slice_id])
        (max_formula_order_collector.max_order_by_operator + 1).times do |price_formula_order|
          calculate_tarif_results_batches(price_formula_order)
        end
        service_slice_id += 1
      end while current_tarif_optimization_results.service_ids_to_calculate and current_tarif_optimization_results.service_ids_to_calculate.count > 0
    end
  end
  
  def calculate_tarif_results_batches(price_formula_order)
    performance_checker.run_check_point('calculate_tarif_results_batches', 3) do
      batch_count = 1    
      while batch_count <= ( current_tarif_optimization_results.service_ids_to_calculate.count / service_ids_batch_size + 1) 
        batch_low_limit = service_ids_batch_size * (batch_count - 1)
        batch_high_limit = [batch_low_limit + service_ids_batch_size - 1, current_tarif_optimization_results.service_ids_to_calculate.count - 1].min
        
        calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
        
        batch_count += 1
        background_process_informer.increase_current_value(batch_high_limit - batch_low_limit + 1) 
      end if current_tarif_optimization_results.service_ids_to_calculate
    end
  end
  
  def calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
    performance_checker.run_check_point('calculate_tarif_results_batch', 4) do
      sql = tarif_optimization_sql_builder.calculate_service_part_sql(current_tarif_optimization_results.service_ids_to_calculate[batch_low_limit..batch_high_limit], price_formula_order)
      executed_tarif_result_batch_sql = execute_tarif_result_batch_sql(sql)     
      current_tarif_optimization_results.process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
    end
  end
  
  def execute_tarif_result_batch_sql(sql)
    performance_checker.run_check_point('execute_tarif_result_batch_sql', 5) do
      tarif_optimization_sql_builder.check_sql(sql, current_tarif_optimization_results.service_ids_to_calculate.count, sql.split(' ').size)
      Customer::Call.find_by_sql(sql) unless sql.blank?
    end
  end
  
  module Helper
  end

end

