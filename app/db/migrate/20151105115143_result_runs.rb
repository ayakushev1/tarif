class ResultRuns < ActiveRecord::Migration
  def change
    create_table :result_runs do |t|
      t.string :name
      t.text :description
      t.references :user, index: true
      t.references :call_run, index: true
      t.string :accounting_period, index: true
      t.integer :optimization_type_id, index: true
      t.integer :run, index: true
      t.jsonb :optimization_params, index: true
      t.jsonb :calculation_choices, index: true
      t.jsonb :selected_service_categories, index: true
      t.jsonb :services_by_operator, index: true
      t.jsonb :temp_value, index: true
      t.jsonb :service_choices, index: true
      t.jsonb :services_select, index: true
      t.jsonb :services_for_calculation_select, index: true
      t.jsonb :service_categories_select, index: true
    end
  end
end
