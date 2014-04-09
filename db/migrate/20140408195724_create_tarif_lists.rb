class CreateTarifLists < ActiveRecord::Migration
  def change
    create_table :tarif_lists do |t|
      t.string :name
      t.references :tarif_class, index: true
      t.references :region, index: true
      t.json :features
      t.text :description
      
      t.timestamps      
    end
  end
end
