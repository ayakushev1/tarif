class Calls::HistoryParser::FileProcessor::Pdf
  attr_reader :call_history_file
  attr_reader :doc, :table_heads
  attr_reader :processor_type

  def initialize(call_history_file)
    @call_history_file = call_history_file
    @processor_type = :pdf
    @doc = PDF::Reader.new(@call_history_file.path)
    @dd = PDF::Reader::ObjectHash.new(@call_history_file.path)
  end

  def table_body(table_filtrs = {}) #doc_sheet
    return @table_body if @table_body
    @table_body =  []
    doc.pages.each do |page|
      page.text.split("\n").each do |row|
        row_item = row.split(' ') 
        @table_body <<  row_item unless row_item.blank?
      end      
    end
    @table_body
  end
  
  def table_body_size
    table_body.count
  end
  
  def table_rows(table_filtrs = {})
    table_body(table_filtrs)
  end

  
  def file_type(file)
#    raise(StandardError, file_type)    
    file_name_as_array = (file.public_methods.include?(:original_filename) ? file.original_filename.to_s.split('.') : file.path.to_s.split('.'))
    file_type = file_name_as_array[file_name_as_array.size - 1] if file_name_as_array
    file_type = file_type.downcase if file_type
  end
  
end
