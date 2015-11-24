class AddComparisonResult < ActiveRecord::Migration
  def change
    create_table :comparison_results do |t|
      t.string :name
      t.text :description
      t.references :publication_status, index: true
      t.integer :publication_order, index: true
      t.string :optimization_list_key, index: true
      t.jsonb :optimization_list_item
      t.jsonb :optimization_result
    end
    add_index :comparison_results, :optimization_list_item, using: :gin
    add_index :comparison_results, :optimization_result, using: :gin
  end
end
