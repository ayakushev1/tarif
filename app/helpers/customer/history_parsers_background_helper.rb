module Customer::HistoryParsersBackgroundHelper
  include SavableInSession::ProgressBarable, SavableInSession::SessionInitializers

  def call_history_parsing_progress_bar
    options = {'action_on_update_progress' => customer_history_parsers_calculation_status_path}.merge(
      background_process_informer.current_values)
    create_progress_barable('call_history_parsing', options)
  end

  def prepare_background_process_informer
    background_process_informer.clear_completed_process_info_model
    background_process_informer.init(0, 100)
  end
  
  def background_process_informer
#    @background_process_informer ||= 
    Customer::BackgroundStat::Informer.new('parsing_uploaded_file', current_or_guest_user_id)
  end
  
  def init_background_process_informer
#    @background_process_informer ||= 
    Customer::BackgroundStat::Informer.new('parsing_uploaded_file', current_or_guest_user_id)
  end
  
end
