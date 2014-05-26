class Price::FormulasController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def formula_filtr
    Filtrable.new(self, "price_formula")
  end

  def formulas
    Tableable.new(self, Price::Formula.query_from_filtr(formula_filtr.session_filtr_params) )
  end

end
