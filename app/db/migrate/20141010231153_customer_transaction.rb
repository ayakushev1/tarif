class CustomerTransaction < ActiveRecord::Migration
  def change
    create_table :customer_transactions do |t|
      t.references :user, index: true
      t.references :info_type, index: true
      t.json :status
      t.json :description
      t.datetime :made_at, index: true
    end
  end
end
