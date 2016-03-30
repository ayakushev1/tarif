require 'roo'
#require 'spreadsheet'

class Calls::HistoryParser::FileProcessor::Xls
  attr_reader :call_history_file
  attr_reader :doc, :table_heads
  attr_reader :processor_type

  def initialize(call_history_file)
    @call_history_file = call_history_file
    @processor_type = :xls
    @doc = case file_type(@call_history_file)
    when 'xls'
      Roo::Spreadsheet.open(@call_history_file.path, extension: :xls)
    else
      Roo::Spreadsheet.open(@call_history_file.path)
    end
  end

  def table_body(table_filtrs = {}) #doc_sheet
    @table_body ||= doc.sheet(table_filtrs[processor_type][:body])
  end
  
  def table_body_size
    table_body.last_row # - table_heads_row
  end
  
  def table_rows(table_filtrs = {})
    table_body(table_filtrs)
    (1..table_body.last_row).collect{|i| table_body(table_filtrs).row(i)}    
  end
  
  def file_type(file)
#    raise(StandardError, file_type)    
    file_name_as_array = (file.public_methods.include?(:original_filename) ? file.original_filename.to_s.split('.') : file.path.to_s.split('.'))
    file_type = file_name_as_array[file_name_as_array.size - 1] if file_name_as_array
    file_type = file_type.downcase if file_type
  end
  
end
