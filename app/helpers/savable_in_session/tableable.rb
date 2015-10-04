require 'will_paginate/array'

#TODO сделать возможность виртуальной модели для запросов с группировками без id поля

module SavableInSession::Tableable

  def create_tableable(model)
    tableable = Tableable.new(model)
    set_pagination_current_id(tableable)

    tableable.pagination_page = session[:pagination][tableable.pagination_name]
    tableable.row_action = request.path_info
    
    set_tables_current_id(tableable)
    tableable.row_current_id = session[:current_id][tableable.current_id_name]

    tableable
  end
  
  def pagination_action
    request.path_info
  end
  

  class Tableable
    include SavableInSession::AssistanceInView
    
    attr_accessor :base_name, :caption, :heads, :pagination_per_page, :id_name, :pagination_page, :row_current_id, :row_action
    attr_writer :current_row_class, :current_id_name
    attr_reader :pagination_param_name, :pagination_name, :table_name, :model_size
    
    def initialize(model)
      @model = model
      @model_size =model.count
      @base_name = model.table_name.singularize
      @table_name = "#{@base_name}_table"
      @id_name = :id
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

  private
  
  def set_pagination_current_id(tableable)
    pagination_name = tableable.pagination_name
    pagination_per_page = tableable.pagination_per_page
    current_id_name = tableable.current_id_name

#    raise(StandardError)
    if (params[:pagination] and params[:pagination][pagination_name]) 
      if session[:pagination][pagination_name] != params[:pagination][pagination_name]
        session[:current_id][current_id_name] = nil 
        params[:current_id][current_id_name] = nil if params[:current_id]
      end
      session[:pagination][pagination_name] = params[:pagination][pagination_name]
    end
    
    session[:pagination][pagination_name] = 1 unless session[:pagination][pagination_name]
      
    if session[:pagination][pagination_name].to_i > (1.0 * tableable.model_size / pagination_per_page).ceil
      session[:pagination][pagination_name] = 1
    end
  end

  def set_tables_current_id(tableable)
    pagination_name = tableable.pagination_name
    current_id_name = tableable.current_id_name
    id_name = tableable.id_name
    row_model = tableable.model
    
    params[:current_id][current_id_name] = nil if (params[:current_id] and params[:current_id][current_id_name].blank?)
    session[:current_id][current_id_name] = params[:current_id][current_id_name] if (params[:current_id] and params[:current_id][current_id_name])
    session[:current_id][current_id_name] = row_model.first[id_name] if session[:current_id][current_id_name].blank? and row_model.first
    check_if_current_id_exist_in_row_model = false
    row_model.each do |row|
      check_if_current_id_exist_in_row_model = true if row[id_name].to_s == session[:current_id][current_id_name].to_s
      break if check_if_current_id_exist_in_row_model
    end
    session[:current_id][current_id_name] = row_model.first[id_name] if row_model and row_model.first and !check_if_current_id_exist_in_row_model
  end
  
end
