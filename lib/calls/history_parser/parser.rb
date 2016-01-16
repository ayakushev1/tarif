class Calls::HistoryParser::Parser
  attr_reader :call_history_file, :user_params, :parsing_params
  attr_reader :file_processer, :operator_processer, :background_process_informer, :message
  
  def initialize(call_history_file, user_params, parsing_params = {})
    @call_history_file = call_history_file
    @user_params = user_params
    @parsing_params = parsing_params
    
    @file_processer = Calls::HistoryParser::ClassLoader.file_processer(@call_history_file).new(@call_history_file)
    @operator_processer = Calls::HistoryParser::ClassLoader.operator_processer(@call_history_file, user_params[:operator_id]).new(user_params)
    @background_process_informer = parsing_params[:background_process_informer] || Customer::BackgroundStat::Informer.new('parsing_uploaded_file', user_params[:user_id])
  end
  
  def self.find_operator_parser(call_history_file, user_params, parsing_params)
    if user_params[:operator_id] > 0
      parser = Calls::HistoryParser::Parser.new(call_history_file, user_params, parsing_params)
      message = parser.check_if_file_is_good
    else
      file_type = Calls::HistoryParser::ClassLoader.file_type(call_history_file)
      message = {:file_is_good => false, 'message' => "Неправильный формат детализации", :a => Calls::HistoryParser::ClassLoader.allowed_operators_by_file_type[file_type]} 
      parser = nil
  
      Calls::HistoryParser::ClassLoader.allowed_operators_by_file_type[file_type].each do |operator_id|
        parser = Calls::HistoryParser::Parser.new(call_history_file, user_params.merge!({:operator_id => operator_id}), parsing_params)
        message = parser.check_if_file_is_good
        if message[:file_is_good]
          Customer::CallRun.find(user_params[:call_run_id]).update_columns({:operator_id => operator_id})
          break 
        end
#        raise(StandardError, message) if operator_id == Category::Operator::Const::Beeline
      end if Calls::HistoryParser::ClassLoader.allowed_operators_by_file_type[file_type]
    end
    [parser, message]
  end
  
  def check_if_file_is_good
    call_history_file.rewind if call_history_file.eof?  

    column_indexes = operator_processer.find_column_indexes(file_processer.table_rows(operator_processer.table_filtrs))
#    raise(StandardError, column_indexes)

    return {:file_is_good => false, 'message' => "Неправильный формат детализации"} if !column_indexes

    {:file_is_good => true, 'message' => nil}
  end
  
  def parse
    call_history_file.rewind if call_history_file.eof?
    
    call_detail_rows = file_processer.table_rows(operator_processer.table_filtrs)
    
    raise(StandardError, call_detail_rows) if false
    
    max_row_number = [parsing_params[:call_history_max_line_to_process],  file_processer.table_body_size].min

    background_process_informer.init(0.0, max_row_number) if background_process_informer

    update_step = [parsing_params[:background_update_frequency], 1].max
    
    i = 0
    
    while i < max_row_number
      row = call_detail_rows[i]
      date = operator_processer.row_date(row)
      
      raise(StandardError, [row, date]) if false
      
      if date == "invalid_date"
        i += 1
        next
      end
      
      if (date.to_date.year.to_i > user_params[:accounting_period_year].to_i) or 
         (date.to_date.month.to_i >= user_params[:accounting_period_month].to_i and date.to_date.year.to_i >= user_params[:accounting_period_year].to_i)
        operator_processer.parse_row(row, date) 
      end 
#      raise(StandardError, [(date.to_date.month.to_i >= user_params[:accounting_period_month].to_i), (date.to_date.year.to_i >= user_params[:accounting_period_year].to_i), operator_processer.parse_row(row, date) ]) if false
      i += 1

      background_process_informer.increase_current_value(update_step) if background_process_informer and (i + 1).divmod(update_step)[1] == 0
    end 
    nil
  end
    
  def parse_result
    {
      'processed' => operator_processer.processed,
      'unprocessed' => operator_processer.unprocessed,
      'ignorred' => operator_processer.ignorred,
      'message' => message,
    }
  end

  def processed_percent    
    @processed_percent ||= operator_processer.processed.size.to_f * 100.0 / (parsing_params[:call_history_max_line_to_process] || 1.0).to_f    
  end
    
end
