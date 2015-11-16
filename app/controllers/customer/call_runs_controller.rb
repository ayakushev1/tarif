class Customer::CallRunsController < ApplicationController
  include Crudable
  crudable_actions :all
  
end
