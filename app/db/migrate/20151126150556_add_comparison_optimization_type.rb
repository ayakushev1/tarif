class AddComparisonOptimizationType < ActiveRecord::Migration
  def change
    create_table :comparison_optimization_types do |t|
      t.string :name
      t.jsonb :for_service_categories
      t.jsonb :for_services_by_operator
    end
    add_index :comparison_optimization_types, :for_service_categories, using: :gin
    add_index :comparison_optimization_types, :for_services_by_operator, using: :gin
  end
end
