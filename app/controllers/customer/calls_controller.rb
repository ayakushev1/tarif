class Customer::CallsController < ApplicationController
#  include Crudable
#  crudable_actions :index
  before_action :create_call_run_if_not_exists, only: [:set_calls_generation_params]
  before_action :update_usage_pattern, only: [:set_calls_generation_params]
  before_action :setting_if_nil_default_calls_generation_params, only: [:set_calls_generation_params, :generate_calls]
  after_action -> {update_customer_infos}, only: :generate_calls

  def set_default_calls_generation_params
    setting_default_calls_generation_params
    redirect_to customer_calls_set_calls_generation_params_path       
  end
  
  def set_calls_generation_params      
    update_location_data(params) 
  end
  
  def generate_calls
    Calls::Generator.new(customer_calls_generation_params, user_params).generate_calls
    Customer::CallRun.where(:id => customer_call_run_id).first_or_create.calculate_call_stat
    redirect_to tarif_optimizators_main_index_path
  end
  
  def update_customer_infos
    Customer::Info::CallsGenerationParams.update_info(current_or_guest_user_id, customer_calls_generation_params)
    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'calls_modelling_count')
    Customer::CallRun.find(customer_call_run_id).update(
      :operator_id => customer_calls_generation_params[:general]['operator_id'].to_i,
      :init_params => customer_calls_generation_params
    ) 
#    raise(StandardError, customer_calls_generation_params[:general]['operator_id']) 
  end
  
  def call_run_choice
    create_filtrable("call_run_choice")
  end
  
  def filtr
    @filtr ||= 
    create_filtrable("customer_calls")
  end
  
  def customer_calls
    user_filtr = (user_type == :admin ? 'true' : {:user_id => current_or_guest_user_id})
    options = {:base_name => 'customer_calls', :current_id_name => 'customer_call_id', :id_name => 'id', :pagination_per_page => 10}
    @customer_calls ||= 
    create_tableable(Customer::Call.includes(:base_service, :base_subservice, :user, :call_run).
      where(user_filtr).query_from_filtr(session_filtr_params(filtr)), options)
  end
  
  def calls_gener_params_report
    options = {:base_name => 'call_generation_params_report', :current_id_name => 'param', :id_name => 'param', :pagination_per_page => 20}
#    @calls_gener_params_report ||= 
    create_array_of_hashable(
      Calls::GenerationParamsPresenter.new(Calls::Generator.new(customer_calls_generation_params, user_params), customer_calls_generation_params).report, options )
  end
  
  def setting_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id)[key]
    end
  end
  
  def update_usage_pattern
    unchanged_params = params.dup
    old_usage_type = {}
    ['customer_calls_generation_params_general_filtr', 'customer_calls_generation_params_own_region_filtr', 'customer_calls_generation_params_home_region_filtr', 
      'customer_calls_generation_params_own_country_filtr', 'customer_calls_generation_params_abroad_filtr'].each do |rouming_type|
        old_usage_type[rouming_type] = session[:filtr][rouming_type]['phone_usage_type_id'].to_s if session[:filtr] and session[:filtr][rouming_type]
    end
    #raise(StandardError, [session[:filtr], unchanged_params])
    customer_calls_generation_params_filtr.each do |key, value|
      if unchanged_params and unchanged_params[value.filtr_name] and unchanged_params[value.filtr_name]['phone_usage_type_id'] != old_usage_type[value.filtr_name]
        
        raise(StandardError, [old_usage_type[value.filtr_name], unchanged_params[value.filtr_name]['phone_usage_type_id'], value.filtr_name, 
          session[:filtr][value.filtr_name]['phone_usage_type_id']]) if false
          
        usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
        session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id)[key]  
         if key == :general
           new_usage_types = Calls::Generator.update_all_usage_patterns_based_on_general_usage_type(unchanged_params[value.filtr_name]['phone_usage_type_id'])
           session[:filtr].merge!(new_usage_types)           
           setting_default_calls_generation_params   
         end        
      end 
    end
  end
  
  def setting_if_nil_default_calls_generation_params
    saved_call_generation_param = Customer::Info::CallsGenerationParams.info(current_or_guest_user_id)
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
      result[key] = session_filtr_params(customer_calls_generation_params_filtr[key])
    end
    result
  end
  
  def user_params
    {
      "user_id" => current_or_guest_user_id,
      "call_run_id" => customer_call_run_id
    }
  end
  
  def customer_calls_generation_params_filtr
    return {
      :general => create_filtrable("customer_calls_generation_params_general"),
      :own_region => create_filtrable("customer_calls_generation_params_own_region"),
      :home_region => create_filtrable("customer_calls_generation_params_home_region"),
      :own_country => create_filtrable("customer_calls_generation_params_own_country"),
      :abroad => create_filtrable("customer_calls_generation_params_abroad"),
    }      
=begin
    return @customer_calls_generation_params_filtr if @customer_calls_generation_params_filtr
    @customer_calls_generation_params_filtr ||= {}
    if @customer_calls_generation_params_filtr.blank?
      @customer_calls_generation_params_filtr[:general] = create_filtrable("customer_calls_generation_params_general")
      @customer_calls_generation_params_filtr[:own_region] = create_filtrable("customer_calls_generation_params_own_region")
      @customer_calls_generation_params_filtr[:home_region] = create_filtrable("customer_calls_generation_params_home_region")
      @customer_calls_generation_params_filtr[:own_country] = create_filtrable("customer_calls_generation_params_own_country")
      @customer_calls_generation_params_filtr[:abroad] = create_filtrable("customer_calls_generation_params_abroad")
    end
    @customer_calls_generation_params_filtr
=end          
  end
  
  def update_location_data(params)
    if params['customer_calls_generation_params_general_filtr']
      user_session["country_id"] = params['customer_calls_generation_params_general_filtr']['country_id']
      user_session["country_name"] = !user_session["country_id"].blank? ? ::Category.find(user_session["country_id"] ).name : nil
       
      user_session["region_id"] = params['customer_calls_generation_params_general_filtr']['region_id']
      user_session["region_name"] = !user_session["region_id"].blank? ? ::Category.find(user_session["region_id"] ).name : nil
    end
  end
  
  def customer_call_run_id
    session_filtr_params(call_run_choice)['customer_call_run_id'] ||
    Customer::CallRun.where(:user_id => current_or_guest_user_id).
      first_or_create(:name => "Моделирование звонков", :source => 0, :description => "", :user_id => current_or_guest_user_id).id  
  end
  
  def create_call_run_if_not_exists
    Customer::CallRun.min_new_call_run(user_type).times.each do |i|
      Customer::CallRun.create(:name => "Моделирование звонков №#{i}", :source => 1, :description => "", :user_id => current_or_guest_user_id)
    end  if !Customer::CallRun.where(:user_id => current_or_guest_user_id).present?
  end
end
