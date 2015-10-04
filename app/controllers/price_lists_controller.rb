class PriceListsController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def price_list_filtr
    create_filtrable("price_list")
  end

  def price_lists
    create_tableable(PriceList.includes(:tarif_list, :service_category_group, :service_category_tarif_class).
      query_from_filtr(session_filtr_params(price_list_filtr)) )
  end

end
