module TarifOptimizators::SharedHelper
  def user_priority
    Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
  end

  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end
  
  def customer_call_run_id
    customer_call_runs.present? ? customer_call_runs.first.id : -1
  end
  
  def customer_call_runs
    Customer::CallRun.where(:user_id => current_or_guest_user_id)
  end

  def accounting_period
    accounting_periods(customer_call_run_id).blank? ? -1 : accounting_periods(customer_call_run_id)[0]['accounting_period']
  end

  def accounting_periods(call_run_id = nil)
    @accounting_periods ||= Customer::Call.
      where(:user_id => current_or_guest_user_id, :call_run_id => (call_run_id || -1).to_i).
      select("description->>'accounting_period' as accounting_period").uniq
  end
  
end

      
        
