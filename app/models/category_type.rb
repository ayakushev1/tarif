# == Schema Information
#
# Table name: category_types
#
#  id   :integer          not null, primary key
#  name :string
#

class CategoryType < ActiveRecord::Base
  has_many :categories, :class_name =>'Category', :foreign_key => :type_id
  has_many :category_levels, :class_name =>'CategoryLevel', :foreign_key => :type_id
end

