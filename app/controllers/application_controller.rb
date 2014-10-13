class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :main_layout
  before_action :set_current_session#, :authorize
  before_action :authenticate_user!, except: -> {allow_skip_authenticate_user}
  before_action :authorize
  skip_before_filter :verify_authenticity_token, if: -> { allowed_request_origin }
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_admin?

  def default_render(options = nil)
    respond_to do |format|
      format.js {render_js(view_context.default_view_id_name)}
      format.html
      format.json
    end
  end

  def render_js(id_of_page_to_substitute, template = action_name)
    view_context.tap do |v|
      js_string = v.content_tag(:div, render_to_string(template), {:id => v.view_id_name})
      js_string = "$('##{id_of_page_to_substitute}').html(\" #{v.escape_javascript js_string} \");"          
      render :inline => js_string#, :layout => 'application'
    end
  end
  
  protected

  def set_current_session
    set_current_tabs_pages
    set_current_accordion_pages
  end

  def set_current_tabs_pages
    session[:current_tabs_page] ||= {}
    params[:current_tabs_page].each { |key, value| session[:current_tabs_page][key] = value } if params[:current_tabs_page]
  end
      
  def set_current_accordion_pages
    session[:current_accordion_page] ||= {}
    params[:current_accordion_page].each { |key, value| session[:current_accordion_page][key] = value } if params[:current_accordion_page]
  end
  
  def main_layout
    current_user_admin? ? 'application' : 'demo_application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up)  << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  << :name #{ |u| u.permit(:name, :password, :password_confirmation, :current_password) }
  end  

  def after_sign_in_path_for(resource)
    # return the path based on resource
    root_path
  end
    
  private
    def authorize
#      raise(StandardError, [controller_name, action_name])
      if controller_name == 'users' or controller_name == 'registrations'
        redirect_to(root_path, alert: 'Вы пытаетесь получить доступ к чужому счету') if !user_access_to_his_account  
      else
#        raise(StandardError, [controller_name, action_name])
        if controller_name == 'sessions' #and action_name == 'destroy'
#          user_session = nil
        else
          if !current_user_admin?
            redirect_to(root_path) if !controller_has_public_url?
          end         
        end
      end
    end
    
    def allow_skip_authenticate_user
      (user_is_registering or root_page? or allowed_request_origin)
    end
    
    def root_page?
      (controller_name == 'demo/home' and ['index'].include?(action_name))
    end
    
    def user_is_registering
      (controller_name == 'users' and ['new', 'create'].include?(action_name))
    end
    
    def user_access_to_his_account
      #raise(StandardError)
      ((controller_name == 'users' or controller_name == 'registrations') and ['show', 'edit', 'update'].include?(action_name) and params[:id] and
      current_user and current_user.id.to_i == params[:id].to_i)
    end
    
    def current_user_admin?
      (current_user and current_user.email == ENV["TARIF_ADMIN_USERNAME"])
    end
    
    def allowed_request_origin
      (allowed_user_agents.include?(request.headers["HTTP_USER_AGENT"]) and controller_has_public_url?)
    end
    
    def allowed_user_agents
      [
        "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)",
        "Mozilla/5.0 (compatible; YandexWebmaster/2.0; +http://yandex.com/bots)",
        "Mozilla/5.0 (compatible; YandexMetrika/2.0; +http://yandex.com/bots)",      
      ]      
    end
    
    def controller_has_public_url?
      (self.class.name =~ /Demo/) ? true : false
    end
end
