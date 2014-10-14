class Users::SessionsController < Devise::SessionsController
  after_action :check_customer_info, only: :create

  def new
    super
    #redirect_to root_path
  end
  # before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  def check_customer_info
    if !current_user.customer_infos_services_used.exists?
      User.transaction do
        current_user.customer_infos_services_used.create(:info => Init::CustomerInfo::ServicesUsed.default_values, :last_update => Time.zone.now)
        current_user.customer_transactions_services_used.create(:status => {}, :description => Init::CustomerInfo::ServicesUsed.default_values, :made_at => Time.zone.now)
      end
    end
     
  end


  protected
  
end
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  status       :json
#  description  :json
#  made_at      :datetime

#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime