class AddComparisonGroupCallRun < ActiveRecord::Migration
  def change
    create_table :comparison_group_call_runs do |t|
      t.references :comparison_group, index: true
      t.references :call_run, index: true
    end
  end
end
