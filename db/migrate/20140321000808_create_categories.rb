class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, index: true
      t.references :type, index: true
    end
  end
end
