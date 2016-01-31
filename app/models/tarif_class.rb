# == Schema Information
#
# Table name: tarif_classes
#
#  id                  :integer          not null, primary key
#  name                :string
#  operator_id         :integer
#  privacy_id          :integer
#  standard_service_id :integer
#  features            :json
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  dependency          :json
#  slug                :string
#

class TarifClass < ActiveRecord::Base
  include WhereHelper, FriendlyIdHelper
#  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  belongs_to :privacy, :class_name =>'Category', :foreign_key => :privacy_id
  belongs_to :standard_service, :class_name =>'Category', :foreign_key => :standard_service_id
  has_many :service_category_tarif_classes, :class_name => 'Service::CategoryTarifClass', :foreign_key => :tarif_class_id
  has_many :tarif_lists, :class_name => 'TarifList', :foreign_key => :tarif_class_id

  scope :for_business, -> {where(:privacy_id => 1)}
  scope :for_private_use, -> {where(:privacy_id => 2)}

  scope :tarifs, -> {where(:standard_service_id => 40)}
  scope :common_services, -> {where(:standard_service_id => 41)}
  scope :special_services, -> {where(:standard_service_id => 42)}
  scope :options_of_tarif, -> {where(:standard_service_id => 43)}

  def slug_candidates
    [
      :name,
      [:operator_name, :name],
      [:operator_name, :standard_service_name, :name]
    ]
  end
  
  def operator_name
    operator.name
  end    
  
  def standard_service_name
    standard_service.name
  end

  def full_name
    "#{operator.name} #{name}"
  end
  
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
  
  def self.allowed_tarif_option_ids_for_tarif(operator_id, tarif_id)
    return [] if !operator_id or !tarif_id
    
    tarif_option_ids = []
    special_services.services_by_operator([operator_id]).each do |row|
      dependency = row['dependency']
      next if (row['is_archived'] == true or !dependency or !dependency['forbidden_tarifs'])

      if !dependency['prerequisites'].blank? and dependency['prerequisites'].include?(tarif_id)
        tarif_option_ids << row['id']
      end
      
      if !dependency['forbidden_tarifs']['to_switch_on'].blank? and !dependency['forbidden_tarifs']['to_switch_on'].include?(tarif_id)
        tarif_option_ids << row['id']
      end
      
      if dependency['prerequisites'].blank? and dependency['forbidden_tarifs']['to_switch_on'].blank?
        tarif_option_ids << row['id']
      end

#    raise(StandardError) if row['name'] == 'Везде как дома SMART'
    end

    tarif_option_ids.compact
  end

end

