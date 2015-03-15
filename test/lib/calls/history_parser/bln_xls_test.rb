require 'test_helper'

describe Calls::HistoryParser::OperatorProcessor::Bln < ActiveSupport::TestCase do
  @@parser_bln_xls_test = Calls::HistoryParser::OperatorProcessor::Bln.new(File.open('tmp/beeline_original_2.XLS'), {"user_id" => 0}, {
    :call_history_max_line_to_process => 5000,
    :background_update_frequency => 100,
  })
  
  before do
#    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
#    @user.skip_confirmation_notification!
#    @user.save!(validate: false)
#    sign_in @user
    
#    @parser = Calls::HistoryParser::BlnXls.new(File.open('tmp/beeline.XLS'), {"user_id" => 0}, {})
#   @parser.parse(4000) if @parser.processed.blank?
    
  end

=begin  
  describe 'table_heads_row' do
    it 'must return row of head if head exist and correct' do
      head_row = ['Дата звонка', 'Время звонка', 'Инициатор звонка', 'Набранный номер', 'Тип звонка', 'Услуга', 'Предварительная стоимость (без НДС)', 'Продолжительность', 'Объем (MB)', 'Номер БС']
      @@parser_bln_xls_test.table_heads_row(head_row).must_be :>=, -1 #@parser.table_heads_row
    end
  end  

  describe 'row_column_index' do
    it 'must return ids of column' do
      @@parser_bln_xls_test.row_column_index.values.include?(nil).must_be :==, false #@parser.table_heads_row
    end
  end  

  describe 'row_column_index' do
    it 'must return ids of column' do
      row = @@parser_bln_xls_test.doc_sheet.row(3411)
      @@parser_bln_xls_test.row_date(row).must_be :==, "invalid_date" 
#      @parser.volume(row).must_be :==, row 
    end
  end
  
  describe 'dup_row_calls' do
    it 'must return row and dup_row' do
      row, dup_row = @@parser_bln_xls_test.dup_row_calls(2097) 
      [_inbound, _outbound].include?(@@parser_bln_xls_test.row_service(row)[:subservice]).must_be :==, true
      [_inbound, _outbound].include?(@@parser_bln_xls_test.row_service(dup_row)[:subservice]).must_be :==, false
    end
  end
  
  describe 'row_number' do
    it 'must return for internet init phone and unspecified direction' do
      row = @@parser_bln_xls_test.doc_sheet.row(6)
      @@parser_bln_xls_test.row_number(row).must_be :==, {:number => '85.115.245.243', :subservice => _unspecified_direction} 
    end

    it 'must return for internet init phone and unspecified direction' do
      row = @@parser_bln_xls_test.doc_sheet.row(11)
#      service = @@parser_bln_xls_test.row_service(row)
#      service[:subservice].must_be :==, row#[:number_init]
      @@parser_bln_xls_test.row_number(row).must_be :==, {:number=>"79260012031", :subservice=>71, :code=>926, :start_range=>9260000000, :end_range=>9260999999, :operator_id=>1028, :city_id=>1238, :region_id=>1238, :country_id=>1100, :operator_type_id=>170}  
    end

    it 'must return for internet init phone and unspecified direction' do
      row = @@parser_bln_xls_test.doc_sheet.row(12)
      @@parser_bln_xls_test.row_number(row).must_be :==, {:number=>"79036101404", :subservice=>70, :code=>903, :start_range=>9036100000, :end_range=>9036299999, :operator_id=>1025, :city_id=>1238, :region_id=>1238, :country_id=>1100, :operator_type_id=>170}  
    end
  end
  
  describe 'row_partner' do
    it 'must return row and dup_row' do
#      row, dup_row = @@parser_bln_xls_test.dup_row_calls(11) 
#      @@parser_bln_xls_test.row_partner(row, dup_row).must_be :==, true
    end
  end
=end

  describe 'parse' do
    it 'must return row and dup_row' do
      result = @@parser_bln_xls_test.parse
      result.must_be :==, true
    end
  end
end

