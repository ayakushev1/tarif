class Customer::TarifOptimizatorController < ApplicationController
#  append_view_path("results/")
#  append_view_path("#{Rails.root}/app/views/customer/tarif_optimizator/results/")
  include Crudable
  crudable_actions :index
  before_action :check_if_optimization_options_are_in_session, only: [:index]
  before_action :validate_tarifs, only: [:index, :recalculate]
  before_action :init_background_process_informer, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate, :update_minor_results, :index, :prepare_final_tarif_results]
  attr_reader :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif

  def prepare_final_tarif_results
    if optimization_params.session_filtr_params['save_interim_results_after_calculating_tarif_results'] == 'false' #or optimization_params.session_filtr_params['save_interim_results_after_calculating_final_tarif_sets'] == 'false'
      redirect_to({:action => :index}, :alert => "Невозможно обновить данные если save_interim_results_after_calculating_tarif_results or save_interim_results_after_calculating_final_tarif_sets = false")
    else
      if optimization_params.session_filtr_params['calculate_on_background'] == 'true'
        [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].each do |background_process_informer|
          background_process_informer.clear_completed_process_info_model
          background_process_informer.init
        end
        
        Spawnling.new(:argv => "preparing_final_tarif_results for #{current_user.id}") do
          begin
            preparing_final_tarif_results
          rescue => e
            ServiceHelper::OptimizationResultSaver.new('optimization_results', 'Error on preparing_final_tarif_results', current_user.id).({:result => {:error => e}})
            raise(e)
          ensure
            [@background_process_informer_operators, @background_process_informer_tarifs, @background_process_informer_tarif].each do |background_process_informer|
              background_process_informer.finish
              background_process_informer = nil
            end          
          end            
        end     
        redirect_to(:action => :calculation_status)
      else
        preparing_final_tarif_results
        redirect_to(:action => :show_customer_results)
      end
    end
  end
  
  def preparing_final_tarif_results
    tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
    tarif_optimizator.prepare_and_save_final_tarif_results
  end

  def update_minor_results
    if optimization_params.session_filtr_params['save_interim_results_after_calculating_tarif_results'] == 'false'
      redirect_to({:action => :index}, :alert => "Невозможно обновить данные если save_interim_results_after_calculating_tarif_results = false")
    else    
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
              background_process_informer = nil
            end          
          end            
        end     
        redirect_to(:action => :calculation_status)
      else
        updating_minor_results
        redirect_to(:action => :index)
      end
    end
  end
  
  def updating_minor_results
    tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
    tarif_optimizator.init_input_for_one_operator_calculation(operator)
    tarif_optimizator.update_minor_results
    tarif_optimizator.calculate_and_save_final_tarif_sets
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
    if options[:accounting_period].blank? 
      redirect_to(:action => :index, :error => "Выберите период для расчета")
    end
    
    if optimization_params.session_filtr_params['calculate_on_background'] == 'true'
      [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].each do |background_process_informer|
        background_process_informer.clear_completed_process_info_model
        background_process_informer.init
      end
      
      Spawnling.new(:argv => 'tarif_optimization') do
        begin
          tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
          tarif_optimizator.calculate_all_operator_tarifs
        rescue => e
          ServiceHelper::OptimizationResultSaver.new('optimization_results', 'Error on optimization', current_user.id).override({:result => {:error => e}})
          raise(e)
        ensure
          [@background_process_informer_operators, @background_process_informer_tarifs, @background_process_informer_tarif].each do |background_process_informer|
            background_process_informer.finish
            background_process_informer = nil
          end          
        end            
      end     
      redirect_to(:action => :calculation_status)
    else
      tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
      tarif_optimizator.calculate_all_operator_tarifs
      tarif_optimizator = nil
#      updating_minor_results
      redirect_to(:action => :index)
    end
    tarif_optimization_inputs_saver('user_input').save({:result => service_choices.session_filtr_params.merge({'accounting_period' => nil})})
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
  
  def customer_service_sets
#    @customer_service_sets ||= 
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_service_sets_array)
  end
  
  def customer_tarif_results
#    @customer_tarif_results ||= 
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_results_array(session[:current_id]['service_sets_id']))
  end

  def customer_tarif_detail_results
