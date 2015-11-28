module Calls::HistoryParser
  class Runner
    attr_reader :user_params, :parsing_params
    
    def initialize(user_params, parsing_params)
      @user_params = user_params
      @parsing_params = parsing_params
    end
  
    def recalculate_on_back_ground(call_history_file, save_calls = true)
      parser = Calls::HistoryParser::Parser.new(call_history_file, user_params, parsing_params)
      message = parser.check_if_file_is_good
      return message if !message[:file_is_good]
      
      prepare_background_process_informer
      Spawnling.new(:argv => "parsing call history file for #{user_params[:user_id]}") do
#        background_process_informer.init(0, 100)
        message = parse_file(parser, call_history_file, save_calls)
        background_process_informer.finish
        message
      end    
      message 
    end
    
    def recalculate_direct(call_history_file, save_calls = true)
      parser = Calls::HistoryParser::Parser.new(call_history_file, user_params, parsing_params)
      message = parser.check_if_file_is_good
      return message if !message[:file_is_good]

      parse_file(parser, call_history_file, save_calls)
    end
  
    def parse_file(parser, file, save_calls = true)
      file.rewind if file.eof?
      message = parser.parse
  
      message = {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"} if !message
      call_history_to_save = parser.parse_result.merge({'message' => message})
      call_history_saver.save({:result => call_history_to_save}) if parsing_params[:save_processes_result_to_stat]
  
      Customer::Call.where(:user_id => user_params[:user_id], :call_run_id => user_params[:call_run_id]).delete_all
      if save_calls
        Customer::Call.bulk_insert(values: call_history_to_save['processed']) 
        Customer::CallRun.where(:id => user_params[:call_run_id]).first_or_create.calculate_call_stat
      end
        
      call_history_to_save['message']
    end
    
    def call_history_saver
      Customer::Stat::OptimizationResult.new('call_history', 'call_history', user_params[:user_id])
    end
    
    def prepare_background_process_informer
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init(0, 100)
    end
    
    def background_process_informer
      Customer::BackgroundStat::Informer.new('parsing_uploaded_file', user_params[:user_id])
    end
    
  end

end
