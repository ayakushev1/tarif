class HomeController < ApplicationController
  include Crudable
  crudable_actions :all
 
  def index
  end
end
