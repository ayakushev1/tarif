class AddStatToCustomerCallRun < ActiveRecord::Migration
  def change
    change_table :customer_call_runs do |t|
      t.jsonb :stat
    end
    add_index :customer_call_runs, :stat, using: :gin
  end
end
