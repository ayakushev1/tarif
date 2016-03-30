class AddResultCallStat < ActiveRecord::Migration
  def change
    create_table :result_call_stats do |t|
      t.references :run, index: true
      t.references :operator, index: true
      t.jsonb :stat
    end
    add_index :result_call_stats, :stat, using: :gin
  end
end
