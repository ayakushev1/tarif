# == Schema Information
#
# Table name: categories
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  level_id  :integer
#  type_id   :integer
#  parent_id :integer
#

class Category < ActiveRecord::Base
  belongs_to :type, :class_name =>'CategoryType', :foreign_key => :type_id
  belongs_to :level, :class_name =>'CategoryLevel', :foreign_key => :level_id
  belongs_to :parent, :class_name =>'Category', :foreign_key => :parent_id
  has_many :children, :class_name =>'Category', :foreign_key => :parent_id

  scope :locations, -> {where(:type_id => 0)}
  scope :countries, -> {where(:type_id => 0, :level_id => 2)}
  scope :regions, -> {where(:type_id => 0, :level_id => 3)}
  scope :operators, -> {where(:type_id => 2)}
  scope :privacy, -> {where(:type_id => 3)}
  scope :standard_services, -> {where(:type_id => 4)}
  scope :base_services, -> {where(:type_id => 5)}
  scope :service_directions, -> {where(:type_id => 6)}
  scope :param_value_types, -> {where(:type_id => 7)}
  scope :param_sources, -> {where(:type_id => 8)}
  scope :unit_types, -> {where(:type_id => 9, :level_id => 20)}
  scope :units, -> {where(:type_id => 9, :level_id => 21)}
  scope :characteristic_units, -> {where(:type_id => 9, :parent_id => 75)}
  scope :trafic_units, -> {where(:type_id => 9, :parent_id => 76)}
  scope :cost_units, -> {where(:type_id => 9, :parent_id => 77)}
  scope :date_time_units, -> {where(:type_id => 9, :parent_id => 78)}
  scope :trafic_speed_units, -> {where(:type_id => 9, :parent_id => 79)}
  scope :comparison_operations, -> {where(:type_id => 14)}
  
  def self.type(type_id)
    if type_id.blank?
      where("true")
    else
      where(:type_id => type_id) 
    end 
  end
  
  def self.level(level_id)
    if level_id.blank?
      where("true")
    else
      where(:level_id => level_id) 
    end 
  end
  
  def self.with_parent(parent_id)
    if parent_id.blank?
      where("false")
    else
      where(:parent_id => parent_id) 
    end 
  end
  
end

