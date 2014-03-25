module Crudable
#  extend self
  extend ActiveSupport::Concern
  
  CRUDABLE_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
  
  included do
    add_access_methods
    before_action :set_model, only: [:show, :edit, :update, :destroy]
        
  end
  
#  private
  
  module ClassMethods
    def crudable_actions(*arr)
      crudable_actions = (arr.empty? or arr.include?(:all) ) ? CRUDABLE_ACTIONS : arr
      
      delete_actions(CRUDABLE_ACTIONS - crudable_actions)
    end
   
    
    def delete_actions(actions)
      existing_actions = self.action_methods.collect{ |a| a.to_sym}
      actions_to_hide = actions.select { |action| existing_actions.include?(action.to_sym) }
      self.hide_action(actions_to_hide)
    end
    
    def add_access_methods
      collection_name = self.controller_name
      model_name = self.controller_name.singularize.to_s

      self.send(:define_method, collection_name) do
        Tableable.new(self, collection_name.singularize.capitalize.constantize)
      end

      self.send(:define_method, model_name) do
        if self.request and self.params[:id]
          model_name.capitalize.constantize.find(self.params[:id])
        else
          model_name.capitalize.constantize.new
        end    
      end

      self.send(:define_method, :model_params) do
        params.require(model_name.to_sym).permit!
      end
            
      self.send(:define_method, :set_model) do
        @model = model_name.capitalize.constantize.find(params[:id])
      end
            

    end
  end
      
    def index  
    end
    
    def show 
    end

    def new
#      super 
    end

    def create
      @model = controller_name.singularize.to_s.capitalize.constantize.new(model_params)
      respond_to do |format|
        if @model.save
          format.html { redirect_to @model, notice: "#{self.controller_name.singularize.capitalize} was successfully created." }
          format.json { render action: 'show', status: :created, location: @model }
        else
          format.html { render action: 'new' }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def edit
    end
    
    def update
      respond_to do |format|
        if @model.update(model_params)
          format.html { redirect_to @model, notice: "#{self.controller_name.singularize.capitalize} was successfully updated." }
          format.json { render action: 'show', status: :created, location: @model }
        else
          format.html { render action: 'edit' }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def destroy
      @model.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    end
  #end


end