class AddTimeStampToCustomerCallRun < ActiveRecord::Migration
  def change
      add_column(:customer_call_runs, :created_at, :datetime)
      add_column(:customer_call_runs, :updated_at, :datetime)
      add_index(:customer_call_runs, :created_at)
      add_index(:customer_call_runs, :updated_at)
  end
end
