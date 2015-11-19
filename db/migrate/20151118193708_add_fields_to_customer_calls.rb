class AddFieldsToCustomerCalls < ActiveRecord::Migration
  def change
    change_table :customer_calls do |t|
      t.string :calendar_period, index: true
      t.integer :global_category_id, index: true
    end
  end
end
