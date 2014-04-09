class TarifListsController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def tarif_list_filtr
    Filtrable.new(self, "tarif_list")
  end

  def tarif_lists
    Tableable.new(self, TarifList.query_from_filtr(tarif_list_filtr.session_filtr_params) )
  end

end
