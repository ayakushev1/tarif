class Demo::SessionsController < ApplicationController
  layout 'demo_application'

  def new
  end
  
  def create
    @login = params["login_filtr"]
    if @login 
      user =User.find_by_name(@login["login"])
      if user and user.authenticate(@login["password"])
        session[:current_user]["user_id"]=user.id
        redirect_to root_path 
      else
        redirect_to demo_login_path, alert: "Неправильный логин или пароль"  
      end
    else
      redirect_to demo_login_path, alert: "there is no :login in params"
    end
  end
  
  def destroy
    clean_session
    session[:current_user] = nil
    redirect_to root_path
  end
  
  def user
    Filtrable.new(self, "login")
  end

end
