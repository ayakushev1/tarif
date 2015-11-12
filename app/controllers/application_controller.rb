class ApplicationController < ActionController::Base
  include ApplicationHelper::DefaultRenderer, ApplicationHelper::Authorization, ApplicationHelper::DeviseSettings, 
          ApplicationHelper::SetCurrentSession, ApplicationHelper::CustomerUsedServicesCheck, 
          ApplicationHelper::GuestUser, ApplicationHelper::MiniProfiler

  helper_method :current_user_admin?, :customer_has_free_trials?, :current_or_guest_user, :guest_user?, :user_type, :current_user_id,
                :current_or_guest_user_id

  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::Tableable, SavableInSession::ProgressBarable,
          SavableInSession::Formable, SavableInSession::SessionInitializers
  
  helper_method :session_filtr_params, :session_model_params

  
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :allowed_request_origin
  skip_before_filter :track_ahoy_visit
  before_action :set_current_session
  before_action :authenticate_and_authorise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_make_payment_invitation_page_if_no_free_trials_left
  before_action :check_rack_mini_profiler



end
