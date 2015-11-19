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
    result_model.each do |result_item|
        result_item[model_init_data[:result_name]].each do |result_type, result_value|
          if result_value.is_a?(Hash)
            results[result_type] ||= {}
            results[result_type].merge!(result_value)
          else
            results[result_type] = result_value
          end
        end if result_item and model_init_data and model_init_data[:result_name] and result_item[model_init_data[:result_name]]
    end if result_model
    results
  end

  def self.init_result_model(model_init_data = {})
    result = init_result_model_without_select(model_init_data).
    select("result as #{model_init_data[:result_name]}")
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
  
  def self.result_model(model_init_data =  { #можно удалить 
        :result_type => 'optimization_results',
        :result_name => 'prepared_final_tarif_results',
        :user_id => 1, #current_user.id,
        :demo_result_id => nil,
    })
    sql = init_result_model(model_init_data)
    find_by_sql(sql)
  end
  
  

end
