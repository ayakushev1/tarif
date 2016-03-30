class AddGlobalToServiceCategory < ActiveRecord::Migration
  def change
    change_table :service_categories do |t|
      t.string :global
    end
    add_index :service_categories, :global
  end
end
