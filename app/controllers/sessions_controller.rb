class SessionsController < ApplicationController

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
        redirect_to login_path, alert: "Invalid user / password combination"  
      end
    else
      redirect_to login_path, alert: "there is no :login in params"
    end
  end
  
  def destroy
    clean_session
    session[:current_user] = nil
    redirect_to root_path
  end
  
  def new_location
  end
  
  def choose_location
    session[:current_user]["country_id"] = params["location_filtr"]["country_id"]
    unless params["location_filtr"]["country_id"].blank?
      session[:current_user]["country_name"] = Category.find(params["location_filtr"]["country_id"]).name
    else  
      session[:current_user]["country_name"] = nil
    end
    
    session[:current_user]["region_id"] = params["location_filtr"]["region_id"]    
    unless params["location_filtr"]["region_id"].blank?
      session[:current_user]["region_name"] = Category.find(params["location_filtr"]["region_id"]).name
    else  
      session[:current_user]["region_name"] = nil
    end

    redirect_to root_path 
  end
  
  def user
    Filtrable.new(self, "login")
  end

  def location
    Filtrable.new(self, "location")
  end

end
