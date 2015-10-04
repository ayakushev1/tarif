class Service::CriteriaController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def service_criteria
    create_tableable(Service::Criterium.where(:service_category_id => params['category_id'].to_i) )
  end

end
