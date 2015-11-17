class TarifOptimizators::LimitedScopeController < ApplicationController
  include TarifOptimizators::LimitedScopeHelper
  
  before_action :create_result_run_if_not_exists, only: [:index]
  before_action :update_call_run_on_result_run_change, only: [:index]
  before_action :check_if_optimization_options_are_in_session, only: [:index]

  before_action :check_if_customer_has_free_trials, only: :recalculate
  before_action :check_inputs_for_recalculate, only: :recalculate

  after_action :track_recalculate, only: :recalculate
  after_action :track_index, only: :index

  def recalculate    
    update_customer_infos
    TarifOptimization::TarifOptimizatorRunner.recalculate_with_delayed_job(options)
    redirect_to root_path, {:alert => "Мы сообщим вам электронным письмом об окончании расчетов"}
  end 
  
  def check_inputs_for_recalculate     
    if session_filtr_params(calculation_choices)['result_run_id'].blank?
      redirect_to({:action => :index}, {:alert => "Выберите описание подбора тарифа"}) and return
    end

    call_run_id = session_filtr_params(calculation_choices)['call_run_id']
    if session_filtr_params(calculation_choices)['accounting_period'].blank? or
        !accounting_periods(call_run_id).map(&:accounting_period).include?(session_filtr_params(calculation_choices)['accounting_period'])
      redirect_to({:action => :index}, {:alert => "Выберите период для расчета"}) and return
    end

    if selected_service_categories.blank?
      message_for_blank_operator = "Список услуг связи не может быть пустым. Выберите услуги на вкладке 'Выбор услуг оператора'"
      redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return 
    end
    
    is_user_calculating_now = Delayed::Job.where(:queue => "tarif_optimization", :attempts => 0, :reference_id => current_or_guest_user_id, :reference_type => 'user').present?
    if is_user_calculating_now
      message = "Мы для вас сейчас уже подбираем тариф. Подождите до окончания подбора, мы сообщим об этом письмом, если вы предоставили адрес"
      redirect_to({:action => :index}, {:alert => message}) and return 
    end
  end
  
  def check_if_customer_has_free_trials
    if !customer_has_free_tarif_optimization_trials?
      redirect_to({:action => :index}, {:alert => "У Вас не осталось свободных попыток для подбора тарифа, только для расчета выбранных тарифа и опций"}) and return
    end
  end
  
  private
  
  def track_recalculate
#    raise(StandardError, optimization_params)
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#      'optimization_params' => optimization_params,
#      'calculation_choices' => calculation_choices,
#      'services_select' => services_select,
#      'service_categories_select' => service_categories_select,
#   })
  end

  def track_index
 #   ahoy.track("#{controller_name}/#{action_name}", {
 #     'flash' => flash,      
 #   }) if params.count == 2
  end

end
