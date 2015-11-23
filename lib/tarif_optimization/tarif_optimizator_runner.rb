class TarifOptimization::TarifOptimizatorRunner
  def self.recalculate_direct(controller_options)
    options = optimization_params(controller_options)
    options_to_add = {:use_background_process_informers => false, :if_clean_output_results => true, :is_send_email => false, :update_call_stat => true }
    calculate(options.merge(options_to_add))
  end
  
  def self.recalculate_with_spawling(controller_options)
    options = optimization_params(controller_options)    
    Spawnling.new(:argv => "optimize for #{options[:user_input][:user_id]}") do
      options_to_add = {:use_background_process_informers => true, :if_clean_output_results => true, :is_send_email => true, :update_call_stat => true }
      calculate(options.merge(options_to_add))
    end
  end
  
  def self.recalculate_with_delayed_job(controller_options)
    options = optimization_params(controller_options)
    priority = options[:user_input][:user_priority]
    
    TarifOptimization::TarifOptimizator.new(options).clean_output_results
    TarifOptimization::TarifOptimizator.new(options).clean_new_results
    
    is_send_email = false
    number_of_workers_to_add = 0
    options[:services_by_operator][:operators].each do |operator|
      options[:services_by_operator][:tarifs][operator].each do |tarif|
        services = {:services_by_operator => {}}
        services[:operators] = [operator]
        services[:tarifs] = {operator => [tarif]}
        services[:tarif_options] = {operator => options[:services_by_operator][:tarif_options][operator]}
        services[:common_services] = {operator => options[:services_by_operator][:common_services][operator]}

        if operator == options[:services_by_operator][:operators].last and tarif == options[:services_by_operator][:tarifs][operator].last
          is_send_email = options[:user_input][:user_id] ? true : false 
          update_call_stat = true
        end
        options_to_add = {:use_background_process_informers => false, :if_clean_output_results => false, :services_by_operator => services, 
                          :is_send_email => is_send_email, :update_call_stat => update_call_stat} 
        options_to_calculate = options.merge(options_to_add)
        number_of_workers_to_add += 1
        
        Delayed::Job.enqueue Background::Job::TarifOptimization.new(options_to_calculate), 
          :priority => priority, :reference_id => options[:user_input][:user_id], :reference_type => 'user'
      end if options[:services_by_operator][:tarifs] and options[:services_by_operator][:tarifs][operator]
    end if options[:services_by_operator] and options[:services_by_operator][:operators]       
    
    base_worker_add_number = (options[:tarif_optimizator_input][:max_number_of_tarif_optimization_workers] || 3).to_i
    base_worker_add_number = options[:user_input][:user_id] == 1 ? base_worker_add_number : 1
    number_of_workers_to_add = [
      base_worker_add_number - Background::WorkerManager::Manager.worker_quantity('tarif_optimization'),
      number_of_workers_to_add
    ].min
    Background::WorkerManager::Manager.start_number_of_worker('tarif_optimization', number_of_workers_to_add)
    i = 0
  end
    
  def self.calculate(options)
    tarif_optimizator = TarifOptimization::TarifOptimizator.new(options)   

    Customer::Stat::PerformanceChecker.apply(TarifOptimization::TarifOptimizator)
    Customer::Stat::PerformanceChecker.apply(TarifOptimization::FinalTarifSetGenerator)
    Customer::Stat::PerformanceChecker.apply(TarifOptimization::CurrentTarifSet)
    Customer::Stat::PerformanceChecker.apply(TarifOptimization::QueryConstructor)
    Customer::Stat::PerformanceChecker.apply(TarifOptimization::CurrentTarifOptimizationResults)

    if options[:use_background_process_informers]
      Customer::BackgroundStat::Informer.apply(TarifOptimization::TarifOptimizator)
      Customer::BackgroundStat::Informer.apply(TarifOptimization::FinalTarifSetGenerator)
    end

    tarif_optimizator.calculate_all_operator_tarifs
    tarif_optimizator.update_minor_results

    UserMailer.tarif_optimization_complete(options[:user_input][:user_id], options[:user_input][:result_run_id]).
      deliver if options[:is_send_email] == true    
  end
  
  def self.optimization_params(options = {})
    optimization_params = options[:optimization_params]
    calculation_choices = options[:calculation_choices]
    selected_service_categories = options[:selected_service_categories]
    services_by_operator = options[:services_by_operator]
    temp_value = options[:temp_value]
    {
     :tarif_optimizator_input => {
        :save_tarif_results_ord => optimization_params['save_tarif_results_ord'], 
        :save_new_final_tarif_results_in_my_batches => optimization_params['save_new_final_tarif_results_in_my_batches'],
        :calculate_old_final_tarif_preparator => optimization_params['calculate_old_final_tarif_preparator'],
        :save_interim_results_after_calculating_tarif_results => optimization_params['save_interim_results_after_calculating_tarif_results'], 
        :analyze_query_constructor_performance => optimization_params['analyze_query_constructor_performance'], 
        :max_number_of_tarif_optimization_workers => optimization_params['max_number_of_tarif_optimization_workers'],
       },
     :optimization_params => {
        :service_ids_batch_size => optimization_params['service_ids_batch_size'], 
        :simplify_tarif_results => optimization_params['simplify_tarif_results'], 
       },
     :user_input => {
        :accounting_period => calculation_choices['accounting_period'],
        :call_run_id => calculation_choices['call_run_id'],
        :calculate_with_limited_scope => calculation_choices['calculate_with_limited_scope'],
        :selected_service_categories => selected_service_categories,
        :result_run_id => calculation_choices['result_run_id'],
        :user_id => temp_value[:user_id],
        :user_region_id => temp_value[:user_region_id],                   
       },
     :services_by_operator => services_by_operator,
     :final_tarif_set_generator_params => {
        :use_short_tarif_set_name => optimization_params['use_short_tarif_set_name'], 
        :max_tarif_set_count_per_tarif => optimization_params['max_tarif_set_count_per_tarif'],
        :save_current_tarif_set_calculation_history => optimization_params['save_current_tarif_set_calculation_history'],
        :use_price_comparison_in_current_tarif_set_calculation => optimization_params['use_price_comparison_in_current_tarif_set_calculation'],
        :part_sort_criteria_in_price_optimization => optimization_params['part_sort_criteria_in_price_optimization'],       
       },
     :tarif_list_generator_params => {
        :calculate_with_multiple_use => optimization_params['calculate_with_multiple_use'],
        :calculate_only_chosen_services => calculation_choices['calculate_only_chosen_services'],
        :calculate_with_fixed_services => calculation_choices['calculate_with_fixed_services'],       
       }, 
     :tarif_result_simlifier_params => {
        :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results => optimization_params['if_update_tarif_sets_to_calculate_from_with_cons_tarif_results'],
        :eliminate_identical_tarif_sets => optimization_params['eliminate_identical_tarif_sets'],       
       }, 
     }   
  end

end