#    @customer_tarif_detail_results ||= 
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_detail_results_array(
      session[:current_id]['service_sets_id'], session[:current_id]['service_id']))
  end
  
  def service_sets
#    @service_sets ||= 
    ArrayOfHashable.new(self, optimization_result_presenter.service_sets_array)
  end
  
  def tarif_results
#    @tarif_results ||= 
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']))
  end
  
  def tarif_results_details
#    @tarif_results_details ||= 
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_class_id']))
  end
  
  def calls_stat_options
#    @calls_stat_options ||= 
    Filtrable.new(self, "calls_stat_options")
  end
  
  def calls_stat
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
#    @calls_stat ||= 
    ArrayOfHashable.new(self, minor_result_presenter.calls_stat_array(calls_stat_options) )
  end
  
  def performance_results
#    @performance_results ||= 
    ArrayOfHashable.new(self, minor_result_presenter.performance_results )    
  end
  
  def service_packs_by_parts
#    @service_packs_by_parts ||= 
    ArrayOfHashable.new(self, minor_result_presenter.service_packs_by_parts_array )    
  end
  
  def memory_used
#    @memory_used ||= 
    ArrayOfHashable.new(self, minor_result_presenter.used_memory_by_output )    
  end
  
  def current_tarif_set_calculation_history
#    @current_tarif_set_calculation_history ||= 
    ArrayOfHashable.new(self, minor_result_presenter.current_tarif_set_calculation_history )   
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
    GC.start
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
      :tarif_count => tarifs.size,
      }
#    @optimization_result_presenter ||= 
    ServiceHelper::OptimizationResultPresenter.new(options)
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :show_zero_tarif_result_by_parts => optimization_params.session_filtr_params['show_zero_tarif_result_by_parts'],
      }
#    @optimization_result_presenter ||= 
    ServiceHelper::FinalTarifResultsPresenter.new(options)
  end
  
  def minor_result_presenter
#    @minor_result_presenter ||= 
    ServiceHelper::AdditionalOptimizationInfoPresenter.new({:operator => operator, :user_id=> (current_user ? current_user.id.to_i : nil) })
  end 
  
  def tarif_optimization_inputs_saver(name)
