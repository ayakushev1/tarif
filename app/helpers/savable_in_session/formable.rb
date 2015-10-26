module SavableInSession::Formable
  
  def create_formable(model)
    formable = Formable.new(model)
    init_session_for_formable(formable)
    set_session_from_params_for_formable(formable)
    formable
  end
  
  def session_model_params(formable)
    session[:form][formable.form_name].dup
  end
  
  class Formable
    include SavableInSession::AssistanceInView
    attr_accessor :form_name, :caption, :action_on_submit
    attr_reader :model
    
    def initialize(model, model_name = "base_name")
      @model = model
      @base_name = model.class.name.underscore.gsub(/\//, "_").to_sym || model_name # || controller.model_name || controller.controller_path.gsub(/\//, "_").underscore.singularize.to_sym
      @form_name = "#{@base_name}"
    end
  end
end