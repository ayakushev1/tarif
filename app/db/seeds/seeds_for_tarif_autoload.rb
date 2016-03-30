Dir[Rails.root.join("db/seeds/autoload/tarif_description/*.rb")].sort.each { |f| require f }
