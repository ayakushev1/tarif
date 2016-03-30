class ChangeCustomerCallRun < ActiveRecord::Migration
  def change
    change_table :customer_call_runs do |t|
      t.references :operator, index: true
      t.string :init_class, index: true
      t.jsonb :init_params
    end
    add_index :customer_call_runs, :init_params, using: :gin
  end
end
