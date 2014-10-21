class Customer::TarifOptimizator < ActiveType::Object
  attribute :session, default: proc {controller.session}
  attribute :user_session, default: proc {controller.user_session}
  attribute :current_user_id, :integer, default: proc {controller.current_user.id}
  attribute :optimization_params, default: proc {Filtrable.new(controller, "optimization_params")}
  attribute :service_choices, default: proc {Filtrable.new(controller, "service_choices")}
  attribute :services_select, default: proc {Filtrable.new(controller, "services_select")}
  attribute :service_categories_select, default: proc {Filtrable.new(controller, "service_categories_select")}
  attribute :operators_optimization_progress_bar, default: proc {ProgressBarable.new(controller, 'operators_optimization', background_process_informer_operators.current_values)}
  attribute :tarifs_optimization_progress_bar, default: proc {ProgressBarable.new(controller, 'tarifs_optimization', background_process_informer_tarifs.current_values)}
  attribute :tarif_optimization_progress_bar, default: proc {ProgressBarable.new(controller, 'tarif_optimization', background_process_informer_tarif.current_values)}
  attribute :tarif_optimization_starter, default: proc {ServiceHelper::TarifOptimizationStarter.new()}
  attr_reader :controller
  attr_reader :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif
  
  def initialize(controller, init_values = {})
    super init_values
    @controller = controller
  end 

  def update_customer_infos
    Customer::Info::ServicesSelect.update_info(current_user_id, services_select.session_filtr_params)
    Customer::Info::ServiceChoices.update_info(current_user_id, service_choices.session_filtr_params)
    Customer::Info::ServiceCategoriesSelect.update_info(current_user_id, service_categories_select.session_filtr_params)
    Customer::Info::TarifOptimizationParams.update_info(current_user_id, optimization_params.session_filtr_params)

    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_user.id, 'tarif_optimization_count')
  end
  
  def recalculate_on_back_ground
    prepare_background_process_informer
    if !(optimization_params.session_filtr_params['calculate_background_with_spawnling'] == 'false')
      Spawnling.new(:argv => "optimize for #{current_user_id}") do
        tarif_optimization_starter.start_calculate_all_operator_tarifs(options)          
      end
    else
      tarif_optimization_starter.delay.start_calculate_all_operator_tarifs(options)
    end              
  end
    
  def recalculate_direct
     tarif_optimization_starter.start_calculate_all_operator_tarifs(options)
  end
  
  def prepare_background_process_informer
    [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].each do |background_process_informer|
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init
    end
  end
  
  def init_background_process_informer
    GC.start
    @background_process_informer_operators ||= ServiceHelper::BackgroundProcessInformer.new('operators_optimization', current_user_id)
    @background_process_informer_tarifs ||= ServiceHelper::BackgroundProcessInformer.new('tarifs_optimization', current_user_id)
    @background_process_informer_tarif ||= ServiceHelper::BackgroundProcessInformer.new('tarif_optimization', current_user_id)
  end
   
  def options
  {:operator => operator,
   :user_id => current_user_id,
   :user_region_id => (user_session[:region_id] ? user_session[:region_id].to_i : nil),  
#   :background_process_informer_operators => @background_process_informer_operators,        
#   :background_process_informer_tarifs => @background_process_informer_tarifs,        
#   :background_process_informer_tarif => @background_process_informer_tarif,        
   :simplify_tarif_results => optimization_params.session_filtr_params['simplify_tarif_results'], 
   :save_tarif_results_ord => optimization_params.session_filtr_params['save_tarif_results_ord'], 
   :analyze_memory_used => optimization_params.session_filtr_params['analyze_memory_used'], 
   :analyze_query_constructor_performance => optimization_params.session_filtr_params['analyze_query_constructor_performance'], 
   :save_interim_results_after_calculating_tarif_results => optimization_params.session_filtr_params['save_interim_results_after_calculating_tarif_results'], 
#   :save_interim_results_after_calculating_final_tarif_sets => optimization_params.session_filtr_params['save_interim_results_after_calculating_final_tarif_sets'], 

   :service_ids_batch_size => optimization_params.session_filtr_params['service_ids_batch_size'], 
   :accounting_period => service_choices.session_filtr_params['accounting_period'],
   :calculate_with_limited_scope => service_choices.session_filtr_params['calculate_with_limited_scope'],
   :selected_service_categories => selected_service_categories,
   
   :services_by_operator => {
      :operators => operators, :tarifs => tarifs, :tarif_options => tarif_options, 
      :common_services => common_services, 
      :calculate_only_chosen_services => service_choices.session_filtr_params['calculate_only_chosen_services'],
      :use_short_tarif_set_name => optimization_params.session_filtr_params['use_short_tarif_set_name'], 
      :calculate_with_multiple_use => optimization_params.session_filtr_params['calculate_with_multiple_use'],
      :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results => optimization_params.session_filtr_params['if_update_tarif_sets_to_calculate_from_with_cons_tarif_results'],
      :eliminate_identical_tarif_sets => optimization_params.session_filtr_params['eliminate_identical_tarif_sets'],
      :use_price_comparison_in_current_tarif_set_calculation => optimization_params.session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
      :max_tarif_set_count_per_tarif => optimization_params.session_filtr_params['max_tarif_set_count_per_tarif'],
      :save_current_tarif_set_calculation_history => optimization_params.session_filtr_params['save_current_tarif_set_calculation_history'],
      :part_sort_criteria_in_price_optimization => optimization_params.session_filtr_params['part_sort_criteria_in_price_optimization'],
      } 
   }   
  end

  def operator
    optimization_params.session_filtr_params['operator_id'].blank? ? 1030 : optimization_params.session_filtr_params['operator_id'].to_i
  end
  
  def operators
    bln = services_select.session_filtr_params['operator_bln'] == 'true'? 1025 : nil
    mgf = services_select.session_filtr_params['operator_mgf'] == 'true'? 1028 : nil
    mts = services_select.session_filtr_params['operator_mts'] == 'true'? 1030 : nil
    [bln, mgf, mts].compact    
  end
  
  def validate_tarifs
    session[:filtr]['service_choices_filtr'].merge!(Customer::Info::ServiceChoices.validate_tarifs(service_choices.session_filtr_params))
  end
  
  def tarifs
    {
      1025 => (service_choices.session_filtr_params['tarifs_bln'] || []), 
      1028 => (service_choices.session_filtr_params['tarifs_mgf'] || []), 
      1030 => (service_choices.session_filtr_params['tarifs_mts'] || []), 
    }     
  end
  
  def tarif_options
    {
      1025 => (service_choices.session_filtr_params['tarif_options_bln'] || []), 
      1028 => (service_choices.session_filtr_params['tarif_options_mgf'] || []), 
      1030 => (service_choices.session_filtr_params['tarif_options_mts'] || []), 
    }     
  end
  
  def common_services
    {
      1025 => (service_choices.session_filtr_params['common_services_bln'] || []), 
      1028 => (service_choices.session_filtr_params['common_services_mgf'] || []), 
      1030 => (service_choices.session_filtr_params['common_services_mts'] || []), 
    }     
  end
  
  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_user_id).select("description->>'accounting_period' as accounting_period").uniq
  end

  def check_if_optimization_options_are_in_session
    session[:filtr] ||= {}  
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if session[:filtr]['service_choices_filtr'].blank?
      session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = Customer::Info::ServiceChoices.info(current_user_id).merge({'accounting_period' => accounting_period})
    end

    if session[:filtr]['services_select_filtr'].blank?
      session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = Customer::Info::ServicesSelect.info(current_user_id)
    end
    
    if !session[:filtr] or session[:filtr]['service_categories_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_categories_select_filtr'] ||= {}
      session[:filtr]['service_categories_select_filtr']  = Customer::Info::ServiceCategoriesSelect.info(current_user_id)
    end
#    raise(StandardError)
    
    if session[:filtr]['optimization_params_filtr'].blank?
      session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = Customer::Info::TarifOptimizationParams.info(current_user_id)
    end
#    raise(StandardError, )
  end

  def selected_service_categories    
    selected_services = Customer::Info::ServiceCategoriesSelect.selected_services_from_session_format(service_categories_select.session_filtr_params)
    Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end
  
  def persisted?
    false
  end  
end

