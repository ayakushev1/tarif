class ResultRuns < ActiveRecord::Migration
  def change
    create_table :result_runs do |t|
      t.references :user, index: true
      t.integer :run, index: true
      t.string :name
      t.text :description
      t.jsonb :optimization_params
      t.jsonb :service_choices
      t.jsonb :services_select
      t.jsonb :service_categories_select
      t.jsonb :services_for_calculation_select
    end
  end
end
