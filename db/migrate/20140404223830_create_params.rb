class CreateParams < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name
      t.string :description
      t.string :nick_name
      t.references :source_type, index: true
      t.json :source
      t.json :display
      t.json :unit
    end
  end
end
