module ApplicationHelper::AuthenticityAndAuthorization
  
  def my_authenticate_user   
    if !allow_skip_authenticate_user
      authenticate_user!
    end
  end
    
  protected

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
      if ['users', 'registrations'].include?(controller_name) 
        redirect_to(root_path, alert: 'Вы пытаетесь получить доступ к чужому счету') if !user_access_to_his_account and !user_is_registering
      else
        if user_make_some_allowed_actions_with_devise_controllers
        else
          if !current_user_admin?
            redirect_to(root_path) if !controller_has_public_url?
          end         
        end
      end
#        raise(StandardError, [controller_name, action_name])
    end
    
    def root_page?
#      raise(StandardError, [controller_name, action_name])
      ((controller_name == 'home') and ['index'].include?(action_name))
    end
    
    def user_is_registering
#      raise(StandardError, [controller_name, action_name])
      ((controller_name == 'users' or controller_name == 'registrations') and ['new', 'create'].include?(action_name))
    end
    
    def user_access_to_his_account
#      raise(StandardError, [controller_name, action_name])
      comparison_between_form_and_params = case action_name
      when 'show', 'edit'
        params[:id] and current_or_guest_user and current_or_guest_user.id.to_i == params[:id].to_i
      when 'update'
        params[:user] and current_or_guest_user and 
          (current_or_guest_user.valid_password?(params[:user][:current_password]) or (current_user and current_user.password.blank?) )
      else
        false
      end
#        raise(StandardError, comparison_between_form_and_params)

      (['users', 'registrations'].include?(controller_name) and comparison_between_form_and_params)      
    end
    
    def user_make_some_allowed_actions_with_devise_controllers
#      raise(StandardError, [flash[:alert], user_login, user_confirm_his_email, user_unlock_his_email, user_reset_passwords,
#        (current_or_guest_user ? user_change_passwords_his_email : false)])
      user_login or user_confirm_his_email or user_unlock_his_email or user_reset_passwords or (current_or_guest_user ? user_change_passwords_his_email : false)
    end
    
    def user_login
      (controller_name == 'sessions')
    end
    
    def user_confirm_his_email
      (controller_name == 'confirmations' and ['new', 'show', 'create', 'confirm'].include?(action_name) )
    end
    
    def user_unlock_his_email
      (controller_name == 'unlocks' and ['new', 'show', 'create'].include?(action_name) )
    end
    
    def user_change_passwords_his_email
#      raise(StandardError, [controller_name, action_name])
      (controller_name == 'passwords' and (['new', 'create'].include?(action_name) or 
      (['edit', 'update'].include?(action_name) and params[:id] and current_or_guest_user and current_or_guest_user.id.to_i == params[:id].to_i) ) )
    end
    
    def user_reset_passwords
      (controller_name == 'passwords' and ['new', 'create', 'edit', 'update'].include?(action_name) )
    end
    
    def current_user_admin?
      (current_or_guest_user and current_or_guest_user.email == ENV["TARIF_ADMIN_USERNAME"])
#      raise(StandardError, [current_or_guest_user.email, ENV["TARIF_ADMIN_USERNAME"]])
    end
    
    def allow_skip_authenticate_user
#      raise(StandardError, [controller_name, action_name])
      (user_is_registering or root_page? or allowed_request_origin or controller_has_public_url? or external_api_processing)
    end

    def allowed_request_origin
      allowed_content_type or external_api_processing or controller_has_public_url?
    end
    
    def allowed_content_type
      ['*/*', 'ANY_FORMAT'].include?(request.headers["CONTENT_TYPE"])
    end
    
    def controller_has_public_url?
      public_url.each do |allowed_controller_path, allowed_action_names|
        return true if (
          (controller_path == allowed_controller_path) and allowed_action_names.include?(action_name)
        )
      end
      false
    end
    
    def public_url
      {
        'home' => ['index', 'short_description', 'detailed_description', 'update_tabs', 'news'],
        'content/articles' => ['show', 'index', 'call_statistic', 'detailed_results'],
        'customer/calls' =>['index', 'set_calls_generation_params', 'set_default_calls_generation_params', 'generate_calls'],
        'customer/payments' => ['create', 'new', 'edit', 'show', 'update', 'wait_for_payment_being_processed', 'process_payment'],
        'customer/history_parsers' => ['prepare_for_upload', 'upload', 'calculation_status'],
        'customer/optimization_steps' => ['choose_load_calls_options', 'check_loaded_calls', 'choose_optimization_options', 'optimize_tarifs', 'show_optimized_tarifs'],
        'customer/tarif_optimizators' => ['index', 'recalculate', 'calculation_status', 'select_services'],
        'customer/optimization_results' => ['show_customer_results', 'show_customer_detailed_results'],
        'customer/demands' => ['index', 'create', 'new'],
        'errors' => ['error404', 'error422', 'error500'],
      }
    end

    def external_api_processing
#      raise(StandardError, request.headers.to_h["action_dispatch.request.content_type"])#, request.headers["REQUEST_METHOD"], controller_name, action_name])
      #(request.headers.to_h["action_dispatch.request.content_type"]== "application/x-www-form-urlencoded" and 
      (request.headers["REQUEST_METHOD"].downcase == 'post' and
      controller_name = 'payments' and action_name = 'process_payment' )
    end
    
end
