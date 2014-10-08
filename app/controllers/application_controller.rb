class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  include Tableable_helper
#  before_action :clean_session
#  layout 'application'
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions'}
  skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'registrations'}
  layout :main_layout
  before_action :set_current_session#, :authorize
  before_action :authenticate_user!, except: -> {controller_name == 'users' }
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_or_guest_user 

#  attr_reader :current_user


  def default_render(options = nil)
    respond_to do |format|
      format.js {render_js(view_context.default_view_id_name)}
      format.html 
    end
  end

  def render_js(id_of_page_to_substitute, template = action_name)
#    raise(StandardError)
    view_context.tap do |v|
      js_string = v.content_tag(:div, render_to_string(template), {:id => v.view_id_name})
      js_string = "$('##{id_of_page_to_substitute}').html(\" #{v.escape_javascript js_string} \");"          
      render :inline => js_string#, :layout => 'application'
    end
  end

  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
#        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end
  
  def guest_user
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

#  def become
#    return unless current_user.id == 1 
#    sign_in(:user, User.find(params[:id]))
#    redirect_to root_url # or user_root_url
#  end

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
    current_or_guest_user.name == 'admin@admin' ? 'application' : 'demo_application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end  

  def after_sign_in_path_for(resource)
    # return the path based on resource
    root_path
  end
    
  private
    def create_guest_user
      u = User.create(:id => 0, :name => "Гость", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
      u.skip_confirmation_notification!
      u.save!(:validate => false)
      session[:guest_user_id] = u.id
      u
    end
end
