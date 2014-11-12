class Customer::DemandsController < ApplicationController
  include Crudable
  crudable_actions :all


end
