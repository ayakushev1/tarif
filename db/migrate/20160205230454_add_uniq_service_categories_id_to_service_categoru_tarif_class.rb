class AddUniqServiceCategoriesIdToServiceCategoruTarifClass < ActiveRecord::Migration
  def change
    change_table :service_category_tarif_classes do |t|
      t.string :uniq_service_category
    end
    add_index :service_category_tarif_classes, :uniq_service_category
  end
end
