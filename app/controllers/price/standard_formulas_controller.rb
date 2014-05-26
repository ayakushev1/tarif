class Price::StandardFormulasController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def standard_formula_filtr
    Filtrable.new(self, "price_standard_formula")
  end

  def standard_formulas
    Tableable.new(self, Price::StandardFormula.query_from_filtr(standard_formula_filtr.session_filtr_params) )
  end

end
