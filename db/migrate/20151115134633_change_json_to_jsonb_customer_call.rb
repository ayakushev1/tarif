class ChangeJsonToJsonbCustomerCall < ActiveRecord::Migration
  def up
    change_column :customer_calls, :own_phone, 'jsonb USING CAST(own_phone AS jsonb)' 
    change_column :customer_calls, :partner_phone, 'jsonb USING CAST(partner_phone AS jsonb)'
    change_column :customer_calls, :connect, 'jsonb USING CAST(connect AS jsonb)'
    change_column :customer_calls, :description, 'jsonb USING CAST(description AS jsonb)'  
  end

  def down
    change_column :customer_calls, :own_phone, 'json USING CAST(own_phone AS json)' 
    change_column :customer_calls, :partner_phone, 'json USING CAST(partner_phone AS json)'
    change_column :customer_calls, :connect, 'json USING CAST(connect AS json)'
    change_column :customer_calls, :description, 'json USING CAST(description AS json)'  
  end
end
