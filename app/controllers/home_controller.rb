class HomeController < ApplicationController
  include Crudable
  crudable_actions :all
 
end
