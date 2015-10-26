class TarifClassesController < ApplicationController
  include TarifClassesHelper
  include Crudable
  crudable_actions :all
  


end
