class Demo::CallsController < Customer::CallsController
  after_action :track_generate_calls, only: :generate_calls
  after_action :track_set_calls_generation_params, only: :set_calls_generation_params
  after_action :track_index, only: :index

  def generate_calls
    Calls::Generator.new(self, customer_calls_generation_params, user_params).generate_calls
    redirect_to demo_calls_path
  end
  
  private
  
  def track_generate_calls
    ahoy.track "#{controller_name}/#{action_name}", {
      'flash' => flash,
      'customer_calls_generation_params' => customer_calls_generation_params, 
      'user_params' => user_params,
      }
  end

  def track_set_calls_generation_params
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end

  def track_index
    ahoy.track("#{controller_name}/#{action_name}", {
      'flash' => flash,      
    }) if params.count == 2
  end
end
