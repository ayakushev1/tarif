class Customer::CallsController < ApplicationController
  include Crudable
  crudable_actions :index
#  attr_accessor :customer_calls_generation_params_filtr #:calls_generator
  before_action :setting_if_nil_default_calls_generation_params, only: [:set_calls_generation_params, :generate_calls]

  def set_default_calls_generation_params
    setting_default_calls_generation_params
    redirect_to customer_calls_set_calls_generation_params_path       
  end
  
  def set_calls_generation_params            
#    setting_if_nil_default_calls_generation_params
  end
  
  def generate_calls
#    raise(StandardError, customer_calls_generation_params)
#    setting_if_nil_default_calls_generation_params
    calls_generator.new(self, customer_calls_generation_params ).generate_calls
    redirect_to customer_calls_path
  end
  
  def filtr
    @filtr ||= Filtrable.new(self, "customer_calls")
  end
  
  def customer_calls
    @customer_calls ||= Tableable.new(self, Customer::Call.query_from_filtr(filtr.session_filtr_params))
  end
  
  def setting_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = calls_generator.default_calls_generation_params(key, usage_pattern_id)[key]
      
    end
  end
  
  def setting_if_nil_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = calls_generator.default_calls_generation_params(key, usage_pattern_id)[key] if session[:filtr][value.filtr_name].blank? 
    end
  end
  
  def customer_calls_generation_params
    result = {}
    customer_calls_generation_params_filtr.keys.each do |key|
      result[key] = customer_calls_generation_params_filtr[key].session_filtr_params
    end
    result
  end
  
  def customer_calls_generation_params_filtr
    @customer_calls_generation_params_filtr ||= {}
    if @customer_calls_generation_params_filtr.blank?
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
  
end
