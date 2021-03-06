class Customer::HistoryParser < ActiveType::Object
  attribute :session, default: proc {controller.session}
#  attribute :user_session, default: proc {controller.user_session}
  attribute :current_user_id, :integer, default: proc {controller.current_user.id}

  attribute :call_history_saver, default: proc {Customer::Stat::OptimizationResult.new('call_history', 'call_history', current_user_id)}
  attribute :call_history_results, default: proc {(call_history_saver.results || {'processed' => [{}], 'unprocessed' => [{}], 'ignorred' => [{}], 'original_doc' => [{}] } )}
  attribute :call_history, default: proc {
    options = {:base_name => 'call_history', :current_id_name => 'base_service_id', :id_name => 'base_service_id'}
    controller.create_array_of_hashable(call_history_results['processed'], options)}
  attribute :call_history_unprocessed, default: proc {
    options = {:base_name => 'unprocessed_call_history', :current_id_name => 'unprocessed_column', :id_name => 'unprocessed_column'}
    controller.create_array_of_hashable(call_history_results['unprocessed'], options)}
  attribute :call_history_ignorred, default: proc {
    options = {:base_name => 'ignorred_call_history', :current_id_name => 'ignorred_column', :id_name => 'ignorred_column'}
    controller.create_array_of_hashable(call_history_results['ignorred'], options)}

  attribute :parsing_params_filtr, default: proc {controller.create_filtrable("parsing_params")}
  attribute :user_params_filtr, default: proc {controller.create_filtrable("user_params")}

  attribute :call_history_parsing_progress_bar, default: proc {
    options = {'action_on_update_progress' => controller.customer_history_parsers_calculation_status_path}.merge(
      background_process_informer.current_values)
    controller.create_progress_barable('call_history_parsing', options)}

  attr_reader :controller

  def initialize(controller, init_values = {})
    super init_values
    @controller = controller
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
    Customer::Info::CallsDetailsParams.update_info(current_user_id, controller.session_filtr_params(user_params_filtr))
    Customer::Info::CallsParsingParams.update_info(current_user_id, controller.session_filtr_params(parsing_params_filtr))
    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_user_id, 'calls_parsing_count')    
  end
  
  def parse_uploaded_file(uploaded_call_history_file)
    call_history_to_save = parse_file(uploaded_call_history_file)
    Customer::Call.batch_save(call_history_to_save['processed'], {:user_id => current_user_id})
    call_history_to_save['message']
  end
  
  def parse_file(file)
    parser = Calls::HistoryParser::Parser.new(file, user_params, parsing_params)
#    parser = Calls::HistoryParser::Loader.parser(file_type(file)).new(file, user_params, parsing_params)
#    raise(StandardError)
    message = parser.parse

    message = {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"} if !message
    call_history_to_save = parser.parse_result.merge({'message' => message})
    call_history_saver.save({:result => call_history_to_save})

    call_history_to_save
  end
  
  def upload_file(uploaded_call_history_file)
    uploaded_call_history_file ? check_uploaded_call_history_file(uploaded_call_history_file) : {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
  end
  
  def check_uploaded_call_history_file(call_history_file)
    result = {:file_is_good => true, 'message' => nil}

#    raise(StandardError, user_params[:operator_id])    
    message = "Не выбран оператор. Выберите вашего оператора"
    result = {:file_is_good => false, 'message' => message} if user_params[:operator_id].blank? or user_params[:operator_id] == 0

    file_size = (call_history_file.size / 1000000.0).round(2) if call_history_file
    message = "Файл слишком большой: #{file_size}Mb. Он должен быть не больше #{parsing_params[:file_upload_max_size]}Mb"
    result = {:file_is_good => false, 'message' => message} if file_size > parsing_params[:file_upload_max_size]

    file_type = file_type(call_history_file)
    message = "Файл неправильного типа #{file_type}. Он должен быть один из #{parsing_params[:allowed_call_history_file_types]}"
    result = {:file_is_good => false, 'message' => message} if !parsing_params[:allowed_call_history_file_types].include?(file_type)
    result
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
    user_params_filtr_session_filtr_params = controller.session_filtr_params(user_params_filtr)
    {
      :user_id => current_user_id,

      :own_phone_number => user_params_filtr_session_filtr_params['own_phone_number'],
      :operator_id => user_params_filtr_session_filtr_params['operator_id'].to_i,
      :region_id => user_params_filtr_session_filtr_params['region_id'].to_i,
      :country_id => user_params_filtr_session_filtr_params['country_id'].to_i,
      :accounting_period_month => user_params_filtr_session_filtr_params['accounting_period_month'],
      :accounting_period_year => user_params_filtr_session_filtr_params['accounting_period_year'],
    }
  end
  
  def parsing_params
    parsing_params_filtr_session_filtr_params = controller.session_filtr_params(parsing_params_filtr)
    {
#      :background_process_informer => background_process_informer,
      :calculate_on_background => (parsing_params_filtr_session_filtr_params['calculate_on_background'] == 'true' ? true : false),
      :save_processes_result_to_stat => (parsing_params_filtr_session_filtr_params['save_processes_result_to_stat'] == 'true' ? true : false),
      :file_upload_remote_mode => (parsing_params_filtr_session_filtr_params['file_upload_remote_mode'] == 'true' ? true : false),
      :file_upload_turbolink_mode => (parsing_params_filtr_session_filtr_params['file_upload_turbolink_mode'] == 'true' ? true : false),
      :file_upload_max_size => parsing_params_filtr_session_filtr_params['file_upload_max_size'].to_f,
      :call_history_max_line_to_process => parsing_params_filtr_session_filtr_params['call_history_max_line_to_process'].to_f,
      :allowed_call_history_file_types => parsing_params_filtr_session_filtr_params['allowed_call_history_file_types'],
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

  def persisted?
    false
  end  
end

