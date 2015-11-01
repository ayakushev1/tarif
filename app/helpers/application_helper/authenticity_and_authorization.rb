module ApplicationHelper::AuthenticityAndAuthorization
  
  def my_authenticate_user
    if !allow_skip_authenticate_user
      authenticate_user!
    end
  end
    
  protected

  def main_layout
    current_user_admin? ? 'application' : 'demo_application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up)  << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  << :name #{ |u| u.permit(:name, :password, :password_confirmation, :current_password) }
  end  

  def after_sign_in_path_for(resource)
    root_path
  end
    
  private
    def authorize
      if controller_name == 'users' or controller_name == 'registrations'
#        raise(StandardError, [controller_name, action_name])
        redirect_to(root_path, alert: 'Вы пытаетесь получить доступ к чужому счету') if !user_access_to_his_account and !user_is_registering
      else
#        raise(StandardError, [controller_name, action_name])
        if user_make_some_allowed_actions_with_devise_controllers
          
        else
          if !current_user_admin?
            redirect_to(root_path) if !controller_has_public_url?
          end         
        end
      end
    end
    
    def root_page?
#      raise(StandardError, [controller_name, action_name])
      ((controller_name == 'home') and ['index'].include?(action_name))
    end
    
    def user_is_registering
      #raise(StandardError, [controller_name, action_name])
      ((controller_name == 'users' or controller_name == 'registrations') and ['new', 'create'].include?(action_name))
    end
    
    def user_access_to_his_account
#      raise(StandardError, [controller_name, action_name])
      comparison_between_form_and_params = case action_name
      when 'show', 'edit'
        params[:id] and current_user and current_user.id.to_i == params[:id].to_i
      when 'update'
#        raise(StandardError)
        params[:user] and current_user and current_user.valid_password?(params[:user][:password])
      else
        false
      end

      (['users', 'registrations'].include?(controller_name) and comparison_between_form_and_params)      
    end
    
    def user_make_some_allowed_actions_with_devise_controllers
      user_login or user_confirm_his_email or user_unlock_his_email or user_reset_passwords or (current_user ? user_change_passwords_his_email : false)
    end
    
    def user_login
      (controller_name == 'sessions')
    end
    
    def user_confirm_his_email
      (controller_name == 'confirmations' and ['new', 'show', 'create'].include?(action_name) )
    end
    
    def user_unlock_his_email
      (controller_name == 'unlocks' and ['new', 'show', 'create'].include?(action_name) )
    end
    
    def user_change_passwords_his_email
#      raise(StandardError, [controller_name, action_name])
      (controller_name == 'passwords' and (['new', 'create'].include?(action_name) or 
      (['edit', 'update'].include?(action_name) and params[:id] and current_user and current_user.id.to_i == params[:id].to_i) ) )
    end
    
    def user_reset_passwords
      (controller_name == 'passwords' and ['new', 'create', 'edit', 'update'].include?(action_name) )
    end
    
    def current_user_admin?
      (current_user and current_user.email == ENV["TARIF_ADMIN_USERNAME"])
#      raise(StandardError, [current_user.email, ENV["TARIF_ADMIN_USERNAME"]])
    end
    
    def allow_skip_authenticate_user
#      raise(StandardError, [controller_name, action_name])
      (user_is_registering or root_page? or allowed_request_origin or controller_has_public_url? or external_api_processing)
    end

    def allowed_request_origin
      #raise(StandardError, [controller_name, action_name, allowed_user_agents.include?(request.headers["HTTP_USER_AGENT"]), controller_has_free_public_url?])
#      (allowed_user_agents.include?(request.headers["HTTP_USER_AGENT"]) and controller_has_free_public_url?) or external_api_processing
      allowed_content_type or external_api_processing
    end
    
    def allowed_content_type
      ['*/*'].include?(request.headers["CONTENT_TYPE"])
    end
    
    def controller_has_public_url?
      ((controller_name == 'home') and ['index', 'short_description', 'detailed_description', 'update_tabs'].include?(action_name)) or
      ((controller_path == 'content/articles') and ['show', 'index', 'call_statistic', 'detailed_results'].include?(action_name)) or
      ((controller_path == 'customer/calls') and ['index', 'set_calls_generation_params', 'set_default_calls_generation_params', 'generate_calls'].include?(action_name)) or
      ((controller_path == 'customer/payments') and ['create', 'new', 'edit', 'show', 'update', 'wait_for_payment_being_processed', 'process_payment'].include?(action_name)) or
      ((controller_path == 'home') and ['short_description', 'detailed_description'].include?(action_name)) or
      ((controller_path == 'customer/history_parsers') and ['prepare_for_upload', 'upload', 'calculation_status'].include?(action_name)) or
      ((controller_path == 'customer/optimization_steps') and ['choose_load_calls_options', 'check_loaded_calls', 'choose_optimization_options', 'optimize_tarifs', 'show_optimized_tarifs'].include?(action_name)) or
      ((controller_path == 'customer/tarif_optimizators') and ['index', 'recalculate', 'calculation_status', 'select_services'].include?(action_name)) or
      ((controller_path == 'customer/optimization_results') and ['show_customer_results', 'show_customer_detailed_results'].include?(action_name)) or
      ((controller_path == 'customer/demands') and ['index', 'create', 'new'].include?(action_name))
    end

    def external_api_processing
#      raise(StandardError, request.headers.to_h["action_dispatch.request.content_type"])#, request.headers["REQUEST_METHOD"], controller_name, action_name])
      #(request.headers.to_h["action_dispatch.request.content_type"]== "application/x-www-form-urlencoded" and 
      (request.headers["REQUEST_METHOD"].downcase == 'post' and
      controller_name = 'payments' and action_name = 'process_payment' )
    end
    
end
