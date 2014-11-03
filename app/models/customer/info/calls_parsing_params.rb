class Customer::Info::CallsParsingParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 6)
  end

  def self.info(user_id)
    where(:user_id => user_id).first.info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first.update(:info => values)
  end
  
  def self.default_values
    {
      'calculate_on_background' => 'true',
      'save_processes_result_to_stat' => 'true',
      'file_upload_remote_mode' => 'false',
      'file_upload_turbolink_mode' => 'false',
      'file_upload_form_method' => 'post',
      'file_upload_max_size' => 1,
      'call_history_max_line_to_process' => 5000,
      'allowed_call_history_file_types' => ['html', 'xls'],
      'background_update_frequency' => 100,
    }
  end


end