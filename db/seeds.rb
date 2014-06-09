# users categories tarif_classes parameters service/categories service/category_tarif_classes service/category_groups 
# tarif_lists price_lists price/standard_formulas price/formulas customer/service relations customer/calls service/priorities

Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

%w{
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
end

#Dir[Rails.root.join("db/seeds/tarifs/**/*.rb")].each { |f| require f }

#  tarif_classes service/category_tarif_classes service/category_groups 
#  price_lists price/formulas

#  tarif_classes service/categories relations
#tarif_classes price/standard_formulas  
#  tarif_tests/mts/tarifs/smart+  
#  customer/calls

#  tarifs/mts/common_services/international_rouming
#  tarif_tests/mts/common_services/international_rouming

# tarif_tests/mts/tarif_options/smart_plus_groups_with_everywhere_as_home
#tarif_tests/mts/tarif_options/everywhere_as_home