class Calls::CustomerCallSaver
  def self.save(calls, user_id)
    Customer::Call.where(:user_id => user_id).delete_all
    fields = calls[0].keys
    values = calls.map do |call|
      updated_values = call.values.collect do |value|
        value.is_a?(Hash) ? "'#{value.stringify_keys}'".gsub(/nil/, 'null').gsub(/=>/, ':') : value
      end
      "(#{updated_values.join(', ')})"
    end
    sql = "INSERT INTO customer_calls (#{fields.join(', ')}) VALUES #{values.join(', ')}"
    Customer::Call.connection.execute(sql)      
  end
end
