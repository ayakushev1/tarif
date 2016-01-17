module Calls::HistoryParser::TextProcessorHelper
  def take_out_special_symbols(string)
    result = string; result_2 = string
    special_symbols = ['.'.freeze, ':'.freeze, ';'.freeze]
    special_symbols.each{|sym| result = result.mb_chars.downcase.to_s.split(sym).join(' '.freeze)}
    special_symbols = ['-'.freeze]
    special_symbols.each{|sym| result_2 = result_2.mb_chars.downcase.to_s.split(sym).join(' '.freeze)}
    result.squish.split(' '.freeze) + result_2.squish.split(' '.freeze)
  end

  def take_out_special_symbols_from_phone_number(phone)
    result = phone
    special_symbols = ['.'.freeze, ':'.freeze, ';'.freeze, ' '.freeze, '+'.freeze, '-'.freeze, '<'.freeze]
    special_symbols.each{|sym| result = result.mb_chars.downcase.to_s.split(sym).join('')}
    result = "7#{result.to_s}" if result and result.to_s.length == 10
    result
  end
  
end
