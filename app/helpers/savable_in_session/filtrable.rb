module SavableInSession::Filtrable
  
  def create_filtrable(filtr_name)
    filtr_name = "#{filtr_name}_filtr"
    init_session(filtr_name)
    set_session_from_params(filtr_name)
    Filtrable.new(filtr_name)
  end
  
  def session_filtr_params(filtrable_object)
    session[:filtr][filtrable_object.filtr_name]
  end
  
  class Filtrable
    include SavableInSession::AssistanceInView
    attr_accessor :filtr_name, :caption, :action_on_submit
    
    def initialize(filtr_name)
      @filtr_name = filtr_name
    end
  end

  private
  
  def init_session(filtr_name)
    session[:filtr] ||= {}
    session[:filtr][filtr_name] ||= {}
    session[:pagination] ||= {}
  end
  
  def set_session_from_params(filtr_name)    
    params[filtr_name].each do |key, value|
      session[:pagination].each do |key_p, value_p|
        session[:pagination][key_p] = 1
      end if session[:filtr][filtr_name][key] != value
      
      session[:filtr][filtr_name][key] = value
    end if params[filtr_name]
  end
end