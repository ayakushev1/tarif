class Customer::HistoryParsersController < ApplicationController
  include Crudable
  crudable_actions :index

  before_action -> {customer_history_parser.check_if_parsing_params_in_session}, only: [:parse, :prepare_for_upload]
  before_action -> {customer_history_parser.init_background_process_informer}, only: [:upload, :calculation_status, :parse]
#  after_action -> {customer_history_parser.update_customer_infos}, only: :upload

  helper_method :customer_history_parser

  def calculation_status
    if !customer_history_parser.background_process_informer.calculating?     
      redirect_to({:action => :prepare_for_upload})#, {:alert => message})
    end
  end
  
  def parse
    local_call_history_file = File.open('tmp/beeline_original_3.XLS')
#    local_call_history_file = File.open('tmp/call_details_vgy_08092014.html')
    background_parser_processor(:parse_file, local_call_history_file)
  end

  def upload
    message = customer_history_parser.upload_file(params[:call_history])
    if message[:file_is_good] == true
      background_parser_processor(:parse_uploaded_file, params[:call_history])
    else
      redirect_to( {:action => :prepare_for_upload}, {:alert => message})  
    end    
  end
  
  def background_parser_processor(parser_starter, call_history_file)  
    customer_history_parser.call_history_saver.clean_output_results         
     
    if customer_history_parser.parsing_params[:calculate_on_background]
      customer_history_parser.recalculate_on_back_ground(parser_starter, call_history_file)
      redirect_to :action => :calculation_status
    else      
      message = customer_history_parser.recalculate_direct(parser_starter, call_history_file) 
      redirect_to({:action => :prepare_for_upload}, {:notice => message})
    end
  end
  
  def customer_history_parser
#    @customer_history_parser ||= 
    Customer::HistoryParser.new(self)
  end
  

end
