class Formable < Presenter
  
  def initialize(controller, model)
    super(controller)
    @model = model
    @base_name = model.new.class.name.downcase
    self.extend TableHelper
  end
  
  def model
    init_session
    @model
  end
  
  private
  
  def init_session
    c.session[:form] ||= {}
  end
  
  def set_tables_current_id
    c.session[:current_id][current_id_name] = c.params[:current_id][current_id_name] if (c.params[:current_id] and c.params[:current_id][current_id_name])
    c.session[:current_id][current_id_name] = @raw_model.first.id if c.session[:current_id][current_id_name].blank?
    c.session[:current_id][current_id_name] = @raw_model.first.id unless @raw_model.pluck(:id).include?(c.session[:current_id][current_id_name].to_i)
  end

  module TableHelper
  end
end
