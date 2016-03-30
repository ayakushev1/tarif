module PgArrayHelper
  extend ActiveSupport::Concern
  
  module ClassMethods
    def pg_array_belongs_to(name, options = {})
      raise Class.new(StandardError), "pg_array_belongs_to is missing name" unless name
      option_keys = [:class_name, :foreign_key]
      unless option_keys.inject { |result, key| result and options.keys.include?(key) }
        raise Class.new(StandardError), "pg_array_belongs_to is missing one of options keys: #{option_keys.join(", ")}"
      end
      
      self.send(:define_method, name) do
        id = options[:primary_key] || :id
        id_values = self[options[:foreign_key]]
        options[:class_name].constantize.where(id => id_values).all
#        @@pg_associations ||= {}
#        @@pg_associations[name] = {:class_name => options[:class_name], :foreign_key => options[:foreign_key]}
      end

#      def pg_includes(*associations)
#        associations.each do |assoc|
#          options = @@pg_associations[assoc]
#          id = options[:primary_key] || :id
#          id_values = self[options[:foreign_key]]
#          options[:class_name].constantize.where(id => id_values).all
#        end
#      end
    end
    
  end
      
end
