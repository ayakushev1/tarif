class TarifClassesController < ApplicationController
  include Crudable
  crudable_actions :all
  
  def tarif_class_filtr
    Filtrable.new(self, "tarif_class")
  end

  def tarif_classes
    Tableable.new(self, TarifClass.query_from_filtr(tarif_class_filtr.session_filtr_params) )
  end

  def service_category_tarif_classes
    session[:current_id] = session[:current_id] || {}
    Tableable.new(self, Service::CategoryTarifClass.
      where(:tarif_class_id => session[:current_id]['tarif_class_id']).
      order(:service_category_one_time_id, :service_category_periodic_id, 
            :service_category_rouming_id,:service_category_geo_id, :service_category_calls_id, :service_category_partner_type_id) )
  end

end
