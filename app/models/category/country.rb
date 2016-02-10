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
#require Rails.root.join("db/seeds/definitions/11_operators_country_groups.rb")

class Category::Country < ActiveType::Record[Category]
  include Category::Country::Const
  
  scope :countries, -> {where(:type_id => 0, :level_id => 2)}
  
  def self.default_scope
    where(:type_id => 0, :level_id => 2)
  end
  
  def self.to_const_list
    all.map{|country| "c::#{country.slug.capitalize} = #{country.id}"}
  end

  def self.list_to_const_array(arr)    
    where(:id => arr).map{|country| "c::#{country.slug.capitalize}"}
  end

end
