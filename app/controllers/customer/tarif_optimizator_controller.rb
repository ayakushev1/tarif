class Customer::TarifOptimizatorController < ApplicationController
#  append_view_path("results/")
#  append_view_path("#{Rails.root}/app/views/customer/tarif_optimizator/results/")
  include Crudable
  crudable_actions :index
  before_action :check_if_optimization_options_are_in_session, only: [:index]
  before_action :validate_tarifs, only: [:index, :recalculate]
  before_action :init_background_process_informer, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate, :update_minor_results, :prepare_final_tarif_results]
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
    user_input_to_save = service_choices.session_filtr_params.merge(services_select.session_filtr_params).merge(optimization_params.session_filtr_params)
    tarif_optimization_inputs_saver('user_input').save({:result => user_input_to_save})
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
    @optimization_result_presenter ||= ServiceHelper::OptimizationResultPresenter.new(options)
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id.to_i : nil),
      :show_zero_tarif_result_by_parts => optimization_params.session_filtr_params['show_zero_tarif_result_by_parts'],
      }
    @optimization_result_presenter ||= ServiceHelper::FinalTarifResultsPresenter.new(options)
  end
  
  def minor_result_presenter
    @minor_result_presenter ||= ServiceHelper::AdditionalOptimizationInfoPresenter.new({:operator => operator, :user_id=> (current_user ? current_user.id.to_i : nil) })
  end 
  
  def tarif_optimization_inputs_saver(name)
    @tarif_optimization_inputs_saver ||= ServiceHelper::OptimizationResultSaver.new('tarif_optimization_inputs', name, current_user.id)
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
    operator = 1025
    session[:filtr]['service_choices_filtr']['tarifs_bln'] = service_choices.session_filtr_params['tarifs_bln'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarifs[operator] 
    session[:filtr]['service_choices_filtr']['tarif_options_bln'] = service_choices.session_filtr_params['tarif_options_bln'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarif_options[operator] 
    session[:filtr]['service_choices_filtr']['common_services_bln'] = service_choices.session_filtr_params['common_services_bln'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.common_services[operator] 

    operator = 1028
    session[:filtr]['service_choices_filtr']['tarifs_mgf'] = service_choices.session_filtr_params['tarifs_mgf'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarifs[operator] 
    session[:filtr]['service_choices_filtr']['tarif_options_mgf'] = service_choices.session_filtr_params['tarif_options_mgf'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarif_options[operator] 
    session[:filtr]['service_choices_filtr']['common_services_mgf'] = service_choices.session_filtr_params['common_services_mgf'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.common_services[operator] 

    operator = 1030
    session[:filtr]['service_choices_filtr']['tarifs_mts'] = service_choices.session_filtr_params['tarifs_mts'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarifs[operator] 
    session[:filtr]['service_choices_filtr']['tarif_options_mts'] = service_choices.session_filtr_params['tarif_options_mts'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.tarif_options[operator] 
    session[:filtr]['service_choices_filtr']['common_services_mts'] = service_choices.session_filtr_params['common_services_mts'].to_s.scan(/\d+/).map(&:to_i) & ServiceHelper::Services.common_services[operator] 
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
  
  def what_format_of_results
    optimization_params.session_filtr_params['what_format_of_results'] || 'results_by_services'
  end
  
  def saved_tarif_optimization_inputs
#    @saved_tarif_optimization_inputs ||= 
    tarif_optimization_inputs_saver('user_input').results
  end
  
  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_user.id).select("description->>'accounting_period' as accounting_period").uniq
  end
  
  def check_if_optimization_options_are_in_session  
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if !session[:filtr] or session[:filtr]['service_choices_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = if saved_tarif_optimization_inputs.blank?
        {
          'tarifs_bln' => [], 'tarifs_mgf' => [], 'tarifs_mts' => [],
          'tarif_options_bln' => [], 'tarif_options_mgf' => [], 'tarif_options_mts' => [], 
          'common_services_bln' => [], 'common_services_mgf' => [], 'common_services_mts' => [], 
          'accounting_period' => accounting_period,
          'calculate_only_chosen_services' => 'false'
          }        
      else
        saved_tarif_optimization_inputs.merge({'accounting_period' => accounting_period, 'calculate_only_chosen_services' => 'false'})
      end 
    end
    
    if !session[:filtr] or session[:filtr]['services_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = if saved_tarif_optimization_inputs.blank?
        {
          'operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
          'tarifs' => 'true', 'common_services' => 'false', 
          'all_tarif_options' => 'false'
          }        
      else
        saved_tarif_optimization_inputs
      end 
    end
    
    if !session[:filtr] or session[:filtr]['optimization_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = if saved_tarif_optimization_inputs.blank?
        {
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
      else
        saved_tarif_optimization_inputs
      end
    end
  end
  
  def process_selecting_services
    if params['services_select_filtr']
      if params['services_select_filtr']['operator_bln'] == 'true'
        input = selected_services(1025)
        session[:filtr]['service_choices_filtr']['tarifs_bln'] = input['tarifs']
        session[:filtr]['service_choices_filtr']['common_services_bln'] = input['common_services']
        session[:filtr]['service_choices_filtr']['tarif_options_bln'] = input['tarif_options']
      end
      if params['services_select_filtr']['operator_mgf'] == 'true'
        input = selected_services(1028)
        session[:filtr]['service_choices_filtr']['tarifs_mgf'] = input['tarifs']
        session[:filtr]['service_choices_filtr']['common_services_mgf'] = input['common_services']
        session[:filtr]['service_choices_filtr']['tarif_options_mgf'] = input['tarif_options']
      end
      if params['services_select_filtr']['operator_mts'] == 'true'
        input = selected_services(1030)
        session[:filtr]['service_choices_filtr']['tarifs_mts'] = input['tarifs']
        session[:filtr]['service_choices_filtr']['common_services_mts'] = input['common_services']
        session[:filtr]['service_choices_filtr']['tarif_options_mts'] = input['tarif_options']
      end
    end
#    raise(StandardError, [params['services_select_filtr']['operator_mgf'], session[:filtr]['service_choices_filtr']['tarif_options_mgf']])
    services_select.session_filtr_params
  end
  
  def selected_services(operator)
    result = {}
    result['tarifs'] = (params['services_select_filtr']['tarifs'] == 'true') ? ServiceHelper::Services.tarifs[operator] : []
    result['common_services'] = (params['services_select_filtr']['common_services'] == 'true') ? ServiceHelper::Services.common_services[operator] : []
#    raise(StandardError, [params['services_select_filtr']['all_tarif_options']])
    if params['services_select_filtr']['all_tarif_options'] == 'true'
      result['tarif_options'] = ServiceHelper::Services.tarif_options[operator]
    else
      result['tarif_options'] = []
      existing_tarif_options = ServiceHelper::Services.tarif_options_by_type[operator]
      result['tarif_options'] += (params['services_select_filtr']['international_rouming'] == 'true') ? existing_tarif_options[:international_rouming] : []
      result['tarif_options'] += (params['services_select_filtr']['country_rouming'] == 'true') ? existing_tarif_options[:country_rouming] : []
      result['tarif_options'] += (params['services_select_filtr']['calls'] == 'true') ? existing_tarif_options[:calls] : []
      result['tarif_options'] += (params['services_select_filtr']['internet'] == 'true') ? existing_tarif_options[:internet] : []
      result['tarif_options'] += (params['services_select_filtr']['sms'] == 'true') ? existing_tarif_options[:sms] : []
      result['tarif_options'] += (params['services_select_filtr']['mms'] == 'true') ? existing_tarif_options[:mms] : []      
      result['tarif_options'].uniq!
    end
    result
  end
  
end
