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
    redirect_to( result_runs_path, alert: message) if result_runs_count < 2
  end
  
  def is_allowed_new_result_run?
    result_runs_count < allowed_new_result_run(user_type) ? true : false
  end
  
  def result_runs_count
    Result::Run.where(:user_id => current_or_guest_user_id).count
  end
  
  def allowed_new_result_run(user_type = :guest)
    {:guest => 4, :trial => 10, :user => 20, :admin => 100000}[user_type]
  end
  
  def accounting_periods(call_run_id = nil)
    @accounting_periods ||= Customer::Call.
      where(:user_id => current_or_guest_user_id, :call_run_id => (call_run_id || -1).to_i).
      select("description->>'accounting_period' as accounting_period").uniq
  end
  
  

end
