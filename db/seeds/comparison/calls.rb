Customer::CallRun.find_or_create_by(:id => 0).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 1).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 2).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 3).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)


Customer::CallRun.find_or_create_by(:id => 5).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 6).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 7).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 8).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)


Customer::CallRun.find_or_create_by(:id => 10).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 11).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 12).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 13).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)



Customer::CallRun.find_or_create_by(:id => 20).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 21).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 22).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 23).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)


Customer::CallRun.find_or_create_by(:id => 25).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 26).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 27).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 28).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)


Customer::CallRun.find_or_create_by(:id => 30).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Tele2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 31).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Beeline', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 32).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Megafon', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 33).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, MTS', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

