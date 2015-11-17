#TODO убрать part 'mms'
#TODO - обновить в тарифах поля с month, day or week

class TarifOptimization::TarifOptimizator

#дополнительные классы
  attr_reader :tarif_list_generator, :final_tarif_set_generator, :stat_function_collector, :query_constructor, :optimization_result_saver, :minor_result_saver, 
              :final_tarif_sets_saver, :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif, 
              :performance_checker, :current_tarif_optimization_results, :tarif_optimization_sql_builder, :max_formula_order_collector, 
              :calls_stat_calculator, :prepared_final_tarif_results_saver, :operator_description
#входные данные              
  attr_reader :options, :use_background_process_informers
# параметры оптимизации 
  attr_reader :optimization_params, :check_sql_before_running, :execute_additional_sql, :service_ids_batch_size
#настройки вывода результатов
  attr_reader  :simplify_tarif_results, :save_tarif_results_ord, :output_call_ids_to_tarif_results, :output_call_count_to_tarif_results, 
               :analyze_query_constructor_performance, :save_interim_results_after_calculating_tarif_results, :analyze_final_tarif_set_generator_performance,
               :calculate_old_final_tarif_preparator, :save_new_final_tarif_results_in_my_batches
               #, :save_interim_results_after_calculating_final_tarif_sets
               
#user input
  attr_reader :user_id, :fq_tarif_region_id, :accounting_period, :call_run_id, :selected_service_categories, :calculate_with_limited_scope, :result_run_id
#local
  attr_reader :calls_count_by_parts
  
  def initialize(options = {})
    init_input_data(options)
    init_output_params(options)
    @performance_checker = Customer::Stat::PerformanceChecker.new()
#    performance_checker.clean_history;
   init_additional_general_classes    
    init_optimization_params
  end
  
  def init_input_data(options)
    @options = options
    @use_background_process_informers = options[:use_background_process_informers] != nil ? options[:use_background_process_informers] : true
    @fq_tarif_region_id = ((options[:user_input][:user_region_id] and options[:user_input][:user_region_id] != 0) ? options[:user_input][:user_region_id] : 1238)
    @user_id = options[:user_input][:user_id] || 0
    @result_run_id = options[:user_input][:result_run_id] || 0
    @calculate_with_limited_scope = (options[:user_input][:calculate_with_limited_scope] == 'true' ? true : false)
    @selected_service_categories = options[:user_input][:selected_service_categories]
    @accounting_period = options[:user_input][:accounting_period] #|| '1_2014'
    @call_run_id = options[:user_input][:call_run_id] 
  end
  
  def init_output_params(options)
    @simplify_tarif_results = (options[:optimization_params][:simplify_tarif_results] == 'true' ? true : false) 
    @save_tarif_results_ord = (options[:tarif_optimizator_input][:save_tarif_results_ord] == 'true' ? true : false) 
    @analyze_query_constructor_performance = (options[:tarif_optimizator_input][:analyze_query_constructor_performance] == 'true' ? true : false) 
    @analyze_final_tarif_set_generator_performance = true
    @output_call_ids_to_tarif_results = false; @output_call_count_to_tarif_results = false
    @save_interim_results_after_calculating_tarif_results = (options[:tarif_optimizator_input][:save_interim_results_after_calculating_tarif_results] == 'true' ? true : false)
    @calculate_old_final_tarif_preparator = (options[:tarif_optimizator_input][:calculate_old_final_tarif_preparator] == 'true' ? true : false)
    @save_new_final_tarif_results_in_my_batches = (options[:tarif_optimizator_input][:save_new_final_tarif_results_in_my_batches] == 'true' ? true : false)
  end
  
  def init_additional_general_classes
    @optimization_result_saver = Customer::Stat::OptimizationResult.new('optimization_results', nil, user_id)
    @final_tarif_sets_saver = Customer::Stat::OptimizationResult.new('optimization_results', 'final_tarif_sets', user_id)
    @prepared_final_tarif_results_saver = Customer::Stat::OptimizationResult.new('optimization_results', 'prepared_final_tarif_results', user_id)
    @calls_stat_calculator = Customer::Call::StatCalculator.new(
      {:user_id => user_id, :accounting_period => accounting_period, :call_run_id => call_run_id})
    @tarif_optimization_sql_builder = TarifOptimization::TarifOptimizationSqlBuilder.new(self, 
      {:user_id => user_id, :accounting_period => accounting_period, :call_run_id => call_run_id})
    @minor_result_saver = Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', user_id)
    @tarif_list_generator = TarifOptimization::TarifListGenerator.new(options || {})
    if use_background_process_informers
      @background_process_informer_operators = options[:background_process_informer_operators] || Customer::BackgroundStat::Informer.new('operators_optimization', user_id)
      @background_process_informer_tarifs = options[:background_process_informer_tarifs] || Customer::BackgroundStat::Informer.new('tarifs_optimization', user_id)
      @background_process_informer_tarif = options[:background_process_informer_tarif] || Customer::BackgroundStat::Informer.new('tarif_optimization', user_id)
    end
    @operator_description = {}; Category::Operator.operators.all.each {|r| @operator_description[r['id'].to_s] = r}
  end
  
  def init_optimization_params
    @optimization_params = {:common => ['multiple_use_of_tarif_option', 'auto_turbo_buttons'], :onetime => [], :periodic => [], :calls => ['multiple_use_of_tarif_option'], :sms => ['multiple_use_of_tarif_option'], :internet => ['multiple_use_of_tarif_option']}
    @check_sql_before_running = false
    @execute_additional_sql = false
    @service_ids_batch_size = (options[:optimization_params][:service_ids_batch_size] ? options[:optimization_params][:service_ids_batch_size].to_i : 10)
  end  

  def calculate_all_operator_tarifs
    clean_output_results if options[:if_clean_output_results]
    clean_new_results  if options[:if_clean_output_results]
    tarif_list_generator.operators.each do |operator| 
      calculate_one_operator(operator) if !tarif_list_generator.tarifs[operator].blank?
    end
