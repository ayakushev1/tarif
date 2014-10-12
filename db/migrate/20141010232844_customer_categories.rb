class CustomerCategories < ActiveRecord::Migration
  def change
    create_table :customer_categories do |t|
      t.string :name, index: true
      t.references :level, index: true
      t.references :type, index: true
      t.references :parent, index: true
    end
  end
end
