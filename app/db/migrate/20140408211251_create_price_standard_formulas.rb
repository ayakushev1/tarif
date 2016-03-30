class CreatePriceStandardFormulas < ActiveRecord::Migration
  def change
    create_table :price_standard_formulas do |t|
      t.string :name
      t.json :formula
      t.references :price_unit
      t.references :volume
      t.references :volume_unit      
      t.text :description
    end
  end
end
