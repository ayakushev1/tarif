module BatchInsert
  extend ActiveSupport::Concern
  
  def batch_save(insert_rows, filtr_to_delete)
    if !insert_rows.blank?
      where(filtr_to_delete).delete_all
      fields = insert_rows[0].keys
      values = insert_rows.map do |insert_row|
        updated_values = fields.collect do |field|
#          raise(StandardError)
          value = insert_row[field] || insert_row[field.to_sym]
          case 
          when value.is_a?(Hash)
            "'#{value.stringify_keys}'".gsub(/nil/, 'null').gsub(/=>/, ':') 
          when value.is_a?(Array)
            "'{#{(value - ['']).compact.join(', ')}}'"
          when !value
            'null'
          when value.is_a?(String)
            "'#{value}'"
          else 
            value
          end
#          value.is_a?(Hash) ? "'#{value.stringify_keys}'".gsub(/nil/, 'null').gsub(/=>/, ':') : value
        end
        "(#{updated_values.join(', ')})"
      end if insert_rows
      model_table_name = self.table_name
      sql = "INSERT INTO #{model_table_name} (#{fields.join(', ')}) VALUES #{values.join(', ')}"
      connection.execute(sql)      
    end
  end

end

