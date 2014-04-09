module WhereHelper
  extend ActiveSupport::Concern
#  extend self
  
  module ClassMethods
    def query_hash_from_filtr_with_all_keys_excluded(filtr_data)
      keys_from_filtr(filtr_data).inject({}) {|hash, key| hash.merge({key => query_from_filtr(filtr_data, key) }) }
    end
    
    def query_from_filtr(filtr_data, field_to_exclude_from_query = nil)
      data = clean_filtr_data_from_excluded_field(filtr_data.deep_dup, field_to_exclude_from_query)
      result = self.where(true)
      data.each do |key, value|
        result = result.where_from_filtr(key, value)
      end if filtr_data.kind_of?(Hash)
      result.where(true)
    end

    def where_from_filtr(key, value)
      result = self.where(true)
      col={}
      columns.each{|c| col[c.name] = c.type}
      if col.keys.include?(key.to_s)
        case
        when col[key] == :json          
          value.each do |v|
            result = result.where("#{key.to_s}->>'#{v[0]}' = ? ", v[1]) unless v[1].blank?
          end if value  
        else
          result = result.where(key => value) unless value.blank?        
        end
      end
      result
    end
        
    protected

    def clean_filtr_data_from_excluded_field(filtr_data, field_to_exclude_from_query = nil)
      return filtr_data if filtr_data.blank?
      case
      when ( (field_to_exclude_from_query.kind_of?(String) ) and !(field_to_exclude_from_query =~ /(.*?)\[(.*?)\]/) ) 
        filtr_data[field_to_exclude_from_query] = nil
        filtr_data
      when field_to_exclude_from_query =~ /(.*?)\[(.*?)\]/ 
        field_to_exclude_from_query.gsub(/(.*?)\[(.*?)\]/ ) { |s| filtr_data[$1][$2] = nil if filtr_data[$1] }
        filtr_data
      when field_to_exclude_from_query == nil
        filtr_data
      else
        raise Class.new(StandardError), "unknown type of field_to_exclude_from_query, #{field_to_exclude_from_query}"
      end
    end

    def keys_from_filtr(filtr_data)
      result = []
      filtr_data.each do |key, value|
        if value.kind_of?(Hash)
          value.each {|k, v| result << "#{key}[#{k}]" }
        else
          result << key          
        end
      end
      result
    end
        
  end
      
end

