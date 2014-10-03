#TODO убрать part 'mms'
class ServiceHelper::TarifOptimizator
#TODO - обновить в тарифах поля с month, day or week
#дополнительные классы
  attr_reader :tarif_list_generator, :final_tarif_set_generator, :stat_function_collector, :query_constructor, :optimization_result_saver, :minor_result_saver, 
              :final_tarif_sets_saver, :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif, 
              :performance_checker, :current_tarif_optimization_results, :tarif_optimization_sql_builder, :max_formula_order_collector, 
              :calls_stat_calculator, :prepared_final_tarif_results_saver, :operator_description
#входные данные              
  attr_reader :options, :operator_id, :fq_tarif_region_id  
# параметры оптимизации 
  attr_reader :optimization_params, :check_sql_before_running, :execute_additional_sql, :service_ids_batch_size
#настройки вывода результатов
  attr_reader  :simplify_tarif_results, :save_tarif_results_ord, :analyze_memory_used, :output_call_ids_to_tarif_results, :output_call_count_to_tarif_results, 
               :analyze_query_constructor_performance, :save_interim_results_after_calculating_tarif_results#, :save_interim_results_after_calculating_final_tarif_sets
#local
  attr_reader :calls_count_by_parts, :user_id, :accounting_period
  
  def initialize(options = {})
    self.extend Helper
    init_input_data(options)
    init_output_params(options)
    init_additional_general_classes    
    init_optimization_params
  end
  
  def init_input_data(options)
    @options = options
    @fq_tarif_region_id = (options[:user_region_id] and options[:user_region_id] != 0 ? options[:user_region_id] : 1238)
    @user_id = options[:user_id] || 0
    
    @accounting_period = options[:accounting_period] #|| '1_2014'
  end
  
  def init_output_params(options)
    @simplify_tarif_results = (options[:simplify_tarif_results] == 'true' ? true : false) 
    @save_tarif_results_ord = (options[:save_tarif_results_ord] == 'true' ? true : false) 
    @analyze_memory_used = (options[:analyze_memory_used] == 'true' ? true : false) 
    @analyze_query_constructor_performance = (options[:analyze_query_constructor_performance] == 'true' ? true : false) 
    @output_call_ids_to_tarif_results = false; @output_call_count_to_tarif_results = false
    @save_interim_results_after_calculating_tarif_results = (options[:save_interim_results_after_calculating_tarif_results] == 'true' ? true : false)
#    @save_interim_results_after_calculating_final_tarif_sets = (options[:save_interim_results_after_calculating_final_tarif_sets] == 'true' ? true : false)
  end
  
  def init_additional_general_classes
    @performance_checker = ServiceHelper::PerformanceChecker.new()
    performance_checker.clean_history;
    performance_checker.run_check_point('init_additional_general_classes', 1) do
      @optimization_result_saver = ServiceHelper::OptimizationResultSaver.new('optimization_results', nil, user_id)
      @final_tarif_sets_saver = ServiceHelper::OptimizationResultSaver.new('optimization_results', 'final_tarif_sets', user_id)
      @prepared_final_tarif_results_saver = ServiceHelper::OptimizationResultSaver.new('optimization_results', 'prepared_final_tarif_results', user_id)
      @calls_stat_calculator = ServiceHelper::CallsStatCalculator.new({:user_id => user_id, :accounting_period => accounting_period})
      @tarif_optimization_sql_builder = ServiceHelper::TarifOptimizationSqlBuilder.new(self, {:user_id => user_id, :accounting_period => accounting_period})
      @minor_result_saver = ServiceHelper::OptimizationResultSaver.new('optimization_results', 'minor_results', user_id)
      @tarif_list_generator = ServiceHelper::TarifListGenerator.new(options[:services_by_operator] || {})
