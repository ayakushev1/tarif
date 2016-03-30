class CreateTarifClasses < ActiveRecord::Migration
  def change
    create_table :tarif_classes do |t|
      t.string :name, index: true
      t.references :operator, index: true
      t.references :privacy, index: true
      t.references :standard_service, index: true
      t.json :features
      t.text :description

      t.timestamps      
    end
  end
end
