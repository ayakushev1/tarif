class ApplicationController < ActionController::Base
  include ApplicationHelper::DefaultRenderer, ApplicationHelper::Authorization, ApplicationHelper::DeviseSettings, 
          ApplicationHelper::SetCurrentSession, ApplicationHelper::CustomerUsedServicesCheck, 
          ApplicationHelper::GuestUser, ApplicationHelper::MiniProfiler,
          ApplicationHelper::LocaleSettings

  helper_method :current_user_admin?, :customer_has_free_trials?, :current_or_guest_user, :guest_user?, :user_type, :current_user_id,
                :current_or_guest_user_id

  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::Tableable, SavableInSession::ProgressBarable,
          SavableInSession::Formable, SavableInSession::SessionInitializers
  
  helper_method :session_filtr_params, :session_model_params, :breadcrumb_name, :my_path_for_current_controller_and_action
  add_breadcrumb :breadcrumb_name, :my_path_for_current_controller_and_action

  
  before_action :current_or_guest_user
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :allowed_request_origin
  skip_before_filter :track_ahoy_visit
  before_action :set_current_session
  before_action :set_locale
  before_action :authenticate_and_authorise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_make_payment_invitation_page_if_no_free_trials_left
  before_action :check_rack_mini_profiler

protected
  
  def breadcrumb_name
    I18n.t("#{controller_path}.#{action_name}") 
  end
  
  def my_path_for_current_controller_and_action
#    aa = url_for(controller: controller_name.to_s, action: action_name, only_path: true).sub('/', '')
#    bb = controller_name
#    cc = controller_path
#    raise(StandardError, [aa, bb, cc].join("\n"))
#    "#{controller_name}/#{action_name}"
    url_for(controller: controller_name.to_s, action: action_name, only_path: true).sub('/', '')
  end

 
end
