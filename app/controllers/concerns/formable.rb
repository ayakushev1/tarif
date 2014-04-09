class Formable < Presenter
  attr_accessor :form_name, :caption, :action_on_submit
  
  def initialize(controller, model)
    super(controller)
    @model = model
    @base_name = model.class.name.underscore.gsub(/\//, "_").to_sym || controller.model_name || controller.controller_path.gsub(/\//, "_").underscore.singularize.to_sym
    @form_name = "#{@base_name}_form"
    init_session
    set_session_from_params
  end
  
  def model
    @model
  end
  
  def session_model_params
    c.session[:form][form_name]
  end
  
  private
  
  def init_session
    c.session[:form] ||= {}
    c.session[:form][form_name] ||= {}
  end

  def set_session_from_params
    if c.params[:id]
      if c.params[form_name]
        c.session[:form][form_name][:id] = c.params[:id]
        c.session[:form][form_name] = c.params[form_name]
      else
        if c.session[:form][form_name][:id] != c.params[:id]
          c.session[:form][form_name][:id] = c.params[:id]
          model.attributes.each do |col, value|
            c.session[:form][form_name][col] = value    
          end
        end        
      end
    else
      if c.params[form_name]
        c.session[:form][form_name][:id] = nil
        c.session[:form][form_name] = c.params[form_name]
      end
    end
  end
  
end
