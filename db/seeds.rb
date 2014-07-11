# users categories tarif_classes parameters service/categories service/category_groups 
# tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities

# users categories tarif_classes parameters service/categories service/category_tarif_classes service/category_groups 
# tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities

Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

%w{
 users categories tarif_classes parameters service/categories service/category_tarif_classes service/category_groups 
 tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
end

#raise(StandardError, calls)
Dir[Rails.root.join("db/seeds/tarif_tests/mts/tarifs/smart_mini.rb")].each { |f| require f }
#Dir[Rails.root.join("db/seeds/tarif_tests/mts/tarifs/umnyi_dom.rb")].each { |f| require f }
Dir[Rails.root.join("db/seeds/tarifs/**/*.rb")].each { |f| require f }


#  categories tarif_classes service/categories service/category_tarif_classes service/category_groups price/standard_formulas
#  price_lists price/formulas relations
