PriceList.delete_all
plst =[]
#price_list_to_real_category_groups
  #all operators
plst << {:id => _pl_free_sum_duration, :name => "price for _scg_free_sum_duration", :service_category_group_id => _scg_free_sum_duration, :is_active => true}
plst << {:id => _pl_free_count_volume, :name => "price for _scg_free_count_volume", :service_category_group_id => _scg_free_count_volume, :is_active => true}
plst << {:id => _pl_free_sum_volume, :name => "price for _scg_free_sum_volume", :service_category_group_id => _scg_free_sum_volume, :is_active => true}

plst << {:id => _pl_free_group_sum_duration, :name => "price for _scg_free_group_sum_duration", :service_category_group_id => _scg_free_group_sum_duration, :is_active => true}
plst << {:id => _pl_free_group_count_volume, :name => "price for _scg_free_group_count_volume", :service_category_group_id => _scg_free_group_count_volume, :is_active => true}
plst << {:id => _pl_free_group_sum_volume, :name => "price for _scg_free_group_sum_volume", :service_category_group_id => _scg_free_group_sum_volume, :is_active => true}

PriceList.transaction do
  PriceList.create(plst)
end

last_real_price_list_id = _pl_free_group_sum_volume

i =  last_real_price_list_id + 1
plst =[]

TarifList.where(:region_id => [_moscow, _piter] ).each do |tarif_list|
  next if _correct_tarif_list_ids.include?(tarif_list.id)
  Service::CategoryTarifClass.active.original.where({:tarif_class_id => tarif_list.tarif_class_id}).
    each do |service_category_tarif_class|    
    plst << {:id => i, 
             :name => "price for #{tarif_list.name}, service_category_tarif_class_id: #{service_category_tarif_class.id}", 
             :tarif_class_id => tarif_list.tarif_class_id, 
             :tarif_list_id => tarif_list.id, 
             :service_category_group_id => nil, 
             :service_category_tarif_class_id => service_category_tarif_class.id, 
             :is_active => true, 
    }
    i += 1
  end
end

TarifClass.all.each do |tarif_class|
  next if _correct_tarif_class_ids.include?(tarif_class.id)
  Service::CategoryTarifClass.active.original.where({:tarif_class_id => tarif_class.id}).
    each do |service_category_tarif_class|    
    plst << {:id => i, 
             :name => "price for tarif_class_id: #{tarif_class.id}", 
             :tarif_class_id => tarif_class.id, 
             :service_category_group_id => nil, 
             :service_category_tarif_class_id => service_category_tarif_class.id, 
             :is_active => true, 
    }
    i += 1
  end
end

Service::CategoryGroup.all.each do |standard_category_group|
  Service::CategoryTarifClass.active.where({:as_standard_category_group_id => standard_category_group.id}).
    where.not(:tarif_class_id => _correct_tarif_class_ids).
    where(:as_tarif_class_service_category_id => nil).limit(1).
    each do |service_category_tarif_class|    
    plst << {:id => i, 
             :name => "price for standard_category_group_id: #{standard_category_group.id}", 
             :tarif_class_id => service_category_tarif_class.tarif_class_id, 
             :service_category_group_id => standard_category_group.id, 
             :service_category_tarif_class_id => nil, 
             :is_active => true, 
    }
    i += 1
  end
end

PriceList.transaction do
#  PriceList.create(plst)
end

@_last_price_lis_id = PriceList.maximum(:id)
