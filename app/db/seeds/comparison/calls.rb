# :source - источник звонков: детализация, моделирование или рейтинги
#For ОЭСР in home region rating
Customer::CallRun.find_or_create_by(:id => 0).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 1).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 2).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 3).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только собственный и домашний регионы, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly)


Customer::CallRun.find_or_create_by(:id => 5).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 6).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 7).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 8).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только собственный и домашний регионы, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly)


Customer::CallRun.find_or_create_by(:id => 10).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 11).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 12).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)

Customer::CallRun.find_or_create_by(:id => 13).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только собственный и домашний регионы, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly)


#For ОЭСР in own country rating
Customer::CallRun.find_or_create_by(:id => 20).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 21).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 22).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 23).update(
  :user_id => nil, :source => 2, :name => 'Малая корзина, только своя страна, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::SmallBasket::OwnCountryOnly',:init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly)


Customer::CallRun.find_or_create_by(:id => 25).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 26).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 27).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 28).update(
  :user_id => nil, :source => 2, :name => 'Средняя корзина, только своя страна, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::MiddleBasket::OwnCountryOnly',:init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly)


Customer::CallRun.find_or_create_by(:id => 30).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 31).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 32).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

Customer::CallRun.find_or_create_by(:id => 33).update(
  :user_id => nil, :source => 2, :name => 'Дорогая корзина, только своя страна, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::ExpensiveBasket::OwnCountryOnly',:init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly)

#For internet in home region rating
Customer::CallRun.find_or_create_by(:id => 40).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb100',:init_params => Customer::Call::Init::Internet::Mb100)

Customer::CallRun.find_or_create_by(:id => 41).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb100',:init_params => Customer::Call::Init::Internet::Mb100)

Customer::CallRun.find_or_create_by(:id => 42).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb100',:init_params => Customer::Call::Init::Internet::Mb100)

Customer::CallRun.find_or_create_by(:id => 43).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb100',:init_params => Customer::Call::Init::Internet::Mb100)


Customer::CallRun.find_or_create_by(:id => 50).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb300',:init_params => Customer::Call::Init::Internet::Mb300)

Customer::CallRun.find_or_create_by(:id => 51).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb300',:init_params => Customer::Call::Init::Internet::Mb300)

Customer::CallRun.find_or_create_by(:id => 52).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb300',:init_params => Customer::Call::Init::Internet::Mb300)

Customer::CallRun.find_or_create_by(:id => 53).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb300',:init_params => Customer::Call::Init::Internet::Mb300)


Customer::CallRun.find_or_create_by(:id => 60).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb500',:init_params => Customer::Call::Init::Internet::Mb500)

Customer::CallRun.find_or_create_by(:id => 61).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb500',:init_params => Customer::Call::Init::Internet::Mb500)

Customer::CallRun.find_or_create_by(:id => 62).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb500',:init_params => Customer::Call::Init::Internet::Mb500)

Customer::CallRun.find_or_create_by(:id => 63).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb500',:init_params => Customer::Call::Init::Internet::Mb500)


Customer::CallRun.find_or_create_by(:id => 70).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb1000',:init_params => Customer::Call::Init::Internet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 71).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb1000',:init_params => Customer::Call::Init::Internet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 72).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb1000',:init_params => Customer::Call::Init::Internet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 73).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb1000',:init_params => Customer::Call::Init::Internet::Mb1000)


Customer::CallRun.find_or_create_by(:id => 80).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb2000',:init_params => Customer::Call::Init::Internet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 81).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb2000',:init_params => Customer::Call::Init::Internet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 82).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb2000',:init_params => Customer::Call::Init::Internet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 83).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb2000',:init_params => Customer::Call::Init::Internet::Mb2000)


Customer::CallRun.find_or_create_by(:id => 90).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb3000',:init_params => Customer::Call::Init::Internet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 91).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb3000',:init_params => Customer::Call::Init::Internet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 92).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb3000',:init_params => Customer::Call::Init::Internet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 93).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb3000',:init_params => Customer::Call::Init::Internet::Mb3000)


Customer::CallRun.find_or_create_by(:id => 100).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb5000',:init_params => Customer::Call::Init::Internet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 101).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb5000',:init_params => Customer::Call::Init::Internet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 102).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb5000',:init_params => Customer::Call::Init::Internet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 103).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb5000',:init_params => Customer::Call::Init::Internet::Mb5000)


