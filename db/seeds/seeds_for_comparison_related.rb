Dir[Rails.root.join("db/seeds/comparison/*.rb")].sort.each { |f| require f }

Comparison::Optimization.generate_calls(true)
