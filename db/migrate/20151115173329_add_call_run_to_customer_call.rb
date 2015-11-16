class AddCallRunToCustomerCall < ActiveRecord::Migration
  def change
    change_table :customer_calls do |t|
      t.references :call_run, index: true
    end
    
    add_index  :customer_calls, :own_phone, using: :gin
    add_index  :customer_calls, :partner_phone, using: :gin
    add_index  :customer_calls, :connect, using: :gin
    add_index  :customer_calls, :description, using: :gin
  end
end
