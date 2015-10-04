class TarifClassesController < ApplicationController
  include Crudable
  crudable_actions :all
  
  def tarif_class_filtr
    create_filtrable("tarif_class")
  end

  def tarif_classes
    create_tableable(TarifClass.query_from_filtr(session_filtr_params(tarif_class_filtr)) )
  end

  def price_lists_for_index
    create_tableable(PriceList.tarif_class_price_lists(session[:current_id]['tarif_class_id'] ) )
  end
  
  def price_lists_for_show
    create_tableable(PriceList.tarif_class_price_lists(tarif_class.id) ) 
  end
  
  def price_formulas
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_list_id']) )
#    create_tableable(Price::Formula.where(:price_list_id => session[:current_id]['price_list_id']) )
  end
  
private

end
