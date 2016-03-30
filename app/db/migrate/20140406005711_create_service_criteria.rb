class CreateServiceCriteria < ActiveRecord::Migration
  def change
    create_table :service_criteria do |t|
      t.references :service_category, index: true
      t.references :criteria_param, index: true
      t.references :comparison_operator, index: true
      t.references :value_param, index: true
      t.references :value_choose_option, index: true
      t.json :value
    end
  end
end
