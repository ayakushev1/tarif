module Crudable
#  extend self
  extend ActiveSupport::Concern
  
  CRUDABLE_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
  
  included do
    add_access_methods
    before_action :set_model, only: [:new, :create, :show, :edit, :update, :destroy]
        
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
    
    def model_name
      self.controller_path.gsub(/\//, "_").singularize.to_sym
    end
  
    def form_model_name
      "#{self.model_name}_form"
    end
  
    def collection_name
      collection_name = self.model_name.to_s.pluralize
      collection_name = (collection_name == self.model_name ? collection_name + "s" : collection_name )
    end
  
    def table_name
      self.controller_path.gsub(/\//, "_").underscore.pluralize  
    end                
    
    def add_access_methods
#      self.send(:define_method, collection_name) do
#        create_tableable(model_class)
#      end

      self.send(:define_method, model_name) do
        @model
      end

      self.send(:define_method, form_model_name.to_sym) do
        @form_model
      end

    end
  end
      
    def index  
    end
    
    def show 
    end

    def new
    end

    def create
      respond_to do |format|
        if @model.save
          format.html { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully created." }
          format.js { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully created." }
        else
          format.html { render action: 'new', error: @model.errors}
          format.js { render action: 'new',  error: @model.errors }
        end
      end
    end
    
    def edit
    end
    
    def update
      respond_to do |format|
        if @model.save#update(model_params)
          format.html { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully updated."}
          format.js { render action: 'show', notice: "#{self.controller_name.singularize.capitalize} was successfully updated." }
          format.json { render action: 'show', status: :created, location: @model }
        else
          format.html { render action: 'edit', error: @model.errors }
          format.js { render action: 'edit',  error: @model.errors }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def destroy
      @model.destroy
      respond_to do |format|
#        redirect_to "/#{controller_name}" 
        format.html { redirect_to "/#{controller_path}" }
        format.js { render_js(view_context.default_view_id_name, :index) }
        format.json { head :no_content }
      end
    end
 #end

  def model_params
    unless params[form_model_name].blank?
      params.require(form_model_name).permit!
    else
      {}
    end
  end
        
  def set_model
    @model = params[:id] ?  model_class.find(params[:id]) : model_class.new
    @form_model = create_formable(@model )    
    params[form_model_name] = session_model_params(@form_model)
    @model.assign_attributes(model_params) 
  end

  def model_name
    self.class.model_name
  end

  def form_model_name
    self.class.form_model_name
  end

  def collection_name
    self.class.collection_name
  end

  def table_name
    self.class.table_name  
  end             
  
  def model_class
    controller_path.camelize.singularize.constantize
  end   
  
end