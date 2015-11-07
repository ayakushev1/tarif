class ResultServices < ActiveRecord::Migration
  def change
    create_table :result_services do |t|
      t.references :run, index: true
      t.references :tarif, index: true
      t.string :service_set_id, index:true
      t.references :service, index: true
      t.float :price, index: true
      t.integer :call_id_count, index: true
      t.float :sum_duration_minute
      t.float :sum_volume
      t.integer :count_volume
    end
  end
end
