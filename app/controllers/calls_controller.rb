class CallsController < ApplicationController
  include Crudable
  crudable_actions :index

  def set_default_calls_generation_params
    session[:filtr][calls_generation_params.filtr_name] = view_context.default_calls_generation_params
    redirect_to calls_set_calls_generation_params_path       
  end
  
  def set_calls_generation_params
    if session[:filtr][calls_generation_params.filtr_name].blank?        
      session[:filtr][calls_generation_params.filtr_name] = view_context.default_calls_generation_params
    end
  end
  
  def generate_calls
    view_context.generate_calls(params[calls_generation_params.filtr_name])
    redirect_to calls_path
  end
  
  def calls_generation_params
    Filtrable.new(self, "calls_generation_params")
  end
  
  def filtr
    Filtrable.new(self, "calls")
  end
  
  def calls
    Tableable.new(self, Call.query_from_filtr(session[:filtr][filtr.filtr_name]))
  end
  
end
