class Content::ArticlesController < ApplicationController

  def articles
    s_filtr = recommendation_select_params.session_filtr_params
    choosen_operators = ((s_filtr["operator_ids"] || []) -['']).map(&:to_i)
    choosen_roumings = ((s_filtr["roumings"] || []) -['']).map(&:to_i)
    choosen_services = ((s_filtr["services"] || []) -['']).map(&:to_i)
    choosen_destinations = ((s_filtr["destinations"] || []) -['']).map(&:to_i)
    
    recommendation_query = Content::Article.demo_results.published
    recommendation_query = recommendation_query.
      where("(key->>'operators')::jsonb @> '#{choosen_operators}'::jsonb").
      where("(key->>'roumings')::jsonb @> '#{choosen_roumings}'::jsonb").
      where("(key->>'services')::jsonb @> '#{choosen_services}'::jsonb").
      where("(key->>'destinations')::jsonb @> '#{choosen_destinations}'::jsonb")
#    raise(StandardError, [choosen_roumings, recommendation_query.to_sql])

    Tableable.new(self, recommendation_query)
  end
  
  def recommendation_select_params
    Filtrable.new(self, "recommendation_select_params")
  end

  def demo_result_description
    #@demo_result_description ||= 
    Content::Article.demo_results.where(:id => demo_result_id).first
  end
  
  def customer_service_sets
#    return @customer_service_sets if @customer_service_sets
#    @customer_service_sets = 
    ArrayOfHashable.new(self, 
      final_tarif_results_presenter.customer_service_sets_array((recommendation_select_params.session_filtr_params['operator_ids'] || []) - ['']))
  end
  
  def customer_tarif_results        
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_results_array(service_sets_id))
  end

  def customer_tarif_detail_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.customer_tarif_detail_results_array(
      service_sets_id, session[:current_id]['service_id']))
  end
  
  def aggregated_customer_tarif_detail_results
    ArrayOfHashable.new(self, final_tarif_results_presenter.aggregated_customer_tarif_detail_results_array(service_sets_id))
  end
  
  def final_tarif_results_presenter
    options = {
      :user_id=> (current_user ? current_user.id : 0),
      :show_zero_tarif_result_by_parts => 'false',
      :demo_result_id => demo_result_id 
      }
#    @optimization_result_presenter ||= 
    Customers::FinalTarifResultsPresenter.new(options)
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
#    @minor_result_presenter ||= 
    Customers::AdditionalOptimizationInfoPresenter.new(options)
  end   
  
  def service_sets_id
    customer_service_sets.model_size == 0 ? -1 : session[:current_id]['service_sets_id']
  end
  
  def demo_result_id
    session[:current_id]['content_articles_id'].blank? ? -1 : session[:current_id]['content_articles_id'].to_i
  end

end
