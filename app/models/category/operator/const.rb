module Category::Operator::Const
  Category::Operator::Const::Russian_operators = 3001
  Category::Operator::Const::Foreign_operators = 3002
  Category::Operator::Const::OperatorsWithTarifs = [1023, 1025, 1028, 1030]
  Category::Operator::Const::OperatorsWithParsing = [1023, 1025, 1028, 1030]
  Category::Operator::Const::OperatorsForOptimization = [1023, 1025, 1028, 1030]
  Category::Operator::Const::Tele2 = 1023
  Category::Operator::Const::Beeline = 1025
  Category::Operator::Const::Megafon = 1028
  Category::Operator::Const::Mts = 1030
  Category::Operator::Const::MtsUkrain = 1031
  Category::Operator::Const::KievStar = 1027
  Category::Operator::Const::FixedlineOperator = 1034
  Category::Operator::Const::OtherRusianOperator = 1035
  Category::Operator::Const::RusianOperatorsGroup = [Category::Operator::Const::Tele2, Category::Operator::Const::Beeline, 
    Category::Operator::Const::Megafon, Category::Operator::Const::Mts, Category::Operator::Const::OtherRusianOperator, Category::Operator::Const::FixedlineOperator]
  Category::Operator::Const::SicOperatorsGroup = [Category::Operator::Const::MtsUkrain, Category::Operator::Const::KievStar,] 
  Category::Operator::Const::OtherOperatorsGroup = [] 
  Category::Operator::Const::BeelinePartnerOperators = [Category::Operator::Const::Beeline, Category::Operator::Const::KievStar,] 
end