#    update_minor_results    
  end
  
  def clean_output_results
    [optimization_result_saver, final_tarif_sets_saver, prepared_final_tarif_results_saver, minor_result_saver].each {|saver| saver.clean_output_results}
  end
  
  def calculate_one_operator(operator)
    init_input_for_one_operator_calculation(operator)                    
    init_calls_count_by_parts(operator)
    
    @calcutate_with_tarif_slices = true
    if !@calcutate_with_tarif_slices
      init_input_for_one_tarif_calculation(operator)  
      tarif_optimization_sql_builder.calculate_tarif_results_through_categories(operator)
    end

    tarif_list_generator.tarifs[operator].each do |tarif|
      calculate_one_tarif(operator, tarif)
    end        

  end 
  
  def init_calls_count_by_parts(operator)
#    raise(StandardError, selected_service_categories)
    calls_stat_calculator.calculate_calculation_scope(query_constructor, selected_service_categories) if true #calculate_with_limited_scope
    @calls_count_by_parts = calls_stat_calculator.calculate_calls_count_by_parts(query_constructor, 
      tarif_list_generator.uniq_parts_by_operator[operator], tarif_list_generator.uniq_parts_criteria_by_operator[operator])    
  end
  
  def init_input_for_one_operator_calculation(operator)
    @fq_tarif_operator_id = operator

    init_stat_function_collector(operator)    
    init_query_constructor(operator)
    init_max_formula_order_collector(operator)
  end
  
  def init_stat_function_collector(operator)
    @stat_function_collector = TarifOptimization::StatFunctionCollector.new(tarif_list_generator.all_services_by_operator[operator], 
        optimization_params, operator, @fq_tarif_region_id, true)
  end
  
  def init_query_constructor(operator)
    @query_constructor = TarifOptimization::QueryConstructor.new(self, {
      :tarif_class_ids => tarif_list_generator.all_services_by_operator[operator], 
      :performance_checker => (analyze_query_constructor_performance ? performance_checker : nil),
      }, operator, @fq_tarif_region_id, true )
  end
  
  def init_max_formula_order_collector(operator)
    @max_formula_order_collector = TarifOptimization::MaxPriceFormulaOrderCollector.new(tarif_list_generator.all_services_by_operator[operator], operator)
  end
  
  def update_minor_results
    tarif_list_generator.calculate_service_packs; tarif_list_generator.calculate_service_packs_by_parts
    
    start_time = minor_result_saver.results['start_time'].to_datetime if minor_result_saver.results and minor_result_saver.results['start_time']
    start_time = performance_checker.start if !start_time
    
    saved_performance_results = minor_result_saver.results['original_performance_results'] if minor_result_saver.results
    updated_original_performance_results = performance_checker.add_current_results_to_saved_results(saved_performance_results, start_time)
    
    minor_result_saver.save({:result => 
      {:performance_results => performance_checker.show_stat_hash(updated_original_performance_results),
       :original_performance_results => updated_original_performance_results,
       :start_time => start_time,
       :calls_stat => calls_stat_calculator.calculate_calls_stat(query_constructor),
#         :service_packs_by_parts => tarif_list_generator.tarif_sets, #,будет показывать только последний посчитанный тариф
       :service_packs_by_parts => tarif_list_generator.service_packs_by_parts,
       }})
  end
  
  def calculate_one_tarif(operator, tarif)
    if @calcutate_with_tarif_slices
      init_input_for_one_tarif_calculation(operator, tarif)  
      [tarif_list_generator.tarif_options_slices, tarif_list_generator.tarifs_slices].each do |service_slice| 
        calculate_tarif_results(operator, service_slice)
      end
    end
    
    current_tarif_optimization_results.update_all_tarif_results_with_missing_prev_results
    current_tarif_optimization_results.calculate_all_cons_tarif_results_by_parts        
    tarif_sets, tarif_results, groupped_identical_services = simplify_tarif_resuts_by_tarif(operator, tarif, accounting_period)
        
    if save_interim_results_after_calculating_tarif_results
      save_tarif_results(operator, tarif, accounting_period, {:tarif_sets => tarif_sets, :tarif_results => tarif_results, :groupped_identical_services => groupped_identical_services})    
      calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period)
    else
