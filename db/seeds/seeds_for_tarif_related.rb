# users categories tarif_classes parameters service/categories service/category_groups 
# tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities

# categories tarif_classes parameters service/categories service/category_tarif_classes service/category_groups 
# tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities

# users
# users/create_customer_info


Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

%w{
  categories tarif_classes parameters service/categories service/category_tarif_classes service/category_groups price/standard_formulas
  price_lists price/formulas relations
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/#{part}.rb"
end


#raise(StandardError, calls)
#Dir[Rails.root.join("db/seeds/tarif_tests/mts/tarifs/smart_plus.rb")].each { |f| require f }
#Dir[Rails.root.join("db/seeds/tarif_tests/mts/tarif_options/everywhere_as_home.rb")].each { |f| require f }

#НЕ ЗАПУСКАТЬ ТАРИФЫ БЕЗ ОСТАЛЬНЫХ ТАБЛИЦ!!!
Dir[Rails.root.join("db/seeds/tarifs/**/*.rb")].each { |f| require f }
ServiceHelper::StatAndQuerySaver.save_stat_function_collector

#  categories tarif_classes service/categories service/category_tarif_classes service/category_groups price/standard_formulas
#  price_lists price/formulas relations
