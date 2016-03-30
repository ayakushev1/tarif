# == Schema Information
#
# Table name: category_levels
#
#  id      :integer          not null, primary key
#  name    :string
#  level   :integer
#  type_id :integer
#

class CategoryLevel < ActiveRecord::Base
  belongs_to :type, :class_name =>'CategoryType', :foreign_key => :type_id
  has_many :categories, :class_name =>'Category', :foreign_key => :level_id
  
  def self.type(type_id)
    if type_id.blank?
      where("true")
    else
      where(:type_id => type_id) 
    end 
  end
end

