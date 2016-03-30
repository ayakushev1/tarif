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
class Category::ServiceDirection < ActiveType::Record[Category]
  c = Category::ServiceDirection
  c::Outbound = 70; c::Inbound = 71; c::Unspecified_direction = 72;
  
  scope :service_directions, -> {where(:type_id => 6)}
  
  def self.default_scope
    where(:type_id => 6)
  end
end
