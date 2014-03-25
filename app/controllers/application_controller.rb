class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  include Tableable_helper
#  before_action :clean_session
  protect_from_forgery with: :exception
  before_action :set_current_session, :authorize
  attr_reader :current_user

  protected
  def authorize
    session[:current_user]["user_id"] ? @current_user=User.find(session[:current_user]["user_id"]) : set_current_user_for_guest  
  end

  def set_current_user_for_guest
    @current_user = User.find(0)
  end
    
  
  def set_current_session
    set_current_user_session
    set_current_tabs_pages
    set_current_accordion_pages
  end

  def set_current_user_session
    session[:current_user] ||= {}
  end
  
  def set_current_tabs_pages
    session[:current_tabs_page] ||= {}
    params[:current_tabs_page].each { |key, value| v.session[:current_tabs_page][key] = value } if params[:current_tabs_page]
  end
      
  def set_current_accordion_pages
    session[:current_accordion_page] ||= {}
    params[:current_accordion_page].each { |key, value| v.session[:current_accordion_page][key] = value } if params[:current_accordion_page]
  end
  
  def clean_session
    session.destroy
  end

  def default_render
    respond_to do |format|
      format.js {render_js(view_context.view_id_name)}
      format.html 
    end
  end

  def render_js(id_of_page_to_substitute, template = action_name)
    js_string = "\"#{view_context.escape_javascript render_to_string(template, :layout => nil)}\""
    js_string = "$('##{id_of_page_to_substitute}').html( #{js_string});"          
    render :inline => js_string    
  end
  
end
