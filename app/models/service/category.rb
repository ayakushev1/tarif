# == Schema Information
#
# Table name: service_categories
#
#  id        :integer          not null, primary key
#  name      :string
#  type_id   :integer
#  parent_id :integer
#  level     :integer
#  path      :integer          default([]), is an Array
#

class Service::Category < ActiveRecord::Base
  include WhereHelper, PgArrayHelper
  extend BatchInsert

  belongs_to :type, :class_name =>'Category', :foreign_key => :type_id
  belongs_to :parent, :class_name =>'Service::Category', :foreign_key => :parent_id
  belongs_to :parent_call, :class_name =>'Service::Category', :foreign_key => :parent_id
  has_many :children, :class_name =>'Service::Category', :foreign_key => :parent_id
  has_many :criteria, :class_name =>'Service::Criterium', :foreign_key => :service_category_id
#  has_and_belongs_to_many :tarif_classes, :join_table => ':service_category_tarif_classes', :class_name => '::TarifClass' 
#  pg_array_belongs_to :parents, :class_name =>'Service::Category', :foreign_key => :path
  
  def parents
    Service::Category.find(path)
  end  

  def children
    Service::Category.where('path && ARRAY[?]', id)
  end  
  
  def where_hash(context)
    (children.pluck(:id) << self.id).collect do |category_id|
      criteria.exists? ? criteria.map{|criterium| criterium.where_hash(context) } : true 
    end.join(' and ')
  end
  
  def self.where_hashes(context)
    result = []
    all.each{ |category| result[category.id] = category.where_hash(context) }
    result
  end
  
end

