class ServiceHelper::TarifSeedTester
  attr_reader :tarif_optimizator
  def initialize(options = {})
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new(options)
  end
  
  def load_tarif(tarif_file_name)
    Dir[Rails.root.join("db/seeds/tarifs/#{tarif_file_name}")].each { |f| require f }
  end
  
  def load_tarif_test_data(tarif_file_name)
    Dir[Rails.root.join("db/seeds/tarif_tests/#{tarif_file_name}")].each { |f| require f }
  end
  
end
