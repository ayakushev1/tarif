class HomeController < ApplicationController
#  before_action :calls_stat_options
  after_action :track_demo_results, only: :demo_results
  after_action :track_index, only: :index


  private
  
  def track_demo_results
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#    }) if params.count == 2
  end

  def track_index
#    ahoy.track("#{controller_name}/#{action_name}", {
#      'flash' => flash,      
#    }) if params.count == 2
  end

end
