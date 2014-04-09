class CreatePriceFormulas < ActiveRecord::Migration
  def change
    create_table :price_formulas do |t|
      t.string :name
      t.references :price_list, index: true
      t.integer :calculation_order, index: true
      t.references :standard_formula, index: true
      t.json :formula
      t.decimal :price
      t.references :price_unit
      t.references :volume
      t.references :volume_unit      
      t.text :description

      t.timestamps      
    end
  end
end
