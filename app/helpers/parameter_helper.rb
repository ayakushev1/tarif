module ParameterHelper
  def parameter_class_instance_value(parameter)
    ParameterHelper::ParameterPresenter.new(parameter).value
  end
  
  def parameter_class_instance_display(parameter, view_context)
    ParameterHelper::ParameterPresenter.new(parameter).display(view_context)
  end
  
  class ParameterHelper::ParameterPresenter < Object
    attr_reader :param
    def initialize(parameter)
      @param = parameter
    end
    
    def param_class; param['source']['class'].constantize; end;
    
    def field; param.source['field']; end;

    def sub_field; param.source['sub_field']; end;

    def table; param.source['table']; end;

    def query; param.source['query']; end;

    def field_type_id; param.source['field_type_id']; end;
    
    def value_from_class; param_class.select(field).first[field]; end;

    def value_from_table; param_class.find_by_sql("select #{field} from #{table}").first[field];  end;
    
    def value_from_query; param_class.find_by_sql(query).first[field]; end;
    
    def value_for_pg_json(value_before_pg_json)
      (field_type_id == 11 and value_before_pg_json) ? value_before_pg_json[sub_field] : value_before_pg_json
    end
    
    def value(choice = nil)
      choice = choice || method_to_calculate_value
      value_for_pg_json(send(:"value_from_#{choice}") )
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
    
    def method_to_calculate_value
      return 'query' unless query.blank?
      return 'table' unless table.blank?
      'class' 
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
    
    def display_value(view_context)
      view_context.text_field display_param_for_pg_json, display_field_for_pg_json
    end
    
    def display_list(view_context)
      options_to_display = view_context.options_for_select(display_option_list)
      view_context.select display_param_for_pg_json, display_field_for_pg_json, options_to_display
    end
    
    def display_table(view_context)
      options_to_display = display_option_class.find_by_sql( "select * from #{display_option_table}" )
      view_context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display_string(view_context)
      options_to_display = eval(display_option_string)
      view_context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display_query(view_context)
      options_to_display = display_option_class.find_by_sql(display_option_query)
      view_context.collection_select display_param_for_pg_json, display_field_for_pg_json, options_to_display, display_id_field, display_name_field
    end
    
    def display(view_context, display_type_id = nil)
      display_type_id = display_type_id || display_display_type_id
      send(:"display_#{ choice_to_word(display_type_id) }", view_context)
    end
  end
  
end
