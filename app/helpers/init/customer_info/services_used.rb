class Init::CustomerInfo::ServicesUsed
  def self.default_values
    {
      :calls_modelling_count => 5,
      :calls_parsing_count => 3,
      :tarif_optimization_count => 1,
    }
  end

  def self.values_for_payment
    {
      :calls_modelling_count => 2,
      :calls_parsing_count => 2,
      :tarif_optimization_count => 1,
    }
  end
end


