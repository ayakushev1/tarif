class Customer::HistoryParsersController < ApplicationController
  include Customer::HistoryParsersHelper
#  include Crudable
#  crudable_actions :index

  before_action :check_if_parsing_params_in_session, only: [:parse, :prepare_for_upload]
  before_action :init_background_process_informer, only: [:upload, :calculation_status, :parse]
#  after_action :update_customer_infos, only: :upload
  after_action :track_upload, only: :upload
  after_action :track_prepare_for_upload, only: :prepare_for_upload

  helper_method :customer_history_parser

  def calculation_status
    if !background_process_informer.calculating?   
#      message = call_history_results['message']
#      raise(StandardError, call_history_results['message'])
      redirect_to({:action => :prepare_for_upload})#, {:alert => message, :notice => message})
    end
  end
  
  def parse
#    local_call_history_file = File.open('tmp/beeline_original_3.XLS') #Beeline
#    local_call_history_file = File.open('tmp/call_details_vgy_08092014.html') #MTS 
#    local_call_history_file = File.open('tmp/mts_small.html') #MTS 
    local_call_history_file = File.open('tmp/megafon_small.html') #Megafon
#    local_call_history_file = File.open('tmp/megafon_big.html') #Megafon
    background_parser_processor(:parse_file, local_call_history_file)
  end

  def upload
    message = upload_file(params[:call_history])
    if message[:file_is_good] == true
#      raise(StandardError, message)
      background_parser_processor(:parse_uploaded_file, params[:call_history])
    else
      text_message = (message.is_a?(Hash) and !message.blank?) ? message['message'] : message
      redirect_to( {:action => :prepare_for_upload}, {:alert => text_message})  
    end    
  end
  
  def background_parser_processor(parser_starter, call_history_file)  
    call_history_saver.clean_output_results         
     
    if parsing_params[:calculate_on_background]
      recalculate_on_back_ground(parser_starter, call_history_file)
      redirect_to :action => :calculation_status
    else      
      message = recalculate_direct(parser_starter, call_history_file) 
      redirect_to({:action => :prepare_for_upload}, {:notice => message})
    end
  end
  
#  def customer_history_parser
#    @customer_history_parser ||= 
#    Customer::HistoryParser.new(self)
#  end
  
  private
  
  def track_upload
#    ahoy.track "#{controller_name}/#{action_name}", {
#      'flash' => flash,
#      'parsing_params' => parsing_params, 
#      'user_params' => user_params,
#      }
  end

  def track_prepare_for_upload
#    ahoy.track("#{controller_name}/#{action_name}", {
#      :flash => flash
#    }) if params.count == 2
  end

end