#      final_tarif_set_generator = 
      calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period, {
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

    if calculate_old_final_tarif_preparator
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
    end
    
  end
  
  def init_input_for_one_tarif_calculation(operator, tarif = nil)
    tarif_list_generator.set_parts(calls_stat_calculator.calculation_scope[:parts]) if true #calculate_with_limited_scope
    tarif_list_generator.calculate_tarif_sets_and_slices(operator, tarif)
    @current_tarif_optimization_results = TarifOptimization::CurrentTarifOptimizationResults.new(self)
  end
  
  def save_tarif_results(operator, tarif = nil, accounting_period = '1_2014', result_to_save = {})
    output = {}
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
  
  def simplify_tarif_resuts_by_tarif(operator, tarif, accounting_period)
    tarif_result_simlifier = TarifOptimization::TarifResultSimlifier.new(options[:tarif_result_simlifier_params] || {})
    
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
    })
    
    tarif_result_simlifier.simplify_tarif_results_and_tarif_sets
  end
  
  def calculate_and_save_final_tarif_sets_by_tarif(operator, tarif, accounting_period, saved_results = nil)
    @final_tarif_set_generator = TarifOptimization::FinalTarifSetGenerator.new(options[:final_tarif_set_generator_params] || {})
    
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
      :performance_checker => (analyze_final_tarif_set_generator_performance ? performance_checker : nil),        
    })

    saved_results = nil
    
    final_tarif_set_generator.calculate_final_tarif_sets(operator, tarif, background_process_informer_tarif)
    
    new_preparator_and_saver(operator, tarif.to_i, final_tarif_set_generator.final_tarif_sets,
        final_tarif_set_generator.groupped_identical_services,  final_tarif_set_generator.tarif_results)

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
          
