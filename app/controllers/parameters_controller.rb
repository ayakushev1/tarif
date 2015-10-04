class ParametersController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def parameter_filtr
    create_filtrable("parameters")
  end

  def parameters
    create_tableable(Parameter.query_from_filtr(session_filtr_params(parameter_filtr)) )
  end

  def parameter_show
    Formable.new(self, Parameter.where(:id => session[:current_id]['parameters_id']).first )
  end
end
