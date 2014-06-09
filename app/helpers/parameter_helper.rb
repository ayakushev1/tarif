module ParameterHelper
  def parameter_class_sql_name(parameter, context, *external_value)
    ParameterHelper::ParameterPresenter.new(parameter, context, *external_value).sql_name
  end
  
  def parameter_class_instance_value(parameter, context, *external_value)
    ParameterHelper::ParameterPresenter.new(parameter, context, *external_value).value
  end
  
  def parameter_class_instance_display(parameter, context, *external_value)
    ParameterHelper::ParameterPresenter.new(parameter, context, *external_value).display
  end
  
  class ParameterHelper::ParameterPresenter < Object
    attr_reader :param, :context, :external_value
    def initialize(parameter, context, *external_value)
      @param = parameter
      @context = context
      @external_value = external_value[0]
    end
    
#    def param_class; param['source']['class'].constantize; end;
    def param_class; param.source['class'].constantize; end;
    
    def field; param.source['field']; end;

    def field_type; category_field_type(param.source['field_type_id']); end;

    def sub_field_type; category_field_type(param.source['sub_field_type_id']); end;
         
    def category_field_type(category_field_type_id)
       case category_field_type_id
       when 3; 'boolean';
       when 4; 'integer';
       when 5; 'string';
       when 6; 'text';
       when 7; 'decimal';
#       when 8; 'list';
       when 9; 'integer';# instead of reference
       when 10; 'timestamp';# instead of datetime
       when 11; 'json';
#       when 12; 'array';
       else 'text';
       end
    end

    def sub_field; param.source['sub_field']; end;

    def input; param.source['input']; end;

    def string; param.source['string']; end;

    def table; param.source['table']; end;

    def query; param.source['query']; end;

    def field_type_id; param.source['field_type_id']; end;
    
    def value_from_input; (context and context.respond_to?(field.to_sym) ) ? context.send(field.to_sym) : context.send(:eval, field); end;

    def value_from_string; context.send(:eval, string); end;

    def value_from_class; param_class.select(field).first[field]; end;

    def value_from_table; param_class.find_by_sql("select #{field} from #{table}").first[field];  end;
    
    def value_from_query; param_class.find_by_sql(query).first[field]; end;
    
    def value_for_pg_json(value_before_pg_json)
      (field_type_id == 11 and value_before_pg_json) ? value_before_pg_json[sub_field] : value_before_pg_json
    end
    
    def value(choice = nil)
      if external_value
        field_type_name = ::Category.find(field_type_id).name
        external_value[field_type_name]
      else
        choice = choice || method_to_calculate_value
        value_for_pg_json(send(:"value_from_#{choice}") )
      end
    end
     
    def method_to_calculate_value
      return 'input' unless input.blank?
      return 'string' unless string.blank?
      return 'query' unless query.blank?
      return 'table' unless table.blank?
      'class' 
    end

    def sql_name
      sql_name_before_pg_json = "#{table}.#{field}"
      (field_type_id == 11 ) ? "(#{sql_name_before_pg_json}->>'#{sub_field}')::#{sub_field_type}" : sql_name_before_pg_json
    end
    
    def choice_to_word(display_type_id)
     case display_type_id.to_i
     when 135; 'value';
     when 136; 'list';
     when 137; 'table';
     when 138; 'string';
     when 139; 'query';
     else ; 'value'; end;
   end
    
   def display_display_type_id; param.display['display_type_id']; end;

    def display_option_list; param.display['list']; end;

    def display_option_table; param.display['table']; end;
    
    def display_option_string; param.display['string']; end;

    def display_option_query; param.display['query']; end;

    def display_option_class; param.display['class'].constantize; end;
    
    def display_name_field; param.display['name_field']; end;
    
    def display_id_field; param.display['id_field']; end;
    
    def display_param_for_pg_json
      (field_type_id == 11) ? "#{table}[#{field}]" : table
    end
    
    def display_field_for_pg_json
      (field_type_id == 11) ? sub_field : field
    end
    
    def display_value
      context.text_field display_param_for_pg_json, display_field_for_pg_json
    end
    
    def display_list
      options_to_display = context.options_for_select(display_option_list)
      context.select display_param_for_pg_json, display_field_for_pg_json, options_to_display
    end
    
    def display_table
      options_to_display = display_option_class.find_by_sql( "select * from #{display_option_table}" )
      context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display_string
      options_to_display = eval(display_option_string)
      context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display_query
      options_to_display = display_option_class.find_by_sql(display_option_query)
      context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display(display_type_id = nil)
      display_type_id = display_type_id || display_display_type_id
      send(:"display_#{ choice_to_word(display_type_id) }")
    end
  end
  
end
