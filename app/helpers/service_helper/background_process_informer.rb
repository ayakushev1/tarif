class ServiceHelper::BackgroundProcessInformer
  attr_reader :name, :process_info_model, :user_id
  def initialize(name, user_id)
    @name = name || 'default_background_process_name'
    @user_id = user_id
    @process_info_model = Customer::Stat.where(:result_type => 'background_processes', :user_id => user_id).
      where(:result_name => @name)#.where("(result_key->>'calculating')::boolean = true")
  end
  
  def clear_completed_process_info_model
    Customer::Stat.where(:result_type => 'background_processes', :user_id => user_id).
      where(:result_name => name).where("(result_key->>'calculating')::boolean = false").delete_all
  end      
  
  def current_values
    process_info_model.first['result'] if process_info_model.first
  end
  
  def calculating?
    if process_info_model.exists?
      raise(StandardError, process_info_model.first['result_key']['calculating']) if process_info_model.first['result_key']['calculating'].is_a?(String)
      process_info_model.first['result_key']['calculating']
    else
      false
    end 
  end
  
  def init(min_value = 0.0, max_value = 100.0)
    if process_info_model.exists?
      process_info_model.first.update_attributes!({:result_key => {:calculating => true}, :result => {
        :name => name, :max_value => max_value, :min_value => min_value, :current_value => min_value}})
    else
      process_info_model.create({:result_type => 'background_processes', :result_name => name, :user_id => user_id, :result_key => {:calculating => true}, :result => {
        :name => name, :max_value => max_value, :min_value => min_value, :current_value => min_value}})
    end       
  end
  
  def increase_current_value(increment_value)
    back_processing_stat = process_info_model.first['result']
    bat_processing_current_value = increment_value + back_processing_stat['current_value']
    back_processing_update = {:name => name, :max_value => back_processing_stat['max_value'], :min_value => 0.0, :current_value => bat_processing_current_value}
    
    process_info_model.first.update_attributes!({:result_key => {:calculating => true}, :result => back_processing_update})  
  end
  
  def finish
    back_processing_stat = process_info_model.first['result']
    process_info_model.first.update_attributes!({:result_key => {:calculating => false}, :result => {
      :name => name, 
      :max_value => back_processing_stat['max_value'],
      :min_value => back_processing_stat['min_value'],
      :current_value => back_processing_stat['current_value'],
      }})
  end
end
