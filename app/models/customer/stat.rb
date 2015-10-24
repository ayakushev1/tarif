# == Schema Information
#
# Table name: customer_stats
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  phone_number      :string
#  filtr             :text
#  result            :json
#  stat_from         :datetime
#  stat_till         :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  operator_id       :integer
#  tarif_id          :integer
#  accounting_period :string
#  result_type       :string
#  result_name       :string
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
#    raise(StandardError, init_result_model(model_init_data))
    result_model.each do |result_item|
      result_item.attributes[model_init_data[:result_name]].each do |result_type, result_value|
        if result_value.is_a?(Hash)
          results[result_type] ||= {}
          results[result_type].merge!(result_value)
        else
          results[result_type] = result_value
        end
      end if result_item and result_item.attributes and model_init_data and model_init_data[:result_name] and result_item.attributes[model_init_data[:result_name]]
    end if result_model
#      raise(StandardError, results) if results.blank?
    results
  end

  def self.init_result_model(model_init_data = {})
    result = init_result_model_without_select(model_init_data).
    select("result as #{model_init_data[:result_name]}")
#    raise(StandardError, result.to_sql)
    result
  end
  
  def self.init_result_model_without_select(model_init_data = {})
    demo_result_where_string = if !model_init_data[:demo_result_id].blank?
      "result_key->'demo_result'->>'id' = '#{model_init_data[:demo_result_id].to_s}'"
    else
      "(result_key->'demo_result'->>'id')::integer is null"
    end
    tarif_id_where_string = if model_init_data[:tarif_id]
      "tarif_id = #{model_init_data[:tarif_id]}"
    else
      'true'
    end
    result = where(:result_type => model_init_data[:result_type]).
    where(:result_name => model_init_data[:result_name]).
    where(demo_result_where_string).
    where(:user_id => model_init_data[:user_id]).
    where(tarif_id_where_string)
#    select("result as #{model_init_data[:result_name]}")
#    raise(StandardError, result.to_sql)

  end
  

end
