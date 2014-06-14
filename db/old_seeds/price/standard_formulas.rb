Price::StandardFormula.delete_all
stf =[]

stf << { :id => _stf_price_by_1_month, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _month, :name => 'monthly fee', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "((1.0)::float)"}, :method => 'price_formulas.price * count_volume'} }#

stf << { :id => _stf_price_by_30_day, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _day, :name => 'daily fee', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "((30.0)::float)"}, :method => 'price_formulas.price * count_volume'} }#

stf << { :id => _stf_price_by_1_item, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'onetime fee', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "((1.0)::float)"}, :method => 'price_formulas.price * count_volume'} }#


stf << { :id => _stf_zero_sum_duration_second, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _second, :name => '0 * sum_duration in seconds', 
        :description => '',  :formula => {:params => nil, :stat_params => {:sum_duration => "sum((description->>'duration')::float)"}, :method => '0.0 * sum_duration'} } #

stf << { :id => _stf_zero_count_volume_item, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => '0 * count_volume in items', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "count((description->>'volume')::integer)"}, :method => '0.0 * count_volume'} } #

stf << { :id => _stf_zero_sum_volume_m_byte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '0 * sum_volume in Mbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, :method => '0.0 * sum_volume'} }

stf << { :id => _stf_price_by_sum_duration_second, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _second, :name => 'price * sum_duration in seconds', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_duration => "sum((description->>'duration')::float)"}, :method => :'price_formulas.price * sum_duration'} } 

stf << { :id => _stf_price_by_count_volume_item, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'price * count_volume in items', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "count((description->>'volume')::float)"}, :method => 'price_formulas.price * count_volume'} }

stf << { :id => _stf_price_by_sum_volume_m_byte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'price * sum_volume in Mbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, :method => 'price_formulas.price * sum_volume'} }

stf << { :id => _stf_price_by_sum_duration_minute, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => 'price * sum_duration in minutes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, :method => :'price_formulas.price * sum_duration_minute'} } 



stf << { :id => _stf_zero_group_sum_duration_second, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _second, :name => '0 * group_sum_duration in seconds', 
        :description => '',  :formula => {:params => nil, :stat_params => {:group_sum_duration => "sum((description->>'duration')::float)"}, :method => '0.0 * group_sum_duration'} } #

stf << { :id => _stf_zero_group_count_volume_item, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => '0 * group_count_volume in items', 
         :description => '',  :formula => {:params => nil, :stat_params => {:group_count_volume => "count((description->>'volume')::integer)"}, :method => '0.0 * group_count_volume'} } #
                
stf << { :id => _stf_zero_group_sum_volume_m_byte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => '0 * group_sum_volume in Mbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:group_sum_volume => "sum((description->>'volume')::float)"}, :method => '0.0 * group_sum_volume'} }

stf << { :id => _stf_price_by_group_sum_duration_second, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _second, :name => 'price * group_sum_duration in seconds', 
         :description => '',  :formula => {:params => nil, :stat_params => {:group_sum_duration => "sum((description->>'duration')::float)"}, :method => :'price_formulas.price * group_sum_duration'} } 

stf << { :id => _stf_price_by_group_count_volume_item, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'price * group_count_volume in items', 
         :description => '',  :formula => {:params => nil, :stat_params => {:group_count_volume => "count((description->>'volume')::float)"}, :method => 'price_formulas.price * group_count_volume'} }
                
stf << { :id => _stf_price_by_group_sum_volume_m_byte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'price * group_sum_volume in Mbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:group_sum_volume => "sum((description->>'volume')::float)"}, :method => 'price_formulas.price * group_sum_volume'} }

Price::StandardFormula.transaction do
  Price::StandardFormula.create(stf)
end

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
  
