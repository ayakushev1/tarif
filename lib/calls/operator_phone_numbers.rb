Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

class Calls::OperatorPhoneNumbers
  include Calls::OperatorPhoneNumbers::Ranges, Calls::OperatorPhoneNumbers::StartRanges
  
  def find_range(number)    
  	return nil if !number.is_a?(String)
  	length = number.length
  	return nil if length < 11
  	country_code = number.first(length - 10)
  	return nil if !['', '7', '+7', '07', '007'].include?(country_code)	
  	return nil if number.last(10) !~ /[0-9]{10}/
  	phone_without_country = number.last(10).to_i
  	
  	ranges = Calls::OperatorPhoneNumbers::StartRanges::START_RANGES
    phone_numbers = Calls::OperatorPhoneNumbers::Ranges::RANGES

    phone_range = ranges.select{|start, end_range| phone_without_country >= start.to_i and phone_without_country <= end_range.to_i}

  	if !phone_range.blank?
  	  hash_key = phone_range.to_a[0][0]
  	  result = phone_numbers[hash_key].merge({:country_id => _russia, :operator_type_id => _mobile})
#  	  raise(StandardError, result)
  	else 
  	  if phone_without_country >= 9000000000
  	    result = {:operator_id => 1035, :country_id => _russia, :operator_type_id => _mobile}
  	  else
  	    nil
  	  end
  	end
  end
end
