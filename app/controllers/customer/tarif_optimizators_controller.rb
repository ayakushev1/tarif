require 'platform-api'

class Customer::TarifOptimizatorsController < ApplicationController
  before_action -> {customer_tarif_optimizator.check_if_optimization_options_are_in_session}, only: [:index]

  before_action :check_if_customer_has_free_trials, only: :recalculate
  before_action :check_inputs_for_recalculate, only: :recalculate
  before_action -> {customer_tarif_optimizator.validate_tarifs}, only: [:index, :recalculate]

  before_action -> {customer_tarif_optimizator.init_background_process_informer}, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate]
#  after_action -> {customer_tarif_optimizator.update_customer_infos}, only: :recalculate

  helper_method :customer_tarif_optimizator

  def index
#    heroku = Background::WorkerManager::Heroku.new().heroku
#    Rails.logger.info Background::WorkerManager::Heroku.new().worker_quantity('tarif_optimization')
#    Rails.logger.info heroku.formation.info(ENV["MY_HEROKU_APP_NAME"], 'tarif_optimization')    
#    Rails.logger.info heroku.dyno.list(ENV["MY_HEROKU_APP_NAME"])    
#    Rails.logger.info heroku.formation.list(ENV["MY_HEROKU_APP_NAME"])    
  end

 def select_services
    session[:filtr]['service_choices_filtr'].merge!(Customer::Info::ServicesSelect.process_selecting_services(params['services_select_filtr']))
    customer_tarif_optimizator.services_select.session_filtr_params
    redirect_to(:action => :index)
  end
  
  def calculation_status
#    raise(StandardError)
    if !customer_tarif_optimizator.background_process_informer_operators.calculating?      
      redirect_to(:action => :index)
    end
  end
  
  def recalculate    
#    raise(StandardError)
    if customer_tarif_optimizator.optimization_params.session_filtr_params['calculate_on_background'] == 'true' and
      customer_tarif_optimizator.service_choices.session_filtr_params['calculate_with_fixed_services'] == 'false'
#      raise(StandardError)
      customer_tarif_optimizator.recalculate_on_background
#      sleep 0.2
      if customer_tarif_optimizator.optimization_params.session_filtr_params['calculate_background_with_spawnling'] == 'true' or 
        customer_tarif_optimizator.service_choices.session_filtr_params['calculate_with_fixed_services'] == 'true'
        redirect_to(:action => :calculation_status)
      else
        redirect_to root_path, {:alert => "Мы сообщим вам электронным письмом об окончании расчетов"}
      end
    else
#      raise(StandardError)
      customer_tarif_optimizator.recalculate_direct
      redirect_to({:action => :index}, {:alert => "Расчет выполнен. Можете перейти к просмотру результатов"})
    end    
  end 
  
  def check_inputs_for_recalculate     
    if customer_tarif_optimizator.service_choices.session_filtr_params['accounting_period'].blank?
      redirect_to({:action => :index}, {:alert => "Выберите период для расчета"}) and return
    end

    if customer_tarif_optimizator.service_choices.session_filtr_params['calculate_with_fixed_services'] == 'true'
      if customer_tarif_optimizator.services_for_calculation_select.session_filtr_params["operator_id"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите оператора на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return
      end

      if customer_tarif_optimizator.services_for_calculation_select.session_filtr_params["tarif_to_calculate"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите тариф на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return 
      end
    end
    
#    operator_id = customer_tarif_optimizator.services_for_calculation_select.session_filtr_params["operator_id"].to_i
#    tarif_id = customer_tarif_optimizator.services_for_calculation_select.session_filtr_params["tarif_to_calculate"].to_i
#    redirect_to({:action => :index}, {:alert => TarifClass.allowed_tarif_option_ids_for_tarif(operator_id, tarif_id)}) and return

  end
  
  def check_if_customer_has_free_trials
    if customer_tarif_optimizator.service_choices.session_filtr_params['calculate_with_fixed_services'] == 'true'
      if !customer_has_free_tarif_recalculation_trials?
        redirect_to({:action => :index}, {:alert => "У Вас не осталось свободных попыток для расчета выбранных тарифа и опций, а только для подбора тарифа"}) and return
      end
    else
      if !customer_has_free_tarif_optimization_trials?
        redirect_to({:action => :index}, {:alert => "У Вас не осталось свободных попыток для подбора тарифа, только для расчета выбранных тарифа и опций"}) and return
      end
    end
  end
  
  def customer_tarif_optimizator
    @customer_tarif_optimizator ||= 
    Customer::TarifOptimizator.new(self)
  end
  
end
