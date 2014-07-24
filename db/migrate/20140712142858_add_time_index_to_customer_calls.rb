class AddTimeIndexToCustomerCalls < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_customer_calls_on_description_year ON customer_calls ( (description->>'year') );
      CREATE INDEX index_customer_calls_on_description_month ON customer_calls ( (description->>'month') );
      CREATE INDEX index_customer_calls_on_description_day ON customer_calls ( (description->>'day') );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP INDEX index_customer_calls_on_description_year;
      DROP INDEX index_customer_calls_on_description_month;
      DROP INDEX index_customer_calls_on_description_day;
    SQL
  end
end
