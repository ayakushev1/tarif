Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

Dir[Rails.root.join("db/seeds/users.rb")].each { |f| require f }
