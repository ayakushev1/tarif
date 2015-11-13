module Customer::TarifOptimizatorHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::ProgressBarable, SavableInSession::SessionInitializers

  attr_reader :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif
  
  def optimization_params
    create_filtrable("optimization_params")
  end
  
  def service_choices
    create_filtrable("service_choices")
  end
  
  def calculation_choices
    create_filtrable("calculation_choices")
  end
  
  def services_select
    create_filtrable("services_select")
  end
  
  def service_categories_select
    if params['service_categories_select_filtr']
      selected_services = Customer::Info::ServiceCategoriesSelect.selected_services_from_session_format(params['service_categories_select_filtr'], user_type)
      params['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.selected_services_to_session_format(selected_services)
    end
    create_filtrable("service_categories_select")
  end
  
  def services_for_calculation_select
    create_filtrable("services_for_calculation_select")
  end

  def operators_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_operators.current_values);
    create_progress_barable('operators_optimization', options)
  end
  
  def tarifs_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_tarifs.current_values);
    create_progress_barable('tarifs_optimization', options)
#    raise(StandardError)
  end
  
  def tarif_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_tarif.current_values);
    create_progress_barable('tarif_optimization', options)
  end

  def update_customer_infos
    Customer::Info::ServicesSelect.update_info(current_or_guest_user_id, session_filtr_params(services_select)) if user_type == :admin
    Customer::Info::ServiceChoices.update_info(current_or_guest_user_id, session_filtr_params(service_choices)) if user_type == :admin
    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))
    Customer::Info::ServiceCategoriesSelect.update_info(current_or_guest_user_id, session_filtr_params(service_categories_select))
    Customer::Info::TarifOptimizationParams.update_info(current_or_guest_user_id, session_filtr_params(optimization_params)) if user_type == :admin

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_recalculation_count')
    else
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_optimization_count')      
    end
  end
  
  def recalculate_with_spawling
    prepare_background_process_informer
    Spawnling.new(:argv => "optimize for #{current_or_guest_user_id}") do
      calculate(options.merge({:use_background_process_informers => true}))
      UserMailer.tarif_optimization_complete(current_or_guest_user_id).deliver
    end
  end
  
  def recalculate_with_delayed_job
    priority = Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
    update_customer_infos
    
    TarifOptimization::TarifOptimizator.new(options).clean_output_results
    TarifOptimization::TarifOptimizator.new(options).clean_new_results
    
    is_send_email = false
    number_of_workers_to_add = 0
    options[:services_by_operator][:operators].each do |operator|
      options[:services_by_operator][:tarifs][operator].each do |tarif|
        options_to_calculate = options.merge({:use_background_process_informers => false})
        options_to_calculate[:services_by_operator][:operators] = [operator]
        options_to_calculate[:services_by_operator][:tarifs] = {operator => [tarif]}
        options_to_calculate[:services_by_operator][:tarif_options] = {operator => options[:services_by_operator][:tarif_options][operator]}
        options_to_calculate[:services_by_operator][:common_services] = {operator => options[:services_by_operator][:common_services][operator]}
        is_send_email = true if operator == options[:services_by_operator][:operators].last and tarif == options[:services_by_operator][:tarifs][operator].last
        number_of_workers_to_add += 1
        
        Delayed::Job.enqueue Background::Job::TarifOptimization.new(options_to_calculate, is_send_email), 
          :priority => priority, :reference_id => current_or_guest_user_id, :reference_type => 'user'
      end if options[:services_by_operator][:tarifs] and options[:services_by_operator][:tarifs][operator]
    end if options[:services_by_operator] and options[:services_by_operator][:operators]       
    
    base_worker_add_number = (session_filtr_params(optimization_params)['max_number_of_tarif_optimization_workers'] || 3).to_i
    base_worker_add_number = current_or_guest_user_id == 1 ? base_worker_add_number : 1
    number_of_workers_to_add = [
      base_worker_add_number - Background::WorkerManager::Manager.worker_quantity('tarif_optimization'),
      number_of_workers_to_add
    ].min
    Background::WorkerManager::Manager.start_number_of_worker('tarif_optimization', number_of_workers_to_add)
    i = 0
  end
    
  def recalculate_direct
    calculate(options.merge({:use_background_process_informers => false}))
  end
  
  def calculate(options)
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

    tarif_optimizator.calculate_all_operator_tarifs(true)
    tarif_optimizator.update_minor_results
    
    update_customer_infos
  end
  
  def prepare_background_process_informer
    [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].compact.each do |background_process_informer|
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init
    end
    
  end
  
  def init_background_process_informer
