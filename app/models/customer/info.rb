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
  
  def customer_has_free_trials?
    if services_used and services_used.info
      (services_used.info['calls_modelling_count'] == 0 or services_used.info['calls_parsing_count'] == 0 or services_used.info['tarif_optimization_count'] == 0) ? false : true
    else
      true
    end
  end

end
