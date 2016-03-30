class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.references :type, index: true
      t.string :name, index: true
      t.integer :owner_id, index: true
      t.integer :parent_id, index: true
      t.integer :children, array: true, default:[]
      t.integer :children_level, default: 1
    end
  end
end
