class CreateAddSlugToTarifClasses < ActiveRecord::Migration
  def change
    change_table :tarif_classes do |t|
      t.string :slug
    end
    add_index :tarif_classes, :slug, unique: true
  end
end
