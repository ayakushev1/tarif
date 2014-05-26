class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.string :name
      t.references :tarif_class, index: true
      t.references :tarif_list, index: true
      t.references :service_category_group, index: true
      t.references :service_category_tarif_class, index: true
      t.boolean :is_active, index: true
      t.json :features
      t.text :description
      
      t.timestamps      
    end
  end
end
