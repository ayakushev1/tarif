require 'will_paginate/array'
#TODO сделать возможность виртуальной модели для запросов с группировками без id поля
class ArrayOfHashable1 < Presenter
  attr_accessor :base_name, :caption, :heads, :pagination_per_page, :id_name
  attr_writer :current_row_class, :current_id_name
  attr_reader :pagination_param_name, :pagination_name, :table_name, :model_size
  
  def initialize(controller, array_of_hash)
    super(controller)
    @model = array_of_hash ? array_of_hash : [{}]
    @model_size = array_of_hash ? array_of_hash.size : -1
    @base_name = 'array_table'
    @table_name = "#{@base_name}_table"
    @id_name = model[0].keys.first if model[0]
    self.extend TableHelper
  end
  
  def model
    set_pagination_current_id
    page = c.session[:pagination][pagination_name]
    @row_model=@model.paginate(page: page, :per_page => pagination_per_page)#.order(id_name)
    set_tables_current_id
    @row_model
  end
  
  def pagination_name
    "#{@base_name}_page"
  end
  
  def pagination_action
    c.request.path_info
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
     @current_row_class || "current_table_row" 
  end
  
  def row_details(row)
    row_name="#{base_name}_row"
    ["current_id_name=#{current_id_name}",
     "action_name=#{c.request.path_info}",
     "row_name=#{row_name}",
     "id=#{row_name}_#{row[id_name].to_s}",
     "value=#{row[id_name]}",
     ( (c.session[:current_id][current_id_name].to_s == row[id_name].to_s) ? "class=#{current_row_class}" : "" ),
     ].join(" ")
  end

  private
  
  def set_pagination_current_id
    if (c.params[:pagination] and c.params[:pagination][pagination_name]) 
      if c.session[:pagination][pagination_name] != c.params[:pagination][pagination_name]
        c.session[:current_id][current_id_name] = nil 
        c.params[:current_id][current_id_name] = nil if c.params[:current_id]
      end
      c.session[:pagination][pagination_name] = c.params[:pagination][pagination_name]
    end
    
    c.session[:pagination][pagination_name] = 1 unless c.session[:pagination][pagination_name]
      
    if c.session[:pagination][pagination_name].to_i > (1.0 * @model.count / pagination_per_page).ceil
      c.session[:pagination][pagination_name] = 1
    end
  end

  def set_tables_current_id
    c.params[:current_id][current_id_name] = nil if (c.params[:current_id] and c.params[:current_id][current_id_name].blank?)
    c.session[:current_id][current_id_name] = c.params[:current_id][current_id_name] if (c.params[:current_id] and c.params[:current_id][current_id_name])
    c.session[:current_id][current_id_name] = @row_model.first[id_name] if c.session[:current_id][current_id_name].blank? and @row_model.first
    check_if_current_id_exist_in_row_model = false
    @row_model.each do |row|
      check_if_current_id_exist_in_row_model = true if row[id_name].to_s == c.session[:current_id][current_id_name].to_s
      break if check_if_current_id_exist_in_row_model
    end
    c.session[:current_id][current_id_name] = @row_model.first[id_name] if @row_model and @row_model.first and !check_if_current_id_exist_in_row_model
  end

  module TableHelper
  end
end
