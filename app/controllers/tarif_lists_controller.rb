class TarifListsController < ApplicationController

  include Crudable
  crudable_actions :index, :show
  
  def tarif_list_filtr
    Filtrable.new(self, "tarif_list")
  end

  def tarif_lists
    Tableable.new(self, TarifList.includes(:tarif_class, :region).query_from_filtr(tarif_list_filtr.session_filtr_params) )
  end

  def price_list_filtr
    Filtrable.new(self, "price_list")
  end

  def price_lists_for_index
    Tableable.new(self, PriceList.includes(:tarif_class, :tarif_list, :service_category_group, :service_category_tarif_class).
      all_price_lists(session[:current_id]['tarif_list_id'] ) )
  end
  
  def price_lists_for_show
    Tableable.new(self, price_lists_to_show(
      PriceList.includes(:tarif_class, :tarif_list, :service_category_group, :service_category_tarif_class).
        query_from_filtr(price_list_filtr.session_filtr_params), price_list_filtr.session_filtr_params['price_list_to_show'] ) )
  end
  
  def price_formulas
    Tableable.new(self, Price::Formula.includes(:price_list, :standard_formula, :price_unit, :volume, :volume_unit).
      with_price_list(session[:current_id]['price_list_id']) )
  end
  
private

  def price_lists_to_show(model, show_option = 'all_price_lists')
    case show_option
    when 'all_price_lists'
      model.all_price_lists(tarif_list.id)
    when 'direct_tarif_price_lists'
      model.direct_price_lists(tarif_list.id)
    when 'tarif_class_price_lists'
      model.tarif_class_price_lists(tarif_list.tarif_class_id)
    when 'tarif_class_price_lists_not_in_direct'
      model.tarif_class_price_lists_not_in_direct(tarif_list.id)
    when 'category_group_price_lists'
      standard_category_group_ids = Service::CategoryGroup.
        where(:tarif_class_id => tarif_list.tarif_class_id, :operator_id => tarif_list.tarif_class.operator_id).all
      model.category_group_price_lists(standard_category_group_ids)
    when 'category_group_price_lists_not_in_direct'
      model.category_group_price_lists_not_in_direct(tarif_list.id)
    else
      model.all_price_lists(tarif_list.id)
    end 
  end  

end
