require 'will_paginate/array'

#TODO сделать возможность виртуальной модели для запросов с группировками без id поля

module SavableInSession::Tableable

  def create_tableable(model, options = {})
    tableable = Tableable.new(model, options)
    set_pagination_current_id(tableable)

    tableable.pagination_page = session[:pagination][tableable.pagination_name]
    tableable.row_action = request.path_info
    
    set_tables_current_id(tableable)
    tableable.row_current_id = session[:current_id][tableable.current_id_name]

    tableable
  end
  
  class Tableable
    include SavableInSession::AssistanceInView
    
    attr_accessor :base_name, :caption, :heads, :pagination_per_page, :id_name, :pagination_page, :row_current_id, :row_action
    attr_writer :current_row_class, :current_id_name
    attr_reader :pagination_param_name, :pagination_name, :table_name, :model_size, :options
    
    def initialize(model, options = {})
      @options = options
      @model = model
      @model_size =model.count
      @base_name = options[:base_name] || model.table_name.singularize
      @table_name = "#{@base_name}_table"
      @id_name = :id
      @pagination_per_page =options[:pagination_per_page] || 10
    end
    
    def pagination_page
      @pagination_page || 1
    end
    
    def model
      @row_model=@model.paginate(page: pagination_page, :per_page => pagination_per_page)#.order(id_name)
      @row_model
    end
    
    def pagination_name
      "#{@base_name}_page"
    end
    
    def pagination_param_name
      "pagination[#{pagination_name}]"
    end
    
    def pagination_per_page
      @pagination_per_page || 10
    end
  
    def current_id_name
      @current_id_name || "#{@base_name}_id"
    end
    
    def current_row_class
       @current_row_class ||= "current_table_row" 
    end
    
    def row_details(row)
      row_name="#{base_name}_row"
      ["current_id_name=#{current_id_name}",
       "action_name=#{row_action}",
       "row_name=#{row_name}",
       "id=#{row_name}_#{row[id_name].to_s}",
       "value=#{row[id_name]}",
       ( (row_current_id.to_s == row[id_name].to_s) ? "class=#{current_row_class}" : "" ),
       ].join(" ")
    end
  
  end
end
