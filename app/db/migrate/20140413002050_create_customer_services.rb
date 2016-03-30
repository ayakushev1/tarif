class CreateCustomerServices < ActiveRecord::Migration
  def change
    create_table :customer_services do |t|
      t.references :user, index: true
      t.string :phone_number, index:true
      t.references :tarif_class, index: true
      t.references :tarif_list, index: true
      t.references :status, index: true
      t.datetime :valid_from, index:true
      t.datetime :valid_till, index:true
      t.json :description

      t.timestamps      
    end
    
    add_column :users, :description, :json
    add_column :users, :location_id, :integer, :index => true
  end
end
