class AddTimeIndexToCustomerCalls < ActiveRecord::Migration
  def up
    execute <<-SQL
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
      DROP INDEX index_customer_calls_on_description_year;
      DROP INDEX index_customer_calls_on_description_month;
      DROP INDEX index_customer_calls_on_description_day;
      DROP INDEX index_customer_calls_on_description_cost;
      DROP INDEX index_customer_calls_on_description_date;
      DROP INDEX index_customer_calls_on_description_date_number;
      DROP INDEX index_customer_calls_on_description_accounting_period;
    SQL
  end
end

