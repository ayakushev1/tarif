class PriceListsController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def price_list_filtr
    Filtrable.new(self, "price_list")
  end

  def price_lists
    Tableable.new(self, PriceList.includes(:tarif_list, :service_category_group, :service_category_tarif_class).
      query_from_filtr(price_list_filtr.session_filtr_params) )
  end

end
