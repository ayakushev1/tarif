class Customer::TarifOptimizatorController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action :validate_tarifs, only: [:index, :recalculate]
  before_action :init_background_process_informer, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate, :index]
  attr_reader :operator, :background_process_informer#, :optimization_result_presenter

  def calculation_status
    if !background_process_informer.calculating?      
      redirect_to(:action => :index)
    end
  end
  
  def recalculate   
    if service_choices.session_filtr_params['calculate_on_background'] == 'true'
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init
      Spawnling.new(:argv => 'tarif_optimization') do
        begin
          @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
          @tarif_optimizator.calculate_one_operator_tarifs(operator)
        rescue => e
          raise(e)
        ensure
          background_process_informer.finish
        end            
      end     
      redirect_to(:action => :calculation_status)
    else
      @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
      @tarif_optimizator.calculate_one_operator_tarifs(operator)
      redirect_to(:action => :index)
    end
  end 
  
  def service_choices
    @service_choices ||= Filtrable.new(self, "service_choices")
  end
  
  def service_sets
    ArrayOfHashable.new(self, optimization_result_presenter.service_sets_array)
  end
  
  def tarif_results
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_array( session[:current_id]['service_sets_id']))
  end
  
  def tarif_results_details
    ArrayOfHashable.new(self, optimization_result_presenter.tarif_results_details_array(session[:current_id]['service_sets_id'], session[:current_id]['tarif_class_id']))
  end
  
  def calls_stat_options
    @calls_stat_options ||= Filtrable.new(self, "calls_stat_options")
  end
  
  def calls_stat
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    ArrayOfHashable.new(self, optimization_result_presenter.calls_stat_array(calls_stat_options) )
  end
  
  def tarif_optimization_progress_bar
    ProgressBarable.new(self, 'tarif_optimization', background_process_informer.current_values)
  end
  
  def init_background_process_informer
    @background_process_informer = ServiceHelper::BackgroundProcessInformer.new('tarif_optimization')
  end
  
  def optimization_result_presenter
    options = {:service_set_based_on_tarif_sets_or_tarif_results => service_choices.session_filtr_params['service_set_based_on_tarif_sets_or_tarif_results']}
    @optimization_result_presenter ||= ServiceHelper::OptimizationResultPresenter.new(operator, options)
  end
  
  def operator
    service_choices.session_filtr_params['operator_id'].blank? ? 1030 : service_choices.session_filtr_params['operator_id'].to_i
  end
  
  def validate_tarifs
    all_operator_services = TarifClass.services_by_operator(operator).with_not_null_dependency    
    session[:filtr]['service_choices_filtr']['tarifs_id'] = (service_choices.session_filtr_params['tarifs_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.tarifs.pluck(:id)) 
    session[:filtr]['service_choices_filtr']['tarif_options_id'] = (service_choices.session_filtr_params['tarif_options_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.special_services.pluck(:id)) 
    session[:filtr]['service_choices_filtr']['common_services_id'] = (service_choices.session_filtr_params['common_services_id'].to_s.scan(/\d+/).map(&:to_i) & all_operator_services.common_services.pluck(:id)) 
  end
  
  def options
  {:controller => self,
   :background_process_informer => background_process_informer,    
   :services_by_operator => {
      :operators => [operator], :tarifs => {operator => tarifs}, :tarif_options => {operator => tarif_options}, 
      :common_services => {operator => common_services}, :use_short_tarif_set_name => service_choices.session_filtr_params['use_short_tarif_set_name'] } 
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
  
end
