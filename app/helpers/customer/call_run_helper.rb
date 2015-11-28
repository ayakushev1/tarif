module Customer::CallRunHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def call_run
#    raise(StandardError, [params[:id], Customer::CallRun.where(:id => params[:id]).first])
    @call_run ||= Customer::CallRun.where(:id => params[:id].to_i).first
  end
  
  def customer_call_runs
    create_tableable(Customer::CallRun.where(:user_id => current_or_guest_user_id))
  end
  
  def check_if_allowed_new_call_run
    message = "Вам не разрешено создавать более #{allowed_new_call_run(user_type)}  описаний"
    redirect_to( customer_call_runs_path, alert: message) if !is_allowed_new_call_run?
  end
  
  def check_if_allowed_delete_call_run
    message = "Нельзя удалять последнее описание"
    redirect_to( customer_call_runs_path, alert: message) if customer_call_runs_count < (Customer::CallRun.min_new_call_run(user_type) + 1)
  end
  
  def is_allowed_new_call_run?
    customer_call_runs_count < allowed_new_call_run(user_type) ? true : false
  end
  
  def customer_call_runs_count
    Customer::CallRun.where(:user_id => current_or_guest_user_id).count
  end
  
  def allowed_new_call_run(user_type = :guest)
    Customer::CallRun.allowed_new_call_run(user_type)
  end

  def create_call_run_if_not_exists
    Customer::CallRun.min_new_call_run(user_type).times.each do |i|
      Customer::CallRun.create(:name => "Загрузка детализации №#{i}", :source => 1, :description => "", :user_id => current_or_guest_user_id)
    end  if !Customer::CallRun.where(:user_id => current_or_guest_user_id).present?
  end

  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def account_period_choicer
    create_filtrable("account_period_choicer")
  end
  
  def account_period_options
    call_run.stat ? call_run.stat.keys : [] 
  end

  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    calls_stat_options = {"rouming" => 'true'} if calls_stat_options.blank?
        
    operator_id = call_run.operator_id if call_run
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    @calls_stat ||= create_array_of_hashable(
      Customer::CallRun.where(:id => params[:id], :operator_id => operator_id).first_or_create.calls_stat_array(calls_stat_options), options )
  end

end
