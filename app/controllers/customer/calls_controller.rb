class Customer::CallsController < ApplicationController
  include Crudable
  crudable_actions :index
  attr_accessor :message#, :background_process_informer_parsing
  before_action -> {update_usage_pattern(params)}, only: [:set_calls_generation_params]
  before_action :setting_if_nil_default_calls_generation_params, only: [:set_calls_generation_params, :generate_calls]
  before_action :init_background_process_informer_parsing, only: [:upload_call_history, :calculation_status]

  def calculation_status
    if !@background_process_informer_parsing.calculating?      
      redirect_to customer_calls_prepare_for_upload_path, :alert => (message || {})[:message]
    end
  end
  
  def prepare_for_upload
    flash[:alert] = saved_call_history_results['message']['message'] if saved_call_history_results and saved_call_history_results['message']
    call_history_saver.save({:result => {'message' => nil}})
  end
  
  def upload_call_history
    
    if true #optimization_params.session_filtr_params['calculate_on_background'] == 'true'
      @background_process_informer_parsing.clear_completed_process_info_model
      @background_process_informer_parsing.init(0, 100)
      
      Spawnling.new(:argv => "parsing_uploaded_file for #{current_user.id}") do
        begin
          uploaded_call_history = params[:call_history]
          message = parsing_uploaded_file(uploaded_call_history)
        rescue => e
          call_history_saver('Error on parsing_uploaded_file', current_user.id).({:result => {:error => e}})
          raise(e)
        ensure
          @background_process_informer_parsing.finish
        end            
      end     
      redirect_to(:action => :calculation_status)
    else
      uploaded_call_history = params[:call_history]
      message = parsing_uploaded_file(uploaded_call_history)
      redirect_to customer_calls_prepare_for_upload_path, :alert => (message || {})[:message]
    end
  end
  
  def init_background_process_informer_parsing
    @background_process_informer_parsing ||= ServiceHelper::BackgroundProcessInformer.new('parsing_uploaded_file', current_user.id)
#    @background_process_informer_parsing
  end
  
  def parsing_uploaded_file(uploaded_call_history)
    if uploaded_call_history
      call_history_saver.clean_output_results
      message = check_uploaded_call_history(uploaded_call_history)
      if message[:file_is_good]
        parser = Calls::CallHistoryParser.new(self, user_params_for_call_history_parser, uploaded_call_history, @background_process_informer_parsing)
        parser.parse#(5)
        processed_percent = parser.processed.size.to_f * 100.0 / (parser.original_row_number || 1.0).to_f
        message = {:file_is_good => false, :message => "Обработано #{processed_percent}%"}
        call_history_to_save = {
          'processed' => parser.processed,
          'unprocessed' => parser.unprocessed,
          'ignorred' => parser.ignorred,
          'message' => message,
#          'original_doc' => {'table_heads' => parser.table_heads, 'table_rows' => parser.table_rows},
        }
        call_history_saver.save({:result => call_history_to_save})
        Calls::CustomerCallSaver.save(parser.processed, current_user.id)
      end      
    else
      message = {:file_is_good => false, :message => "Вы не выбрали файл для загрузки"}
    end
    message
  end
  
  def check_uploaded_call_history(uploaded_call_history)
    result = {:file_is_good => true, :message => nil}
    file_size = (uploaded_call_history.size / 1000000.0).round(2) if uploaded_call_history
    result = {:file_is_good => false, :message => "Файл слишком большой: #{file_size}Mb. Он должен быть не больше 5Mb"} if file_size > 5.0
    file_type = uploaded_call_history.original_filename.to_s.split('.')[1]
    result = {:file_is_good => false, :message => "Файл неправильного типа #{file_type}. Он должен быть .html"} if file_type != "html"
