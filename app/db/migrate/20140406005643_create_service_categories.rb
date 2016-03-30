class CreateServiceCategories < ActiveRecord::Migration
  def change
    create_table :service_categories do |t|
      t.string :name
      t.references :type, index: true
      t.references :parent, index: true
      t.integer :level, index: true
      t.integer :path, array: true, default:[]
    end
    
    add_index :service_categories, :path, using: 'gin'    
  end
end
