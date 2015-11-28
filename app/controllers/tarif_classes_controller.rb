class TarifClassesController < ApplicationController
  include TarifClassesHelper
  helper TarifClassesHelper
  include Crudable
  crudable_actions :all
  


end
