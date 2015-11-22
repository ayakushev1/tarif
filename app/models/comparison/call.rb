# == Schema Information
#
# Table name: customer_calls
#
#  id                 :integer          not null, primary key
#  base_service_id    :integer
#  base_subservice_id :integer
#  user_id            :integer
#  own_phone          :jsonb
#  partner_phone      :jsonb
#  connect            :jsonb
#  description        :jsonb
#  call_run_id        :integer
#  calendar_period    :string
#  global_category_id :integer
#

class Comparison::Call
  
  def self.generate_calls_for_new_inits
    unloaded_init_keys.collect do |unloaded_init_key|
      generate_calls_for_one_init(unloaded_init_key)
      unloaded_init_key
    end
  end
  
  def self.generate_calls_for_one_init(call_init_key)
    if init_list[call_init_key]
      user_params = {"call_run_id" => init_list[call_init_key]["call_run_id"]}
      Customer::Call.where(user_params).delete_all
      Calls::Generator.new(Comparison::Call::Init::Student, user_params).generate_calls
    end
  end
  
  def self.clean_all_inits
    Customer::Call.where("user_id is null").delete_all
  end
  
  def self.init_run_ids
    init_list.values.map{|v| v["call_run_id"]}
  end
  
  def self.loaded_init_run_ids
    Customer::Call.where("user_id is null").pluck(:call_run_id).uniq
  end
  
  def self.unloaded_init_keys
    unloaded_call_run_ids = init_run_ids - loaded_init_run_ids
    init_list.keys.map{|k| k if unloaded_call_run_ids.include?(init_list[k]["call_run_id"])}
  end
  
  def self.init_list
    {
      :student => {"call_run_id"=>0, "init_class" => Comparison::Call::Init::Student},
    }
  end

end

