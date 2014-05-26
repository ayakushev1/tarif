_sctcg_own_region_calls_incoming = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_in}
_sctcg_own_region_calls_local_own_operator = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_region_calls_local_other_operator = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_region_calls_local_fixed_line = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_fixed_line}


_sctcg_own_region_sms_incoming = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_in}
_sctcg_own_region_mms_incoming = {:service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _mms_in}

#Smart+
ctc = []; next_ctc = @_last_service_category_tarif_class_id + 1 #Service::CategoryTarifClass
plst = []; next_plst = @_last_price_lis_id + 1 #PriceList
prf = []; next_prf = @_last_price_formula_id + 1 #Price::Formula
operator_id = _mts
tarif_class_id = 203

#Переход на тариф
  ctc << {:id => next_ctc, :service_category_one_time_id => _tarif_switch_on} 
  plst << {:id => next_plst, :service_category_tarif_class_id => next_ctc} 
  prf << {:id => next_prf, :price_list_id => next_plst, :standard_formula_id => _stf_price_by_1_item, :price => 0.0}; next_ctc += 1; next_plst += 1; next_prf += 1

#Ежемесячная плата
  ctc << {:id => next_ctc, :service_category_one_time_id => _periodic_monthly_fee} 
  plst << {:id => next_plst, :service_category_tarif_class_id => next_ctc} 
  prf << {:id => next_prf, :price_list_id => next_plst, :standard_formula_id => _stf_price_by_1_month, :price => 900.0}; next_ctc += 1; next_plst += 1; next_prf += 1

#Own region, Calls, Incoming
  ctc << {:id => next_ctc, :as_standard_category_group_id => _scg_free_sum_duration}.merge(_sctcg_own_region_calls_incoming); next_ctc += 1
#Own region, Calls, Outcoming, to_local_number, to_own_operator
  ctc << {:id => next_ctc, :as_standard_category_group_id => _scg_free_sum_duration}.merge(_sctcg_own_region_calls_local_own_operator); next_ctc += 1
#Own region, Calls, Outcoming, to_local_number, to_other_operator
  ctc << {:id => next_ctc}.merge(_sctcg_own_region_calls_local_other_operator)
  plst << {:id => next_plst, :service_category_tarif_class_id => next_ctc} 
  prf << {:id => next_prf, :price_list_id => next_plst, :standard_formula_id => _stf_price_by_sum_duration_second, :price => 2.0}; next_ctc += 1; next_plst += 1; next_prf += 1
#Own region, Calls, Outcoming, to_local_number, to_fixed_line
  ctc << {:id => next_ctc}.merge(_sctcg_own_region_calls_local_fixed_line)
  plst << {:id => next_plst, :service_category_tarif_class_id => next_ctc} 
  prf << {:id => next_prf, :price_list_id => next_plst, :standard_formula_id => _stf_price_by_sum_duration_second, :price => 2.0}; next_ctc += 1; next_plst += 1; next_prf += 1


#Own region, sms, Incoming
  ctc << {:id => next_ctc, :as_standard_category_group_id => _scg_free_count_volume}.merge(_sctcg_own_region_sms_incoming); next_ctc += 1
#Own region, mms, Incoming
  ctc << {:id => next_ctc, :as_standard_category_group_id => _scg_free_count_volume}.merge(_sctcg_own_region_mms_incoming); next_ctc += 1


@_last_service_category_tarif_class_id = next_ctc; @_last_price_lis_id = next_plst; @_last_price_formula_id = next_prf;
ctc.each {|item| item = {:tarif_class_id => tarif_class_id, :is_active => true}.merge(item) } 
plst.each {|item| item = {:name => "", :tarif_class_id => tarif_class_id, :is_active => true}.merge(item) }
prf.each {|item| item = {:calculation_order => 0}.merge(item) }

Service::CategoryTarifClass.transaction do 
  Service::CategoryTarifClass.create(ctc) 
  PriceList.create(plst)
  Price::Formula.create(prf)
  
end
#TarifClass.find(203).update(id: 203, operator_id: 1030, privacy_id: 2, standard_service_id: 40, name: 'Smart+')

# Table name: service_category_tarif_classes
#
#  tarif_class_id                     :integer
#  service_category_rouming_id        :integer
#  service_category_geo_id            :integer
#  service_category_partner_type_id   :integer
#  service_category_calls_id          :integer
#  service_category_one_time_id       :integer
#  service_category_periodic_id       :integer
#  as_standard_category_group_id      :integer
#  as_tarif_class_service_category_id :integer
#  tarif_class_service_categories     :integer          default([]), is an Array
#  standard_category_groups           :integer          default([]), is an Array
#  is_active                          :boolean

# Table name: price_lists
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  tarif_class_id                  :integer
#  tarif_list_id                   :integer
#  service_category_group_id       :integer
#  service_category_tarif_class_id :integer
#  is_active                       :boolean
#  features                        :json
#  description                     :text

# Table name: price_formulas
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  price_list_id       :integer
#  calculation_order   :integer
#  standard_formula_id :integer
#  formula             :json
#  price               :decimal(, )
#  price_unit_id       :integer
#  volume_id           :integer
#  volume_unit_id      :integer
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