#              raise(StandardError)
#      @final_tarif_set_generator = ServiceHelper::FinalTarifSetGenerator.new(options[:services_by_operator] || {})
      @background_process_informer_operators = options[:background_process_informer_operators] || ServiceHelper::BackgroundProcessInformer.new('operators_optimization', user_id)
      @background_process_informer_tarifs = options[:background_process_informer_tarifs] || ServiceHelper::BackgroundProcessInformer.new('tarifs_optimization', user_id)
      @background_process_informer_tarif = options[:background_process_informer_tarif] || ServiceHelper::BackgroundProcessInformer.new('tarif_optimization', user_id)
      @operator_description = {}; Category.operators.all.each {|r| @operator_description[r['id'].to_s] = r}
    end
  end
  
  def init_optimization_params
    @optimization_params = {:common => ['multiple_use_of_tarif_option', 'auto_turbo_buttons'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['multiple_use_of_tarif_option']}
#    @optimization_params = {:common => ['single_use_of_tarif_option'], :onetime => [], :periodic => [], :calls => [], :sms => [], :internet => ['single_use_of_tarif_option']}
    @check_sql_before_running = false
    @execute_additional_sql = false
    @service_ids_batch_size = (options[:service_ids_batch_size] ? options[:service_ids_batch_size].to_i : 10)
  end
  
  def calculate_all_operator_tarifs
    performance_checker.run_check_point('calculate_all_operator_tarifs', 1) do
      background_process_informer_operators.init(0.0, tarif_list_generator.operators.size)
      
      background_process_informer_operators.increase_current_value(0, "clean_output_results")
      [optimization_result_saver, final_tarif_sets_saver, prepared_final_tarif_results_saver, minor_result_saver].each {|saver| saver.clean_output_results} 

      background_process_informer_operators.increase_current_value(0, "calculating all_operator_tarifs")
      tarif_list_generator.operators.each do |operator| 
        calculate_one_operator(operator) if !tarif_list_generator.tarifs[operator].blank?
        background_process_informer_operators.increase_current_value(1)
      end
    end

#raise(StandardError)
    update_minor_results
    
    background_process_informer_operators.increase_current_value(0, "finish calculating operators")
    background_process_informer_operators.finish
  end
  
  def update_minor_results
    performance_checker.run_check_point('update_minor_results', 2) do
      background_process_informer_operators.increase_current_value(0, "update_minor_results")
      tarif_list_generator.calculate_service_packs; tarif_list_generator.calculate_service_packs_by_parts
      
      used_memory_by_output = {}
      performance_checker.run_check_point('memory_usage_analyze_for_output', 4) do      
        used_memory_by_output = calculate_used_memory(output)
      end if analyze_memory_used    
    
      
      minor_result_saver.override({:result => 
        {:performance_results => performance_checker.show_stat_hash,
         :calls_stat => calls_stat_calculator.calculate_calls_stat(query_constructor),
         :service_packs_by_parts => tarif_list_generator.tarif_sets,
#         :service_packs_by_parts => tarif_list_generator.service_packs_by_parts,
         :used_memory_by_output => used_memory_by_output,
         }})
    end
  end
  
  def calculate_and_save_final_tarif_sets
    return nil if !save_interim_results_after_calculating_tarif_results
    performance_checker.run_check_point('calculate_and_save_final_tarif_sets', 1) do
      background_process_informer_operators.init(0.0, tarif_list_generator.operators.size)
      background_process_informer_operators.increase_current_value(0, "clean_output_results")
      [final_tarif_sets_saver, prepared_final_tarif_results_saver].each {|saver| saver.clean_output_results}
      
      background_process_informer_operators.increase_current_value(0, "calculate_and_save_final_tarif_sets_by_tarif")
      tarif_list_generator.operators.each do |operator|
        background_process_informer_tarifs.init(0.0, tarif_list_generator.tarifs[operator].size )
        tarif_list_generator.tarifs[operator].each do |tarif|
          calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period)
          background_process_informer_tarifs.increase_current_value(1)
        end
        background_process_informer_tarifs.increase_current_value(0, "finish calculating one operator tarifs")
        background_process_informer_tarifs.finish
        background_process_informer_operators.increase_current_value(1)
      end
      background_process_informer_operators.increase_current_value(0, "finish calculating operators")
      background_process_informer_operators.finish
    end        
  end
  
  def prepare_and_save_final_tarif_results
    return nil if !(save_interim_results_after_calculating_tarif_results)# and save_interim_results_after_calculating_final_tarif_sets)
    performance_checker.run_check_point('prepare_and_save_final_tarif_results', 1) do
      background_process_informer_operators.init(0.0, tarif_list_generator.operators.size)
      background_process_informer_operators.increase_current_value(0, "clean_output_results")
      [prepared_final_tarif_results_saver].each {|saver| saver.clean_output_results}
      
      background_process_informer_operators.increase_current_value(0, "prepare_and_save_final_tarif_results_by_tarif")
      tarif_list_generator.operators.each do |operator|
        background_process_informer_tarifs.init(0.0, tarif_list_generator.tarifs[operator].size )
        tarif_list_generator.tarifs[operator].each do |tarif|
          prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period)
          background_process_informer_tarifs.increase_current_value(1)
        end
        background_process_informer_tarifs.increase_current_value(0, "finish calculating one operator tarifs")
        background_process_informer_tarifs.finish
        background_process_informer_operators.increase_current_value(1)
      end
      background_process_informer_operators.increase_current_value(0, "finish calculating operators")
      background_process_informer_operators.finish
    end        
  end
  
  def calculate_one_operator(operator)
    performance_checker.run_check_point('calculate_one_operator', 2) do      
      background_process_informer_tarifs.init(0.0, tarif_list_generator.tarifs[operator].size )
            
      init_input_for_one_operator_calculation(operator)    
                  
      background_process_informer_tarifs.increase_current_value(0, "calculate_calls_count_by_parts")
      performance_checker.run_check_point('calculate_calls_count_by_parts', 3) do
        @calls_count_by_parts = calls_stat_calculator.calculate_calls_count_by_parts(query_constructor, 
          tarif_list_generator.uniq_parts_by_operator[operator], tarif_list_generator.uniq_parts_criteria_by_operator[operator])
      end      
      
      background_process_informer_tarifs.increase_current_value(0, "calculate_tarifs")
      tarif_list_generator.tarifs[operator].each do |tarif|
        calculate_one_tarif(operator, tarif)
        background_process_informer_tarifs.increase_current_value(1)
      end        
      background_process_informer_tarifs.increase_current_value(0, "finish calculating one operator tarifs")
      background_process_informer_tarifs.finish
    end
  end 
  
  def init_input_for_one_operator_calculation(operator)
    performance_checker.run_check_point('init_input_for_one_operator_calculation', 3) do
      background_process_informer_tarifs.increase_current_value(0, "init_input_for_one_operator_calculation")
      @fq_tarif_operator_id = operator
      @operator_id = operator
      performance_checker.run_check_point('@stat_function_collector', 4) do
        @stat_function_collector = ServiceHelper::StatFunctionCollector.new(tarif_list_generator.all_services_by_operator[operator], optimization_params)
      end
      performance_checker.run_check_point('@query_constructor', 4) do
        @query_constructor = ServiceHelper::QueryConstructor.new(self, {
          :tarif_class_ids => tarif_list_generator.all_services_by_operator[operator], 
          :performance_checker => (analyze_query_constructor_performance ? performance_checker : nil),
          :user_id => user_id,
          :accounting_period => accounting_period,
          } )
      end
      performance_checker.run_check_point('@max_formula_order_collector', 4) do
        @max_formula_order_collector = ServiceHelper::MaxPriceFormulaOrderCollector.new(tarif_list_generator.all_services_by_operator[operator], operator)
      end
      background_process_informer_tarifs.increase_current_value(0, "")
    end
  end
  
  def calculate_one_tarif(operator, tarif)
    performance_checker.run_check_point('calculate_one_tarif', 3) do      
      background_process_informer_tarif.init(0.0, 100.0)
      background_process_informer_tarif.increase_current_value(0, "init_input_for_one_tarif_calculation")
      init_input_for_one_tarif_calculation(operator, tarif)  
      
      background_process_informer_tarif.init(0.0, tarif_list_generator.all_tarif_parts_count[operator])
      
      background_process_informer_tarif.increase_current_value(0, "calculate_tarif_results")
      [tarif_list_generator.tarif_options_slices, tarif_list_generator.tarifs_slices].each do |service_slice| 
        calculate_tarif_results(operator, service_slice)
      end
      
      current_tarif_optimization_results.update_all_tarif_results_with_missing_prev_results
      current_tarif_optimization_results.calculate_all_cons_tarif_results_by_parts        
      tarif_sets, tarif_results, groupped_identical_services = simplify_tarif_resuts_by_tarif(operator, tarif, accounting_period)
          
      if save_interim_results_after_calculating_tarif_results
        save_tarif_results(operator, tarif, accounting_period, {:tarif_sets => tarif_sets, :tarif_results => tarif_results, :groupped_identical_services => groupped_identical_services})    
        calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period)
      else
        final_tarif_set_generator = calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period, {
          :tarif_sets => tarif_sets,
          :cons_tarif_results => current_tarif_optimization_results.cons_tarif_results,
          :cons_tarif_results_by_parts => current_tarif_optimization_results.cons_tarif_results_by_parts,
          :tarif_results => tarif_results, 
          :groupped_identical_services => groupped_identical_services,
          :tarif_results_ord => (save_tarif_results_ord ? current_tarif_optimization_results.tarif_results_ord : {}), 
  
          :services_that_depended_on => tarif_list_generator.services_that_depended_on,      
          :service_description => tarif_list_generator.service_description,   
          :common_services_by_parts => tarif_list_generator.common_services_by_parts,   
          :common_services => tarif_list_generator.common_services,          
        }.stringify_keys)
      end
