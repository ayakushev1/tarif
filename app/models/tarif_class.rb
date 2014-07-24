# == Schema Information
#
# Table name: tarif_classes
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  operator_id         :integer
#  privacy_id          :integer
#  standard_service_id :integer
#  features            :json
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  dependency          :json
#

class TarifClass < ActiveRecord::Base
  include WhereHelper
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  belongs_to :privacy, :class_name =>'Category', :foreign_key => :privacy_id
  belongs_to :standard_service, :class_name =>'Category', :foreign_key => :standard_service_id
  has_many :service_category_tarif_classes, :class_name => 'Service::CategoryTarifClass', :foreign_key => :tarif_class_id
  has_many :tarif_lists, :class_name => 'TarifList', :foreign_key => :tarif_class_id

  scope :tarifs, -> {where(:standard_service_id => 40)}
  scope :common_services, -> {where(:standard_service_id => 41)}
  scope :special_services, -> {where(:standard_service_id => 42)}
  scope :options_of_tarif, -> {where(:standard_service_id => 43)}

  def self.services_by_operator(operator_ids)
    if operator_ids.blank?
      none
    else
      where(:operator_id => operator_ids)
    end
  end
  
  def self.with_not_null_dependency
    where("dependency is not null")
  end

end

