class CustomerInfo < ActiveRecord::Migration
  def change
    create_table :customer_infos do |t|
      t.references :user, index: true
      t.references :info_type, index: true
      t.json :info
      t.datetime :last_update, index: true
    end
  end
end
