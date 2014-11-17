class Demo::HistoryParsersController < Customer::HistoryParsersController

  after_action :track_upload, only: :upload
  after_action :track_prepare_for_upload, only: :prepare_for_upload

  private
  
  def track_upload
    ahoy.track "#{controller_name}/#{action_name}", {
      'flash' => flash,
      'parsing_params' => customer_history_parser.parsing_params, 
      'user_params' => customer_history_parser.user_params,
      }
  end

  def track_prepare_for_upload
    ahoy.track("#{controller_name}/#{action_name}", {
      :flash => flash
    }) if params.count == 2
  end

end
