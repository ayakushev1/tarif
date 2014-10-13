class Home1Controller < ApplicationController
#  include Crudable
#  crudable_actions :all
  def index
    render nothing: true
  end
 
end
