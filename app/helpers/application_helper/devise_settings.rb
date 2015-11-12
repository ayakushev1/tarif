module ApplicationHelper::DeviseSettings

  def configure_permitted_parameters
#    devise_parameter_sanitizer.for(:sign_in) << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
#    devise_parameter_sanitizer.for(:sign_up)  << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
#    devise_parameter_sanitizer.for(:account_update)  << :name #{ |u| u.permit(:name, :password, :password_confirmation, :current_password) }
  end  

  def after_sign_in_path_for(resource)
    root_path
  end
    
  private
    
end
