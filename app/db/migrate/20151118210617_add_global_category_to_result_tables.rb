class AddGlobalCategoryToResultTables < ActiveRecord::Migration
  def change
    change_table :result_runs do |t|
      t.jsonb :categ_ids, index: true
    end

    change_table :result_service_sets do |t|
      t.jsonb :categ_ids, index: true
    end

    change_table :result_services do |t|
      t.jsonb :categ_ids, index: true
    end

    change_table :result_agregates do |t|
      t.jsonb :categ_ids, index: true
    end

    change_table :result_service_categories do |t|
      t.jsonb :categ_ids, index: true
    end
  end
end
