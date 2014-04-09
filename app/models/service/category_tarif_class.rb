# == Schema Information
#
# Table name: service_category_tarif_classes
#
#  id                                 :integer          not null, primary key
#  tarif_class_id                     :integer
#  service_category_rouming_id        :integer
#  service_category_geo_id            :integer
#  service_category_partner_type_id   :integer
#  service_category_calls_id          :integer
#  service_category_one_time_id       :integer
#  service_category_periodic_id       :integer
#  as_standard_category_group_id      :integer
#  as_tarif_class_service_category_id :integer
#  tarif_class_service_categories     :integer          default([]), is an Array
#  standard_category_groups           :integer          default([]), is an Array
#  is_active                          :boolean
#  created_at                         :datetime
#  updated_at                         :datetime
#

class Service::CategoryTarifClass < ActiveRecord::Base
  include WhereHelper
  belongs_to :service_category_rouming, :class_name =>'Service::Category', :foreign_key => :service_category_rouming_id
  belongs_to :service_category_geo, :class_name =>'Service::Category', :foreign_key => :service_category_geo_id
  belongs_to :service_category_partner_type, :class_name =>'Service::Category', :foreign_key => :service_category_partner_type_id
  belongs_to :service_category_calls, :class_name =>'Service::Category', :foreign_key => :service_category_calls_id
  belongs_to :service_category_one_time, :class_name =>'Service::Category', :foreign_key => :service_category_one_time_id
  belongs_to :service_category_periodic, :class_name =>'Service::Category', :foreign_key => :service_category_periodic_id
  belongs_to :as_standard_category_group, :class_name =>'Service::CategoryGroup', :foreign_key => :as_standard_category_group_id
  belongs_to :as_tarif_class_service_category, :class_name =>'Service::CategoryTarifClass', :foreign_key => :as_tarif_class_service_category_id
  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id

  def self.with_operator(operator_id)
    operator_id ? joins(:tarif_class).where('tarif_classes.operator_id = ?', operator_id ) : self 
  end
  
  def self.with_standard_category_groups(group_id)
    group_id ? where("array[standard_category_groups] @> array[#{group_id.to_i}] ") : self 
  end
  
end
