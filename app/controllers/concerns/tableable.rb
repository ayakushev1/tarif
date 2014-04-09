class Tableable < Presenter
  attr_accessor :base_name, :caption, :heads
  attr_writer :current_raw_class
  attr_reader :pagination_param_name, :pagination_name, :current_id_name, :table_name
  
  def initialize(controller, model)
    super(controller)
    @model = model
    @base_name = model.table_name.singularize
    @table_name = "#{@base_name}_table"
    self.extend TableHelper
  end
  
  def model
    init_session
    set_pagination_current_id
    page = c.session[:pagination][pagination_name]
    @raw_model=@model.paginate(page: page, :per_page => 10).order(:id)
    set_tables_current_id
    @raw_model
  end
  
  def pagination_name
    "#{@base_name}_page"
  end
  
  def pagination_param_name
    "pagination[#{pagination_name}]"
  end
  
  def current_id_name
    @current_id_name || "#{@base_name}_id"
  end
  
  def current_raw_class
     @current_raw_class || "current_table_raw" 
  end
  
  def raw_details(raw)
    raw_name="#{base_name}_raw"
    ["current_id_name=#{current_id_name}",
     "action_name=#{c.request.path_info}",
     "raw_name=#{raw_name}",
     "id=#{raw_name}_#{raw.id.to_s}",
     "value=#{raw.id}",
     "class=#{((c.session[:current_id][current_id_name].to_i == raw.id) ? current_raw_class : "")}"
     ].join(" ")
  end

  private
  
  def init_session
    c.session[:pagination] ||= {}
    c.session[:current_id] ||= {}
  end
  
  def set_pagination_current_id
    if (c.params[:pagination] and c.params[:pagination][pagination_name]) 
      if c.session[:pagination][pagination_name] != c.params[:pagination][pagination_name]
        c.session[:current_id][current_id_name] = nil 
        c.params[:current_id][current_id_name] = nil if c.params[:current_id]
      end
      c.session[:pagination][pagination_name] = c.params[:pagination][pagination_name]
    end  
  end

  def set_tables_current_id
    c.params[:current_id][current_id_name] = nil if (c.params[:current_id] and c.params[:current_id][current_id_name].blank?)
    c.session[:current_id][current_id_name] = c.params[:current_id][current_id_name] if (c.params[:current_id] and c.params[:current_id][current_id_name])
    c.session[:current_id][current_id_name] = @raw_model.first.id if c.session[:current_id][current_id_name].blank? and @raw_model.first
    unless @raw_model.pluck(:id).include?(c.session[:current_id][current_id_name].to_i) 
      c.session[:current_id][current_id_name] = @raw_model.first.id if @raw_model.first
    end
  end

  module TableHelper
  end
end
