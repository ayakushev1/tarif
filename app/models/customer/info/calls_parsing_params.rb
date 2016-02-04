# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info::CallsParsingParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 6)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values(user_type = :guest)
    call_history_max_line_to_process = {:guest => 500, :trial => 1000, :user => 5000, :admin => 10000}[user_type]
    {
      'calculate_on_background' => 'true',
      'save_processes_result_to_stat' => 'false',
      'file_upload_remote_mode' => 'false',
      'file_upload_turbolink_mode' => 'false',
      'file_upload_form_method' => 'post',
      'file_upload_max_size' => 3,
      'call_history_max_line_to_process' => call_history_max_line_to_process,
      'background_update_frequency' => 100,
    }
  end


end