#      raise(StandardError)
      if save_interim_results_after_calculating_tarif_results #and save_interim_results_after_calculating_final_tarif_sets
        prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period)
      else
        prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period, nil,  {
          :final_tarif_sets => final_tarif_set_generator.final_tarif_sets,
          :tarif_results => final_tarif_set_generator.tarif_results,
          :groupped_identical_services => final_tarif_set_generator.groupped_identical_services,
          :service_description => tarif_list_generator.service_description, 
          :operator_description => operator_description, 
          :categories => query_constructor.categories_as_hash,
          :tarif_categories => query_constructor.tarif_class_categories,
          :tarif_category_groups => query_constructor.category_groups,
          :tarif_class_categories_by_category_group => query_constructor.tarif_class_categories_by_category_group,
        }.stringify_keys)
      end      
      
      background_process_informer_tarif.increase_current_value(0, "finish calculating one tarif")
      background_process_informer_tarif.finish
    end
  end
  
  def init_input_for_one_tarif_calculation(operator, tarif = nil)
    performance_checker.run_check_point('init_input_for_one_tarif_calculation', 4) do
      performance_checker.run_check_point('@tarif_list_generator', 5) do
        tarif_list_generator.calculate_tarif_sets_and_slices(operator, tarif)
      end
      @current_tarif_optimization_results = ServiceHelper::CurrentTarifOptimizationResults.new(self)
    end
  end
  
  def save_tarif_results(operator, tarif = nil, accounting_period = '1_2014', result_to_save = {})
    output = {}
    performance_checker.run_check_point('save_tarif_results', 4) do
      background_process_informer_tarif.increase_current_value(0, "override_tarif_results")
      optimization_result_saver.override({:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => {
        :tarif_sets => result_to_save[:tarif_sets],
        :cons_tarif_results => current_tarif_optimization_results.cons_tarif_results,
        :cons_tarif_results_by_parts => current_tarif_optimization_results.cons_tarif_results_by_parts,
        :tarif_results => result_to_save[:tarif_results], 
        :groupped_identical_services => result_to_save[:groupped_identical_services],
        :tarif_results_ord => (save_tarif_results_ord ? current_tarif_optimization_results.tarif_results_ord : {}), 

        :services_that_depended_on => tarif_list_generator.services_that_depended_on,      
        :service_description => tarif_list_generator.service_description,   
        :common_services_by_parts => tarif_list_generator.common_services_by_parts,   
        :common_services => tarif_list_generator.common_services,
        } } )
    end

  end
  
  def simplify_tarif_resuts_by_tarif(operator, tarif, accounting_period)
    performance_checker.run_check_point('simplify_tarif_resuts_by_tarif', 4) do
      tarif_result_simlifier = ServiceHelper::TarifResultSimlifier.new(options[:services_by_operator] || {})
      
      tarif_result_simlifier.set_input_data({
        :tarif_sets => tarif_list_generator.tarif_sets,          
        :services_that_depended_on => tarif_list_generator.services_that_depended_on,
        :operator => operator,      
        :tarif => tarif,
        :common_services_by_parts => tarif_list_generator.common_services_by_parts, 
        :common_services => tarif_list_generator.common_services,  
        :cons_tarif_results_by_parts => current_tarif_optimization_results.cons_tarif_results_by_parts,
        :tarif_results => current_tarif_optimization_results.tarif_results,
        :cons_tarif_results => current_tarif_optimization_results.cons_tarif_results,
        :background_process_informer_tarif => background_process_informer_tarif,
      })
      
      tarif_result_simlifier.simplify_tarif_results_and_tarif_sets
    end
  end
  
  def calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period, saved_results = nil)
    performance_checker.run_check_point('calculate_and_save_final_tarif_sets_by_tarif', 4) do    
      background_process_informer_tarif.init(0.0, 10.0)
      background_process_informer_tarif.increase_current_value(0, "init final_tarif_set_generator")
      final_tarif_set_generator = ServiceHelper::FinalTarifSetGenerator.new(options[:services_by_operator] || {})
      
      saved_results ||= optimization_result_saver.results({:operator_id => operator, :tarif_id => tarif, :accounting_period => accounting_period})
      
      final_tarif_set_generator.set_input_data({
        :tarif_sets => saved_results['tarif_sets'],          
        :services_that_depended_on => saved_results['services_that_depended_on'],
        :operator => operator,      
        :common_services_by_parts => saved_results['common_services_by_parts'], 
        :common_services => saved_results['common_services'],  
        :cons_tarif_results_by_parts => saved_results['cons_tarif_results_by_parts'],
        :tarif_results => saved_results['tarif_results'],
        :cons_tarif_results => saved_results['cons_tarif_results'],
        :groupped_identical_services => saved_results['groupped_identical_services'],
      })
      saved_results = nil
      
      performance_checker.run_check_point('calculate_final_tarif_sets_by_tarif', 3) do
        background_process_informer_tarif.increase_current_value(0, "calculate_final_tarif_sets")
        final_tarif_set_generator.calculate_final_tarif_sets(operator, tarif, background_process_informer_tarif)
      end
      
      performance_checker.run_check_point('save_final_tarif_sets_by_tarif', 3) do
        background_process_informer_tarif.increase_current_value(0, "override final_tarif_sets")
