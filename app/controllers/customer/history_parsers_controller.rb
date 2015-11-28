class Customer::HistoryParsersController < ApplicationController
  include Customer::HistoryParsersHelper, Customer::HistoryParsersBackgroundHelper
  helper Customer::HistoryParsersHelper, Customer::HistoryParsersBackgroundHelper
#  include Crudable
#  crudable_actions :index

  before_action :create_call_run_if_not_exists, only: [:prepare_for_upload]
  before_action :check_if_parsing_params_in_session, only: [:parse, :prepare_for_upload]
  before_action :call_history_saver_clean_output_results, only: [:parse, :upload]
  before_action :init_background_process_informer, only: [:upload, :calculation_status, :parse]
  after_action :track_upload, only: :upload
  after_action :track_prepare_for_upload, only: :prepare_for_upload

  helper_method :customer_history_parser

  def calculation_status
    if !background_process_informer.calculating?   
      redirect_to({:action => :prepare_for_upload})
    end
  end
  
  def parse
    local_call_history_file = File.open('tmp/megafon_small.html') 
    update_customer_infos
    message = Calls::HistoryParser::Runner.new(user_params, parsing_params).recalculate_direct(call_history_file, false) 
    redirect_to({:action => :prepare_for_upload}, {:notice => message})
  end

  def upload
    message = params[:call_history] ? check_uploaded_call_history_file(params[:call_history]) : {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
    if message[:file_is_good] == true       
      update_customer_infos
      if parsing_params[:calculate_on_background]
        message = Calls::HistoryParser::Runner.new(user_params, parsing_params).recalculate_on_back_ground(params[:call_history], true)
        if message[:file_is_good]
          redirect_to :action => :calculation_status 
        else
          redirect_to({:action => :prepare_for_upload}, {:notice => message})
        end
      else      
        message = Calls::HistoryParser::Runner.new(user_params, parsing_params).recalculate_direct(params[:call_history], true) 
        redirect_to({:action => :prepare_for_upload}, {:notice => message})
      end
    else
      text_message = (message.is_a?(Hash) and !message.blank?) ? message['message'] : message
      redirect_to( {:action => :prepare_for_upload}, {:alert => text_message})  
    end    
  end
    
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
