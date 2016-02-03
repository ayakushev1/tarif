class TarifClassesController < ApplicationController
  @new_actions = [:admin_tarif_class]
  include Crudable
  crudable_actions :all
  include TarifClassesHelper
  helper TarifClassesHelper, Service::CategoryTarifClassPresenter
  
  before_filter :check_before_freindly_url, only: [:show]
  
  add_breadcrumb "Список тарифов и опций", :tarif_classes_path
  
  def show
    add_breadcrumb "Описание сервиса '#{tarif_class_form.model.try(:name)}'", tarif_class_path(params[:id])
  end
  
  def edit
    add_breadcrumb "Редактирование сервиса '#{tarif_class_form.model.try(:name)}'", edit_tarif_class_path(params[:id])
  end
  
  def check_before_freindly_url
    @tarif_class = TarifClass.where(:id => params[:id]).first
    if @tarif_class and request.path != tarif_class_path(@tarif_class)
      redirect_to tarif_class_path(@tarif_class), :status => :moved_permanently
    end if params[:id]
  end
  


end
