class ResultTarifs < ActiveRecord::Migration
  def change
    create_table :result_tarifs do |t|
      t.references :run, index: true
      t.references :tarif, index: true
    end
  end
end
