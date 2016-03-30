class Optimization::Tarifs::BaseTarif
  attr_reader :tarif_country_id, :tarif_region_id, :tarif_operator_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids, :operator_id

  def initialize(options = {})
    @tarif_country_id = options[:tarif_country_id] || 1100
    @tarif_region_id = options[:tarif_region_id] || 1238
    @tarif_home_region_ids = options[:tarif_home_region_ids] || [1127]
    @tarif_own_and_home_region_ids = @tarif_home_region_ids + [@tarif_region_id]
    @operator_id = options[:operator_id] || 1030
  end

end
