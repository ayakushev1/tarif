Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

Dir[Rails.root.join("db/seeds/comparison/*.rb")].sort.each { |f| require f }

Comparison::Optimization.generate_calls(true) #true for only new call_types
