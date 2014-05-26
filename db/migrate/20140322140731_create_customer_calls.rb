class CreateCustomerCalls < ActiveRecord::Migration
  def change
    create_table :customer_calls do |t|
      t.references :base_service, index: true
      t.references :base_subservice, index: true
      t.references :user, index: true
      t.json :own_phone
      t.json :partner_phone
      t.json :connect
      t.json :description
    end
  end
end
