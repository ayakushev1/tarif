# == Schema Information
#
# Table name: customer_call_runs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  source      :integer
#  description :text
#  operator_id :integer
#  init_class  :string
#  init_params :jsonb
#

class Customer::CallRun < ActiveRecord::Base
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  has_many :calls, :class_name =>'Customer::Call', :foreign_key => :call_run_id

  def full_name
    "#{source_name}: #{name}"
  end
  
  def source_name
    ['Моделирование', 'Загрузка детализации', 'Сравнение'][source] if source
  end
  
  def self.allowed_new_call_run(user_type = :guest)
    {:guest => 3, :trial => 5, :user => 10, :admin => 100000}[user_type]
  end

  def self.min_new_call_run(user_type = :guest)
    {:guest => 3, :trial => 5, :user => 5, :admin => 5}[user_type]
  end

  
  def self.generate_calls(only_new = true, test = false)
    (only_new ? unloaded_call_runs : all).collect do |call_run|
      call_run.generate_calls(only_new, test)
      call_run.name
    end
  end
  
  def self.generate_group_calls(only_new = true, test = false)
    group_calls = (only_new ? unloaded_call_runs : all)
    return [] if !group_calls.present?

    if test
      group_calls.map(&:id)
    else
      group_calls.first.generate_calls 
      new_call_run_ids = group_calls.map(&:id) - [group_calls.first.id]
      Customer::CallRun.generate_calls_from_one_to_other_operator(group_calls.first.id, new_call_run_ids)
    end
  end
  
  def generate_calls
    return false if !init_params
    calls_generation_params = init_params.symbolize_keys.deep_merge({:general => {"operator_id" => operator_id}})
    user_params = {"call_run_id" => id}
    
    Customer::Call.where(user_params).delete_all
    Calls::Generator.new(calls_generation_params, user_params).generate_calls
  end
  
  def self.generate_calls_from_one_to_other_operator(base_call_id, new_call_run_ids = [])
    base_call = where(:id => base_call_id).first
    if base_call
      where(:id => new_call_run_ids).each do |new_call_run|
        Customer::Call.where({"call_run_id" => new_call_run.id}).delete_all
        Calls::Generator.generate_calls_from_one_to_other_operator(base_call.operator_id, base_call.id, new_call_run.operator_id, new_call_run.id)
      end
    end
  end
  
  def self.loaded_call_run_ids
    Customer::Call.where("user_id is null").pluck(:call_run_id).uniq
  end
  
  def self.unloaded_call_runs
    where("user_id is null").where.not(:id => loaded_call_run_ids)
  end
  
end