Customer::CallRun.find_or_create_by(:id => 110).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb10000',:init_params => Customer::Call::Init::Internet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 111).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb10000',:init_params => Customer::Call::Init::Internet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 112).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb10000',:init_params => Customer::Call::Init::Internet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 113).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb10000',:init_params => Customer::Call::Init::Internet::Mb10000)


Customer::CallRun.find_or_create_by(:id => 120).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb15000',:init_params => Customer::Call::Init::Internet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 121).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb15000',:init_params => Customer::Call::Init::Internet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 122).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb15000',:init_params => Customer::Call::Init::Internet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 123).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb15000',:init_params => Customer::Call::Init::Internet::Mb15000)


Customer::CallRun.find_or_create_by(:id => 130).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb20000',:init_params => Customer::Call::Init::Internet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 131).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb20000',:init_params => Customer::Call::Init::Internet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 132).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb20000',:init_params => Customer::Call::Init::Internet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 133).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb20000',:init_params => Customer::Call::Init::Internet::Mb20000)


Customer::CallRun.find_or_create_by(:id => 140).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, только регион подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Internet::Mb30000',:init_params => Customer::Call::Init::Internet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 141).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, только регион подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Internet::Mb30000',:init_params => Customer::Call::Init::Internet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 142).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, только регион подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Internet::Mb30000',:init_params => Customer::Call::Init::Internet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 143).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, только регион подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Internet::Mb30000',:init_params => Customer::Call::Init::Internet::Mb30000)
  


#For internet in own country rating
Customer::CallRun.find_or_create_by(:id => 150).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb100',:init_params => Customer::Call::Init::CountryInternet::Mb100)

Customer::CallRun.find_or_create_by(:id => 151).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb100',:init_params => Customer::Call::Init::CountryInternet::Mb100)

Customer::CallRun.find_or_create_by(:id => 152).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb100',:init_params => Customer::Call::Init::CountryInternet::Mb100)

Customer::CallRun.find_or_create_by(:id => 153).update(
  :user_id => nil, :source => 2, :name => '100 Мб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb100',:init_params => Customer::Call::Init::CountryInternet::Mb100)


Customer::CallRun.find_or_create_by(:id => 160).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb300',:init_params => Customer::Call::Init::CountryInternet::Mb300)

Customer::CallRun.find_or_create_by(:id => 161).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb300',:init_params => Customer::Call::Init::CountryInternet::Mb300)

Customer::CallRun.find_or_create_by(:id => 162).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb300',:init_params => Customer::Call::Init::CountryInternet::Mb300)

Customer::CallRun.find_or_create_by(:id => 163).update(
  :user_id => nil, :source => 2, :name => '300 Мб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb300',:init_params => Customer::Call::Init::CountryInternet::Mb300)


Customer::CallRun.find_or_create_by(:id => 170).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb500',:init_params => Customer::Call::Init::CountryInternet::Mb500)

Customer::CallRun.find_or_create_by(:id => 171).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb500',:init_params => Customer::Call::Init::CountryInternet::Mb500)

Customer::CallRun.find_or_create_by(:id => 172).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb500',:init_params => Customer::Call::Init::CountryInternet::Mb500)

Customer::CallRun.find_or_create_by(:id => 173).update(
  :user_id => nil, :source => 2, :name => '500 Мб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb500',:init_params => Customer::Call::Init::CountryInternet::Mb500)


Customer::CallRun.find_or_create_by(:id => 180).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb1000',:init_params => Customer::Call::Init::CountryInternet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 181).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb1000',:init_params => Customer::Call::Init::CountryInternet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 182).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb1000',:init_params => Customer::Call::Init::CountryInternet::Mb1000)

Customer::CallRun.find_or_create_by(:id => 183).update(
  :user_id => nil, :source => 2, :name => '1 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb1000',:init_params => Customer::Call::Init::CountryInternet::Mb1000)


Customer::CallRun.find_or_create_by(:id => 190).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb2000',:init_params => Customer::Call::Init::CountryInternet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 191).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb2000',:init_params => Customer::Call::Init::CountryInternet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 192).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb2000',:init_params => Customer::Call::Init::CountryInternet::Mb2000)

Customer::CallRun.find_or_create_by(:id => 193).update(
  :user_id => nil, :source => 2, :name => '2 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb2000',:init_params => Customer::Call::Init::CountryInternet::Mb2000)


Customer::CallRun.find_or_create_by(:id => 200).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb3000',:init_params => Customer::Call::Init::CountryInternet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 201).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb3000',:init_params => Customer::Call::Init::CountryInternet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 202).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb3000',:init_params => Customer::Call::Init::CountryInternet::Mb3000)

