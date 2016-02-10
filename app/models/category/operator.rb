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

class Category::Operator < ActiveType::Record[Category]
  include Category::Operator::Const
  
  scope :operators, -> {where(:type_id => 2).where.not(:parent_id => nil)}
  scope :russian_operators, -> {where(:type_id => 2).where(:parent_id => 3001)}
  scope :foreign_operators, -> {where(:type_id => 2).where(:parent_id => 3002)}
  scope :operators_with_tarifs, -> {where(:id => Category::Operator::Const::OperatorsWithTarifs)}
  scope :operators_with_parsing, -> {where(:id =>Category::Operator::Const::OperatorsWithParsing)}
  scope :operators_for_optimization, -> {where(:id => Category::Operator::Const::OperatorsForOptimization)}
  
  def self.default_scope
    where(:type_id => 2)
  end
  
end
