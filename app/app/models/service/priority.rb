# == Schema Information
#
# Table name: service_priorities
#
#  id                       :integer          not null, primary key
#  type_id                  :integer
#  main_tarif_class_id      :integer
#  dependent_tarif_class_id :integer
#  relation_id              :integer
#  value                    :integer
#  arr_value                :integer          default([]), is an Array
#

class Service::Priority < ActiveRecord::Base
  include WhereHelper, PgArrayHelper
  belongs_to :type, :class_name =>'Category', :foreign_key => :type_id
  belongs_to :relation, :class_name =>'Category', :foreign_key => :relation_id
  belongs_to :main_tarif_class, :class_name =>'TarifClass', :foreign_key => :main_tarif_class_id
  belongs_to :dependent_tarif_class, :class_name =>'TarifClass', :foreign_key => :dependent_tarif_class_id
  
  scope :general_priority, -> {where(:type_id => 300)}
  scope :individual_priority, -> {where(:type_id => 301)}
  scope :dependent_is_required_for_main, -> {where(:type_id => 302)}
  scope :main_is_incompatible_with_dependent, -> {where(:type_id => 303)}
  scope :higher_priority, -> {where(:type_id => 301, :relation_id => 310)}
  scope :lower_priority, -> {where(:type_id => 301, :relation_id => 311)}
  
  
end

