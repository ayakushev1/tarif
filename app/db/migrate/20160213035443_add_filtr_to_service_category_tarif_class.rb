class AddFiltrToServiceCategoryTarifClass < ActiveRecord::Migration
  def change
    change_table :service_category_tarif_classes do |t|
      t.jsonb :filtr
    end
    add_index :service_category_tarif_classes, :filtr, using: :gin
  end
end
