class ChangeResultServiceSet < ActiveRecord::Migration
  def up
    remove_column :result_service_sets, :identical_services
    add_column :result_service_sets, :identical_services, 'jsonb' 
  end

  def down
    remove_column :result_service_sets, :identical_services
    add_column :result_service_sets, :identical_services, 'integer[]' 
  end
end
