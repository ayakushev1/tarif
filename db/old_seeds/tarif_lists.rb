TarifList.delete_all
tlst =[]

TarifClass.where(:standard_service_id => _tarif).each do |tarif_class|
  next if _correct_tarif_class_ids.include?(tarif_class.id)
  _regions.each do |region|    
    tlst << {:id => (tarif_class.id * 1000 + region - 1000), 
             :name => "#{tarif_class.name} #{region}", 
             :tarif_class_id => tarif_class.id, 
             :region_id => region }
  end
end

TarifList.transaction do
#  TarifList.create(tlst)
end
