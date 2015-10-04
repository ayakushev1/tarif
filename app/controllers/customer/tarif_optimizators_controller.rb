require 'platform-api'

class Customer::TarifOptimizatorsController < ApplicationController
  before_action -> {customer_tarif_optimizator.check_if_optimization_options_are_in_session}, only: [:index]

  before_action :check_if_customer_has_free_trials, only: :recalculate
  before_action :check_inputs_for_recalculate, only: :recalculate
  before_action -> {customer_tarif_optimizator.validate_tarifs}, only: [:index, :recalculate]

  before_action -> {customer_tarif_optimizator.init_background_process_informer}, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate]
#  after_action -> {customer_tarif_optimizator.update_customer_infos}, only: :recalculate

  after_action :track_recalculate, only: :recalculate
  after_action :track_index, only: :index

  helper_method :customer_tarif_optimizator

#  def index
#    heroku = Background::WorkerManager::Heroku.new().heroku
#    Rails.logger.info Background::WorkerManager::Heroku.new().worker_quantity('tarif_optimization')
#    Rails.logger.info heroku.formation.info(ENV["MY_HEROKU_APP_NAME"], 'tarif_optimization')    
#    Rails.logger.info heroku.dyno.list(ENV["MY_HEROKU_APP_NAME"])    
#    Rails.logger.info heroku.formation.list(ENV["MY_HEROKU_APP_NAME"])    
#    flash[:alert] = 'sssss'
#  end

 def select_services
    session[:filtr]['service_choices_filtr'].merge!(Customer::Info::ServicesSelect.process_selecting_services(params['services_select_filtr']))
    session_filtr_params(customer_tarif_optimizator.services_select)
    redirect_to(:action => :index)
  end
  
  def calculation_status
    if !customer_tarif_optimizator.background_process_informer_operators.calculating?      
      redirect_to({:action => :index}, :alert => "Расчет закончен")
#      raise(StandardError, flash[:alert])
    end
  end
  
  def recalculate    
#    raise(StandardError)
    if session_filtr_params(customer_tarif_optimizator.optimization_params)['calculate_on_background'] == 'true' and
      session_filtr_params(customer_tarif_optimizator.service_choices)['calculate_with_fixed_services'] == 'false'
#      raise(StandardError)
      customer_tarif_optimizator.recalculate_on_background
#      sleep 0.2
      if session_filtr_params(customer_tarif_optimizator.optimization_params)['calculate_background_with_spawnling'] == 'true' or 
        session_filtr_params(customer_tarif_optimizator.service_choices)['calculate_with_fixed_services'] == 'true'
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
    if session_filtr_params(customer_tarif_optimizator.service_choices)['accounting_period'].blank?
      redirect_to({:action => :index}, {:alert => "Выберите период для расчета"}) and return
    end

    if session_filtr_params(customer_tarif_optimizator.service_choices)['calculate_with_fixed_services'] == 'true'
      if session_filtr_params(customer_tarif_optimizator.services_for_calculation_select)["operator_id"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите оператора на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return
      end

      if session_filtr_params(customer_tarif_optimizator.services_for_calculation_select)["tarif_to_calculate"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите тариф на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return 
      end
    end
    
#    operator_id = session_filtr_params(customer_tarif_optimizator.services_for_calculation_select)["operator_id"].to_i
#    tarif_id = session_filtr_params(customer_tarif_optimizator.services_for_calculation_select)["tarif_to_calculate"].to_i
#    redirect_to({:action => :index}, {:alert => TarifClass.allowed_tarif_option_ids_for_tarif(operator_id, tarif_id)}) and return

  end
  
  def check_if_customer_has_free_trials
    if session_filtr_params(customer_tarif_optimizator.service_choices)['calculate_with_fixed_services'] == 'true'
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
  
  private
  
  def track_recalculate
#    raise(StandardError, customer_tarif_optimizator.optimization_params)
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#      'optimization_params' => customer_tarif_optimizator.optimization_params,
#      'service_choices' => customer_tarif_optimizator.service_choices,
#      'services_select' => customer_tarif_optimizator.services_select,
#      'service_categories_select' => customer_tarif_optimizator.service_categories_select,
#   })
  end

  def track_index
 #   ahoy.track("#{controller_name}/#{action_name}", {
 #     'flash' => flash,      
 #   }) if params.count == 2
  end

end
