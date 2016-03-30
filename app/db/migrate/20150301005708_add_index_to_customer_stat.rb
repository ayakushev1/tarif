class AddIndexToCustomerStat < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_customer_stats_on_result_key_result_key_id ON customer_stats ( (result_key->'result_key'->>'id') );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP INDEX index_customer_stats_on_result_key_result_key_id;
    SQL
  end
end
