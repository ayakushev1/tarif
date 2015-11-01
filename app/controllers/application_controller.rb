class ApplicationController < ActionController::Base
  include ApplicationHelper::DefaultRenderer, ApplicationHelper::AuthenticityAndAuthorization, ApplicationHelper::SetCurrentSession, 
          ApplicationHelper::CustomerUsedServicesCheck
  helper_method :current_user_admin?, :customer_has_free_trials?

  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::Tableable, SavableInSession::ProgressBarable,
          SavableInSession::Formable, SavableInSession::SessionInitializers
  
  helper_method :session_filtr_params, :session_model_params

  
  before_action :run_gc
  protect_from_forgery #with: :exception
  skip_before_filter :verify_authenticity_token, if: :allowed_request_origin
#  skip_before_filter :track_ahoy_visit
  before_action :set_current_session#, :authorize
  before_action :check_rack_mini_profiler
  before_action :my_authenticate_user
  before_action :authorize
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_make_payment_invitation_page_if_no_free_trials_left

  def default_url_options(options = {})
    options#.merge(:anchor => '!')
  end
  
  def check_rack_mini_profiler
#    raise(StandardError)
    # for example - if current_user.admin?
    if false or (current_user_admin?)
      Rack::MiniProfiler.authorize_request
    end
  end  

  layout :main_layout

  protected

  def main_layout
    current_user_admin? ? 'demo_application' : 'demo_application'
  end

  private
  
  def run_gc
#    GC.start
  end

end
