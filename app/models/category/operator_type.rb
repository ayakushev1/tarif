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
class Category::OperatorType < ActiveType::Record[Category]
  c = Category::OperatorType
  c::Mobile = 170; c::Fixed_line = 171;
  
  scope :operator_types, -> {where(:type_id => 19)}
  
  def self.default_scope
    where(:type_id => 19)
  end
end
