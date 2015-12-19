module Customer::BackgroundStat::Helper
  def clear_completed_process_info_model
    process_info_model.where("(result_key->>'calculating')::boolean = false").delete_all
  end      
  
  def current_values
    process_info_model.first['result'] if process_info_model.first
  end
  
  def calculating?
    if process_info_model.exists?
#      raise(StandardError, process_info_model.first['result_key']['calculating']) if process_info_model.first['result_key']['calculating'].is_a?(String)
      process_info_model.first['result_key']['calculating']
    else
      false
    end 
  end
  
  def init(min_value = 0.0, max_value = 100.0, text_value = nil)
    if process_info_model.exists?
      process_info_model.first.update_attributes({:result_key => {:calculating => true}, :result => {
        :name => name, 
        :max_value => max_value, 
        :min_value => min_value, 
        :current_value => min_value, 
        :text_value => text_value
        }})
    else
      process_info_model.create({:result_type => 'background_processes', :result_name => name, :user_id => user_id, :result_key => {:calculating => true}, :result => {
        :name => name, 
        :max_value => max_value, 
        :min_value => min_value, 
        :current_value => min_value, 
        :text_value => text_value
      }})
    end       
  end
  
  def increase_current_value(increment_value = 0, text_value = nil)
    back_processing_stat = process_info_model.first['result']

    process_info_model.first.update_attributes({:result_key => {:calculating => true}, :result => {
      :name => name, 
      :max_value => back_processing_stat['max_value'], 
      :min_value => 0.0, 
      :current_value => increment_value + back_processing_stat['current_value'], 
      :text_value => text_value,
      }})  
  end
  
  def finish
    back_processing_stat = process_info_model.first['result']
    process_info_model.first.update_attributes({:result_key => {:calculating => false}, :result => {
      :name => name, 
      :max_value => back_processing_stat['max_value'],
      :min_value => back_processing_stat['min_value'],
      :current_value => back_processing_stat['current_value'],
      :text_value => back_processing_stat['text_value'],
      }})
  end
end
