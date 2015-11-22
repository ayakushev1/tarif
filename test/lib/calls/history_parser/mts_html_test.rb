require 'test_helper'
#require 'lib/calls/history_parser/mts'

describe Calls::HistoryParser::OperatorProcessor::Mts do
  
  before do
    
   @parser = Calls::HistoryParser::OperatorProcessor::Mts.new(self, Calls::Generator.new({}, {"user_id" => 0}), nil)
#   @parser.parse(4000) if @parser.processed.blank?
    
  end
  
  describe 'take_out_special_symbols' do
    it 'must return' do
      string = 'Билайн; Свердловская область'
      @parser.take_out_special_symbols(string).must_be :==, ["билайн", "свердловская", "область"]
    end
  end  
  
  describe 'find_operator' do
    it 'must return' do
      string = 'БиЛайн; Свердловская область'
      arr_of_string = @parser.take_out_special_symbols(string)
      @parser.find_operator(arr_of_string).must_be :==, [1025, 5] 
    end
  end

  describe 'find_region' do
    it 'must return' do
      string = 'Билайн; Свердловская область'
      arr_of_string = @parser.take_out_special_symbols(string)
      @parser.find_region(arr_of_string).must_be :==, [1162, 24] #[arr_of_string, @parser.regions]
    end

    it 'must return' do
      string = 'Ленинградская'
      arr_of_string = @parser.take_out_special_symbols(string)
      region_index = @parser.find_region(arr_of_string)[1]
      country_id = @parser.regions[:country_ids][region_index]
      @parser.find_operator_by_country(country_id).must_be :==, 1030
    end
  end

  describe 'find_country' do
    it 'must return' do
      string = 'Египет: Etisalat'
      arr_of_string = @parser.take_out_special_symbols(string)
      @parser.find_country(arr_of_string).must_be :==, [1662, 64] #[arr_of_string, @parser.countries]
    end
  end

  describe 'find_operator_by_country' do
    it 'must return' do
      string = 'Украина: MTS UKR'
      arr_of_string = @parser.take_out_special_symbols(string)
      country_id = @parser.find_country(arr_of_string)[0]
      @parser.find_operator_by_country(country_id).must_be :==, 1031 #[arr_of_string, country_id, @parser.operators_by_country]
    end
  end
end

