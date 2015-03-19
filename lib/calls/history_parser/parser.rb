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
  
  def parse
    @message = {:file_is_good => false, 'message' => "Не загружен файл"}
    return message unless call_history_file

    table_heads_row = file_processer.table_heads_row(operator_processer.table_filtrs, operator_processer.correct_table_heads)    
    @message = {:file_is_good => false, 'message' => "Неправильный формат выписки"}
    return message if table_heads_row == -2

    table_heads = file_processer.table_heads(operator_processer.table_filtrs)
    @message = {:file_is_good => false, 'message' => "Неправильный формат выписки"}
#    raise(StandardError, operator_processer.check_if_table_correct(table_heads))
    return message unless operator_processer.check_if_table_correct(table_heads)
    
    max_row_number = parsing_params[:call_history_max_line_to_process]
    background_process_informer.init(0.0, max_row_number) if background_process_informer
    update_step = [parsing_params[:background_update_frequency], 1].max
    
    call_details_doc = file_processer.table_body(operator_processer.table_filtrs)
    
    i = 0; doc_i = table_heads_row + 1
    
    while call_details_doc and i < max_row_number
      row = file_processer.table_row(doc_i, operator_processer.table_filtrs)
      if !row
        doc_i += 1
        i += 1
        next
      end
      
      date = operator_processer.row_date(row)
#      raise(StandardError) if doc_i == 20
      if date == "invalid_date"
        doc_i += 1
        i += 1
        next
      end
      
      if date.to_date.month.to_i >= user_params[:accounting_period_month].to_i and date.to_date.year.to_i >= user_params[:accounting_period_year].to_i
        operator_processer.parse_row(row, date) 
        i += 1
      end 
      
      background_process_informer.increase_current_value(update_step) if background_process_informer and (doc_i + 1).divmod(update_step)[1] == 0
      
      doc_i += 1
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
