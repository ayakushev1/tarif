class Customer::Info::CallsGenerationParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 4)
  end

  def self.info(user_id)
    where(:user_id => user_id).first.info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first.update(:info => values)
  end
  
  def self.default_values
    {
    }
  end


end