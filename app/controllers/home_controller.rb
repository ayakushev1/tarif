class HomeController < ApplicationController
#  include Crudable
#  crudable_actions :all
 
    def index  
      respond_to do |format|
#        format.html { render action: 'index'}
#        format.js { render action: 'index'}
      end
    end
end
