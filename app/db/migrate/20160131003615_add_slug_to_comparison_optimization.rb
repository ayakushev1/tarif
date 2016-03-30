class AddSlugToComparisonOptimization < ActiveRecord::Migration
  def change
    change_table :comparison_optimizations do |t|
      t.string :slug
    end
    add_index :comparison_optimizations, :slug, unique: true
  end
end
