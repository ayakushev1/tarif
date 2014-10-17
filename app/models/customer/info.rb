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

class Customer::Info < ActiveRecord::Base
  include PgJsonHelper, WhereHelper, PgCreateHelper
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :info_type, :class_name =>'Customer::Category', :foreign_key => :info_type_id

  scope :general, -> {where(:info_type_id => 1)}
  scope :cash, -> {where(:info_type_id => 2)}
  scope :services_used, -> {where(:info_type_id => 3)}
  scope :calls_generation_params, -> {where(:info_type_id => 4)}
  scope :calls_details_params, -> {where(:info_type_id => 5)}
  scope :calls_parsing_params, -> {where(:info_type_id => 6)}
  scope :tarif_optimization_params, -> {where(:info_type_id => 7)}
  scope :service_choices, -> {where(:info_type_id => 8)}
  scope :services_select, -> {where(:info_type_id => 9)}
  scope :service_categories_select, -> {where(:info_type_id => 10)}
  scope :tarif_optimization_final_results, -> {where(:info_type_id => 11)}
  scope :tarif_optimization_minor_results, -> {where(:info_type_id => 12)}
  scope :tarif_optimization_process_status, -> {where(:info_type_id => 13)}
  
  def self.free_trials(user_id)
    customer_info = where(:user_id => user_id).services_used
    if customer_info.exists?
      customer_info.first.info
    else
      default_values = Init::CustomerInfo::ServicesUsed.values_for_payment.stringify_keys
      result = customer_info.create(:info => {
        'calls_modelling_count' => default_values['calls_modelling_count'], 
        'calls_parsing_count' => default_values['calls_parsing_count'],
        'tarif_optimization_count' => default_values['tarif_optimization_count']}, :last_update => Time.zone.now)
      result.info
    end
  end

  def self.update_free_trials_by_cash_amount(user_id, cash)
    customer_info = where(:user_id => user_id).services_used   
    update_amount = (cash / 95).to_i
    default_values = Init::CustomerInfo::ServicesUsed.values_for_payment.stringify_keys
    
    if customer_info.exists?
      existing_info = customer_info.first['info'] || {}
      customer_info.first.update(:info => {
        'calls_modelling_count' => (existing_info['calls_modelling_count'] || 0) + update_amount * default_values['calls_modelling_count'], 
        'calls_parsing_count' => (existing_info['calls_parsing_count'] || 0) + update_amount * default_values['calls_parsing_count'], 
        'tarif_optimization_count' => (existing_info['tarif_optimization_count'] || 0) + update_amount * default_values['tarif_optimization_count']}, :last_update => Time.zone.now)
    else
      customer_info.create(:info => {
        'calls_modelling_count' => update_amount * default_values['calls_modelling_count'], 
        'calls_parsing_count' => update_amount * default_values['calls_parsing_count'],
        'tarif_optimization_count' => update_amount * default_values['tarif_optimization_count']}, :last_update => Time.zone.now)
    end
  end

  def self.decrease_one_free_trials_by_one(user_id, service_used)
    customer_info = where(:user_id => user_id).services_used   
    if customer_info.exists?
      existing_info = customer_info.first['info'] || {}
      customer_info.first.update(:info => {
        'calls_modelling_count' => (existing_info['calls_modelling_count'] || 0) - (service_used.to_s == 'calls_modelling_count' ? 1 : 0), 
        'calls_parsing_count' => (existing_info['calls_parsing_count'] || 0) - (service_used.to_s == 'calls_parsing_count' ? 1 : 0), 
        'tarif_optimization_count' => (existing_info['tarif_optimization_count'] || 0) - (service_used.to_s == 'tarif_optimization_count' ? 1 : 0)
        }, :last_update => Time.zone.now)
    else
      customer_info.create(:info => {'calls_modelling_count' => 0, 'calls_parsing_count' => 0, 'tarif_optimization_count' => 0}, :last_update => Time.zone.now)
    end
  end

end
