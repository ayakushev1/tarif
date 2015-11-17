class TarifOptimizators::FixedServicesController < ApplicationController
  include TarifOptimizators::FixedServicesHelper
  
  before_action :check_if_optimization_options_are_in_session, only: [:index]

  before_action :check_if_customer_has_free_trials, only: :recalculate
  before_action :check_inputs_for_recalculate, only: :recalculate

  after_action :track_recalculate, only: :recalculate
  after_action :track_index, only: :index

  def recalculate    
    update_customer_infos
    TarifOptimization::TarifOptimizatorRunner.recalculate_direct(options)
    redirect_to({:action => :index}, {:alert => "Расчет выполнен. Можете перейти к просмотру результатов"})
  end 
  
  def check_inputs_for_recalculate     
    call_run_id = session_filtr_params(calculation_choices)['call_run_id']
    if session_filtr_params(calculation_choices)['accounting_period'].blank? or
        !accounting_periods(call_run_id).map(&:accounting_period).include?(session_filtr_params(calculation_choices)['accounting_period'])
      redirect_to({:action => :index}, {:alert => "Выберите период для расчета"}) and return
    end

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      if session_filtr_params(services_for_calculation_select)["operator_id"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите оператора на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return
      end

      if session_filtr_params(services_for_calculation_select)["tarif_to_calculate"].blank?
        message_for_blank_operator = "Вы выбрали расчет для выбранных тарифа и опций. Поэтому выберите тариф на вкладке 'Выбор тарифа и набора опций для расчета'."
        redirect_to({:action => :index}, {:alert => message_for_blank_operator}) and return 
      end
    end
    
    is_user_calculating_now = Delayed::Job.where(:queue => "tarif_optimization", :attempts => 0, :reference_id => current_or_guest_user_id, :reference_type => 'user').present?
    if is_user_calculating_now
      message = "Мы для вас сейчас уже подбираем тариф. Подождите до окончания подбора, мы сообщим об этом письмом, если вы предоставили адрес"
      redirect_to({:action => :index}, {:alert => message}) and return 
    end
  end
  
  def check_if_customer_has_free_trials
    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      if !customer_has_free_tarif_recalculation_trials?
        redirect_to({:action => :index}, {:alert => "У Вас не осталось свободных попыток для расчета выбранных тарифа и опций, а только для подбора тарифа"}) and return
      end
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
