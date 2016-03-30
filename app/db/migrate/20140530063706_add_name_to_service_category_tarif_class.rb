class AddNameToServiceCategoryTarifClass < ActiveRecord::Migration
  def change
    change_table :service_category_tarif_classes do |t|
      t.text :name, index: true
    end

    add_index :service_category_groups, :name
    add_index :price_standard_formulas, :name
    add_index :price_formulas, :name
    add_index :price_lists, :name
#    add_index :tarif_classes, :name
    add_index :tarif_lists, :name
  end
end