#        raise(StandardError)
        final_tarif_sets_saver.override(
          {:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => {
            :final_tarif_sets => final_tarif_set_generator.final_tarif_sets,
            :tarif_results => final_tarif_set_generator.tarif_results,
            :groupped_identical_services => final_tarif_set_generator.groupped_identical_services,
            :service_description => tarif_list_generator.service_description,
            :operator_description => operator_description,
            :categories => query_constructor.categories_as_hash,
            :tarif_categories => query_constructor.tarif_class_categories,
            :tarif_category_groups => query_constructor.category_groups,
            :tarif_class_categories_by_category_group => query_constructor.tarif_class_categories_by_category_group,
            :current_tarif_set_calculation_history => final_tarif_set_generator.current_tarif_set_calculation_history,
            }}
        ) if save_interim_results_after_calculating_tarif_results #save_interim_results_after_calculating_final_tarif_sets
      end 
            
      final_tarif_set_generator = nil if save_interim_results_after_calculating_tarif_results
      final_tarif_set_generator
    end
  end

  def prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period, input_data = {}, saved_results = nil)
    performance_checker.run_check_point('prepare_and_save_final_tarif_results_by_tarif_for_presenatation', 4) do
      background_process_informer_tarif.increase_current_value(0, "get saved final_tarif_sets")
      saved_results ||= final_tarif_sets_saver.results({:operator_id => operator, :tarif_id => tarif, :accounting_period => accounting_period})
