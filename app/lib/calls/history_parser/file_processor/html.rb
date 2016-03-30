require 'nokogiri'
require 'open-uri'

class Calls::HistoryParser::FileProcessor::Html
  attr_reader :call_history_file
  attr_reader :doc, :table_heads
  attr_reader :processor_type
  
  def initialize(call_history_file)
    @call_history_file = call_history_file
    @processor_type = :html
    @doc = Nokogiri::HTML(@call_history_file) do |config|
      config.nonet
    end    
  end
  
  def table_body(table_filtrs = {})
    @table_body ||= doc.css(table_filtrs[processor_type][:body])
  end

  def table_body_size
    table_body.size
  end

  def table_rows(table_filtrs = {})
    table_heads(table_filtrs) + body_rows(table_filtrs)

  end
  
  
  def table_heads(table_filtrs)
    return @table_heads if @table_heads
    all_table_heads = doc.css(table_filtrs[processor_type][:head])
    @table_heads =  if all_table_heads.blank?
      []
    else
      all_table_heads.first.css(table_filtrs[processor_type][:head_column]).to_a.map{|head_item| head_item.text}
    end
    @table_heads
  end
  
  def body_rows(table_filtrs, max_row_number = 10000)
    result = []
    table_body(table_filtrs)[0, max_row_number].each do |row|
      (result << row.css(table_filtrs[processor_type][:body_column]).to_a.map{|column| column.text}) if row
    end

    result
  end




  def table_row11(row_index, table_filtrs)
    table_body(table_filtrs)[row_index].css(table_filtrs[processor_type][:body_column]).to_a.map{|column| column.text} if table_body(table_filtrs)[row_index]
  end
  
  def table_heads_row11(table_filtrs = {}, correct_table_heads = nil)
    -1
  end  
end
