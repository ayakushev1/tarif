class Demo::HomeController < ApplicationController
#  before_action :calls_stat_options
  after_action :track_demo_results, only: :demo_results
  after_action :track_index, only: :index

  def full_demo_results
    render nothing: true
  end
  
  def recommendation_select_params
    Filtrable.new(self, "recommendation_select_params")
  end

  def demo_result_description
    #@demo_result_description ||= 
    Content::Article.demo_results.where(:id => demo_result_id).first
  end
  
  def customer_service_sets
    return @customer_service_sets if @customer_service_sets
    @customer_service_sets = ArrayOfHashable.new(self, 
      final_tarif_results_presenter.customer_service_sets_array((recommendation_select_params.session_filtr_params['operator_ids'] || []) - ['']))
  end
  
  def customer_tarif_results        
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_results_array(service_sets_id))
  end

  def customer_tarif_detail_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_detail_results_array(
      service_sets_id, session[:current_id]['service_id']))
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id : 0),
      :show_zero_tarif_result_by_parts => 'false',
      :demo_result_id => demo_result_id 
      }
#    @optimization_result_presenter ||= 
    ServiceHelper::FinalTarifResultsPresenter.new(options)
  end  
  
  def calls_stat_options
#    raise(StandardError, session['calls_stat_options_filtr'])
    Filtrable.new(self, "calls_stat_options")
  end
  
  def calls_stat
    filtr = calls_stat_options.session_filtr_params
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    calls_stat_options = {"rouming" => 'true'} if calls_stat_options.blank?
    ArrayOfHashable.new(self, minor_result_presenter.calls_stat_array(calls_stat_options) )    
  end

  def minor_result_presenter
    options = {
      :user_id=> 0,
      :demo_result_id => demo_result_id 
      }
    @minor_result_presenter ||= ServiceHelper::AdditionalOptimizationInfoPresenter.new(options)
  end   
  
  def service_sets_id
    customer_service_sets.model_size == 0 ? -1 : session[:current_id]['service_sets_id']
  end
  
  def demo_result_id
    recommendation_select_params.session_filtr_params['demo_result_id'].blank? ? 1 : recommendation_select_params.session_filtr_params['demo_result_id'].to_i
  end

  private
  
  def track_demo_results
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end

  def track_index
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end

end
