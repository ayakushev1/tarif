Price::Formula.delete_all
=begin
prf = []
#price_list_to_real_category_groups
  #all operators
prf << {:id => _prf_free_sum_duration, :price_list_id => _prf_free_sum_duration, :calculation_order => 0, :standard_formula_id => _stf_zero_sum_duration_second, :price => 0.0, :description => '' }
prf << {:id => _prf_free_count_volume, :price_list_id => _prf_free_count_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, :price => 0.0, :description => '' }
prf << {:id => _prf_free_sum_volume, :price_list_id => _prf_free_sum_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, :price => 0.0, :description => '' }

 
Price::Formula.transaction do
  Price::Formula.create(prf)
end

=end