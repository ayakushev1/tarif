class AddSlugToResultRun < ActiveRecord::Migration
  def change
    change_table :result_runs do |t|
      t.string :slug
    end
    add_index :result_runs, :slug, unique: true
  end
end
