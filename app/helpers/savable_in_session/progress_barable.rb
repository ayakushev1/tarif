module SavableInSession::ProgressBarable
  
  def create_progress_barable(progress_bar_name, options = {})
    progress_barable = ProgressBarable.new(progress_bar_name, options)
    init_session_for_progress_barable(progress_barable)
    set_session_from_options_for_progress_barable(progress_barable)
    set_session_from_params_for_progress_barable(progress_barable)

    progress_barable
  end
  
  class ProgressBarable
    include SavableInSession::AssistanceInView

    attr_accessor :progress_bar, :progress_bar_name, :caption, :action_on_update_progress, 
      :min_value, :max_value, :current_value, :text_value, :options
    
    def initialize(progress_bar_name, options = {})
      @progress_bar_name = progress_bar_name
      @progress_bar = "#{progress_bar_name}_progress_bar"
      @options = options

      @action_on_update_progress = options['action_on_update_progress']
      @min_value = options['min_value'] || 0.0
      @max_value = options['max_value'] || 100.0
      @current_value = options['current_value'] || 50.0
      @text_value = options['text_value'] || ' '
  
    end
    
    def current_value_percent
      current_value / (max_value - min_value)
    end
  end
  
end
