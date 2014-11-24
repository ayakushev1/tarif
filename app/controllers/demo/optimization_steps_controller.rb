class Demo::OptimizationStepsController < ApplicationController
  
  after_action :track_choose_load_calls_options, only: :choose_load_calls_options
  
  def load_calls_options
#    @load_calls_options ||= 
    Filtrable.new(self, "load_calls_options")
  end
  
  private
  
  def track_choose_load_calls_options
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end
end
