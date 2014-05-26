class TarifClassesController < ApplicationController
  include Crudable
  crudable_actions :all
  
  def tarif_class_filtr
    Filtrable.new(self, "tarif_class")
  end

  def tarif_classes
    Tableable.new(self, TarifClass.query_from_filtr(tarif_class_filtr.session_filtr_params) )
  end

  def price_lists_for_index
    Tableable.new(self, PriceList.tarif_class_price_lists(session[:current_id]['tarif_class_id'] ) )
  end
  
  def price_lists_for_show
    Tableable.new(self, PriceList.tarif_class_price_lists(tarif_class.id) ) 
  end
  
  def price_formulas
    Tableable.new(self, Price::Formula.with_price_list(session[:current_id]['price_list_id']) )
#    Tableable.new(self, Price::Formula.where(:price_list_id => session[:current_id]['price_list_id']) )
  end
  
private

end
