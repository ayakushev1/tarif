module SavableInSession::Filtrable
  
  def create_filtrable(filtr_name)
    filtr_name = "#{filtr_name}_filtr"
    init_session_for_filtrable(filtr_name)
    set_session_from_params_for_filtrable(filtr_name)
#    raise(StandardError, session[:filtr][filtr_name]) if filtr_name == 'tarif_class_filtr'
    Filtrable.new(filtr_name)
  end
  
  def session_filtr_params(filtrable_object)
    session[:filtr][filtrable_object.filtr_name].dup
  end
  
  class Filtrable
    include SavableInSession::AssistanceInView

    attr_accessor :filtr_name, :caption, :action_on_submit
    
    def initialize(filtr_name)
      @filtr_name = filtr_name
    end
  end
end