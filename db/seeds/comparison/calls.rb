Customer::CallRun.find_or_create_by(:id => 0).update(
  :user_id => nil, :source => 2, :name => 'Студент, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Comparison::Call::Init::Student',:init_params => Customer::Call::Init::Student)

Customer::CallRun.find_or_create_by(:id => 1).update(
  :user_id => nil, :source => 2, :name => 'Студент, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Comparison::Call::Init::Student',:init_params => Customer::Call::Init::Student)

Customer::CallRun.find_or_create_by(:id => 2).update(
  :user_id => nil, :source => 2, :name => 'Студент, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Comparison::Call::Init::Student',:init_params => Customer::Call::Init::Student)

Customer::CallRun.find_or_create_by(:id => 3).update(
  :user_id => nil, :source => 2, :name => 'Студент, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Comparison::Call::Init::Student',:init_params => Customer::Call::Init::Student)

