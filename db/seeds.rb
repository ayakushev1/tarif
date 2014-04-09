# users categories tarif_classes parameters service/categories service/category_tarif_classes

%w{
  users categories tarif_classes categories parameters service/categories service/category_tarif_classes
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
end
