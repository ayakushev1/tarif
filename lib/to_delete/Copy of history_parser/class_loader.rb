class Calls::HistoryParser::ClassLoader
    
  def self.file_processer(file)
    case file_type(file)
    when 'html'
      Calls::HistoryParser::FileProcessor::Html
    when 'xls', 'xlsx'
      Calls::HistoryParser::FileProcessor::Xls
    when 'pdf'
      Calls::HistoryParser::FileProcessor::Pdf
    else
      raise(StandardError, "Wrong file type: #{file_type}")
    end      
  end

  def self.operator_processer(file, operator_id)
    case file_type(file)
    when 'html'
      case operator_id
      when 1028 #Megafonn
        Calls::HistoryParser::OperatorProcessor::Megafon
      when 1030 #MTS
        Calls::HistoryParser::OperatorProcessor::Mts
      else #MTS
        Calls::HistoryParser::OperatorProcessor::Mts
      end
    when 'xls', 'xlsx'
      case operator_id
      when 1025 #Beeline
        Calls::HistoryParser::OperatorProcessor::Bln
      when 1030 #MTS
        Calls::HistoryParser::OperatorProcessor::Mts
      else 
        Calls::HistoryParser::OperatorProcessor::Bln
      end
    when 'pdf'
      case operator_id
      when 1023 #Tele2
        Calls::HistoryParser::OperatorProcessor::Tele
      else 
        Calls::HistoryParser::OperatorProcessor::Tele
      end
    else
      raise(StandardError, "Wrong file type: #{file_type}")
    end      
  end
  
  def self.file_type(file)
#    raise(StandardError, file_type)    
    file_name_as_array = (file.public_methods.include?(:original_filename) ? file.original_filename.to_s.split('.') : file.path.to_s.split('.'))
    file_type = file_name_as_array[file_name_as_array.size - 1] if file_name_as_array
    file_type = file_type.downcase if file_type
  end
  
  
end

