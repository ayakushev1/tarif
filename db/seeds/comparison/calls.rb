Customer::CallRun.find_or_create_by(:id => 0).update(
  :user_id => nil, :source => 2, :name => 'Студент, только собственный и домашний регионы, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Student::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Student::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 1).update(
  :user_id => nil, :source => 2, :name => 'Студент, только собственный и домашний регионы, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Student::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Student::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 2).update(
  :user_id => nil, :source => 2, :name => 'Студент, только собственный и домашний регионы, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Student::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Student::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 3).update(
  :user_id => nil, :source => 2, :name => 'Студент, только собственный и домашний регионы, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Student::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Student::OwnAndHomeRegionsOnly)


Customer::CallRun.find_or_create_by(:id => 5).update(
  :user_id => nil, :source => 2, :name => 'Пенсионер, только собственный и домашний регионы, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 6).update(
  :user_id => nil, :source => 2, :name => 'Пенсионер, только собственный и домашний регионы, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 7).update(
  :user_id => nil, :source => 2, :name => 'Пенсионер, только собственный и домашний регионы, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 8).update(
  :user_id => nil, :source => 2, :name => 'Пенсионер, только собственный и домашний регионы, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly)

