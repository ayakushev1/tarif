# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info::ServicesUsed < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 3)
  end
  
  def self.info(user_id) 
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end

  def self.update_free_trials_by_cash_amount(user_id, cash, paid = true)
    update_amount = (cash / 95).to_i
    existing_info = info(user_id)
    
    where(:user_id => user_id).first.update_columns(:info => {
      'calls_modelling_count' => (existing_info['calls_modelling_count'] || 0) + update_amount * values_for_payment['calls_modelling_count'], 
      'calls_parsing_count' => (existing_info['calls_parsing_count'] || 0) + update_amount * values_for_payment['calls_parsing_count'], 
      'tarif_optimization_count' => (existing_info['tarif_optimization_count'] || 0) + update_amount * values_for_payment['tarif_optimization_count'],
      'tarif_recalculation_count' => (existing_info['tarif_recalculation_count'] || 0) + update_amount * values_for_payment['tarif_recalculation_count'],
      'has_calls_loaded' => existing_info['has_calls_loaded'],
      'has_tarif_optimized' => existing_info['has_tarif_optimized'],
      'paid_trials' =>  (existing_info['paid_trials'] or paid),
      }, :last_update => Time.zone.now
    )
  end

  def self.decrease_one_free_trials_by_one(user_id, service_used)
    existing_info = info(user_id)
    where(:user_id => user_id).first.update_columns(:info => {
      'calls_modelling_count' => (existing_info['calls_modelling_count'] || 0) - (service_used.to_s == 'calls_modelling_count' ? 1 : 0), 
      'calls_parsing_count' => (existing_info['calls_parsing_count'] || 0) - (service_used.to_s == 'calls_parsing_count' ? 1 : 0), 
      'tarif_optimization_count' => (existing_info['tarif_optimization_count'] || 0) - (service_used.to_s == 'tarif_optimization_count' ? 1 : 0),
      'tarif_recalculation_count' => (existing_info['tarif_recalculation_count'] || 0) - (service_used.to_s == 'tarif_recalculation_count' ? 1 : 0),
      'has_calls_loaded' => (['calls_modelling_count', 'calls_parsing_count'].include?(service_used.to_s) ? true : existing_info['has_calls_loaded']),
      'has_tarif_optimized' => (['tarif_optimization_count', 'tarif_recalculation_count'].include?(service_used.to_s) ? true : existing_info['has_tarif_optimized']),
      'paid_trials' => existing_info['paid_trials'],
      }, :last_update => Time.zone.now)

  end

  def self.default_values
    {
      'calls_modelling_count' => 10,
      'calls_parsing_count' => 10,
      'tarif_optimization_count' => 5,
      'tarif_recalculation_count' => 10,
      'has_calls_loaded' => false,
      'has_tarif_optimized' => false,
    }
  end

  def self.values_for_payment
    {
      'calls_modelling_count' => 10,
      'calls_parsing_count' => 10,
      'tarif_optimization_count' => 5,
      'tarif_recalculation_count' => 20,
      'paid_trials' => true,
    }
  end

  private
  
end
