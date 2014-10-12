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
  has_many :users, :class_name =>'User', :foreign_key => :user_id
  belongs_to :info_type, :class_name =>'Customer::Category', :foreign_key => :info_type_id

  scope :general_info, -> {where(:info_type_id => 1)}
  scope :cash_info, -> {where(:info_type_id => 2)}
  scope :service_used_info, -> {where(:info_type_id => 3)}
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
  
  def required_to_pay?
    true
  end

end

