class ParametersController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def parameter_filtr
    Filtrable.new(self, "parameters")
  end

  def parameters
    Tableable.new(self, Parameter.query_from_filtr(parameter_filtr.session_filtr_params) )
  end

  def parameter_show
    Formable.new(self, Parameter.where(:id => session[:current_id]['parameters_id']).first )
  end
end
