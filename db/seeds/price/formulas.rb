Price::Formula.delete_all
prf = []
#price_list_to_real_category_groups
  #all operators
prf << {:id => _prf_free_sum_duration, :price_list_id => _prf_free_sum_duration, :calculation_order => 0, :standard_formula_id => _stf_zero_sum_duration_second, :price => 0.0, :description => '' }
prf << {:id => _prf_free_count_volume, :price_list_id => _prf_free_count_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_count_volume_item, :price => 0.0, :description => '' }
prf << {:id => _prf_free_sum_volume, :price_list_id => _prf_free_sum_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_sum_volume_m_byte, :price => 0.0, :description => '' }

prf << {:id => _prf_free_group_sum_duration, :price_list_id => _prf_free_group_sum_duration, :calculation_order => 0, :standard_formula_id => _stf_zero_group_sum_duration_second, :price => 0.0, :description => '' }
prf << {:id => _prf_free_group_count_volume, :price_list_id => _prf_free_group_count_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_group_count_volume_item, :price => 0.0, :description => '' }
prf << {:id => _prf_free_group_sum_volume, :price_list_id => _prf_free_group_sum_volume, :calculation_order => 0, :standard_formula_id => _stf_zero_group_sum_volume_m_byte, :price => 0.0, :description => '' }

last_real_price_formula_id = _prf_free_group_sum_volume 
  
Price::Formula.transaction do
  Price::Formula.create(prf)
end


filtrs = []
#filtrs1 = []
filtrs << {
  :condition =>{
    :service_category_rouming_id => [_own_region_rouming],
    :service_category_calls_id => [_calls_in],
  },
  :create => {:standard_formula_id => _stf_zero_sum_duration_second, :formula => {}, :price => 0.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_rouming_id => [_own_region_rouming, _home_region_rouming, _own_country_rouming, _all_world_rouming],
    :service_category_calls_id => [_sms_in, _mms_in],
  },
  :create => {:standard_formula_id => _stf_zero_count_volume_item, :formula => {}, :price => 0.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_rouming_id => [_own_region_rouming, _home_region_rouming, _own_country_rouming],
    :service_category_calls_id => [_calls_out],
  },
  :create => {:standard_formula_id => _stf_price_by_sum_duration_second, :formula => {}, :price => 5.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_rouming_id => [_own_region_rouming, _home_region_rouming, _own_country_rouming],
    :service_category_calls_id => [_sms_out, _mms_out] ,
  },
  :create => {:standard_formula_id => _stf_price_by_count_volume_item, :formula => {}, :price => 1.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_rouming_id => [_all_world_rouming],
    :service_category_calls_id => [_calls_out],
  },
  :create => {:standard_formula_id => _stf_price_by_sum_duration_second, :formula => {}, :price => 50.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_rouming_id => [_all_world_rouming],
    :service_category_calls_id => [_sms_out, _mms_out] ,
  },
  :create => {:standard_formula_id => _stf_price_by_count_volume_item, :formula => {}, :price => 2.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_periodic_id => [_periodic_monthly_fee] ,
  },
  :create => {:standard_formula_id => _stf_price_by_1_month, :formula => {}, :price => 200.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_one_time_id => [_tarif_switch_on] ,
  },
  :create => {:standard_formula_id => _stf_price_by_count_volume_item, :formula => {}, :price => 100.0, :volume_id => nil, :volume_unit_id => nil}  
}

filtrs << {
  :condition =>{
    :service_category_calls_id => [_gprs, _internet] ,
  },
  :create => {:standard_formula_id => _stf_price_by_sum_volume_m_byte, :formula => {}, :price => 15.0, :volume_id => nil, :volume_unit_id => nil}  
}

prlst_tarif_list = []; prlst_tarif_class = []; prlst_service_group = []
prlst = []

i = last_real_price_formula_id + 1

filtrs.reverse.each do |f|
  prf = []; new_prlst_tarif_list = []; new_prlst_tarif_class = []; new_prlst_service_group = []
  
  new_prlst_tarif_list += PriceList.where.not(:tarif_list_id => nil).joins(:service_category_tarif_class).
    merge(Service::CategoryTarifClass.active.original).
    where(:service_category_tarif_classes => f[:condition]).
    where.not(:service_category_tarif_classes => {:tarif_class_id => _correct_tarif_class_ids}).
    where.not(:id => prlst).pluck(:id).uniq
    
  prlst += new_prlst_tarif_list

