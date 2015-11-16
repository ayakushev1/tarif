class AddCustomerCallRun < ActiveRecord::Migration
  def change
    create_table :customer_call_runs do |t|
      t.references :user, index: true
      t.string :name
      t.integer :source, index: true
      t.text :description
    end
  end
end
