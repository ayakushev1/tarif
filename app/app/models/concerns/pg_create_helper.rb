module PgCreateHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def pg_json_create(array_of_hashes = nil)
      self.connection.execute(pg_json_create_sql(array_of_hashes))
    end
    
    def pg_json_create_sql(array_of_hashes = nil)
      array_of_hashes = [array_of_hashes] if !array_of_hashes.is_a?(Array)
      return false if array_of_hashes.blank?
      
      attributes = array_of_hashes[0]
      
      with = []; select = []; key_ids = []
      attributes.each do |key, value|
        with << "#{key} as ( #{field_sql(array_of_hashes, key)} )"
        key_ids << "#{key}.key_#{key}"
      end

      with = "WITH " + with.join(', ')
      insert = " INSERT INTO #{self.table_name} (#{attributes.keys.join(', ')})"
      select = " SELECT #{attributes.keys.join(', ')} FROM #{attributes.keys.join(', ')}"
      where = " where  #{make_equality(key_ids).join(' and ')} "
      returning = " returning * "

      with + insert +select + where + returning
    end

    def field_sql(array_of_hashes, key)
      attributes = array_of_hashes[0]
      
      if attributes[key].is_a?(Hash)
        second_keys = attributes[key].keys        
        second_attrs = extract_hash_values_from_array(array_of_hashes, key)

        sql = ["select #{field_list(["key_" + key.to_s] + second_keys)}",
               "from (values  #{field_values(second_attrs, second_keys)}  )",
               "as #{key} (#{field_list(["key_" + key.to_s] + second_keys)})" ].join(' ')
        
        "select key_#{key}, row_to_json(#{key}_#{key}) as #{key} from ( #{sql} ) #{key}_#{key} (#{field_list(["key_" + key.to_s] + second_keys)} )"
      else
        "select * from (values  #{field_values(array_of_hashes, key)}  ) as #{key} (#{field_list(["key_" + key.to_s, key])})"
      end
    end
    
    def field_list(attributes)
      attributes.collect {|attribute|  attribute.to_s }.join(', ')
    end
    
    def field_values(array_of_hashes, keys)
      keys = [keys] if keys.is_a?(Symbol) or keys.is_a?(String)
      
      result = []
      array_of_hashes.each_with_index do |a, i|
        result << "( #{ keys.each_with_object( ["(#{i})"] ) {|key, value| value << "(#{a[key] || (-1)})"  }.join(', ') } )" 
      end
      result.join(', ')
    end
    
    def extract_hash_values_from_array(array_of_hashes, key)
      hash_keys = array_of_hashes[0][key].keys
      
      array_of_hashes.collect do |arr|
        hash_keys.each_with_object({}) { |second_key, new_attr| new_attr[second_key] = arr[key][second_key] }
      end
    end
    
    def make_equality(key_ids)
      result = []
      key_ids.each_with_index { |key_id, i| result << " ( #{key_id}=#{key_ids[0]} ) " }
      result
    end
    
  end
  
end
