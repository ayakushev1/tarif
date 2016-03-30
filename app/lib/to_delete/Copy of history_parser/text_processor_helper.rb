module Calls::HistoryParser::TextProcessorHelper
  def take_out_special_symbols(string)
    result = string; result_2 = string
    special_symbols = ['.', ':', ';']
    special_symbols.each{|sym| result = result.mb_chars.downcase.to_s.split(sym).join(' ')}
    special_symbols = ['-']
    special_symbols.each{|sym| result_2 = result_2.mb_chars.downcase.to_s.split(sym).join(' ')}
    result.squish.split(' ') + result_2.squish.split(' ')
  end

  def take_out_special_symbols_from_phone_number(phone)
    result = phone
    special_symbols = ['.', ':', ';', ' ', '+', '-', '<']
    special_symbols.each{|sym| result = result.mb_chars.downcase.to_s.split(sym).join('')}
    result = "7#{result.to_s}" if result and result.to_s.length == 10
    result
  end
  
end
