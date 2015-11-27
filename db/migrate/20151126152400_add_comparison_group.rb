class AddComparisonGroup < ActiveRecord::Migration
  def change
    create_table :comparison_groups do |t|
      t.string :name
      t.references :optimization, index: true
      t.jsonb :result
    end
    add_index :comparison_groups, :result, using: :gin
  end
end