#    final_tarif_set_generator = nil if save_interim_results_after_calculating_tarif_results
#    final_tarif_set_generator
  end
  
  def prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period, input_data = {}, saved_results = nil)
    saved_results ||= final_tarif_sets_saver.results({:operator_id => operator, :tarif_id => tarif, :accounting_period => accounting_period})
    
    prepared_final_tarif_results = TarifOptimization::FinalTarifResultPreparator.prepare_final_tarif_results_by_tarif({
      :final_tarif_sets => saved_results['final_tarif_sets'].stringify_keys,
      :tarif_results => saved_results['tarif_results'].stringify_keys,
      :groupped_identical_services => (saved_results['groupped_identical_services'] || {}).stringify_keys,
      :service_description => saved_results['service_description'].stringify_keys,
      :operator_description => saved_results['operator_description'].stringify_keys,
      :categories => saved_results['categories'].stringify_keys,
      :tarif_categories => saved_results['tarif_categories'].stringify_keys,
      :tarif_category_groups => saved_results['tarif_category_groups'].stringify_keys,
      :tarif_class_categories_by_category_group => saved_results['tarif_class_categories_by_category_group'].stringify_keys,
      :operator => operator, 
      :tarif => tarif, 
    })

    prepared_final_tarif_results_saver.override({:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => prepared_final_tarif_results})
    result = {}  
  end
  
  def calculate_tarif_results(operator, service_slice)
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
  
  def calculate_tarif_results_batches(price_formula_order)
    batch_count = 1    
    while batch_count <= ( current_tarif_optimization_results.service_ids_to_calculate.count / service_ids_batch_size + 1) 
      batch_low_limit = service_ids_batch_size * (batch_count - 1)
      batch_high_limit = [batch_low_limit + service_ids_batch_size - 1, current_tarif_optimization_results.service_ids_to_calculate.count - 1].min
      
      calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
      
      batch_count += 1
    end if current_tarif_optimization_results.service_ids_to_calculate
  end
  
  def calculate_tarif_results_batch(batch_low_limit, batch_high_limit, price_formula_order)
    sql = ""
    sql = calculate_service_part_sql(batch_low_limit, batch_high_limit, price_formula_order)

    executed_tarif_result_batch_sql = execute_tarif_result_batch_sql(sql)  
    
    process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
  end
  
  def calculate_service_part_sql(batch_low_limit, batch_high_limit, price_formula_order)
    tarif_optimization_sql_builder.calculate_service_part_sql(current_tarif_optimization_results.service_ids_to_calculate[batch_low_limit..batch_high_limit], price_formula_order)
  end
  
  def execute_tarif_result_batch_sql(sql)
    tarif_optimization_sql_builder.check_sql(sql, current_tarif_optimization_results.service_ids_to_calculate.count, sql.split(' ').size)
    Customer::Call.find_by_sql(sql) unless sql.blank?
  end
  
  def process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
    current_tarif_optimization_results.process_tarif_results_batch(executed_tarif_result_batch_sql, price_formula_order)
  end
  
 
  def calculate_tarif_results_for_tarif_sets(operator, tarif_sets_for_tarif)
    sql = tarif_optimization_sql_builder.calculate_tarif_set_sql_for_tarif_sets(operator, tarif_sets_for_tarif)
    executed_tarif_result_batch_sql = Customer::Call.find_by_sql(sql) unless sql.blank?       
    process_tarif_results_for_tarif_set(executed_tarif_result_batch_sql)
  end
  
  def clean_new_results
#    result_run = Result::Run.where(:id => user_id, :run => 1).first
    if result_run_id
#      Result::Run.where(:id => result_run_id).delete_all
      Result::Tarif.where(:run_id => result_run_id).delete_all
      Result::ServiceSet.where(:run_id => result_run_id).delete_all
      Result::Service.where(:run_id => result_run_id).delete_all
      Result::Agregate.where(:run_id => result_run_id).delete_all
      Result::ServiceCategory.where(:run_id => result_run_id).delete_all
    end

  end
  
  def new_preparator_and_saver(operator, tarif_id, final_tarif_sets, groupped_identical_services, tarif_results)
    run_id = result_run_id
    result_tarif_id = Result::Tarif.where(:run_id => run_id, :tarif_id => tarif_id).first_or_create()[:id]
#    raise(StandardError, [result_tarif_id, tarif_id, run_id, Result::Tarif.first_or_create(:run_id => run_id, :tarif_id => tarif_id).attributes])
    service_sets_array, services_array, categories_array, agregates_array = TarifOptimization::FinalTarifResultPreparator2.prepare_service_sets({
      :run_id => run_id, 
      :tarif_id => tarif_id, 
      :final_tarif_sets => final_tarif_sets, 
      :groupped_identical_services => groupped_identical_services, 
      :tarif_results => tarif_results, 
      :operator => operator,
      :categories => query_constructor.categories_as_hash.stringify_keys,
      :tarif_categories => query_constructor.tarif_class_categories.stringify_keys,
      :tarif_category_groups => query_constructor.category_groups.stringify_keys,
      :tarif_class_categories_by_category_group => query_constructor.tarif_class_categories_by_category_group.stringify_keys,
      })

#    raise(StandardError, Result::ServiceSet.create(service_sets_array).to_sql)
      
#    Result::ServiceSet.batch_save(service_sets_array, {})
    if save_new_final_tarif_results_in_my_batches
      Result::ServiceSet.bulk_insert values: service_sets_array
      Result::Service.bulk_insert values: services_array
      Result::ServiceCategory.bulk_insert values: categories_array
      Result::Agregate.bulk_insert values: agregates_array
      
#      Result::ServiceSet.batch_save(service_sets_array, {:id => -1})
#      Result::Service.batch_save(services_array, {:id => -1})
#      Result::ServiceCategory.batch_save(categories_array, {:id => -1})
#      Result::Agregate.batch_save(agregates_array, {:id => -1})
    else
      Result::ServiceSet.create(service_sets_array)
      Result::Service.create(services_array)
      Result::ServiceCategory.create(categories_array)
      Result::Agregate.create(agregates_array)
    end
    
  end

end

