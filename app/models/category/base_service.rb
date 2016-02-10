# == Schema Information
#
# Table name: categories
#
#  id        :integer          not null, primary key
#  name      :string
#  type_id   :integer
#  level_id  :integer
#  parent_id :integer
#
#require Rails.root.join("db/seeds/definitions/00_general_categories.rb")
class Category::BaseService < ActiveType::Record[Category]
  c = Category::BaseService
  c::Call = 50; c::Sms = 51; c::Mms = 52; c::Wap = 60; c::C2g = 53; c::C3g = 54; c::C4g = 55; c::Cdma = 56; c::Wifi = 57; 
  c::Periodic = 58; c::One_time = 59;
  
  c::Internet = [c::Wap, c::C2g, c::C3g, c::C4g]
  
  scope :base_services, -> {where(:type_id => 5)}
  
  def self.default_scope
    where(:type_id => 5)
  end
end
