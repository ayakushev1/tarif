class AddComparisonOptimization < ActiveRecord::Migration
  def change
    create_table :comparison_optimizations do |t|
      t.string :name
      t.text :description
      t.references :publication_status, index: true
      t.integer :publication_order, index: true
      t.references :optimization_type, index: true
    end
  end
end
