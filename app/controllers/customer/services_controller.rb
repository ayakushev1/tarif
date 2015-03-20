class Customer::ServicesController < ApplicationController
#  include Crudable
#  crudable_actions :index
  before_action :check_current_id, :set_current_statistic_details
  attr_reader :bench

  def calculate_statistic
    filtr = {:user_id => current_user.id, :phone_number => session[:current_id]['consolidated_customer_service_id'].to_s}
    tarif_class_ids = Customer::Service.where(filtr).pluck(:tarif_class_id)
    TarifOptimization::QueryConstructor.new(self, {:tarif_class_ids => tarif_class_ids, :user_id => user_id}).
      calculate_stat(Customer::Stat, filtr, {'count' => "count(id)", 'array_agg' => "array_agg(id)"})    #array_agg

    redirect_to :action => :index
  end
  
  def consolidate_customer_services
    Customer::Service.includes(:user).
      select(:user_id, :phone_number).where(:user_id => current_user.id).group(:user_id, :phone_number)
  end

  def customer_services
    Tableable.new(self, Customer::Service.includes(:user, :tarif_class, :tarif_list, :status ).
      where(:user_id => current_user.id, :phone_number => session[:current_id]['consolidated_customer_service_id'].to_s) )
  end
  
  def customer_calls
    current_customer_service = customer_services.model.where(:id => session[:current_id]['customer_service_id']).first
    tarif_class_id = current_customer_service.tarif_class_id if current_customer_service
    query_constructor = TarifOptimization::QueryConstructor.new(self, {:tarif_class_ids => [tarif_class_id], :user_id => user_id})
    @bench = query_constructor.bench
    call_ids = query_constructor.call_ids_by_tarif_class_id[(tarif_class_id || 0)] if query_constructor.call_ids_by_tarif_class_id
    Tableable.new(self, Customer::Call.includes(:base_service, :base_subservice, :user).where(:id => call_ids) )
  end

  def stats
    Tableable.new(self, Customer::Stat.includes(:user).
      where(:user_id => current_user.id, :phone_number => session[:current_id]['consolidated_customer_service_id']).
      order(:phone_number, :stat_from) )
  end

  def set_current_statistic_details
    @fq_tarif_operator_id = 1025
    @fq_tarif_region_id = 1238

  end

  def check_current_id
    session[:current_id] ||= {}
    if params[:current_id] and params[:current_id]['consolidated_customer_service_id']
      session[:current_id]['consolidated_customer_service_id'] = params[:current_id]['consolidated_customer_service_id']
    end
  end    

end
