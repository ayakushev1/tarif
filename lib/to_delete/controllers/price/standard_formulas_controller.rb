class Price::StandardFormulasController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def standard_formula_filtr
    create_filtrable("price_standard_formula")
  end

  def standard_formulas
    create_tableable(Price::StandardFormula.query_from_filtr(session_filtr_params(standard_formula_filtr)) )
  end

end
