class TarifClassesController < ApplicationController
  @new_actions = [:admin_tarif_class, :show_by_operator]
  include Crudable
  crudable_actions :all
  include TarifClassesHelper
  helper TarifClassesHelper, Service::CategoryTarifClassPresenter
  
  before_filter :check_before_freindly_url, only: [:show]
  
  add_breadcrumb "Тарифы и опции", :tarif_classes_path#, only: [:index, :show, :edit]
  
  def show
    add_breadcrumb "#{tarif_class_form.model.try(:name)}", tarif_class_path(params[:id])
  end
  
  def edit
    add_breadcrumb "Редактирование сервиса '#{tarif_class_form.model.try(:name)}'", edit_tarif_class_path(params[:id])
  end
  
  def by_operator
    @operator = Category::Operator.friendly.find(params[:operator_id])
    add_breadcrumb "#{@operator.try(:name)}", tarif_classes_by_operator_path(@operator)
  end
  
  def show_by_operator
    @operator = Category::Operator.friendly.find(params[:operator_id])
    @tarif_class = TarifClass.friendly.find(params[:id])
    add_breadcrumb "#{@operator.try(:name)}", tarif_classes_by_operator_path(@operator)
    add_breadcrumb "#{@tarif_class.try(:name)}", tarif_class_by_operator_path(@operator, @tarif_class)
  end
  
  def check_before_freindly_url
    @tarif_class = TarifClass.where(:id => params[:id]).first
    if @tarif_class and request.path != tarif_class_path(@tarif_class)
      redirect_to tarif_class_by_operator_path(@tarif_class.operator, @tarif_class), :status => :moved_permanently
    end if params[:id]
  end
  


end