Customer::CallRun.find_or_create_by(:id => 203).update(
  :user_id => nil, :source => 2, :name => '3 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb3000',:init_params => Customer::Call::Init::CountryInternet::Mb3000)


Customer::CallRun.find_or_create_by(:id => 210).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb5000',:init_params => Customer::Call::Init::CountryInternet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 211).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb5000',:init_params => Customer::Call::Init::CountryInternet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 212).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb5000',:init_params => Customer::Call::Init::CountryInternet::Mb5000)

Customer::CallRun.find_or_create_by(:id => 213).update(
  :user_id => nil, :source => 2, :name => '5 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb5000',:init_params => Customer::Call::Init::CountryInternet::Mb5000)


Customer::CallRun.find_or_create_by(:id => 220).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb10000',:init_params => Customer::Call::Init::CountryInternet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 221).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb10000',:init_params => Customer::Call::Init::CountryInternet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 222).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb10000',:init_params => Customer::Call::Init::CountryInternet::Mb10000)

Customer::CallRun.find_or_create_by(:id => 223).update(
  :user_id => nil, :source => 2, :name => '10 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb10000',:init_params => Customer::Call::Init::CountryInternet::Mb10000)


Customer::CallRun.find_or_create_by(:id => 230).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb15000',:init_params => Customer::Call::Init::CountryInternet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 231).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb15000',:init_params => Customer::Call::Init::CountryInternet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 232).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb15000',:init_params => Customer::Call::Init::CountryInternet::Mb15000)

Customer::CallRun.find_or_create_by(:id => 233).update(
  :user_id => nil, :source => 2, :name => '15 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb15000',:init_params => Customer::Call::Init::CountryInternet::Mb15000)


Customer::CallRun.find_or_create_by(:id => 240).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb20000',:init_params => Customer::Call::Init::CountryInternet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 241).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb20000',:init_params => Customer::Call::Init::CountryInternet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 242).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb20000',:init_params => Customer::Call::Init::CountryInternet::Mb20000)

Customer::CallRun.find_or_create_by(:id => 243).update(
  :user_id => nil, :source => 2, :name => '20 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb20000',:init_params => Customer::Call::Init::CountryInternet::Mb20000)


Customer::CallRun.find_or_create_by(:id => 250).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, за пределами региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb30000',:init_params => Customer::Call::Init::CountryInternet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 251).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, за пределами региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb30000',:init_params => Customer::Call::Init::CountryInternet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 252).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, за пределами региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb30000',:init_params => Customer::Call::Init::CountryInternet::Mb30000)

Customer::CallRun.find_or_create_by(:id => 253).update(
  :user_id => nil, :source => 2, :name => '30 Гб интернета, за пределами региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::CountryInternet::Mb30000',:init_params => Customer::Call::Init::CountryInternet::Mb30000)






#Calls only in own region
Customer::CallRun.find_or_create_by(:id => 300).update(
  :user_id => nil, :source => 2, :name => '120 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min120',:init_params => Customer::Call::Init::Calls::Min120)

Customer::CallRun.find_or_create_by(:id => 301).update(
  :user_id => nil, :source => 2, :name => '120 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min120',:init_params => Customer::Call::Init::Calls::Min120)

Customer::CallRun.find_or_create_by(:id => 302).update(
  :user_id => nil, :source => 2, :name => '120 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min120',:init_params => Customer::Call::Init::Calls::Min120)

Customer::CallRun.find_or_create_by(:id => 303).update(
  :user_id => nil, :source => 2, :name => '120 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min120',:init_params => Customer::Call::Init::Calls::Min120)


Customer::CallRun.find_or_create_by(:id => 310).update(
  :user_id => nil, :source => 2, :name => '300 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min300',:init_params => Customer::Call::Init::Calls::Min300)

Customer::CallRun.find_or_create_by(:id => 311).update(
  :user_id => nil, :source => 2, :name => '300 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min300',:init_params => Customer::Call::Init::Calls::Min300)

Customer::CallRun.find_or_create_by(:id => 312).update(
  :user_id => nil, :source => 2, :name => '300 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min300',:init_params => Customer::Call::Init::Calls::Min300)

Customer::CallRun.find_or_create_by(:id => 313).update(
  :user_id => nil, :source => 2, :name => '300 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min300',:init_params => Customer::Call::Init::Calls::Min300)


Customer::CallRun.find_or_create_by(:id => 320).update(
  :user_id => nil, :source => 2, :name => '600 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min600',:init_params => Customer::Call::Init::Calls::Min600)

