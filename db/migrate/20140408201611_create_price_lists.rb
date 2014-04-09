class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.string :name
      t.references :tarif_list_id, index: true
      t.references :service_category_group_id, index: true
      t.references :service_category_tarif_class_id, index: true
      t.boolean :is_active, index: true
      t.json :features
      t.text :description
      
      t.timestamps      
    end
  end
end
