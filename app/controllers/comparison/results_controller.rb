class Comparison::ResultsController < ApplicationController
  include Comparison::ResultsHelper
  include Crudable
  crudable_actions :all
  
  
end
