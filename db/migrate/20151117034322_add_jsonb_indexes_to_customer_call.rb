class AddJsonbIndexesToCustomerCall < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_customer_calls_on_own_phone_number ON customer_calls ( (own_phone->>'number') );
      CREATE INDEX index_customer_calls_on_own_phone_operator_id ON customer_calls ( (own_phone->>'operator_id') );
      CREATE INDEX index_customer_calls_on_own_phone_region_id ON customer_calls ( (own_phone->>'region_id') );
      CREATE INDEX index_customer_calls_on_partner_phone_number ON customer_calls ( (partner_phone->>'number') );
      CREATE INDEX index_customer_calls_on_partner_phone_operator_id ON customer_calls ( (partner_phone->>'operator_id') );
      CREATE INDEX index_customer_calls_on_partner_phone_country_id ON customer_calls ( (partner_phone->>'country_id') );
      CREATE INDEX index_customer_calls_on_partner_phone_region_id ON customer_calls ( (partner_phone->>'region_id') );
      CREATE INDEX index_customer_calls_on_partner_phone_operator_type_id ON customer_calls ( (partner_phone->>'operator_type_id') );
      CREATE INDEX index_customer_calls_on_connect_country_id ON customer_calls ( (connect->>'country_id') );
      CREATE INDEX index_customer_calls_on_connect_operator_id ON customer_calls ( (connect->>'operator_id') );
      CREATE INDEX index_customer_calls_on_connect_region_id ON customer_calls ( (connect->>'region_id') );
      CREATE INDEX index_customer_calls_on_description_time ON customer_calls ( (description->>'time') );
      CREATE INDEX index_customer_calls_on_description_duration ON customer_calls ( (description->>'duration') );
      CREATE INDEX index_customer_calls_on_description_volume ON customer_calls ( (description->>'volume') );
      CREATE INDEX index_customer_calls_on_description_volume_unit_id ON customer_calls ( (description->>'volume_unit_id') );
      CREATE INDEX index_customer_calls_on_description_year ON customer_calls ( (description->>'year') );
      CREATE INDEX index_customer_calls_on_description_month ON customer_calls ( (description->>'month') );
      CREATE INDEX index_customer_calls_on_description_day ON customer_calls ( (description->>'day') );
      CREATE INDEX index_customer_calls_on_description_cost ON customer_calls ( (description->>'cost') );
      CREATE INDEX index_customer_calls_on_description_date ON customer_calls ( (description->>'date') );
      CREATE INDEX index_customer_calls_on_description_date_number ON customer_calls ( (description->>'date_number') );
      CREATE INDEX index_customer_calls_on_description_accounting_period ON customer_calls ( (description->>'accounting_period') );
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS index_customer_calls_on_own_phone_number;
      DROP INDEX IF EXISTS index_customer_calls_on_own_phone_operator_id;
      DROP INDEX IF EXISTS index_customer_calls_on_own_phone_region_id;
      DROP INDEX IF EXISTS index_customer_calls_on_partner_phone_number;
      DROP INDEX IF EXISTS index_customer_calls_on_partner_phone_operator_id;
      DROP INDEX IF EXISTS index_customer_calls_on_partner_phone_country_id;
      DROP INDEX IF EXISTS index_customer_calls_on_partner_phone_region_id;
      DROP INDEX IF EXISTS index_customer_calls_on_partner_phone_operator_type_id;
      DROP INDEX IF EXISTS index_customer_calls_on_connect_country_id;
      DROP INDEX IF EXISTS index_customer_calls_on_connect_operator_id;
      DROP INDEX IF EXISTS index_customer_calls_on_connect_region_id;
      DROP INDEX IF EXISTS index_customer_calls_on_description_time;
      DROP INDEX IF EXISTS index_customer_calls_on_description_duration;
      DROP INDEX IF EXISTS index_customer_calls_on_description_volume;
      DROP INDEX IF EXISTS index_customer_calls_on_description_volume_unit_id;
      DROP INDEX IF EXISTS index_customer_calls_on_description_year;
      DROP INDEX IF EXISTS index_customer_calls_on_description_month;
      DROP INDEX IF EXISTS index_customer_calls_on_description_day;
      DROP INDEX IF EXISTS index_customer_calls_on_description_cost;
      DROP INDEX IF EXISTS index_customer_calls_on_description_date;
      DROP INDEX IF EXISTS index_customer_calls_on_description_date_number;
      DROP INDEX IF EXISTS index_customer_calls_on_description_accounting_period;
    SQL
  end
end
