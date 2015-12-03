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

class Customer::Info::CallsDetailsParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 5)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values
    {
     'own_phone_number' => '100000000', 
     'operator_id' => 1030, 
     'region_id' => 1238, 
     'country_id' => 1100,
#     'accounting_period_month' => 1,
#     'accounting_period_year' => 2015,
    }
  end


end
