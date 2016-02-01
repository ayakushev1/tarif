class Users::RegistrationsController < Devise::RegistrationsController
  include SavableInSession::Filtrable, SavableInSession::SessionInitializers
  
  before_action :registration_option, only: :new
  
  def registration_option
    create_filtrable("registration_option")
  end

# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
   def new
#   super
    build_resource({})
    set_minimum_password_length
#    yield resource if block_given?
#    respond_with self.resource
   end

  # POST /resource
   def create
     if params[:user]
       params[:user][:name] = params[:user][:email] if !params[:user][:name]
     end 
     if params[:user] and User.where(:email => params[:user][:email]).present?
       if user_signed_in?
        redirect_to after_sign_up_path_for(resource)
       else
         redirect_to login_path(:user => {:email => params[:user][:email]}), {:alert => "Пользователь с таким электронным адресом уже существует. Входите, если это вы."}
       end       
     else
       super
     end
   end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
   def after_sign_up_path_for(resource)
    if session[:work_flow].try(:[], :tarif_optimization).try(:[], :status) == "ready_to_calculate"
      session[:work_flow][:tarif_optimization][:status] = "sent_to_calculate"
      tarif_optimizators_main_recalculate_path
    else
      super(resource)
    end
   end

  # The path used after sign up for inactive accounts.
#   def after_inactive_sign_up_path_for(resource)
#     super(resource)
#   end
end
