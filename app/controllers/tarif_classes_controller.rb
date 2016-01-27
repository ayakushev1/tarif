class TarifClassesController < ApplicationController
  include TarifClassesHelper
  helper TarifClassesHelper, Service::CategoryTarifClassPresenter
  include Crudable
  crudable_actions :all
  
  before_filter :check_before_freindly_url, only: [:show]
  
  def check_before_freindly_url
    @tarif_class = TarifClass.where(:id => params[:id]).first
    if @tarif_class and request.path != tarif_class_path(@tarif_class)
      redirect_to tarif_class_path(@tarif_class), :status => :moved_permanently
    end if params[:id]
  end
  


end
