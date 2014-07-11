class AddConditionToServiceCategoryTarifClass < ActiveRecord::Migration
  def change
    change_table :service_category_tarif_classes do |t|
      t.json :conditions
      t.references :tarif_option, index: true
      t.integer :tarif_option_order, index: true
    end

    change_table :service_category_groups do |t|
      t.json :conditions
    end
  end
end
