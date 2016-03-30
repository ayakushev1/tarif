class AddParametersToServiceCriteria < ActiveRecord::Migration
  def change
    add_column :service_criteria, :eval_string, :text
  end
end
