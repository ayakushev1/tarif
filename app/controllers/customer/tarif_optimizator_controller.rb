class Customer::TarifOptimizatorController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action :check_if_optimization_options_are_in_session, only: [:index]
  before_action :validate_tarifs, only: [:index, :recalculate]
  before_action :init_background_process_informer, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate, :update_minor_results, :index]
  attr_reader :operator, :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif

  def update_minor_results
    if optimization_params.session_filtr_params['calculate_on_background'] == 'true'
      [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].each do |background_process_informer|
        background_process_informer.clear_completed_process_info_model
        background_process_informer.init
      end
      
      Spawnling.new(:argv => "updating_minor_results for #{current_user.id}") do
        begin
          updating_minor_results
        rescue => e
          ServiceHelper::OptimizationResultSaver.new('optimization_results', 'Error on updating_minor_results', current_user.id).({:result => {:error => e}})
          raise(e)
        ensure
          [@background_process_informer_operators, @background_process_informer_tarifs, @background_process_informer_tarif].each do |background_process_informer|
            background_process_informer.finish
          end          
        end            
      end     
      redirect_to(:action => :calculation_status)
    else
      updating_minor_results
      redirect_to(:action => :index)
    end
  end
  
  def updating_minor_results
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
    @tarif_optimizator.init_input_for_one_operator_calculation(operator)
    @tarif_optimizator.update_minor_results
    @tarif_optimizator.calculate_and_save_final_tarif_sets
  end
  
  def select_services
    process_selecting_services
    redirect_to(:action => :index)
  end
  
  def calculation_status
    if !background_process_informer_operators.calculating?      
      redirect_to(:action => :index)
    end
  end
  
  def recalculate
    session[:filtr1] = {}   
    if optimization_params.session_filtr_params['calculate_on_background'] == 'true'
      [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].each do |background_process_informer|
        background_process_informer.clear_completed_process_info_model
        background_process_informer.init
      end
      
      Spawnling.new(:argv => 'tarif_optimization') do
        begin
          @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
          @tarif_optimizator.calculate_all_operator_tarifs
        rescue => e
          ServiceHelper::OptimizationResultSaver.new('optimization_results', 'Error on optimization', current_user.id).save({:result => {:error => e}})
          raise(e)
        ensure
          [@background_process_informer_operators, @background_process_informer_tarifs, @background_process_informer_tarif].each do |background_process_informer|
            background_process_informer.finish
          end          
        end            
      end     
      redirect_to(:action => :calculation_status)
    else
      @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
      @tarif_optimizator.calculate_all_operator_tarifs #calculate_one_operator_tarifs(operator)
      redirect_to(:action => :index)
    end
    tarif_optimization_inputs_saver('user_input').save({:result => service_choices.session_filtr_params})
  end 
  
  def optimization_params
    @optimization_params ||= Filtrable.new(self, "optimization_params")
  end
  
  def service_choices
    @service_choices ||= Filtrable.new(self, "service_choices")
  end
  
  def services_select
    @services_select ||= Filtrable.new(self, "services_select")
  end
  
  def service_sets
    @service_sets ||= ArrayOfHashable.new(self, optimization_result_presenter.service_sets_array)
  end
  
  def tarif_results
    @tarif_results ||= ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']))
  end
  
  def tarif_results_details
    @tarif_results_details ||= ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_class_id']))
  end
  
  def calls_stat_options
    @calls_stat_options ||= Filtrable.new(self, "calls_stat_options")
  end
  
  def calls_stat
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    @calls_stat ||= ArrayOfHashable.new(self, minor_result_presenter.calls_stat_array(calls_stat_options) )
  end
  
  def performance_results
    @performance_results ||= ArrayOfHashable.new(self, minor_result_presenter.performance_results )    
  end
  
  def service_packs_by_parts
    @service_packs_by_parts ||= ArrayOfHashable.new(self, minor_result_presenter.service_packs_by_parts_array )    
  end
  
  def memory_used
    @memory_used ||= ArrayOfHashable.new(self, minor_result_presenter.used_memory_by_output )    
  end
  
  def current_tarif_set_calculation_history
    @current_tarif_set_calculation_history ||= ArrayOfHashable.new(self, optimization_result_presenter.current_tarif_set_calculation_history )   
  end
  
  def operators_optimization_progress_bar
    ProgressBarable.new(self, 'operators_optimization', background_process_informer_operators.current_values)
  end
  
  def tarifs_optimization_progress_bar
    ProgressBarable.new(self, 'tarifs_optimization', background_process_informer_tarifs.current_values)
  end
  
  def tarif_optimization_progress_bar
    ProgressBarable.new(self, 'tarif_optimization', background_process_informer_tarif.current_values)
  end
  
  def init_background_process_informer
    @background_process_informer_operators ||= ServiceHelper::BackgroundProcessInformer.new('operators_optimization', current_user.id)
    @background_process_informer_tarifs ||= ServiceHelper::BackgroundProcessInformer.new('tarifs_optimization', current_user.id)
    @background_process_informer_tarif ||= ServiceHelper::BackgroundProcessInformer.new('tarif_optimization', current_user.id)
  end
  
  def optimization_result_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :service_set_based_on_tarif_sets_or_tarif_results => optimization_params.session_filtr_params['service_set_based_on_tarif_sets_or_tarif_results'],
      :show_zero_tarif_result_by_parts => optimization_params.session_filtr_params['show_zero_tarif_result_by_parts'],
      :use_price_comparison_in_current_tarif_set_calculation => optimization_params.session_filtr_params['use_price_comparison_in_current_tarif_set_calculation'],
      :max_tarif_set_count_per_tarif => optimization_params.session_filtr_params['max_tarif_set_count_per_tarif'],
      }
    @optimization_result_presenter ||= ServiceHelper::OptimizationResultPresenter.new(operator, options)
  end
  
  def minor_result_presenter
    @minor_result_presenter ||= ServiceHelper::OptimizationResultPresenter.new(operator, {:user_id=> (current_user ? current_user.id.to_i : nil)}, nil, 'minor_results')
  end 
  
  def tarif_optimization_inputs_saver(name)
    @tarif_optimization_inputs_saver ||= ServiceHelper::OptimizationResultSaver.new('tarif_optimization_inputs', name, current_user.id)
    @tarif_optimization_inputs_saver
  end

  def operator
    optimization_params.session_filtr_params['operator_id'].blank? ? 1030 : optimization_params.session_filtr_params['operator_id'].to_i
  end
  
  def validate_tarifs
    all_operator_services = TarifClass.services_by_operator(operator).with_not_null_dependency    
    session[:filtr]['service_choices_filtr']['tarifs_id'] = (service_choices.session_filtr_params['tarifs_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.tarifs.pluck(:id)) 
    session[:filtr]['service_choices_filtr']['tarif_options_id'] = (service_choices.session_filtr_params['tarif_options_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.special_services.pluck(:id)) 
    session[:filtr]['service_choices_filtr']['common_services_id'] = (service_choices.session_filtr_params['common_services_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.common_services.pluck(:id)) 
  end
  
  def options
  {:user_id=> (current_user ? current_user.id.to_i : nil),
   :user_region_id => (session[:current_user] ? session[:current_user]["region_id"].to_i : nil),  
   :background_process_informer_operators => @background_process_informer_operators,        
   :background_process_informer_tarifs => @background_process_informer_tarifs,        
   :background_process_informer_tarif => @background_process_informer_tarif,        
   :simplify_tarif_results => optimization_params.session_filtr_params['simplify_tarif_results'], 
   :save_tarif_results_ord => optimization_params.session_filtr_params['save_tarif_results_ord'], 
   :analyze_memory_used => optimization_params.session_filtr_params['analyze_memory_used'], 
   :analyze_query_constructor_performance => optimization_params.session_filtr_params['analyze_query_constructor_performance'], 
   :service_ids_batch_size => optimization_params.session_filtr_params['service_ids_batch_size'], 
   :services_by_operator => {
      :operators => [operator], :tarifs => {operator => tarifs}, :tarif_options => {operator => tarif_options}, 
      :common_services => {operator => common_services}, 
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

  def tarifs
    service_choices.session_filtr_params['tarifs_id'] || [] 
  end
  
  def tarif_options
    service_choices.session_filtr_params['tarif_options_id'] || [] 
  end
  
  def common_services
    service_choices.session_filtr_params['common_services_id']  || []
  end
  
  def check_if_optimization_options_are_in_session
    if !session[:filtr] or session[:filtr]['service_choices_filtr'].blank?
      saved_tarif_optimization_inputs = tarif_optimization_inputs_saver('user_input').results
      session[:filtr] ||= {}; session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = if saved_tarif_optimization_inputs.blank?
        {'tarifs_id' => [200], 'tarif_options_id' => [], 'common_services_id' => [],}        
      else
        saved_tarif_optimization_inputs
      end 
    end

    if !session[:filtr] or session[:filtr]['optimization_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = {
        'calculate_on_background' => 'true',
        'service_set_based_on_tarif_sets_or_tarif_results' => 'final_tarif_sets',
        'operator_id' => 1030,
        'calculate_with_multiple_use' => 'true',
        'simplify_tarif_results' => 'true',
        'save_tarif_results_ord' => 'false',
        'analyze_memory_used' => 'false',
        'analyze_query_constructor_performance' => 'false',
        'service_ids_batch_size' => 10,
        'use_short_tarif_set_name' => 'true',
        'show_zero_tarif_result_by_parts' => 'false',
        'if_update_tarif_sets_to_calculate_from_with_cons_tarif_results' => 'true',
        'max_tarif_set_count_per_tarif' => 3,
        'eliminate_identical_tarif_sets' => 'true',
        'use_price_comparison_in_current_tarif_set_calculation' => 'true',
        'save_current_tarif_set_calculation_history' => 'true',
        'part_sort_criteria_in_price_optimization' => 'auto',
      } 
    end
#    service_choices.session_filtr_params
  end

  def process_selecting_services
    if params['services_select_filtr']
      set_selected_services('tarifs_id', 'tarifs_1')
      set_selected_services('tarifs_id', 'tarifs_2')
      set_selected_services('common_services_id', 'common_services')
      set_selected_services('tarif_options_id', 'all_tarif_options')
      set_selected_services('tarif_options_id', 'tarif_options_calls')
      set_selected_services('tarif_options_id', 'tarif_options_calls_abroad')
      set_selected_services('tarif_options_id', 'tarif_options_country_rouming_1')
      set_selected_services('tarif_options_id', 'tarif_options_country_rouming_2')
      set_selected_services('tarif_options_id', 'tarif_options_international_rouming')
      set_selected_services('tarif_options_id', 'tarif_options_internet_1')
      set_selected_services('tarif_options_id', 'tarif_options_internet_2')
      set_selected_services('tarif_options_id', 'tarif_options_internet_3')
      set_selected_services('tarif_options_id', 'tarif_options_internet_4')
      set_selected_services('tarif_options_id', 'tarif_options_internet_5')
      set_selected_services('tarif_options_id', 'tarif_options_internet_6')
      set_selected_services('tarif_options_id', 'tarif_options_mms')
      set_selected_services('tarif_options_id', 'tarif_options_service_to_country')
      set_selected_services('tarif_options_id', 'tarif_options_sms_1')
      set_selected_services('tarif_options_id', 'tarif_options_sms_2')
      set_selected_services('tarif_options_id', 'tarif_options_sms_3')
      set_selected_services('tarif_options_id', 'tarif_options_sms_4')
    end
    services_select.session_filtr_params
  end
  
  def set_selected_services(services_to_set, which_services)
    if params['services_select_filtr'][which_services] != session[:filtr]['services_select_filtr'][which_services]
      session[:filtr]['service_choices_filtr'][services_to_set] = (params['services_select_filtr'][which_services] == 'true') ? 
        (service_choices.session_filtr_params[services_to_set].map(&:to_i) + which_services_values(which_services)).uniq.sort : 
        (service_choices.session_filtr_params[services_to_set].map(&:to_i) - which_services_values(which_services))
    end
  end
  
  def which_services_values(which_services)
    case which_services
    when 'tarifs_1'; [200, 201, 202, 203, 204, 205]
    when 'tarifs_2'; [206, 207, 208, 210]
    when 'common_services'; [276, 277, 312]
    when 'all_tarif_options'; [280, 281, 282, 283, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 313, 314, 315, 316, 317, 318, 321, 322, 323, 324, 325, 326, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342]
    when 'tarif_options_calls'; [328, 329, 330, 331, 332]
    when 'tarif_options_calls_abroad'; [281, 309, 293] 
    when 'tarif_options_country_rouming_1'; [294, 282, 283, 297]
    when 'tarif_options_country_rouming_2'; [321, 322]
    when 'tarif_options_international_rouming'; [288, 289, 290, 291, 292]   
    when 'tarif_options_internet_1'; [302, 303, 304]    
    when 'tarif_options_internet_2'; [310, 311]        
    when 'tarif_options_internet_3'; [313, 314]     
    when 'tarif_options_internet_4'; [315, 316, 317, 318]       
    when 'tarif_options_internet_5'; [340, 341]     
    when 'tarif_options_internet_6'; [342] 
    when 'tarif_options_mms'; [323, 324, 325, 326]    
    when 'tarif_options_service_to_country'; [280] 
    when 'tarif_options_sms_1'; [295, 296]    
    when 'tarif_options_sms_2'; [305, 306, 307, 308]    
    when 'tarif_options_sms_3'; [333, 334, 335]   
    when 'tarif_options_sms_4'; [336, 337, 338, 339]
    end
  end
end
