class Comparison::Call
  
  def self.generate_calls_for_inits(init_list_keys = [])
    init_list_keys.collect do |init_list_key|
      generate_calls_for_one_init(init_list_key)
      init_list_key
    end
  end
  
  def self.generate_calls_for_new_inits
    unloaded_init_keys.collect do |unloaded_init_key|
      generate_calls_for_one_init(unloaded_init_key)
      unloaded_init_key
    end
  end
  
  def self.generate_calls_for_one_init(call_init_key)    
    if init_list[call_init_key] and init_list[call_init_key]["call_run_by_operator"]
      
      operator_id = init_list[call_init_key]["call_run_by_operator"].keys[0]
      call_run_id = init_list[call_init_key]["call_run_by_operator"][operator_id]
      
      calls_generation_params = init_list[call_init_key]["init_class"].deep_merge({:general => {"operator_id" => operator_id}})
      user_params = {"call_run_id" => call_run_id}
      Customer::Call.where(user_params).delete_all
      Calls::Generator.new(calls_generation_params, user_params).generate_calls
      
      init_list[call_init_key]["call_run_by_operator"].except(operator_id).each do |operator_id_2, call_run_id_2|
        Customer::Call.where({"call_run_id" => call_run_id_2}).delete_all
        Calls::Generator.generate_calls_from_one_to_other_operator(operator_id, call_run_id, operator_id_2, call_run_id_2)
      end
    end
  end
  
  def self.clean_all_inits
    Customer::Call.where("user_id is null").delete_all
  end
  
  def self.init_run_ids
    init_list.values.map{|v| v["call_run_by_operator"].values}.flatten
  end
  
  def self.loaded_init_run_ids
    Customer::Call.where("user_id is null").pluck(:call_run_id).uniq
  end
  
  def self.unloaded_init_keys
    init_run_ids_1 = init_run_ids
    unloaded_call_run_ids = init_run_ids_1 - loaded_init_run_ids
    init_list.keys.map{|k| k if (init_list[k]["call_run_by_operator"].values - unloaded_call_run_ids).blank?}
  end
  
  def self.init_list
    {
      :student => {:name => 'Студент', "init_class" => Comparison::Call::Init::Student, "call_run_by_operator" => {1023 => 0, 1025 => 1, 1028 => 2, 1030 => 3}, },
    }
  end

end

