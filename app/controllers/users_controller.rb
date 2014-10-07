class UsersController < ApplicationController
  layout 'demo_application'
  include Crudable
  crudable_actions :all




end
