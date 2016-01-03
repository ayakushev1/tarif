class TarifClassesController < ApplicationController
  include TarifClassesHelper
  helper TarifClassesHelper, Service::CategoryTarifClassPresenter
  include Crudable
  crudable_actions :all
  


end
