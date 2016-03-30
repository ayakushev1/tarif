class ResultAgregates < ActiveRecord::Migration
  def change
    create_table :result_agregates do |t|
      t.references :run, index: true
      t.references :tarif, index: true
      t.string :service_set_id, index:true
      t.string :service_category_name, index:true
      t.integer :rouming_ids, array: true, index: true
      t.integer :geo_ids, array: true, index: true
      t.integer :partner_ids, array: true, index: true
      t.integer :calls_ids, array: true, index: true
      t.integer :one_time_ids, array: true, index: true
      t.integer :periodic_ids, array: true, index: true
      t.integer :fix_ids, array: true, index: true

      t.string :rouming_names, array: true
      t.string :geo_names, array: true
      t.string :partner_names, array: true
      t.string :calls_names, array: true
      t.string :one_time_names, array: true
      t.string :periodic_names, array: true
      t.string :fix_names, array: true

      t.string :rouming_details, array: true
      t.string :geo_details, array: true
      t.string :partner_details, array: true
      t.float :price, index: true
      t.integer :call_id_count, index: true
      t.float :sum_duration_minute
      t.float :sum_volume
      t.integer :count_volume
    end
  end
end
