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
#  identical_services  :integer          is an Array
#  price               :float
#  call_id_count       :integer
#  sum_duration_minute :float
#  sum_volume          :float
#  count_volume        :integer
#

class Result::ServiceSet < ActiveRecord::Base
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id

  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id

end

