class Customer::TarifOptimizatorsController < ApplicationController
  before_action -> {customer_tarif_optimizator.check_if_optimization_options_are_in_session}, only: [:index]
  before_action -> {customer_tarif_optimizator.validate_tarifs}, only: [:index, :recalculate]
  before_action -> {customer_tarif_optimizator.init_background_process_informer}, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate]
  after_action -> {update_customer_infos}, only: :recalculate

  helper_method :customer_tarif_optimizator


  def select_services
    session[:filtr]['service_choices_filtr'].merge!(Customer::Info::ServicesSelect.process_selecting_services(params['services_select_filtr']))
    customer_tarif_optimizator.services_select.session_filtr_params
    redirect_to(:action => :index)
  end
  
  def calculation_status
    if !customer_tarif_optimizator.background_process_informer_operators.calculating?      
      redirect_to(:action => :index)
    end
  end
  
  def recalculate     
    redirect_to({:action => :index}, {:alert => "Выберите период для расчета"}) and return if customer_tarif_optimizator.options[:accounting_period].blank?

    if customer_tarif_optimizator.optimization_params.session_filtr_params['calculate_on_background'] == 'true'
      customer_tarif_optimizator.recalculate_on_back_ground
      sleep 0.2
      redirect_to(:action => :calculation_status)
    else
      customer_tarif_optimizator.recalculate_direct
      redirect_to(:action => :index)
    end    
  end 
  
  def customer_tarif_optimizator
    @customer_tarif_optimizator ||= Customer::TarifOptimizator.new(self)
  end
  
end
