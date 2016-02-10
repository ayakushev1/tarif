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
#require Rails.root.join("db/seeds/definitions/12_operators_region_groups.rb")
class Category::Region < ActiveType::Record[Category]
  include Category::Region::Const
  
  scope :regions, -> {where(:type_id => 0, :level_id => 3)}
  
  def self.default_scope
    where(:type_id => 0, :level_id => 3)
  end
  
  def self.to_const_list
    all.map{|regions| "c::#{regions.slug.capitalize} = #{regions.id}"}
  end

  def self.list_to_const_array(arr)    
    where(:id => arr).map{|regions| "c::#{regions.slug.capitalize}"}
  end

end
