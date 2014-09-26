# == Schema Information
#
# Table name: relations
#
#  id             :integer          not null, primary key
#  type_id        :integer
#  name           :string(255)
#  owner_id       :integer
#  parent_id      :integer
#  children       :integer          default([]), is an Array
#  children_level :integer          default(1)
#

class Relation < ActiveRecord::Base
  include PgArrayHelper

  belongs_to :type, :class_name =>'Category', :foreign_key => :type_id

  scope :operators_by_country, -> {where(:type_id => 192).where(:parent_id => nil)}
  
  def self.home_regions(operator_id, parent_region_id)
    result = where(:type_id => 190, :owner_id => operator_id, :parent_id => parent_region_id).first
    result ? result.children : []
  end

  def self.own_home_regions(operator_id, parent_region_id)
    result = where(:type_id => 190, :owner_id => operator_id, :parent_id => parent_region_id).first
    result ? (result.children + [parent_region_id]) : [parent_region_id]
  end

  def self.country_operators(country_id)
    result = where(:type_id => 192, :owner_id => country_id, :parent_id => nil).first
    result ? result.children : nil
  end

  def self.country_operator(country_id)
    result = country_operators(country_id)
    result ? result.first : nil
  end

  def self.operator_country_groups(operator_id, parent_location_id)
    result = where(:type_id => 191, :owner_id => operator_id, :parent_id => parent_location_id).first
    result ? result.children : []
  end

  def self.operator_country_groups_by_group_id(group_id)
    result = where(:id => group_id).first
    result ? result.children : []
  end

  def self.operator_region_groups_by_group_id(group_id)
    result = where(:id => group_id).first
    result ? result.children : []
  end

end

