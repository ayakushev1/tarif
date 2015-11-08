# == Schema Information
#
# Table name: result_agregates
#
#  id                    :integer          not null, primary key
#  run_id                :integer
#  tarif_id              :integer
#  service_set_id        :string
#  service_category_name :string
#  rouming_ids           :integer          is an Array
#  geo_ids               :integer          is an Array
#  partner_ids           :integer          is an Array
#  calls_ids             :integer          is an Array
#  one_time_ids          :integer          is an Array
#  periodic_ids          :integer          is an Array
#  fix_ids               :integer          is an Array
#  rouming_names         :string           is an Array
#  geo_names             :string           is an Array
#  partner_names         :string           is an Array
#  calls_names           :string           is an Array
#  one_time_names        :string           is an Array
#  periodic_names        :string           is an Array
#  fix_names             :string           is an Array
#  rouming_details       :string           is an Array
#  geo_details           :string           is an Array
#  partner_details       :string           is an Array
#  price                 :float
#  call_id_count         :integer
#  sum_duration_minute   :float
#  sum_volume            :float
#  count_volume          :integer
#

class Result::Agregate < ActiveRecord::Base
  extend BatchInsert

  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id

end

