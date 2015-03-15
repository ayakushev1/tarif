require 'roo'
require 'spreadsheet'

class Calls::HistoryParser::FileProcessor::Xls
  attr_reader :call_history_file
  attr_reader :doc, :table_heads

  def initialize(call_history_file)
    @call_history_file = call_history_file
    @doc = Roo::Spreadsheet.open(@call_history_file.path, extension: :xls)
  end

  def table_body(table_filtrs = {}) #doc_sheet
    @table_body ||= doc.sheet(table_filtrs[:body])
  end
  
  def table_heads(table_filtrs)
    @table_heads ||= table_body(table_filtrs).row(table_heads_row(table_filtrs))
  end

  def table_row(row_index, table_filtrs = {})
    table_body(table_filtrs).row(row_index) #doc_sheet.row(doc_i) doc.sheet(0)
  end
  
  def table_heads_row(table_filtrs, correct_table_heads = nil)
    return @table_heads_row if @table_heads_row
    @table_heads_row = -1
#    return @table_heads_row if !doc.sheets.include?('Sheet0')
    max_search_row = 10
    i = table_body(table_filtrs).first_row
    while (i < max_search_row)
      if table_body(table_filtrs).row(i) == correct_table_heads
        @table_heads_row = i
        break
      end
      i += 1
    end
    @table_heads_row 
  end
  
  
end
