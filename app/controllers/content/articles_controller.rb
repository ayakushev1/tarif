class Content::ArticlesController < ApplicationController

  def show
    if params['content_article_id']
      session[:current_id] ||= []
      session[:current_id]['content_article_id'] = params['content_article_id']
    end
#    raise(StandardError) if !session[:current_id] or !session[:current_id]['content_article_id']
    redirect_to content_articles_index_path if !session[:current_id] or !session[:current_id]['content_article_id']
  end
  
  def articles
    s_filtr = session_filtr_params(recommendation_select_params)
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

    create_tableable(recommendation_query)
  end
  
  def recommendation_select_params
    create_filtrable("recommendation_select_params")
  end

  def demo_result_description
    #@demo_result_description ||= 
    Content::Article.demo_results.where(:id => demo_result_id).first
  end
  
  def customer_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_sets_id', :id_name => 'service_sets_id', :pagination_per_page => 12}
#    return @customer_service_sets if @customer_service_sets
#    @customer_service_sets = 
    create_array_of_hashable(final_tarif_results_presenter.
      customer_service_sets_array((session_filtr_params(recommendation_select_params)['operator_ids'] || []) - ['']), options)
  end
  
  def customer_tarif_results        
    options = {:base_name => 'service_results', :current_id_name => 'service_id', :id_name => 'service_id', :pagination_per_page => 20}
    result = create_array_of_hashable(final_tarif_results_presenter.customer_tarif_results_array(service_sets_id), options)
#    raise(StandardError)
  end

  def customer_tarif_detail_results
    options = {:base_name => 'tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
    create_array_of_hashable(final_tarif_results_presenter.customer_tarif_detail_results_array(
      service_sets_id, session[:current_id]['service_id']), options)
  end
  
  def aggregated_customer_tarif_detail_results
    options = {:base_name => 'aggregated_tarif_detail_results', :current_id_name => 'service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
    create_array_of_hashable(final_tarif_results_presenter.aggregated_customer_tarif_detail_results_array(service_sets_id), options)
#    raise(StandardError)
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
    create_filtrable("calls_stat_options")
  end
  
  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    calls_stat_options = {"rouming" => 'true'} if calls_stat_options.blank?
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    create_array_of_hashable(minor_result_presenter.calls_stat_array(calls_stat_options), options)    
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
    session[:current_id]['content_article_id'].blank? ? -1 : session[:current_id]['content_article_id'].to_i
  end

end
