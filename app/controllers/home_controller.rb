class HomeController < ApplicationController
  layout 'landing', only: :index
#  before_action :calls_stat_options
#  after_action :track_demo_results, only: :demo_results
#  after_action :track_index, only: :index

  def detailed_description
    add_breadcrumb "Подробное описание шагов по подбору тарифа", home_detailed_description_path
  end
  
  def news
    add_breadcrumb "Новости", home_news_path
  end
  
  def contacts
    add_breadcrumb "Контакты", home_contacts_path
  end
  
  def sitemap
    add_breadcrumb "Карта сайта", home_sitemap_path
  end
  
  def update_tabs
    render :nothing => true
  end
  
  def change_locale
    redirect_to root_path, notice: t(:change_locale)
  end


  private
  
  def track_demo_results
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#    }) if params.count == 2
  end

  def track_index
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#    }) if params.count == 2
  end

end
