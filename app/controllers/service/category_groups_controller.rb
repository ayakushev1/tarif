class Service::CategoryGroupsController < ApplicationController
  include Crudable
  crudable_actions :index

  def service_category_group_filtr
    Filtrable.new(self, "service_category_group")
  end

  def service_category_groups
    Tableable.new(self, Service::CategoryGroup.query_from_filtr(service_category_group_filtr.session_filtr_params) )
  end

  def service_category_tarif_classes
    session[:current_id] = session[:current_id] || {}
    Tableable.new(self, Service::CategoryTarifClass.query_from_filtr(service_category_group_filtr.session_filtr_params).
      with_operator(session[:filtr]['service_category_group_filtr']['operator_id'] ).
      with_as_standard_category_group(session[:current_id]['service_category_group_id']).
      order(:service_category_one_time_id, :service_category_periodic_id,  
            :service_category_rouming_id,:service_category_geo_id, :service_category_calls_id, :service_category_partner_type_id) )
  end

end
