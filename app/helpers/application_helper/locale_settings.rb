module ApplicationHelper::LocaleSettings

  private

  def set_locale    
    session[:locale] = params[:locale] if params[:locale]
    local = session[:locale].to_sym if session[:locale] 
    local = :ru if ![:ru, :en].include?(local)
    I18n.locale = local || I18n.default_locale
  end
  
    
end
