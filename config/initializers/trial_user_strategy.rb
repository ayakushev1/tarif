#=begin
Warden::Strategies.add(:trial_user) do
  def valid?    
    if params and params[:user]
      u = User.where(:email => params[:user][:email]).first
      u and u[:encrypted_password].blank?
    else
      false
    end 
  end

  def authenticate!
    u = User.where(email: params[:user][:email]).first if params and params[:user]    
    success!(u) if u.present? and (u.confirmed? or u.active_for_authentication?) and 
      params[:user][:password].blank?
  end
end
#=end