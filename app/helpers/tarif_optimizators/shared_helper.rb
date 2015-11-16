module TarifOptimizators::SharedHelper
  def user_priority
    Customer::Info::ServicesUsed.info(current_or_guest_user_id)['paid_trials'] = true ? 10 : 20
  end

  def new_run_id    
    Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first_or_create()[:id]
  end

  def accounting_periods
    @accounting_periods ||= Customer::Call.where(:user_id => current_or_guest_user_id).select("description->>'accounting_period' as accounting_period").uniq
  end

end
