class AddIndexToCalls < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_calls_on_own_phone_number ON calls ( (own_phone->>'number') );
      CREATE INDEX index_calls_on_own_phone_operator_id ON calls ( (own_phone->>'operator_id') );
      CREATE INDEX index_calls_on_own_phone_region_id ON calls ( (own_phone->>'region_id') );
      CREATE INDEX index_calls_on_partner_phone_number ON calls ( (partner_phone->>'number') );
      CREATE INDEX index_calls_on_partner_phone_operator_id ON calls ( (partner_phone->>'operator_id') );
      CREATE INDEX index_calls_on_partner_phone_region_id ON calls ( (partner_phone->>'region_id') );
      CREATE INDEX index_calls_on_connect_number ON calls ( (connect->>'number') );
      CREATE INDEX index_calls_on_connect_operator_id ON calls ( (connect->>'operator_id') );
      CREATE INDEX index_calls_on_connect_region_id ON calls ( (connect->>'region_id') );
      CREATE INDEX index_calls_on_description_time ON calls ( (description->>'time') );
      CREATE INDEX index_calls_on_description_duration ON calls ( (description->>'duration') );
      CREATE INDEX index_calls_on_description_volume ON calls ( (description->>'volume') );
      CREATE INDEX index_calls_on_description_volume_unit_id ON calls ( (description->>'volume_unit_id') );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP INDEX index_calls_on_own_phone_number;
      DROP INDEX index_calls_on_own_phone_operator_id;
      DROP INDEX index_calls_on_own_phone_region_id;
      DROP INDEX index_calls_on_partner_phone_number;
      DROP INDEX index_calls_on_partner_phone_operator_id;
      DROP INDEX index_calls_on_partner_phone_region_id;
      DROP INDEX index_calls_on_connect_number;
      DROP INDEX index_calls_on_connect_operator_id;
      DROP INDEX index_calls_on_connect_region_id;
      DROP INDEX index_calls_on_description_time;
      DROP INDEX index_calls_on_description_duration;
      DROP INDEX index_calls_on_description_volume;
      DROP INDEX index_calls_on_description_volume_unit_id;
    SQL
  end
end
