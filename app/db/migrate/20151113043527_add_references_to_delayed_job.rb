class AddReferencesToDelayedJob < ActiveRecord::Migration
  def change
    change_table :delayed_jobs do |t|
      t.integer :reference_id, index: true
      t.string :reference_type, index: true
    end

    add_index :delayed_jobs, :attempts, :name => 'delayed_jobs_attempts'
    add_index :delayed_jobs, :queue, :name => 'delayed_jobs_queue'
  end
end