#    @tarif_optimization_inputs_saver ||= 
    ServiceHelper::OptimizationResultSaver.new('tarif_optimization_inputs', name, current_user.id)
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
  {:operator => operator,
   :user_id=> (current_user ? current_user.id.to_i : nil),
   :user_region_id => (session[:current_user] ? session[:current_user]["region_id"].to_i : nil),  
   :background_process_informer_operators => @background_process_informer_operators,        
   :background_process_informer_tarifs => @background_process_informer_tarifs,        
   :background_process_informer_tarif => @background_process_informer_tarif,        
   :simplify_tarif_results => optimization_params.session_filtr_params['simplify_tarif_results'], 
   :save_tarif_results_ord => optimization_params.session_filtr_params['save_tarif_results_ord'], 
   :analyze_memory_used => optimization_params.session_filtr_params['analyze_memory_used'], 
   :analyze_query_constructor_performance => optimization_params.session_filtr_params['analyze_query_constructor_performance'], 
   :save_interim_results_after_calculating_tarif_results => optimization_params.session_filtr_params['save_interim_results_after_calculating_tarif_results'], 
#   :save_interim_results_after_calculating_final_tarif_sets => optimization_params.session_filtr_params['save_interim_results_after_calculating_final_tarif_sets'], 

   :service_ids_batch_size => optimization_params.session_filtr_params['service_ids_batch_size'], 
   :accounting_period => service_choices.session_filtr_params['accounting_period'],
   
   :services_by_operator => {
      :operators => [operator], :tarifs => {operator => tarifs}, :tarif_options => {operator => tarif_options}, 
      :calculate_only_chosen_services => service_choices.session_filtr_params['calculate_only_chosen_services'],
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
  
  def what_format_of_results
    optimization_params.session_filtr_params['what_format_of_results'] || 'results_for_customer'
  end
  
  def saved_tarif_optimization_inputs
#    @saved_tarif_optimization_inputs ||= 
    tarif_optimization_inputs_saver('user_input').results
  end
  
  def check_if_optimization_options_are_in_session    
    accounting_period = Customer::Call.where(:user_id => current_user.id).select("description->>'accounting_period' as accounting_period").uniq
    accounting_period = accounting_period.blank? ? -1 : accounting_period[0]['accounting_period']

    if !session[:filtr] or session[:filtr]['service_choices_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = if saved_tarif_optimization_inputs.blank?
        {
          'tarifs_id' => [200], 
          'tarif_options_id' => [], 
          'common_services_id' => [], 
          'accounting_period' => accounting_period,
          'calculate_only_chosen_services' => 'false'
          }        
      else
        saved_tarif_optimization_inputs.merge({'accounting_period' => accounting_period, 'calculate_only_chosen_services' => 'false'})
      end 
    end
    
    if !session[:filtr] or session[:filtr]['optimization_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = {
        'calculate_on_background' => 'true',
        'service_set_based_on_tarif_sets_or_tarif_results' => 'final_tarif_sets_by_parts',
        'operator_id' => 1030,
        'calculate_with_multiple_use' => 'true',
        'simplify_tarif_results' => 'true',
        'save_tarif_results_ord' => 'false',
        'analyze_memory_used' => 'false',
        'analyze_query_constructor_performance' => 'false',
        'save_interim_results_after_calculating_tarif_results' => 'false',
#        'save_interim_results_after_calculating_final_tarif_sets' => 'false',
        'service_ids_batch_size' => 10,
        'use_short_tarif_set_name' => 'true',
        'show_zero_tarif_result_by_parts' => 'false',
        'if_update_tarif_sets_to_calculate_from_with_cons_tarif_results' => 'true',
        'max_tarif_set_count_per_tarif' => 1,
        'eliminate_identical_tarif_sets' => 'true',
        'use_price_comparison_in_current_tarif_set_calculation' => 'true',
        'save_current_tarif_set_calculation_history' => 'false',
        'part_sort_criteria_in_price_optimization' => 'auto',   
        'what_format_of_results' => 'results_for_customer',     
      } 
#      raise(StandardError, session[:filtr]['optimization_params_filtr'])
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
_mgf_around_world = 100; _mgf_all_simple = 101; 
_mgf_all_included_xs = 102; _mgf_all_included_s = 103; _mgf_all_included_m = 104; _mgf_all_included_l = 105; _mgf_all_included_vip = 106; _mgf_megafon_online = 107;
_mgf_international = 108; _mgf_go_to_zero = 109; _mgf_sub_moscow = 110; _mgf_city_connection = 112; _mgf_warm_welcome = 113;
  
  def which_services_values(which_services)
    case which_services
    when 'tarifs_1'; [200, 201, 202, 203, 204, 205, 206, 207, 208, 210, 212]
    when 'tarifs_2'; [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 112, 113]
    when 'common_services'; [276, 277, 312]
    when 'all_tarif_options'; [280, 281, 282, 283, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 313, 314, 315, 316, 317, 318, 321, 322, 323, 324, 325, 326, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342]
    when 'tarif_options_calls'; [328, 329, 330, 331, 332]
    when 'tarif_options_calls_abroad'; [281, 309, 293] 
    when 'tarif_options_country_rouming_1'; [294, 282, 283, 297, 321, 322]
    when 'tarif_options_country_rouming_2'; []
    when 'tarif_options_international_rouming'; [288, 289, 290, 291, 292]   
    when 'tarif_options_internet_1'; [302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342]
    when 'tarif_options_internet_2'; []        
    when 'tarif_options_internet_3'; []     
    when 'tarif_options_internet_4'; []       
    when 'tarif_options_internet_5'; []     
    when 'tarif_options_internet_6'; [] 
    when 'tarif_options_mms'; [323, 324, 325, 326]    
    when 'tarif_options_service_to_country'; [280] 
    when 'tarif_options_sms_1'; [295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339]    
    when 'tarif_options_sms_2'; []    
    when 'tarif_options_sms_3'; []   
    when 'tarif_options_sms_4'; []
    end
  end
end
