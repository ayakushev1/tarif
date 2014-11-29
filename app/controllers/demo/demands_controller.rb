class Demo::DemandsController < ApplicationController

  before_action :check_if_user_spaming_site, only: [:new, :create]
  before_action :build_demand, only: [:new, :create]
  after_action :track_new, only: :new
  after_action :track_create, only: :create

  def create    
    if @demand.save        
      UserMailer.send_mail_to_admin_about_new_customer_demand(@demand).deliver
      redirect_to root_path, {:alert => "Спасибо за обращение. Мы рассмотрим его и в случае необходимости сообщим вам о результатах"}
    else
      render 'new'
    end
  end
  
  private
  
    def build_demand      
      if params[:demo_demand]
        @demand = Demo::Demand.new({:customer_id => current_user.id, :status_id => demand_is_received_from_customer}.merge(params[:demo_demand].permit!))
      else
        @demand = Demo::Demand.new()
      end
      
    end
    
    def check_if_user_spaming_site
      max_unprocessed_customer_demands = 3
      user_demand_count = Demo::Demand.where({:customer_id => current_user.id, :status_id => demand_is_received_from_customer}).count
      if user_demand_count >= max_unprocessed_customer_demands
        redirect_to root_path, {:alert => "Вы слишком часто пишите нам сообщения. Наберитесь терпения - мы рассмотрим ваше обращение"}
      end
    end
    
    def demand_is_received_from_customer
      350
    end

    def track_new
      ahoy.track("#{controller_name}/#{action_name}", {
        'flash' => flash,      
        'params' => params,
      })
    end
  
    def track_create
      ahoy.track("#{controller_name}/#{action_name}", {
        'flash' => flash,      
        'params' => params,
      })
    end
  
  
end
