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

class Customer::Info::CalculationChoices < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 14)
  end
  
  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values
    {
      'calculate_only_chosen_services' => 'false',
      'calculate_with_limited_scope' => 'false',
      'calculate_with_fixed_services' => 'false'
    }
  end
  


end
