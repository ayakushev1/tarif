class CreateCategoryLevels < ActiveRecord::Migration
  def change
    create_table :category_levels do |t|
      t.string :name, index: true
      t.integer :level, index: true
      t.references :type, index: true
    end
  end
end
