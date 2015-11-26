module Result::RunsHelper
  include SavableInSession::Tableable, SavableInSession::SessionInitializers
  
  def result_runs_table
    create_tableable(Result::Run.where(:user_id => current_or_guest_user_id))
  end
  
  def check_if_allowed_new_result_run
    message = "Вам не разрешено создавать и хранить более #{allowed_new_result_run(user_type)} результатов"
    redirect_to( result_runs_path, alert: message) if !is_allowed_new_result_run?
  end
  
  def check_if_allowed_delete_result_run
    message = "Нельзя удалять единственное описание"
    redirect_to( result_runs_path, alert: message) if result_runs_count < (Result::Run.allowed_min_result_run(user_type) + 1)
  end
  
  def is_allowed_new_result_run?
    result_runs_count < allowed_new_result_run(user_type) ? true : false
  end
  
  def result_runs_count
    Result::Run.where(:user_id => current_or_guest_user_id).count
  end
  
  def allowed_new_result_run(user_type = :guest)
    Result::Run.allowed_new_result_run(user_type)
  end
  
  def accounting_periods(call_run_id = nil)
    @accounting_periods ||= Customer::Call.
      where(:user_id => current_or_guest_user_id, :call_run_id => (call_run_id || -1).to_i).
      select("description->>'accounting_period' as accounting_period").uniq
  end
  
  def create_result_run_if_not_exists
    Result::Run.allowed_min_result_run(user_type).times.each do |i|
      Result::Run.create(:name => "Подбор тарифа №#{i}", :description => "", :user_id => current_or_guest_user_id, :run => 1, 
        :optimization_type_id => 0)
    end if !Result::Run.where(:user_id => current_or_guest_user_id).present?
  end
  
  def set_run_id
    session[:filtr]["service_set_choicer_filtr"] ||={}
    session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] = nil

    session[:filtr]['results_select_filtr'] ||= {}
    session[:filtr]['results_select_filtr']['result_run_id'] = session[:current_id]['result_run_id'].to_i if session[:current_id]['result_run_id']
    
#    raise(StandardError, session[:filtr]['results_select_filtr']['result_run_id'] )
  end
end
