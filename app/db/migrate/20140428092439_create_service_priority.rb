class CreateServicePriority < ActiveRecord::Migration
  def change
    create_table :service_priorities do |t|
      t.references :type, index: true
      t.references :main_tarif_class, index: true
      t.references :dependent_tarif_class, index: true
      t.references :relation, index: true
      t.integer :value, index: true
      t.integer :arr_value, array:true, default:[]
    end
  end
end
