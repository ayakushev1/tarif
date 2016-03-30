class Price::FormulasController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def formula_filtr
    create_filtrable("price_formula")
  end

  def formulas
    create_tableable(Price::Formula.query_from_filtr(session_filtr_params(formula_filtr)) )
  end

end
