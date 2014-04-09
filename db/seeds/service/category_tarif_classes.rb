#constant definition
#TarifClassID
tarif_classes = {
  :Beeline => {:private_tarif => (0..12), :corporate_tarif => (50..55)},
  :Megafon => {:private_tarif => (100..113), :corporate_tarif => (150..160)},
  :MTS => {:private_tarif => (200..210), :corporate_tarif => (250..260)},
}
# standard service types
_two_side_services_both_way = [302, 303, 311, 312, 321, 322]
_two_side_services_out_way = [303, 312, 322]
_one_side_services = [331, 332, 341, 342, 351, 352]
_incoming_calls = 302

#Standard Category blocks
stand_cat = {
  :local => {
    :one_time => [202],
    :periodic => [281],
    :rouming_id => 2, 
    :service_type => {
      :one_side => { :stan_serv => _one_side_services },
      :two_side => { :stan_serv => _two_side_services_both_way, :geo => [101, 102, 103, 105], :partner_type => [191, 192, 193] }
    }
  }
}

Service::CategoryTarifClass.delete_all; 
ctc = []; 

tarif_classes.each do |operator, all_tarifs|
  all_tarifs.each do |privacy, tarif_class_range|
    tarif_class_range.each do |tarif_class_id|
      stand_cat[:local][:one_time].each do |cat_id|
        ctc << {:id => (cat_id*1000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_one_time_id => cat_id, :is_active => true} 
      end      

      stand_cat[:local][:periodic].each do |cat_id|
        ctc << {:id => (cat_id*2000 + tarif_class_id), :tarif_class_id => tarif_class_id, :service_category_periodic_id => cat_id, :is_active => true} 
      end      

      stand_cat[:local][:service_type][:one_side][:stan_serv].each do |stan_cat_id|
        ctc << {:id => (stan_cat_id*3000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
          :service_category_rouming_id => stand_cat[:local][:rouming_id], :service_category_calls_id => stan_cat_id, :is_active => true} 
      end      

      stand_cat[:local][:service_type][:two_side][:stan_serv].each do |stan_cat_id|
        stand_cat[:local][:service_type][:two_side][:geo].each do |geo_cat_id|
          stand_cat[:local][:service_type][:two_side][:partner_type].each do |partner_type_id|
            ctc << {:id => (((partner_type_id*10 + geo_cat_id)*100 + stan_cat_id)*3000 + tarif_class_id), :tarif_class_id => tarif_class_id, 
              :service_category_rouming_id => stand_cat[:local][:rouming_id], :service_category_geo_id => geo_cat_id,
              :service_category_calls_id => stan_cat_id, :service_category_partner_type_id => partner_type_id, :is_active => true} 
          end      
        end      
      end      
    end
  end
end

Service::CategoryTarifClass.transaction do
  Service::CategoryTarifClass.create(ctc)
end

#standard CategoryGroups
_intra_net_rouming = [ 3, 4]
operators = {:beeline => 1025, :megafon => 1028, :mts => 1030}

stand_cat_group = {
  :all_local_incoming_free => {:service_category_rouming_id => stand_cat[:local][:rouming_id], :service_category_calls_id => _incoming_calls, },
  :own_country_intra_net_incoming_free => {:service_category_rouming_id => _intra_net_rouming, :service_category_calls_id => _incoming_calls, },
}

Service::CategoryGroup.delete_all
scg = []
i = 0
operators.each do |operator_name, operator_id|
  stand_cat_group.each do |stand_car_group_name, criteria|
    scg << { :id => (i + operator_id*1000), :name => stand_car_group_name.to_s.split('_').join(' '), :operator_id => operator_id, :criteria => criteria }
    i += 1
  end
end

Service::CategoryGroup.transaction do
  Service::CategoryGroup.create(scg)
end

#UPDATING Service::CategoryTarifClass.standard_category_groups
Service::CategoryTarifClass.transaction do
  Service::CategoryGroup.all.each do |group_raw|
    Service::CategoryTarifClass.
      where(group_raw.criteria ).
      with_operator(group_raw.operator_id ).
      where( 'not (standard_category_groups @> array[?] )', group_raw.id ).
      update_all("
        as_standard_category_group_id = #{group_raw.id.to_i}, 
        standard_category_groups = array_append(standard_category_groups, #{group_raw.id.to_i})
        ")
  end
end

