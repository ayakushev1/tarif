module ApplicationHelper::UserWorkflow
  
  def redirect_user_to_registration_or_main_tarif_optimization
    session[:work_flow][:tarif_optimization] ||= {} 
    session[:work_flow][:tarif_optimization][:status] = "ready_to_calculate"
    if user_type == :guest      
      redirect_to new_user_registration_path, notice: "Мы сгенерировали для вас звонки. Можете приступить к подбору тарифов.\
      Мы предлагаем вам оставить адрес электронной почты для того, чтобы мы могли сообщить вам об окончании расчетов, а также\
      чтобы вы не потеряли доступ к вашим расчетам." and return
    else
      redirect_to tarif_optimizators_main_index_path, notice: "Мы сгенерировали для вас звонки. Можете приступить к подбору тарифов" and return
    end    
  end
end