#    GC.start
    @background_process_informer_operators ||= Customer::BackgroundStat::Informer.new('operators_optimization', current_or_guest_user_id)
    @background_process_informer_tarifs ||= Customer::BackgroundStat::Informer.new('tarifs_optimization', current_or_guest_user_id)
    @background_process_informer_tarif ||= Customer::BackgroundStat::Informer.new('tarif_optimization', current_or_guest_user_id)
  end
   
  def options
    optimization_params_session_filtr_params = session_filtr_params(optimization_params)
    service_choices_session_filtr_params = session_filtr_params(service_choices)
    calculation_choices_session_filtr_params = session_filtr_params(calculation_choices)
    {
     :operator => operator,

     
     :tarif_optimizator_input => {
        :save_tarif_results_ord => optimization_params_session_filtr_params['save_tarif_results_ord'], 
        :save_new_final_tarif_results_in_my_batches => optimization_params_session_filtr_params['save_new_final_tarif_results_in_my_batches'],
        :calculate_old_final_tarif_preparator => optimization_params_session_filtr_params['calculate_old_final_tarif_preparator'],
        :save_interim_results_after_calculating_tarif_results => optimization_params_session_filtr_params['save_interim_results_after_calculating_tarif_results'], 
        :analyze_query_constructor_performance => optimization_params_session_filtr_params['analyze_query_constructor_performance'], 
       },
     :optimization_params => {
        :service_ids_batch_size => optimization_params_session_filtr_params['service_ids_batch_size'], 
        :simplify_tarif_results => optimization_params_session_filtr_params['simplify_tarif_results'], 
       },
     :user_input => {
        :accounting_period => calculation_choices_session_filtr_params['accounting_period'],
        :calculate_with_limited_scope => calculation_choices_session_filtr_params['calculate_with_limited_scope'],
        :selected_service_categories => selected_service_categories,
        :new_run_id => new_run_id,
       },
     :user_description => {
        :user_id => current_or_guest_user_id,
        :user_region_id => nil,                   
       },
     :services_by_operator => {
        :operators => operators, :tarifs => tarifs, :tarif_options => tarif_options, :common_services => common_services,         
       },
     :final_tarif_set_generator_params => {
        :use_short_tarif_set_name => optimization_params_session_filtr_params['use_short_tarif_set_name'], 
        :max_tarif_set_count_per_tarif => optimization_params_session_filtr_params['max_tarif_set_count_per_tarif'],
        :save_current_tarif_set_calculation_history => optimization_params_session_filtr_params['save_current_tarif_set_calculation_history'],
        :use_price_comparison_in_current_tarif_set_calculation => optimization_params_session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
        :part_sort_criteria_in_price_optimization => optimization_params_session_filtr_params['part_sort_criteria_in_price_optimization'],       
       },
     :tarif_list_generator_params => {
        :calculate_with_multiple_use => optimization_params_session_filtr_params['calculate_with_multiple_use'],
        :calculate_only_chosen_services => calculation_choices_session_filtr_params['calculate_only_chosen_services'],
        :calculate_with_fixed_services => calculation_choices_session_filtr_params['calculate_with_fixed_services'],       
       }, 
     :tarif_result_simlifier_params => {
        :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results => optimization_params_session_filtr_params['if_update_tarif_sets_to_calculate_from_with_cons_tarif_results'],
        :eliminate_identical_tarif_sets => optimization_params_session_filtr_params['eliminate_identical_tarif_sets'],       
       }, 
     }   
  end
  
  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end

  def operator
    optimization_params_session_filtr_params = session_filtr_params(optimization_params)
    optimization_params_session_filtr_params['operator_id'].blank? ? 1030 : optimization_params_session_filtr_params['operator_id'].to_i
  end
  
  def operators
    service_choices_session_filtr_params = session_filtr_params(service_choices)
    calculation_choices_session_filtr_params = session_filtr_params(calculation_choices)
    services_select_session_filtr_params = session_filtr_params(services_select)
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    
#    raise(StandardError)
    if calculation_choices_session_filtr_params['calculate_with_fixed_services'] == 'true'
      [services_for_calculation_select_session_filtr_params['operator_id'].to_i]
    else
      tel = services_select_session_filtr_params['operator_tel'] == 'true'? 1023 : nil
      bln = services_select_session_filtr_params['operator_bln'] == 'true'? 1025 : nil
      mgf = services_select_session_filtr_params['operator_mgf'] == 'true'? 1028 : nil
      mts = services_select_session_filtr_params['operator_mts'] == 'true'? 1030 : nil
      [tel, bln, mgf, mts].compact    
    end
  end
  
  def validate_tarifs
    params['service_choices_filtr'].merge!(Customer::Info::ServiceChoices.validate_tarifs(params['service_choices_filtr'])) if params['service_choices_filtr']
  end
  
  def tarifs
    service_choices_session_filtr_params = session_filtr_params(service_choices)
    calculation_choices_session_filtr_params = session_filtr_params(calculation_choices)
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    
    if calculation_choices_session_filtr_params['calculate_with_fixed_services'] == 'true'
      {
        services_for_calculation_select_session_filtr_params['operator_id'].to_i => [services_for_calculation_select_session_filtr_params['tarif_to_calculate'].to_i]
      }
    else
      {
        1023 => (service_choices_session_filtr_params['tarifs_tel'] || []), 
        1025 => (service_choices_session_filtr_params['tarifs_bln'] || []), 
        1028 => (service_choices_session_filtr_params['tarifs_mgf'] || []), 
        1030 => (service_choices_session_filtr_params['tarifs_mts'] || []), 
      }     
    end
  end
  
  def tarif_options
    calculation_choices_session_filtr_params = session_filtr_params(calculation_choices)
    service_choices_session_filtr_params = session_filtr_params(service_choices)
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    
    if calculation_choices_session_filtr_params['calculate_with_fixed_services'] == 'true'
      {
        services_for_calculation_select_session_filtr_params['operator_id'].to_i => services_for_calculation_select_session_filtr_params['tarif_options_to_calculate'].map(&:to_i) - [0]
      }
    else
      {
        1023 => (service_choices_session_filtr_params['tarif_options_tel'] || []), 
        1025 => (service_choices_session_filtr_params['tarif_options_bln'] || []), 
        1028 => (service_choices_session_filtr_params['tarif_options_mgf'] || []), 
        1030 => (service_choices_session_filtr_params['tarif_options_mts'] || []), 
      }     
    end
  end
  
  def common_services
    service_choices_session_filtr_params = session_filtr_params(service_choices)

    {
      1023 => (service_choices_session_filtr_params['common_services_tel'] || []), 
      1025 => (service_choices_session_filtr_params['common_services_bln'] || []), 
      1028 => (service_choices_session_filtr_params['common_services_mgf'] || []), 
      1030 => (service_choices_session_filtr_params['common_services_mts'] || []), 
    }     
  end
  
  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_or_guest_user_id).select("description->>'accounting_period' as accounting_period").uniq
  end

  def check_if_optimization_options_are_in_session
    session[:filtr] ||= {}  
    
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if session[:filtr]['calculation_choices_filtr'].blank?
      session[:filtr]['calculation_choices_filtr'] ||= {}
      session[:filtr]['calculation_choices_filtr']  = Customer::Info::CalculationChoices.info(current_or_guest_user_id).merge({'accounting_period' => accounting_period})
    end

    if session[:filtr]['service_choices_filtr'].blank? or user_type != :admin
      session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = 
        user_type == :admin ? Customer::Info::ServiceChoices.info(current_or_guest_user_id) : Customer::Info::ServiceChoices.default_values(user_type)
    end

    if session[:filtr]['services_select_filtr'].blank? or user_type != :admin
      session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = 
        user_type == :admin ? Customer::Info::ServicesSelect.info(current_or_guest_user_id) : Customer::Info::ServicesSelect.default_values(user_type)
    end
    
    if !session[:filtr] or session[:filtr]['service_categories_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_categories_select_filtr'] ||= {}
      session[:filtr]['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.info(current_or_guest_user_id, user_type)
    end
    
    if session[:filtr]['optimization_params_filtr'].blank? or user_type != :admin
      session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = 
        user_type == :admin ? Customer::Info::TarifOptimizationParams.info(current_or_guest_user_id) : Customer::Info::TarifOptimizationParams.default_values
    end
#    raise(StandardError, )
  end

  def selected_service_categories
#    return @selected_service_categories if @selected_service_categories    
    selected_services = Customer::Info::ServiceCategoriesSelect.selected_services_from_session_format(session_filtr_params(service_categories_select), user_type)
    @selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end
  
  def show_service_categories_select_tab
    session_filtr_params(calculation_choices)['calculate_with_limited_scope'] == 'true' ? true : false
  end
  
  def show_services_for_calculation_select_tab
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? true : false
  end

end
