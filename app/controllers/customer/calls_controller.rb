class Customer::CallsController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action -> {update_usage_pattern(params)}, only: [:set_calls_generation_params]
  before_action :setting_if_nil_default_calls_generation_params, only: [:set_calls_generation_params, :generate_calls]

  def set_default_calls_generation_params
    setting_default_calls_generation_params
    redirect_to customer_calls_set_calls_generation_params_path       
  end
  
  def set_calls_generation_params      
    update_location_data(params) 
  end
  
  def generate_calls
    Calls::Generator.new(self, customer_calls_generation_params, user_params).generate_calls
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
      Calls::GenerationParamsPresenter.new(Calls::Generator.new(self, customer_calls_generation_params, user_params), customer_calls_generation_params).report )
  end
  
  def setting_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id)[key]
      
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
        session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id)[key]  
         if key == :general
           new_usage_types = Calls::Generator.update_all_usage_patterns_based_on_general_usage_type(params[value.filtr_name]['phone_usage_type_id'])
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
        Calls::Generator.default_calls_generation_params(key, usage_pattern_id)[key]
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
  
  def user_params
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

end