#  raise(StandardError, '') if new_prlst_tarif_list.include?(2294)

  new_prlst_tarif_class += PriceList.where.not(:tarif_class_id => nil).joins(:service_category_tarif_class).
    merge(Service::CategoryTarifClass.active.original).
    where(:service_category_tarif_classes => f[:condition]).
    where.not(:service_category_tarif_classes => {:tarif_class_id => _correct_tarif_class_ids}).
    where.not(:id => prlst).pluck(:id).uniq
    
  prlst += new_prlst_tarif_class

#  raise(StandardError, '') if new_prlst_tarif_class.include?(2294)

  new_prlst_service_group += PriceList.where.not(:service_category_group_id => nil).joins(service_category_group: :service_category_tarif_classes).
    merge(Service::CategoryTarifClass.active.where.not(:as_standard_category_group_id => nil) ).
    where(:service_category_tarif_classes => f[:condition]).
    where.not(:service_category_tarif_classes => {:tarif_class_id => _correct_tarif_class_ids}).
    where.not(:id => prlst).pluck(:id).uniq
    
  prlst += new_prlst_service_group
  
#  raise(StandardError, '') if new_prlst_service_group.include?(2294)

  prlst_tarif_list += new_prlst_tarif_list 
  prlst_tarif_class += new_prlst_tarif_class
  prlst_service_group += new_prlst_service_group

  (new_prlst_tarif_list + new_prlst_tarif_class + new_prlst_service_group).each do |price_list_id|            
    prf << {:id => i,
      :price_list_id => price_list_id,
      :calculation_order => 0,
      :standard_formula_id => f[:create][:standard_formula_id],
      :formula => f[:create][:formula],
      :price => f[:create][:price],
      :volume_id => f[:create][:volume_id],
      :volume_unit_id => f[:create][:volume_unit_id],
      :description => ''
    }
    i += 1      
  end

  Price::Formula.transaction do
    Price::Formula.create(prf)
  end
end

@_last_price_formula_id = Price::Formula.maximum(:id)

#  id                              :integer          not null, primary key
#  name                            :string(255)
#  tarif_list_id                   :integer
#  service_category_group_id       :integer
#  service_category_tarif_class_id :integer
#  is_active                       :boolean
#  features                        :json
#  description                     :text

#ServiceCategories
  #rouming
#  _own_region_rouming = 2; _home_region_rouming = 3; _own_country_rouming = 4; _all_world_rouming = 6;
  #география услуг
#  _service_to_own_region = 101; _service_to_home_region = 102; _service_to_own_ountry = 103; _service_to_all_world = 105;
  #partner type
#  _service_to_own_operator = 191; _service_to_other_operator = 192; _service_to_fixed_line = 193;  
  # standard service types
#  _calls_out = 302; _calls_in = 303; _sms_in = 311; _sms_out = 312; _mms_in = 321; _mms_out = 322;
#  _gprs = 330; _internet = 340; _tarif_switch_on = 202; _periodic_monthly_fee = 281;


#9 volume unit ids   
#  _byte = 80; _k_byte = 81; _m_byte = 82; _g_byte = 83;
#  _rur = 90; _usd = 91; _eur = 92; _grivna = 93; _gbp = 94;
#  _second = 95; _minute = 96; _hour = 97; _day = 98; _week = 99; _month = 100; _year = 101;
#  _k_b_sec = 110; _m_b_sec = 111; _g_b_sec = 112;
#  _item = 115;

  #parameter_id
#  _call_base_service_id =       0; _call_base_sub_service_id =       1;
#  _call_own_phone_number =      2; _call_own_phone_operator_id =     3; _call_own_phone_region_id =            4; _call_own_phone_country_id =    5;
#  _call_partner_phone_number =  6; _call_partner_phone_operator_id = 7; _call_partner_phone_operator_type_id = 8; _call_partner_phone_region_id = 9; _call_partner_phone_country_id = 10;
#  _call_connect_operator_id =  11; _call_connect_region_id =        12; _call_connect_country_id =            13;
#  _call_description_time =     14; _call_description_duration =     15; _call_description_volume =            16;
  
