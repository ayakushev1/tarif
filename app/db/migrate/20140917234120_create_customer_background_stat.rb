class CreateCustomerBackgroundStat < ActiveRecord::Migration
  def change
    create_table :customer_background_stats do |t|
      t.references :user, index: true
      t.json :result
      t.string :result_type, index: true
      t.string :result_name, index: true      
      t.json :result_key

      t.timestamps      
    end
  end
end
