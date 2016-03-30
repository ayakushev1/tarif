# Set the host name for URL creation
# foreman run rake sitemap:refresh:no_ping
SitemapGenerator::Sitemap.default_host = "http://www.mytarifs.ru"
SitemapGenerator::Sitemap.sitemaps_path = ''
SitemapGenerator::Sitemap.ping_search_engines("http://www.mytarifs.ru/sitemap.xml.gz")


SitemapGenerator::Sitemap.create do
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  defaults_params = {:priority => nil, :changefreq => nil, :lastmod => nil}
  add comparison_optimizations_path, defaults_params
  add comparison_choose_your_tarif_from_ratings_path, defaults_params
  add customer_calls_choose_your_tarif_with_our_help_path, defaults_params  
  
  Comparison::Optimization.published.find_each do |comparison|
    add comparison_optimization_path(comparison), defaults_params
    comparison.groups.each do |group|
      add result_service_sets_result_path(group.result_run), defaults_params
      Result::ServiceSet.where(:run_id => group.result_run).find_each do |detailed_result|
        add result_service_sets_detailed_results_path(group.result_run, {:service_set_id => detailed_result.service_set_id}), defaults_params
      end
      add result_compare_path(group.result_run), defaults_params
      add comparison_call_stat_path(comparison), defaults_params
    end
  end
  
  add customer_call_runs_path, defaults_params
  add customer_calls_set_calls_generation_params_path, defaults_params
  add customer_history_parsers_prepare_for_upload_path, defaults_params
  add customer_calls_path, defaults_params
  add result_runs_path, defaults_params
  add tarif_optimizators_main_index_path, defaults_params
  add tarif_optimizators_fixed_services_index_path, defaults_params
  add tarif_optimizators_limited_scope_index_path, defaults_params
  add tarif_optimizators_fixed_operators_index_path, defaults_params
  add result_service_sets_results_path, defaults_params

  add tarif_classes_path, defaults_params
  Category::Operator.operators_with_tarifs.find_each do |operator|
    add tarif_classes_by_operator_path(operator), defaults_params
    TarifClass.where(:operator_id => operator.id).find_each do |tarif_class|
      add tarif_class_by_operator_path(operator, tarif_class), defaults_params
    end
  end
  TarifClass.find_each do |tarif_class|
    add tarif_class_path(tarif_class), defaults_params
  end
  
  add home_detailed_description_path, defaults_params
  add home_news_path, defaults_params
  add home_contacts_path, defaults_params
  add new_customer_demand_path, defaults_params
  add home_sitemap_path, defaults_params
end
