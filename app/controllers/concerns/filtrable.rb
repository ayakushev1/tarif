class Filtrable < Presenter
  attr_accessor :filtr_name, :caption, :action_on_submit
  
  def initialize(controller, filtr_name)
    super(controller)
    @filtr_name = "#{filtr_name}_filtr"
    init_session
    set_session_from_params
  end
  
  def session_filtr_params
    c.session[:filtr][filtr_name]
  end
  
  private
  
  def init_session
    c.session[:filtr] ||= {}
    c.session[:filtr][filtr_name] ||= {}
    c.session[:pagination] ||= {}
  end
  
  def set_session_from_params    
    c.params[filtr_name].each do |key, value|
      c.session[:pagination].each do |key_p, value_p|
        c.session[:pagination][key_p] = 1
      end if c.session[:filtr][filtr_name][key] != value
      
      c.session[:filtr][filtr_name][key] = value
    end if c.params[filtr_name]
  end
  
end
