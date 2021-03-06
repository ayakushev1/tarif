# == Schema Information
#
# Table name: result_service_sets
#
#  id                  :integer          not null, primary key
#  run_id              :integer
#  service_set_id      :string
#  tarif_id            :integer
#  operator_id         :integer
#  common_services     :integer          is an Array
#  tarif_options       :integer          is an Array
#  service_ids         :integer          is an Array
#  price               :float
#  call_id_count       :integer
#  sum_duration_minute :float
#  sum_volume          :float
#  count_volume        :integer
#  categ_ids           :jsonb
#  identical_services  :jsonb
#

class Result::ServiceSet < ActiveRecord::Base
  extend BatchInsert
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id

  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id

  def full_name
    "#{operator.name} #{tarif.name}"
  end

  def self.best_results_by_operator(result_run_id, operator_ids)
    result = {}
    operator_ids.each do |operator_id|
      result_by_operator = where(:run_id => result_run_id, :operator_id => operator_id).order("price, array_length(tarif_options,0)").limit(1).first
      result[operator_id] = result_by_operator ? result_by_operator.attributes : {} 
    end    
    result
  end
  
end

