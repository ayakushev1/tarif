class ServiceHelper::BackgroundProcessInformer
  attr_reader :name, :process_info_model
  def initialize(name)
    @name = name || 'default_background_process_name'
    @process_info_model = Customer::Stat.where("(result->'background_processing'->>'calculating')::boolean = true and result->'background_processing'->>'name' = '#{@name}'")
  end
  
  def clear_completed_process_info_model
    Customer::Stat.where("(result->'background_processing'->>'calculating')::boolean = false and result->'background_processing'->>'name' = '#{name}'").delete_all
  end      
  
  def current_values
    process_info_model.first['result']['background_processing'] if process_info_model.first and process_info_model.first['result']
  end
  
  def calculating?
    process_info_model.exists? ? true : false
  end
  
  def init(min_value = 0.0, max_value = 100.0)
    if process_info_model.exists?
      process_info_model.first.update_attributes!({:result => {:background_processing => {
        :name => name, :calculating => true, :max_value => max_value, :min_value => min_value, :current_value => min_value}}})
    else
      process_info_model.create({:result => {:background_processing => {
        :name => name, :calculating => true, :max_value => max_value, :min_value => min_value, :current_value => min_value}}})
    end       
  end
  
  def increase_current_value(increment_value)
    back_processing_stat = process_info_model.first['result']['background_processing']
    bat_processing_current_value = increment_value + back_processing_stat['current_value']
    back_processing_update = {:name => name, :calculating => true, 
      :max_value => back_processing_stat['max_value'], :min_value => 0.0, :current_value => bat_processing_current_value}
    
    process_info_model.first.update_attributes!({:result => {:background_processing => back_processing_update}})  
#    raise(StandardError, [increment_value, current_values, back_processing_update]) #if increment_value != 3
  end
  
  def finish
    back_processing_stat = process_info_model.first['result']['background_processing']
    process_info_model.first.update_attributes!({:result => {:background_processing => {
      :name => name, 
      :calculating => false,
      :max_value => back_processing_stat['max_value'],
      :min_value => back_processing_stat['min_value'],
      :current_value => back_processing_stat['current_value'],
      }}})
  end
end
