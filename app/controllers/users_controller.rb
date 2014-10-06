class UsersController < ApplicationController
  layout 'demo_application'
  before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy]
  attr_reader :user_form, :user

  def create
    respond_to do |format|
      if @user.save
        format.html { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully created." }
        format.js { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully created." }
        session[:current_user]["user_id"] = @user.id  
      else
        format.html { render action: 'new', error: @user.errors}
        format.js { render action: 'new',  error: @user.errors }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @user.update(model_params)
        format.html { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully updated."}
        format.js { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully updated." }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'edit', error: @user.errors }
#          format.js { render action: 'edit',  error: @user.errors }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def set_model
    @user = params[:id] ?  User.find(params[:id]) : User.new
    @user_form = Formable.new(self, @user )    
    params[:user_form] = @user_form.session_model_params
    @user.assign_attributes(model_params)
  end

  def model_params
    unless params[:user_form].blank?
      params.require(:user_form).permit!
    else
      {}
    end
  end
        

end
