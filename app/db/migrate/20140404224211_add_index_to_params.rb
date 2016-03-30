class AddIndexToParams < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_parameters_on_source_table ON parameters ( (source->>'table') );
      CREATE INDEX index_parameters_on_source_field ON parameters ( (source->>'field') );
      CREATE INDEX index_parameters_on_source_field_type_id ON parameters ( (source->>'field_type_id') );
      CREATE INDEX index_parameters_on_unit_field_name ON parameters ( (unit->>'field_name') );
      CREATE INDEX index_parameters_on_unit_unit_id ON parameters ( (unit->>'unit_id') );
    SQL
  end
  
  def down
    execute <<-SQL
      DROP INDEX index_parameters_on_source_table;
      DROP INDEX index_parameters_on_source_field;
      DROP INDEX index_parameters_on_source_field_type_id;
      DROP INDEX index_parameters_on_unit_field_name;
      DROP INDEX index_parameters_on_unit_unit_id;
    SQL
  end
end
