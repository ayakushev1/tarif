class AddPriceStandardParams < ActiveRecord::Migration
  def change
    change_table :price_standard_formulas do |t|
      t.jsonb :stat_params
    end
    add_index :price_standard_formulas, :stat_params, using: :gin
  end
end