#        raise(StandardError)
      
      background_process_informer_tarif.increase_current_value(0, "calculate final_tarif_set_preparator")
      prepared_final_tarif_results = ServiceHelper::FinalTarifResultPreparator.prepare_final_tarif_results_by_tarif({
        :final_tarif_sets => saved_results['final_tarif_sets'].stringify_keys,
        :tarif_results => saved_results['tarif_results'].stringify_keys,
        :groupped_identical_services => saved_results['groupped_identical_services'].stringify_keys,
        :service_description => saved_results['service_description'].stringify_keys,
        :operator_description => saved_results['operator_description'].stringify_keys,
        :categories => saved_results['categories'].stringify_keys,
        :tarif_categories => saved_results['tarif_categories'].stringify_keys,
        :tarif_category_groups => saved_results['tarif_category_groups'].stringify_keys,
        :tarif_class_categories_by_category_group => saved_results['tarif_class_categories_by_category_group'].stringify_keys,
        :operator => operator, 
        :tarif => tarif, 
      })
      background_process_informer_tarif.increase_current_value(0, "override prepared_final_tarif_results_by_tarif")
      prepared_final_tarif_results_saver.override({:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => prepared_final_tarif_results})
      result = {}
    end    
  
    background_process_informer_tarif.increase_current_value(0, "")
    background_process_informer_tarif.finish
  end
    
  def calculate_tarif_results(operator, service_slice)
    performance_checker.run_check_point('calculate_tarif_results', 5) do
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
    performance_checker.run_check_point('calculate_tarif_results_batches', 6) do
      batch_count = 1    
      while batch_count <= ( current_tarif_optimization_results.service_ids_to_calculate.count / service_ids_batch_size + 1) 
        batch_low_limit = service_ids_batch_size * (batch_count - 1)
        batch_high_limit = [batch_low_limit + service_ids_batch_size - 1, current_tarif_optimization_results.service_ids_to_calculate.count - 1].min
        
        calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
        
        batch_count += 1
        background_process_informer_tarif.increase_current_value(batch_high_limit - batch_low_limit + 1) 
      end if current_tarif_optimization_results.service_ids_to_calculate
    end
  end
  
  def calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
    performance_checker.run_check_point('calculate_tarif_results_batch', 7) do
      sql = ""
      performance_checker.run_check_point('calculate_service_part_sql', 8) do
        sql = tarif_optimization_sql_builder.calculate_service_part_sql(current_tarif_optimization_results.service_ids_to_calculate[batch_low_limit..batch_high_limit], price_formula_order)
      end
      executed_tarif_result_batch_sql = execute_tarif_result_batch_sql(sql)  
      performance_checker.run_check_point('process_tarif_results_batch', 8) do
        current_tarif_optimization_results.process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
      end   
    end
  end
  
  def execute_tarif_result_batch_sql(sql)
    performance_checker.run_check_point('execute_tarif_result_batch_sql', 8) do
      tarif_optimization_sql_builder.check_sql(sql, current_tarif_optimization_results.service_ids_to_calculate.count, sql.split(' ').size)
      Customer::Call.find_by_sql(sql) unless sql.blank?
    end
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
      :background_process_informer_operators => General::MemoryUsage.analyze(@background_process_informer_operators),
      :background_process_informer_tarifs => General::MemoryUsage.analyze(@background_process_informer_tarifs),
      :background_process_informer_tarif => General::MemoryUsage.analyze(@background_process_informer_tarif),
    }
  end
  
  module Helper
  end

end

