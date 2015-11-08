# == Schema Information
#
# Table name: result_runs
#
#  id                              :integer          not null, primary key
#  user_id                         :integer
#  run                             :integer
#  name                            :string
#  description                     :text
#  optimization_params             :jsonb
#  service_choices                 :jsonb
#  services_select                 :jsonb
#  service_categories_select       :jsonb
#  services_for_calculation_select :jsonb
#

class Result::Run < ActiveRecord::Base
  extend BatchInsert
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  has_many :tarifs, :class_name =>'Result::Tarif', :foreign_key => :run_id
  has_many :service_sets, :class_name =>'Result::ServiceSet', :foreign_key => :run_id
  has_many :agregates, :class_name =>'Result::Agregate', :foreign_key => :run_id
  has_many :services, :class_name =>'Result::Service', :foreign_key => :run_id
  has_many :service_categories, :class_name =>'Result::ServiceCategory', :foreign_key => :run_id

end

