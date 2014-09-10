class Customer::HistoryParserController < ApplicationController
#  include Crudable
#  crudable_actions :index
  attr_accessor :message, :background_process_informer
  before_action :check_if_parsing_params_in_session, only: [:parse, :prepare_for_upload]
  before_action :init_background_process_informer, only: [:upload, :calculation_status, :parse]

  def calculation_status
    if !@background_process_informer.calculating?      
      message = call_history_results['message']['message'] if call_history_results and call_history_results['message']
      call_history_saver.save({:result => {'message' => nil}})
      redirect_to({:action => :prepare_for_upload}, :alert => message)
    end
  end
  
  def prepare_for_upload
  end
  
  def parse
    local_call_history_file = File.open('tmp/call_details_vgy_08092014.html')
    background_parser_processor(:calculation_status, :prepare_for_upload, :parse_local_call_history, local_call_history_file)
  end

  def upload
    uploaded_call_history_file = params[:call_history]
#    raise(StandardError, params)
    background_parser_processor(:calculation_status, :prepare_for_upload, :parse_uploaded_file, uploaded_call_history_file)
  end
  
  def background_parser_processor(status_action, finish_action, parser_starter, call_history_file)        
    if parsing_params[:calculate_on_background]
      @background_process_informer.clear_completed_process_info_model
      @background_process_informer.init(0, 100)
      
      Spawnling.new(:argv => "parsing call history file for #{current_user.id}") do
        begin
          @background_process_informer.init(0, 100)
          message = send(parser_starter, call_history_file)
          call_history_saver.save({:result => {'message' => {'message' => message}}})
        rescue => e
          call_history_saver.save({:result => {'message' => {'message' => e}}})
          raise(e)
        ensure
          @background_process_informer.finish
        end            
      end     
      redirect_to :action => status_action
    else
      message = send(parser_starter, call_history_file)
      redirect_to({:action => finish_action}, :alert => (message || {})['message'])
    end
  end
  
  def init_background_process_informer
    @background_process_informer ||= ServiceHelper::BackgroundProcessInformer.new('parsing_uploaded_file', current_user.id)
  end
  
  def parse_local_call_history(local_call_history_file)
    parser = Calls::HistoryParser.new(local_call_history_file, user_params, parsing_params)
    parser.parse
    call_history_to_save = {
      'processed' => parser.processed,
      'unprocessed' => parser.unprocessed,
      'ignorred' => parser.ignorred,
      'message' => {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"},
    }
    call_history_saver.save({:result => call_history_to_save})
    message = {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"}
  end

  def parse_uploaded_file(uploaded_call_history_file)
    if uploaded_call_history_file
      call_history_saver.clean_output_results
      message = check_uploaded_call_history_file(uploaded_call_history_file)
      call_history_to_save = {'message' => {:file_is_good => false, 'message' => message} }
      if message[:file_is_good]
        parser = Calls::HistoryParser.new(uploaded_call_history_file, user_params, parsing_params)
        parser.parse
        message = {:file_is_good => false, 'message' => "Обработано #{parser.processed_percent}%"}
        call_history_to_save = {
          'processed' => parser.processed,
          'unprocessed' => parser.unprocessed,
          'ignorred' => parser.ignorred,
          'message' => {:file_is_good => false, 'message' => "Обработано #{parser.processed_percent}%"},
        }
        Customer::Call.batch_save(parser.processed, current_user.id)
      end                  
      call_history_saver.save({:result => call_history_to_save})
    else
      message = {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
    end
    message
  end
  
  def check_uploaded_call_history_file(call_history_file)
    result = {:file_is_good => true, 'message' => nil}
    file_size = (call_history_file.size / 1000000.0).round(2) if call_history_file
    message = "Файл слишком большой: #{file_size}Mb. Он должен быть не больше #{parsing_params[:file_upload_max_size]}Mb"
    result = {:file_is_good => false, 'message' => message} if file_size > parsing_params[:file_upload_max_size]

    file_type = call_history_file.original_filename.to_s.split('.')[1]
    message = "Файл неправильного типа #{file_type}. Он должен быть один из #{parsing_params[:allowed_call_history_file_types]}"
    result = {:file_is_good => false, 'message' => message} if !parsing_params[:allowed_call_history_file_types].include?(file_type)
    result
  end
  
  def call_history_parsing_progress_bar
    ProgressBarable.new(self, 'call_history_parsing', @background_process_informer.current_values)
  end
  
  def call_history
    @call_history ||= ArrayOfHashable.new(self, call_history_results['processed'])
  end
  
  def call_history_unprocessed
    @call_history_unprocessed ||= ArrayOfHashable.new(self, call_history_results['unprocessed'])
  end
  
  def call_history_ignorred
    @call_history_ignorred ||= ArrayOfHashable.new(self, call_history_results['ignorred'])
  end  

  def call_history_saver
    @call_history_saver ||= ServiceHelper::OptimizationResultSaver.new('call_history', 'call_history', current_user.id)
    @call_history_saver
  end
  
  def call_history_results
    @call_history_results ||= (call_history_saver.results || {'processed' => [{}], 'unprocessed' => [{}], 'ignorred' => [{}], 'original_doc' => [{}] } )
    @call_history_results
  end

  def parsing_params_saver(name)
    @parsing_params_saver ||= ServiceHelper::OptimizationResultSaver.new('parsing_params', name, current_user.id)
    @parsing_params_saver
  end

  def parsing_params_filtr
    @parsing_params_filtr ||= Filtrable.new(self, "parsing_params")
  end
  
  def user_params_filtr
    @user_params_filtr ||= Filtrable.new(self, "user_params")
  end  

  def user_params
    {
      :own_phone_number => user_params_filtr.session_filtr_params['own_phone_number'],
      :operator_id => user_params_filtr.session_filtr_params['operator_id'],
      :region_id => user_params_filtr.session_filtr_params['region_id'],
      :country_id => user_params_filtr.session_filtr_params['country_id'],
      :user_id => current_user.id,
    }
  end
  
  def parsing_params
    {
      :background_process_informer => background_process_informer,

      :calculate_on_background => (parsing_params_filtr.session_filtr_params['calculate_on_background'] == 'true' ? true : false),
      :file_upload_remote_mode => (parsing_params_filtr.session_filtr_params['file_upload_remote_mode'] == 'true' ? true : false),
      :file_upload_turbolink_mode => (parsing_params_filtr.session_filtr_params['file_upload_turbolink_mode'] == 'true' ? true : false),
      :file_upload_max_size => parsing_params_filtr.session_filtr_params['file_upload_max_size'].to_f,
      :call_history_max_line_to_process => parsing_params_filtr.session_filtr_params['call_history_max_line_to_process'].to_f,
      :allowed_call_history_file_types => parsing_params_filtr.session_filtr_params['allowed_call_history_file_types'],
      :background_update_frequency => parsing_params_filtr.session_filtr_params['background_update_frequency'].to_i,
      :file_upload_form_method => parsing_params_filtr.session_filtr_params['file_upload_form_method'],
    }
  end
  
  def check_if_parsing_params_in_session
    if !session[:filtr] or session[:filtr]['user_params_filtr'].blank?
      saved_user_params = parsing_params_saver('user_params').results
      session[:filtr] ||= {}; session[:filtr]['user_params_filtr'] ||= {}
      session[:filtr]['user_params_filtr'] = if saved_user_params.blank?
        {'own_phone_number' => '100000000', 'operator_id' => 1030, 'region_id' => 1238, 'country_id' => 1100,}
      else
        saved_user_params
      end
    end

    if !session[:filtr] or session[:filtr]['parsing_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['parsing_params_filtr'] ||= {}
      session[:filtr]['parsing_params_filtr']  = {
        'calculate_on_background' => 'true',
        'file_upload_remote_mode' => 'false',
        'file_upload_turbolink_mode' => 'true',
        'file_upload_form_method' => 'get',
        'file_upload_max_size' => 2,
        'call_history_max_line_to_process' => 2000,
        'allowed_call_history_file_types' => ['html'],
        'background_update_frequency' => 10,
      } 
    end
  end

end
