class CreateCustomerStats < ActiveRecord::Migration
  def change
    create_table :customer_stats do |t|
      t.references :user, index: true
      t.string :phone_number, index:true
      t.text :filtr
      t.json :result
      t.datetime :stat_from, index:true
      t.datetime :stat_till, index:true

      t.timestamps      
    end
  end
end
