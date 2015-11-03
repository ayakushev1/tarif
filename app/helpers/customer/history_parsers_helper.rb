module Customer::HistoryParsersHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::ProgressBarable, SavableInSession::SessionInitializers

  def current_user_id
    current_user.id
  end
   
  def call_history_saver
    Customer::Stat::OptimizationResult.new('call_history', 'call_history', current_user_id)
  end
  
  def call_history_results
    (call_history_saver.results || {'processed' => [{}], 'unprocessed' => [{}], 'ignorred' => [{}], 'original_doc' => [{}] } )
  end
  
  def call_history
    options = {:base_name => 'call_history', :current_id_name => 'base_service_id', :id_name => 'base_service_id', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['processed'], options)
  end
  
  def call_history_unprocessed
    options = {:base_name => 'unprocessed_call_history', :current_id_name => 'unprocessed_column', :id_name => 'unprocessed_column', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['unprocessed'], options)
  end
  
  def call_history_ignorred
    options = {:base_name => 'ignorred_call_history', :current_id_name => 'ignorred_column', :id_name => 'ignorred_column', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['ignorred'], options)
  end

  def parsing_params_filtr
    create_filtrable("parsing_params")
  end
  
  def user_params_filtr
    create_filtrable("user_params")
  end

  def call_history_parsing_progress_bar
    options = {'action_on_update_progress' => customer_history_parsers_calculation_status_path}.merge(
      background_process_informer.current_values)
    create_progress_barable('call_history_parsing', options)
  end

  def recalculate_on_back_ground(parser_starter, call_history_file)
    prepare_background_process_informer
    Spawnling.new(:argv => "parsing call history file for #{current_user_id}") do
      background_process_informer.init(0, 100)
      message = send(parser_starter, call_history_file)
      update_customer_infos
      @background_process_informer.finish
      message
    end     
  end
  
  def recalculate_direct(parser_starter, call_history_file)
    message = send(parser_starter, call_history_file)
    update_customer_infos
    message
  end

  def prepare_background_process_informer
    background_process_informer.clear_completed_process_info_model
    background_process_informer.init(0, 100)
  end
  
  def update_customer_infos
    Customer::Info::CallsDetailsParams.update_info(current_user_id, session_filtr_params(user_params_filtr))
    Customer::Info::CallsParsingParams.update_info(current_user_id, session_filtr_params(parsing_params_filtr))
    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_user_id, 'calls_parsing_count')    
  end
  
  def parse_uploaded_file(uploaded_call_history_file)
    call_history_to_save = parse_file(uploaded_call_history_file)
    Customer::Call.batch_save(call_history_to_save['processed'], {:user_id => current_user_id})
    call_history_to_save['message']
  end
  
  def parse_file(file)
    file.rewind if file.eof?
    parser = Calls::HistoryParser::Parser.new(file, user_params, parsing_params)
    message = parser.parse

    message = {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"} if !message
    call_history_to_save = parser.parse_result.merge({'message' => message})
    call_history_saver.save({:result => call_history_to_save})
#    raise(StandardError)
    call_history_to_save
  end
  
  def upload_file(uploaded_call_history_file)
#    raise(StandardError, check_uploaded_call_history_file(uploaded_call_history_file))
    uploaded_call_history_file ? check_uploaded_call_history_file(uploaded_call_history_file) : {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
  end
  
  def check_uploaded_call_history_file(call_history_file)
    result = {:file_is_good => true, 'message' => nil}

#    raise(StandardError, user_params[:operator_id])    
    message = "Не выбран оператор. Выберите вашего оператора"
    return result = {:file_is_good => false, 'message' => message} if user_params[:operator_id].blank? or user_params[:operator_id] == 0

    file_size = (call_history_file.size / 1000000.0).round(2) if call_history_file
    message = "Файл слишком большой: #{file_size}Mb. Он должен быть не больше #{parsing_params[:file_upload_max_size]}Mb"
    return result = {:file_is_good => false, 'message' => message} if file_size > parsing_params[:file_upload_max_size]

    file_type = file_type(call_history_file)
    message = "Файл неправильного типа #{file_type}. Он должен быть один из #{parsing_params[:allowed_call_history_file_types]}"
    return result = {:file_is_good => false, 'message' => message} if !parsing_params[:allowed_call_history_file_types].include?(file_type)
    
    message = "Тип файла не совпадает с разрешенным типом файла для оператора: МТС и Мегафон - html, МТС и Билайн - xls или xlsx"
    return result = {:file_is_good => false, 'message' => message} if !check_if_file_type_match_with_operator(file_type)
    
    call_history_file.rewind if call_history_file.eof?
    result = Calls::HistoryParser::Parser.new(call_history_file, user_params, parsing_params).check_if_file_is_good
#    result = {:file_is_good => false, 'message' => message}
    
    result
  end
  
  def check_if_file_type_match_with_operator(file_type)
    case file_type
    when 'html'
      [1030, 1028].include?(user_params[:operator_id]) ? true : false
    when 'xls', 'xlsx'
      [1025, 1030].include?(user_params[:operator_id]) ? true : false
    when 'pdf'
      [1023].include?(user_params[:operator_id]) ? true : false
    else
      false
    end
  end
  
  def file_type(file)
#    raise(StandardError, file_type)    
    file_name_as_array = (file.public_methods.include?(:original_filename) ? file.original_filename.to_s.split('.') : file.path.to_s.split('.'))
    file_type = file_name_as_array[file_name_as_array.size - 1] if file_name_as_array
    file_type = file_type.downcase if file_type
  end
  
  def background_process_informer
    @background_process_informer ||= Customer::BackgroundStat::Informer.new('parsing_uploaded_file', current_user_id)
  end
  
  def init_background_process_informer
    @background_process_informer ||= Customer::BackgroundStat::Informer.new('parsing_uploaded_file', current_user_id)
  end
  
  def user_params
    user_params_filtr_session_filtr_params = session_filtr_params(user_params_filtr)
    {
      :user_id => current_user_id,

      :own_phone_number => user_params_filtr_session_filtr_params['own_phone_number'],
      :operator_id => user_params_filtr_session_filtr_params['operator_id'].to_i,
      :region_id => user_params_filtr_session_filtr_params['region_id'].to_i,
      :country_id => (user_params_filtr_session_filtr_params['country_id'].to_i || 1100), #Russia
      :accounting_period_month => user_params_filtr_session_filtr_params['accounting_period_month'],
      :accounting_period_year => user_params_filtr_session_filtr_params['accounting_period_year'],
    }
  end
  
  def parsing_params
    parsing_params_filtr_session_filtr_params = session_filtr_params(parsing_params_filtr)
    {
#      :background_process_informer => background_process_informer,
      :calculate_on_background => (parsing_params_filtr_session_filtr_params['calculate_on_background'] == 'true' ? true : false),
      :save_processes_result_to_stat => (parsing_params_filtr_session_filtr_params['save_processes_result_to_stat'] == 'true' ? true : false),
      :file_upload_remote_mode => (parsing_params_filtr_session_filtr_params['file_upload_remote_mode'] == 'true' ? true : false),
      :file_upload_turbolink_mode => (parsing_params_filtr_session_filtr_params['file_upload_turbolink_mode'] == 'true' ? true : false),
      :file_upload_max_size => parsing_params_filtr_session_filtr_params['file_upload_max_size'].to_f,
      :call_history_max_line_to_process => parsing_params_filtr_session_filtr_params['call_history_max_line_to_process'].to_f,
      :allowed_call_history_file_types => ['html', 'xls', 'xlsx', 'pdf'], #parsing_params_filtr_session_filtr_params['allowed_call_history_file_types'],
      :background_update_frequency => parsing_params_filtr_session_filtr_params['background_update_frequency'].to_i,
      :file_upload_form_method => parsing_params_filtr_session_filtr_params['file_upload_form_method'],
      :sleep_after_file_uploading => parsing_params_filtr_session_filtr_params['sleep_after_file_uploading'].to_f,
    }
  end
  
  def check_if_parsing_params_in_session
    session[:filtr] ||= {}
    if session[:filtr]['user_params_filtr'].blank?
      session[:filtr]['user_params_filtr'] ||= {}
      session[:filtr]['user_params_filtr'] = Customer::Info::CallsDetailsParams.info(current_user_id)
    end

    if session[:filtr]['parsing_params_filtr'].blank?
      session[:filtr]['parsing_params_filtr'] ||= {}
      session[:filtr]['parsing_params_filtr'] = Customer::Info::CallsParsingParams.info(current_user_id)
    end
  end

end
