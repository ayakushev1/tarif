class Demo::SessionsController < ApplicationController

  def new_1
  end
  
  def create_1
    @login = params["login_filtr"]
    if @login 
      user =User.find_by_name(@login["login"])
      if user and user.authenticate(@login["password"])
        session[:current_user]["user_id"]=user.id
        redirect_to root_path, notice: "Вы вошли как #{user.name}"
      else
        redirect_to demo_login_path, alert: "Неправильный логин или пароль"
      end
    else
      redirect_to demo_login_path, alert: "there is no :login in params"
    end
  end
  
  def destroy_1
    clean_session
    session[:current_user] = nil
    redirect_to root_path
  end
  
  def user_1
    Filtrable.new(self, "login")
  end

end
