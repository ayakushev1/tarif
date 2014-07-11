class ProgressBarable < Presenter
  attr_accessor :progress_bar, :progress_bar_name, :caption, :action_on_update_progress, :min_value, :max_value, :current_value, :options
  
  def initialize(controller, progress_bar_name, options = {})
    super(controller)
    @progress_bar_name = progress_bar_name
    @progress_bar = "#{progress_bar_name}_progress_bar"
    @options = options
    init_session
    set_session_from_options
    set_session_from_params
  end
  
  def session_progress_bar_params
    c.session[:progress_bar][progress_bar_name]
  end
  
  def current_value_percent
    current_value / (max_value - min_value)
  end
  
  private
  
  def init_session
    c.session[:progress_bar] ||= {}
    c.session[:progress_bar][progress_bar_name] ||= {}
  end
  
  def set_session_from_options    
    options.each do |key, value|
      c.session[:progress_bar][progress_bar_name][key.to_s] = value
    end if options
  end
  
  def set_session_from_params    
    c.params[progress_bar_name].each do |key, value|
      c.session[:progress_bar][progress_bar_name][key] = value
    end if c.params[progress_bar_name]
  end
  
  
end
