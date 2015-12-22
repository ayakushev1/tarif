module ApplicationHelper::SetCurrentSession
  
  def set_current_session
    session[:current_id] ||= {}
    session[:filtr] ||= {}
    session[:form] ||= {}
    session[:progress_bar] ||= {}
    session[:pagination] ||= {}    
    session[:back_path] ||= {}    
    session[:locale] ||= I18n.default_locale
    set_current_tabs_pages
    set_current_accordion_pages
#    raise(StandardError)
  end

  def set_current_tabs_pages
    session[:current_tabs_page] ||= {}
    params[:current_tabs_page].each { |key, value| session[:current_tabs_page][key] = value } if params[:current_tabs_page]
  end
      
  def set_current_accordion_pages
    session[:current_accordion_page] ||= {}
    params[:current_accordion_page].each { |key, value| session[:current_accordion_page][key] = value } if params[:current_accordion_page]
  end
  
end