#    raise(StandardError, uploaded_call_history) if uploaded_call_history
    result
  end
  
  def call_history_parsing_progress_bar
    ProgressBarable.new(self, 'call_history_parsing', @background_process_informer_parsing.current_values)
  end
  
  def saved_call_history
    @saved_call_history ||= ArrayOfHashable.new(self, saved_call_history_results['processed'])
  end
  
  def saved_call_history_unprocessed
    @saved_call_history_unprocessed ||= ArrayOfHashable.new(self, saved_call_history_results['unprocessed'])
  end
  
  def saved_call_history_ignorred
    @saved_call_history_ignorred ||= ArrayOfHashable.new(self, saved_call_history_results['ignorred'])
  end
  


  def parse_call_history
    
  end

  def call_history
    @call_history ||= ArrayOfHashable.new(self, call_history_parser.processed )
  end
  
  def call_history_unprocessed
    @call_history_unprocessed ||= ArrayOfHashable.new(self, call_history_parser.unprocessed )
  end
  
  def call_history_ignorred
    @call_history_ignorred ||= ArrayOfHashable.new(self, call_history_parser.ignorred)
  end
  
  def call_history_parser
    @parser ||= Calls::CallHistoryParser.new(self, user_params_for_call_history_parser, nil, true)
    @parser.parse(4000) if @parser.processed.blank?
    @parser
  end

  def set_default_calls_generation_params
    setting_default_calls_generation_params
    redirect_to customer_calls_set_calls_generation_params_path       
  end
  
  def set_calls_generation_params      
    update_location_data(params) 
  end
  
  def generate_calls
    calls_generator.new(self, customer_calls_generation_params, user_params_for_call_generator).generate_calls
    call_generation_param_saver('user_input').save({:result => customer_calls_generation_params})
    redirect_to customer_calls_path
  end
  
  def filtr
    @filtr ||= Filtrable.new(self, "customer_calls")
  end
  
  def customer_calls
    @customer_calls ||= Tableable.new(self, Customer::Call.where(:user_id => current_user.id).query_from_filtr(filtr.session_filtr_params))
  end
  
  def calls_gener_params_report
    @calls_gener_params_report ||= ArrayOfHashable.new(self, 
      Calls::CallGenerationParamsPresenter.new(calls_generator.new(self, customer_calls_generation_params, user_params_for_call_generator), customer_calls_generation_params).report )
  end
  
  def setting_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = calls_generator.default_calls_generation_params(key, usage_pattern_id)[key]
      
    end
  end
  
  def update_usage_pattern(params)
    old_usage_type = {}
    ['customer_calls_generation_params_general_filtr', 'customer_calls_generation_params_own_region_filtr', 'customer_calls_generation_params_home_region_filtr', 
      'customer_calls_generation_params_own_country_filtr', 'customer_calls_generation_params_abroad_filtr'].each do |rouming_type|
        old_usage_type[rouming_type] = session[:filtr][rouming_type]['phone_usage_type_id'].to_s if session[:filtr] and session[:filtr][rouming_type]
      end
    customer_calls_generation_params_filtr.each do |key, value|
      if params and params[value.filtr_name] and params[value.filtr_name]['phone_usage_type_id'] != old_usage_type[value.filtr_name]
        raise(StandardError, [old_usage_type[value.filtr_name], params[value.filtr_name]['phone_usage_type_id'], value.filtr_name, 
          session[:filtr][value.filtr_name]['phone_usage_type_id']]) if false
        usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
        session[:filtr][value.filtr_name] = calls_generator.default_calls_generation_params(key, usage_pattern_id)[key]  
         if key == :general
           new_usage_types = calls_generator.update_all_usage_patterns_based_on_general_usage_type(params[value.filtr_name]['phone_usage_type_id'])
           session[:filtr].merge!(new_usage_types)
#           raise(StandardError, [session[:filtr], new_usage_types])
           setting_default_calls_generation_params   
         end        
      end 
    end
  end
  
  def setting_if_nil_default_calls_generation_params
    saved_call_generation_param = call_generation_param_saver('user_input').results
    customer_calls_generation_params_filtr.each do |key, value|
#      raise(StandardError, saved_call_generation_param)
      session[:filtr][value.filtr_name] = if saved_call_generation_param.blank?
        usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
        calls_generator.default_calls_generation_params(key, usage_pattern_id)[key]
      else
        saved_call_generation_param[key.to_s]
      end  if session[:filtr][value.filtr_name].blank?
    end
  end
  
  def customer_calls_generation_params
    result = {}
    customer_calls_generation_params_filtr.keys.each do |key|
      result[key] = customer_calls_generation_params_filtr[key].session_filtr_params
    end
    result
  end
  
  def user_params_for_call_history_parser
#TODO исправить
    {
        :own_phone_number => '9999999999', 
        :operator_id => 0,
        :region_id => 0, 
        :country_id => 0, 
    }
  end
  
  def user_params_for_call_generator
    {
      "user_id" => current_user.id,
    }
  end
  
  def customer_calls_generation_params_filtr
    @customer_calls_generation_params_filtr ||= {}
    if @customer_calls_generation_params_filtr.blank?
      @customer_calls_generation_params_filtr[:general] = Filtrable.new(self, "customer_calls_generation_params_general")
      @customer_calls_generation_params_filtr[:own_region] = Filtrable.new(self, "customer_calls_generation_params_own_region")
      @customer_calls_generation_params_filtr[:home_region] = Filtrable.new(self, "customer_calls_generation_params_home_region")
      @customer_calls_generation_params_filtr[:own_country] = Filtrable.new(self, "customer_calls_generation_params_own_country")
      @customer_calls_generation_params_filtr[:abroad] = Filtrable.new(self, "customer_calls_generation_params_abroad")
    end
    @customer_calls_generation_params_filtr      
  end
  
  def calls_generator
    @calls_generator ||= Calls::Generation::Generator
  end
  
  def update_location_data(params)
    if params['customer_calls_generation_params_general_filtr']
      session[:current_user]["country_id"] = params['customer_calls_generation_params_general_filtr']['country_id']
      session[:current_user]["country_name"] = session[:current_user]["country_id"] ? Category.find(session[:current_user]["country_id"]).name : nil
       
      session[:current_user]["region_id"] = params['customer_calls_generation_params_general_filtr']['region_id']
      session[:current_user]["region_name"] = session[:current_user]["region_id"] ? Category.find(session[:current_user]["region_id"]).name : nil
    end
  end
  
  def call_generation_param_saver(name)
    @call_generation_param_saver ||= ServiceHelper::OptimizationResultSaver.new('call_generation_params', name, current_user.id)
    @call_generation_param_saver
  end

  def call_history_saver
    @call_history_saver ||= ServiceHelper::OptimizationResultSaver.new('call_history', 'call_history', current_user.id)
    @call_history_saver
  end
  
  def saved_call_history_results
    @saved_call_history_results ||= (call_history_saver.results || {'processed' => [{}], 'unprocessed' => [{}], 'ignorred' => [{}], 'original_doc' => [{}] } )
    @saved_call_history_results
  end
end
