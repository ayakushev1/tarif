#Dir[Rails.root.join("db/seeds/seeds_for_content_related.rb")].each { |f| require f }

Dir[Rails.root.join("db/seeds/seeds_for_tarif_related.rb")].each { |f| require f }
Customer::Stat::StatAndQuery.save_stat_function_collector
