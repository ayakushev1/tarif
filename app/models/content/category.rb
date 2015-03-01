# == Schema Information
#
# Table name: content_categories
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  level_id  :integer
#  type_id   :integer
#  parent_id :integer
#

class Content::Category < ActiveRecord::Base
  belongs_to :type, :class_name =>'CategoryType', :foreign_key => :type_id

  scope :content_type, -> {where(:type_id => 30)}
  scope :content_status, -> {where(:type_id => 31)}
  scope :rouming, -> {where(:type_id => 32)}
  scope :service, -> {where(:type_id => 33)}
  scope :destination, -> {where(:type_id => 34)}
  scope :intensity, -> {where(:type_id => 35)}
  
end
