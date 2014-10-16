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
  
  def self.has_free_trials?(user_id)
    customer_info = where(:user_id => user_id).services_used.first
    if customer_info and customer_info.info
      (customer_info.info['calls_modelling_count'] == 0 or customer_info.info['calls_parsing_count'] == 0 or customer_info.info['tarif_optimization_count'] == 0) ? false : true
    else
      true
    end
  end

  def self.update_free_trials_by_cash_amount(user_id, cash)
    customer_info = where(:user_id => user_id).services_used   
    update_amount = (cash / 95).to_i
    if customer_info.exists?
      customer_info.update(:info => {'calls_modelling_count' => update_amount * 2, 'calls_parsing_count' => update_amount * 2, 'tarif_optimization_count' => update_amount}, :last_update => Time.zone.now)
    else
      customer_info.create(:info => {'calls_modelling_count' => update_amount * 2, 'calls_parsing_count' => update_amount * 2, 'tarif_optimization_count' => update_amount}, :last_update => Time.zone.now)
    end
  end

end
