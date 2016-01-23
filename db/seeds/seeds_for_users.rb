Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

%w{
  users
}.each do |part|
  require File.expand_path(File.dirname(__FILE__))+"/#{part}.rb"
end
