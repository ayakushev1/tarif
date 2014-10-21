class Demo::CallsController < Customer::CallsController

  def generate_calls
    Calls::Generator.new(self, customer_calls_generation_params, user_params).generate_calls
    redirect_to demo_calls_path
  end
  
end
