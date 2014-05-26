obj = Object.new
def obj.current_user
  User.find(2)
end
#obj.extend(Customer::Calls::Generation)
#TODO вернуть обратно
#obj.generate_calls(obj.default_calls_generation_params)
Calls::Generation::Generator.new(self).generate_calls
