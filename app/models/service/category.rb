# == Schema Information
#
# Table name: service_categories
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  type_id   :integer
#  parent_id :integer
#  level     :integer
#  path      :integer          default([]), is an Array
#

class Service::Category < ActiveRecord::Base
  include WhereHelper, PgArrayHelper
  belongs_to :type, :class_name =>'Category', :foreign_key => :type_id
  belongs_to :parent, :class_name =>'Service::Category', :foreign_key => :parent_id
  has_many :children, :class_name =>'Service::Category', :foreign_key => :parent_id
#  has_and_belongs_to_many :tarif_classes, :join_table => ':service_category_tarif_classes', :class_name => '::TarifClass' 
#  pg_array_belongs_to :parents, :class_name =>'Service::Category', :foreign_key => :path
  
  def parents
    Service::Category.find(path)
  end  

  def children
    Service::Category.where('path && ARRAY[?]', id)
  end  

  
end

