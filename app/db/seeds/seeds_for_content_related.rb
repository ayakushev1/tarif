Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

#Dir[Rails.root.join("db/seeds/categories.rb")].each { |f| require f }

Dir[Rails.root.join("db/seeds/content/**/*.rb")].each { |f| require f }
