class ResultServiceSets < ActiveRecord::Migration
  def change
    create_table :result_service_sets do |t|
      t.references :run, index: true
      t.string :service_set_id, index:true
      t.references :tarif, index: true
      t.references :operator, index: true
      t.integer :common_services, array: true
      t.integer :tarif_options, array: true
      t.integer :service_ids, array: true
      t.integer :identical_services, array: true
      t.float :price, index: true
      t.integer :call_id_count, index: true
      t.float :sum_duration_minute
      t.float :sum_volume
      t.integer :count_volume
    end
  end
end

