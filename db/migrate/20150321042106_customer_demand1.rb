class CustomerDemand1 < ActiveRecord::Migration
  def change
    create_table :customer_demands do |t|
      t.references :customer, index: true
      t.references :type, index: true
      t.json :info
      t.references :status, index: true
      t.references :responsible, index: true

      t.timestamps      
    end
    
    drop_table :demo_demands do |t|
      t.references :customer, index: true
      t.references :type, index: true
      t.json :info
      t.references :status, index: true
      t.references :responsible, index: true

      t.timestamps      
    end
  end
end
