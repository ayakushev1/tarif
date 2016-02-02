class AddTimeStampToResultRun < ActiveRecord::Migration
  def change
      add_column(:result_runs, :created_at, :datetime)
      add_column(:result_runs, :updated_at, :datetime)
      add_index(:result_runs, :created_at)
      add_index(:result_runs, :updated_at)
  end
end
