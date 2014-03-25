module PgJsonHelper
  extend ActiveSupport::Concern
  
  module ClassMethods
    def pg_json_belongs_to(name, options = {})
      raise Class.new(StandardError), "pg_json_belongs_to is missing name" unless name
      option_keys = [:class_name, :foreign_key, :field]
      unless option_keys.inject { |result, key| result and options.keys.include?(key) }
        raise Class.new(StandardError), "pg_json_belongs_to is missing one of options keys: #{option_keys.join(", ")}"
      end
      
      self.send(:define_method, name) do
        id = options[:primary_key] || :id
        id_value = self[options[:foreign_key]][options[:field].to_s]
        options[:class_name].constantize.where(id => id_value).first
      end
    end
    
  end
      
end