Customer::CallRun.find_or_create_by(:id => 321).update(
  :user_id => nil, :source => 2, :name => '600 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min600',:init_params => Customer::Call::Init::Calls::Min600)

Customer::CallRun.find_or_create_by(:id => 322).update(
  :user_id => nil, :source => 2, :name => '600 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min600',:init_params => Customer::Call::Init::Calls::Min600)

Customer::CallRun.find_or_create_by(:id => 323).update(
  :user_id => nil, :source => 2, :name => '600 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min600',:init_params => Customer::Call::Init::Calls::Min600)


Customer::CallRun.find_or_create_by(:id => 330).update(
  :user_id => nil, :source => 2, :name => '1000 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min1000',:init_params => Customer::Call::Init::Calls::Min1000)

Customer::CallRun.find_or_create_by(:id => 331).update(
  :user_id => nil, :source => 2, :name => '1000 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min1000',:init_params => Customer::Call::Init::Calls::Min1000)

Customer::CallRun.find_or_create_by(:id => 332).update(
  :user_id => nil, :source => 2, :name => '1000 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min1000',:init_params => Customer::Call::Init::Calls::Min1000)

Customer::CallRun.find_or_create_by(:id => 333).update(
  :user_id => nil, :source => 2, :name => '1000 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min1000',:init_params => Customer::Call::Init::Calls::Min1000)


Customer::CallRun.find_or_create_by(:id => 340).update(
  :user_id => nil, :source => 2, :name => '1500 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min1500',:init_params => Customer::Call::Init::Calls::Min1500)

Customer::CallRun.find_or_create_by(:id => 341).update(
  :user_id => nil, :source => 2, :name => '1500 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min1500',:init_params => Customer::Call::Init::Calls::Min1500)

Customer::CallRun.find_or_create_by(:id => 342).update(
  :user_id => nil, :source => 2, :name => '1500 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min1500',:init_params => Customer::Call::Init::Calls::Min1500)

Customer::CallRun.find_or_create_by(:id => 343).update(
  :user_id => nil, :source => 2, :name => '1500 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min1500',:init_params => Customer::Call::Init::Calls::Min1500)


Customer::CallRun.find_or_create_by(:id => 350).update(
  :user_id => nil, :source => 2, :name => '2000 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min2000',:init_params => Customer::Call::Init::Calls::Min2000)

Customer::CallRun.find_or_create_by(:id => 351).update(
  :user_id => nil, :source => 2, :name => '2000 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min2000',:init_params => Customer::Call::Init::Calls::Min2000)

Customer::CallRun.find_or_create_by(:id => 352).update(
  :user_id => nil, :source => 2, :name => '2000 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min2000',:init_params => Customer::Call::Init::Calls::Min2000)

Customer::CallRun.find_or_create_by(:id => 353).update(
  :user_id => nil, :source => 2, :name => '2000 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min2000',:init_params => Customer::Call::Init::Calls::Min2000)


Customer::CallRun.find_or_create_by(:id => 360).update(
  :user_id => nil, :source => 2, :name => '3000 минут звонков, только в пределах региона подключения, Теле2', :description => "", :operator_id => Category::Operator::Const::Tele2,
  :init_class => 'Customer::Call::Init::Calls::Min3000',:init_params => Customer::Call::Init::Calls::Min3000)

Customer::CallRun.find_or_create_by(:id => 361).update(
  :user_id => nil, :source => 2, :name => '3000 минут звонков, только в пределах региона подключения, Билайн', :description => "", :operator_id => Category::Operator::Const::Beeline,
  :init_class => 'Customer::Call::Init::Calls::Min3000',:init_params => Customer::Call::Init::Calls::Min3000)

Customer::CallRun.find_or_create_by(:id => 362).update(
  :user_id => nil, :source => 2, :name => '3000 минут звонков, только в пределах региона подключения, Мегафон', :description => "", :operator_id => Category::Operator::Const::Megafon,
  :init_class => 'Customer::Call::Init::Calls::Min3000',:init_params => Customer::Call::Init::Calls::Min3000)

Customer::CallRun.find_or_create_by(:id => 363).update(
  :user_id => nil, :source => 2, :name => '3000 минут звонков, только в пределах региона подключения, МТС', :description => "", :operator_id => Category::Operator::Const::Mts,
  :init_class => 'Customer::Call::Init::Calls::Min3000',:init_params => Customer::Call::Init::Calls::Min3000)
