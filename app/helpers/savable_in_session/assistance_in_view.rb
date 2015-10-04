module SavableInSession::AssistanceInView 

  def set_fields (&block)
    @fields = block
  end
  
  def fields(*arg)
    content = @fields.call(*arg) if @fields
    if content.kind_of?(Array)
#      raise(StandardError)
      content.collect { |f| yield f }
    else
      content
    end    
  end
  
  def init
    yield(self)
  end
  
  def [](key)
    instance_variable_get(:"@#{key.to_s}")
  end

  def []=(key, value)
    instance_variable_set(:"@#{key.to_s}", value)
  end
  
  def symbolyze(value)
    case 
    when value.kind_of?(Hash)
      symbolyze_hash(value) 
    when value.kind_of?(Array)
      symbolyze_array(value)
    else
      value 
    end
  end

  def symbolyze_hash(hash)
    hash.each do |key, value|
      if key.kind_of?(String)
        hash[key] = nil
        hash[key.to_sym] = value
      end
      case 
      when value.kind_of?(Hash)
        symbolyze_hash(value) 
      when value.kind_of?(Array)
        symbolyze_array(value)
      else
        value 
      end
    end
  end

  def symbolyze_array(arr)
    arr.collect do |item|
      symbolyze(item)
    end
  end

end
