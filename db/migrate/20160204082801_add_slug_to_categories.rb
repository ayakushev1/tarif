class AddSlugToCategories < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.string :slug
    end
    add_index :categories, :slug, unique: true
  end
end
