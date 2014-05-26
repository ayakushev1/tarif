Service::CategoryGroup.delete_all
scg = []

scg << { :id => _scg_all_local_incoming_calls_free, :name => 'all_local_incoming_calls_free', :criteria => {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_in, } }
scg << { :id => _scg_all_home_region_incoming_calls_free, :name => 'all_home_region_incoming_calls_free', :criteria => {:service_category_rouming_id => _own_home_rouming, :service_category_calls_id => _calls_in, } }
scg << { :id => _scg_all_own_country_intra_net_incoming_calls_free, :name => 'all_own_country_intra_net_incoming_calls_free', :criteria => {:service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in, } }

scg << { :id => _scg_all_local_incoming_sms_free, :name => 'all_local_incoming_sms_free', :criteria => {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_in, } }
scg << { :id => _scg_all_home_region_incoming_sms_free, :name => 'all_home_region_incoming_sms_free', :criteria => {:service_category_rouming_id => _own_home_rouming, :service_category_calls_id => _sms_in, } }
scg << { :id => _scg_all_own_country_intra_net_incoming_sms_free, :name => 'all_own_country_intra_net_incoming_sms_free', :criteria => {:service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in, } }

scg << { :id => _scg_all_local_incoming_mms_free, :name => 'all_local_incoming_mms_free', :criteria => {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _mms_in, } }
scg << { :id => _scg_all_home_region_incoming_mms_free, :name => 'all_home_region_incoming_mms_free', :criteria => {:service_category_rouming_id => _own_home_rouming, :service_category_calls_id => _mms_in, } }
scg << { :id => _scg_all_own_country_intra_net_incoming_mms_free, :name => 'all_own_country_intra_net_incoming_mms_free', :criteria => {:service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _mms_in, } }

scg << { :id => _scg_free_sum_duration, :name => 'free_sum_duration' }
scg << { :id => _scg_free_count_volume, :name => 'free_count_volume'}
scg << { :id => _scg_free_sum_volume, :name => 'free_sum_volume'}

Service::CategoryGroup.transaction do
  Service::CategoryGroup.create(scg)
end

#UPDATING Service::CategoryTarifClass.standard_category_groups
Service::CategoryTarifClass.transaction do
  Service::CategoryGroup.where.not(:criteria => nil).all.each do |group_raw|
    Service::CategoryTarifClass.
      where(group_raw.criteria ).
      where( 'not (standard_category_groups @> array[?] )', group_raw.id ).
      update_all("
        as_standard_category_group_id = #{group_raw.id.to_i}, 
        standard_category_groups = array_append(standard_category_groups, #{group_raw.id.to_i})
        ")
  end
end

not_actives = []
not_actives << {:service_category_calls_id => _sms_out, :service_category_partner_type_id => _service_to_fixed_line}
not_actives << {:service_category_calls_id => _mms_out, :service_category_partner_type_id => _service_to_fixed_line}
#UPDATING Service::CategoryTarifClass.is_active == false
Service::CategoryTarifClass.transaction do
  not_actives.each do |not_active|
    Service::CategoryTarifClass.
      where(not_active).
      update_all("is_active = false")
  end
end

