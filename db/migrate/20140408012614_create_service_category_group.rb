class CreateServiceCategoryGroup < ActiveRecord::Migration
  def change
    create_table :service_category_groups do |t|
      t.string :name
      t.references :operator, index: true
      t.references :tarif_class, index: true
      t.json :criteria
      
      t.timestamps      
    end
  end
end
