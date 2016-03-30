Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

module Calls::HistoryParser::DbSearchHelper
  attr_reader :operators, :countries, :regions, :operators_by_country, :operator_phone_numbers, :home_region_by_operator, :categories

  def load_db_data
    region_set = Category.regions.pluck(:id, :name, :parent_id)
    @regions = {:ids => region_set.map{|rs| rs[0].to_i}, :names => region_set.map{|rs| rs[1].mb_chars.downcase.to_s}, :country_ids => region_set.map{|rs| rs[2]}}
    country_set = Category.countries.pluck(:id, :name)
    @countries = {:ids => country_set.map{|rs| rs[0].to_i}, :names => country_set.map{|rs| rs[1].mb_chars.downcase.to_s}}
    operator_set = Category::Operator.operators.pluck(:id, :name)
    @operators = {:ids => operator_set.map{|rs| rs[0].to_i}, :names => operator_set.map{|rs| rs[1].mb_chars.downcase.to_s}}
    @operators_by_country = Relation.operators_by_country.pluck(:owner_id, :children)
    @home_region_by_operator = Relation.home_regions(user_params[:operator_id], user_params[:country_id])[0]
    @categories = {} 
#    raise(StandardError)
    ::Category.pluck(:id, :name).each { |o| categories[o[0]] = o[1] }
#    raise(StandardError)
  end
  
  def find_operator_by_country(country_id)
    operators_by_country.each do |item|
      return item[1][0] if item[0] == country_id
    end
    nil
  end
  
  def find_operator(arr_of_string)
    arr_of_string.each do |str|
      operators[:names].each_index do |operator_index|         
        return [operators[:ids][operator_index], operator_index] if operators[:names][operator_index] == str
      end
    end
    [nil, nil]
  end
  
  def find_country(arr_of_string)
    arr_of_string.each do |str|
      countries[:names].each_index do |country_index|         
        return [countries[:ids][country_index], country_index] if countries[:names][country_index] == str
      end
    end
    [nil, nil]
  end
  
  def find_country_by_country_group(arr_of_string)
    country_groups = [['популярные страны'.freeze, _egypt], ['снг'.freeze, _ukraiun], ['европа'.freeze, _france], ['северная америка'.freeze, _usa], 
    ['южная америка'.freeze, _brasilia], ['америка'.freeze, _usa], ['азия'.freeze, _tailand], ['африка'.freeze, _egypt], ['австралия'.freeze, _australia]]
    str = arr_of_string.join(' ')
    country_groups.each do |country_group|         
      return [country_group[1], 1] if str =~ /#{country_group[0]}/
    end
    [nil, nil]
  end
  
  def find_region(arr_of_string)
    speical_worlds = ['Республика'.freeze, 'республика'.freeze, 'область'.freeze, 'край'.freeze, 'автономный'.freeze, 'автономная'.freeze]
    (arr_of_string - speical_worlds).each do |str|
      regions[:names].each_index do |region_index|       
        return [regions[:ids][region_index], region_index] if (regions[:names][region_index].split(' ') - speical_worlds).include?(str)
      end
    end
    [nil, nil]
  end
  
end
