class ChangeResultRun < ActiveRecord::Migration
  def change
    change_table :result_runs do |t|
      t.references :comparison_group, index: true
    end
  end
end
