class AddKeyToCustomerStats < ActiveRecord::Migration
  def change
    change_table :customer_stats do |t|
      t.integer :operator_id, index: true
      t.integer :tarif_id, index: true
      t.string :accounting_period, index: true
      t.string :result_type, index: true
      t.string :result_name, index: true      
      t.json :result_key
    end
  end
end

