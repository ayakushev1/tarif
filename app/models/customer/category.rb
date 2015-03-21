# == Schema Information
#
# Table name: customer_categories
#
#  id        :integer          not null, primary key
#  name      :string
#  level_id  :integer
#  type_id   :integer
#  parent_id :integer
#

class Customer::Category < ActiveRecord::Base
  belongs_to :type, :class_name =>'CategoryType', :foreign_key => :type_id

  scope :info_type, -> {where(:type_id => 27)}
  
end

