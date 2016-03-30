class AddDependencyToTarifClass < ActiveRecord::Migration
  def change
    change_table :tarif_classes do |t|
      t.json :dependency
    end
  end
end
