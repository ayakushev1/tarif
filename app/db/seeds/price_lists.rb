PriceList.delete_all
=begin
plst =[]
#price_list_to_real_category_groups
  #all operators
plst << {:id => _pl_free_sum_duration, :name => "price for _scg_free_sum_duration", :service_category_group_id => _scg_free_sum_duration, :is_active => true}
plst << {:id => _pl_free_count_volume, :name => "price for _scg_free_count_volume", :service_category_group_id => _scg_free_count_volume, :is_active => true}
plst << {:id => _pl_free_sum_volume, :name => "price for _scg_free_sum_volume", :service_category_group_id => _scg_free_sum_volume, :is_active => true}

PriceList.transaction do
  PriceList.create(plst)
end

=end