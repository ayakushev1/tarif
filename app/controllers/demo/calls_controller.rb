class Demo::CallsController < Customer::CallsController

  def generate_calls
    Calls::Generator.new(self, customer_calls_generation_params, user_params).generate_calls
    call_generation_param_saver('user_input').save({:result => customer_calls_generation_params})
    redirect_to demo_calls_path
  end
  

end
