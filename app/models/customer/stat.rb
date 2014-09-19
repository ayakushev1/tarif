# == Schema Information
#
# Table name: customer_stats
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  phone_number      :string(255)
#  filtr             :text
#  result            :json
#  stat_from         :datetime
#  stat_till         :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  operator_id       :integer
#  tarif_id          :integer
#  accounting_period :string(255)
#  result_type       :string(255)
#  result_name       :string(255)
#  result_key        :json
#

class Customer::Stat < ActiveRecord::Base
  include PgJsonHelper, WhereHelper, PgCreateHelper
#  serialize :result
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id

  def self.get_named_results(model_init_data = {}, item_name)
    results = get_results(model_init_data)
    results ? results[item_name] : {}
  end
  
  def self.get_results(model_init_data = {})
    result_model = init_result_model(model_init_data)
    
    results = {}
    result_model.each do |result_item|
      result_item.attributes[model_init_data[:result_name]].each do |result_type, result_value|
        if result_value.is_a?(Hash)
          results[result_type] ||= {}
          results[result_type].merge!(result_value)
        else
          results[result_type] = result_value
        end
      end
    end if result_model
    results
  end

  def self.init_result_model(model_init_data = {})
    where(:result_type => model_init_data[:result_type]).
    where(:result_name => model_init_data[:result_name]).
    where(:user_id => model_init_data[:user_id]).
    select("result as #{model_init_data[:result_name]}")
  end
  

end
