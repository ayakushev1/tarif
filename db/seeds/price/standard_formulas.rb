Price::StandardFormula.delete_all
stf =[]

#Fixed price
stf << { :id => Price::StandardFormula::Const::PriceByMonth, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _month, :name => 'monthly fee', 
         :description => '',  :formula => {:stat_params => {:count_time => "(count(description->>'time')::integer)"}, :method => "(price_formulas.formula->'params'->>'price')::float"},
         :stat_params => {} }#

stf << { :id => Price::StandardFormula::Const::PriceByItem, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'onetime fee', 
         :description => '',  :formula => {:stat_params => {:count_time => "(count(description->>'time')::integer)"}, :method => "(price_formulas.formula->'params'->>'price')::float"},
         :stat_params => {} }#

stf << { :id => Price::StandardFormula::Const::PriceBySumDurationSecond, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _second, :name => 'price * sum_duration in seconds', 
         :description => '',  :formula => {:params => nil, :stat_params => {
           :sum_duration => "sum((description->>'duration')::float)",
           :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, :method => "(price_formulas.formula->'params'->>'price')::float * sum_duration"},
         :stat_params => {
           :sum_duration => {:formula => "sum((description->>'duration')::float)"},
           :sum_duration_minute =>{:formula => "sum(ceil(((description->>'duration')::float)/60.0))"}
         } } 

stf << { :id => Price::StandardFormula::Const::PriceByCountVolumeItem, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'price * count_volume in items', 
         :description => '',  :formula => {:params => nil, :stat_params => {:count_volume => "count((description->>'volume')::float)"}, :method => "(price_formulas.formula->'params'->>'price')::float * count_volume"},
         :stat_params => {
           :count_volume => {:formula => "count((description->>'volume')::float)"}
         } }

stf << { :id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, :name => 'price * sum_volume in Mbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, :method => "(price_formulas.formula->'params'->>'price')::float * sum_volume"},
         :stat_params => {
           :sum_volume => {:formula => "sum((description->>'volume')::float)"}
         } }

stf << { :id => Price::StandardFormula::Const::PriceBySumVolumeKByte, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _k_byte, :name => 'price * sum_volume in Kbytes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, :method => "(price_formulas.formula->'params'->>'price')::float * sum_volume"},
         :stat_params => {
           :sum_volume_kb => {:formula => "sum((description->>'volume')::float)"}
         } }

stf << { :id => Price::StandardFormula::Const::PriceBySumDuration, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, :name => 'price * sum_duration in minutes', 
         :description => '',  :formula => {:params => nil, :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, :method => "(price_formulas.formula->'params'->>'price')::float * sum_duration_minute"},
         :stat_params => {
           :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"}
         } } 

stf << { :id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _day, :name => 'fixed fee if duration is used during day', 
         :description => '',  :formula => {
           :tarif_condition => true,
           :group_by => 'day', 
           :stat_params => {:count_of_usage => "sum((description->>'duration')::float)"},
           :method => "case when count_of_usage > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end"},
         :stat_params => {
           :days_of_usage => {:formula => "count(*)", :group_by => 'day', :tarif_condition => true}
         } }#

stf << { :id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _day, :name => 'fixed fee if volume is used during day', 
         :description => '',  :formula => {
           :tarif_condition => true,
           :group_by => 'day', 
           :stat_params => {:count_of_usage => "sum((description->>'volume')::float)"},
           :method => "case when count_of_usage > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end"},
         :stat_params => {
           :days_of_usage => {:formula => "count(*)", :group_by => 'day', :tarif_condition => true}
         } }#

stf << { :id => Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _day, :name => 'fixed fee if anything is used during day', 
         :description => '',  :formula => {
           :tarif_condition => true,
           :group_by => 'day', 
           :stat_params => {:count_of_usage => "count(*)"},
           :method => "case when count_of_usage > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end"},
         :stat_params => {
           :days_of_usage => {:formula => "count(*)", :group_by => 'day', :tarif_condition => true}
         } }#

stf << { :id => Price::StandardFormula::Const::PriceByMonthIfUsed, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _month, :name => 'monthly fee', 
         :description => '',  :formula => {
           :tarif_condition => true,
           :group_by => 'month', 
           :stat_params => {:count_of_usage => "count(*)"},
           :method => "case when count_of_usage > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end"},
         :stat_params => {
           :month_of_usage => {:formula => "count(*)", :group_by => 'month', :tarif_condition => true}
         } }#

stf << { :id => Price::StandardFormula::Const::PriceByItemIfUsed, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, :name => 'onetime fee', 
         :description => '',  :formula => {
           :tarif_condition => true,
           :group_by => 'month', 
           :stat_params => {:count_of_usage => "count(*)"},
           :method => "case when count_of_usage > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end"},
         :stat_params => {
           :month_of_usage => {:formula => "count(*)", :group_by => 'month', :tarif_condition => true}
         } }#



#Max volumes for fixed price
stf << { :id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'fixed price for max_duration_minute', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_duration_minute')::float >= sum_duration_minute)", 
    :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float"},
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxCountVolumeForFixedPrice, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, 
  :name => 'fixed price for max_count_volume', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_count_volume')::float >= count_volume)", 
    :stat_params => {:count_volume => "count((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float"},
  :stat_params => {
    :count_volume => {:formula => "count((description->>'volume')::float)"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price for max_sum_volume_m_byte', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_sum_volume')::float >= sum_volume)", 
    :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float"},
  :stat_params => {
    :sum_volume => {:formula => "sum((description->>'volume')::float)"}
  } } 
    
#Max volumes for fixed price if used
stf << { :id => Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'fixed price for max_duration_minute if used', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_duration_minute')::float >= sum_duration_minute)", 
    :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, 
    :method => "case when sum_duration_minute > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end" },
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, 
  :name => 'fixed price for max_count_volume if used', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_count_volume')::float >= count_volume)", 
    :stat_params => {:count_volume => "count((description->>'volume')::float)"}, 
    :method => "case when count_volume > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end" },
  :stat_params => {
    :count_volume => {:formula => "count((description->>'volume')::float)"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price for max_sum_volume_m_byte if used', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_sum_volume')::float >= sum_volume)", 
    :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
    :method => "case when sum_volume > 0.0 then (price_formulas.formula->'params'->>'price')::float else 0.0 end" },
  :stat_params => {
    :sum_volume => {:formula => "sum((description->>'volume')::float)"}
  } } 
 
#Max volumes for special price
stf << { :id => Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'special price for max_duration_minute', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_duration_minute')::float >= sum_duration_minute)", 
    :stat_params => {:sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float * sum_duration_minute"},
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, 
  :name => 'special price for max_count_volume', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_count_volume')::float >= count_volume)", 
    :stat_params => {:count_volume => "count((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float * count_volume"},
  :stat_params => {
    :count_volume => {:formula => "count((description->>'volume')::float)"}
  } } 

stf << { :id => Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'special price for max_sum_volume_m_byte', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_sum_volume')::float >= sum_volume)", 
    :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float * sum_volume"},
  :stat_params => {
    :sum_volume => {:formula => "sum((description->>'volume')::float)"}
  } } 

    
#Turbobuttons
stf << { :id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price times count_of_usage of max_sum_volume in month', :description => '',  
  :formula => {
    :auto_turbo_buttons  => {
      :group_by => 'month', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:sum_volume => "sum((description->>'volume')::float)", 
        :count_of_usage => "ceil((sum((description->>'volume')::float)) / min((price_formulas.formula->'params'->>'max_sum_volume')::float))"} } },
  :stat_params => {
    :sum_volume => {:formula => "sum((description->>'volume')::float)"}
  } }

stf << { :id => Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price times count_of_usage of max_sum_volume in day', :description => '',  
  :formula => {
    :auto_turbo_buttons  => {
      :group_by => 'day', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:sum_volume => "sum((description->>'volume')::float)", 
        :count_of_usage => "ceil((sum((description->>'volume')::float)) / min((price_formulas.formula->'params'->>'max_sum_volume')::float))"} } },
  :stat_params => {
    :day_sum_volume => {:formula => "sum((description->>'volume')::float)", :group_by => 'day'}
  } }

#Max volumes with multiple use
stf << { :id => Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, 
  :name => 'fixed price for max_count_volume or times count_of_usage of max_count_volume in month', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_count_volume')::float >= count_volume)", :window_over => 'month', 
    :stat_params => {:count_volume => "count((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float",

    :multiple_use_of_tarif_option => {
      :group_by => 'month', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:count_volume => "count((description->>'volume')::float)", 
        :count_of_usage => "ceil((count(description->>'volume')) / min((price_formulas.formula->'params'->>'max_count_volume')::float))"} } },
  :stat_params => {
    :count_volume => {:formula => "count((description->>'volume')::float)"}
  } }

stf << { :id => Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseDay, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _item, 
  :name => 'fixed price for max_count_volume or times count_of_usage of max_count_volume in month', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_count_volume')::float >= count_volume)", :window_over => 'day', 
    :stat_params => {:count_volume => "count((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float",

    :multiple_use_of_tarif_option => {
      :group_by => 'day', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:count_volume => "count((description->>'volume')::float)", 
        :count_of_usage => "ceil((count(description->>'volume')) / min((price_formulas.formula->'params'->>'max_count_volume')::float))"} } },
  :stat_params => {
    :day_count_volume => {:formula => "count((description->>'volume')::float)", :group_by => 'day'}
  } }

stf << { :id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price for max_sum_volume_m_byte or times count_of_usage of max_sum_volume in month', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_sum_volume')::float >= sum_volume)", :window_over => 'month', 
    :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float",

    :multiple_use_of_tarif_option => {
      :group_by => 'month', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:sum_volume => "sum((description->>'volume')::float)", 
        :count_of_usage => "ceil((sum((description->>'volume')::float)) / min((price_formulas.formula->'params'->>'max_sum_volume')::float))"} } },
  :stat_params => {
    :sum_volume => {:formula => "sum((description->>'volume')::float)"}
  } }

stf << { :id => Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay, :price_unit_id => _rur, :volume_id => _call_description_volume, :volume_unit_id => _m_byte, 
  :name => 'fixed price for max_sum_volume_m_byte or times count_of_usage of max_sum_volume in day', :description => '',  
  :formula => {
    :window_condition => "((price_formulas.formula->'params'->>'max_sum_volume')::float >= sum_volume)", :window_over => 'day', 
    :stat_params => {:sum_volume => "sum((description->>'volume')::float)"}, 
    :method => "(price_formulas.formula->'params'->>'price')::float",

    :multiple_use_of_tarif_option => {
      :group_by => 'day', 
      :method => "(price_formulas.formula->'params'->>'price')::float * GREATEST(count_of_usage, 0.0)", 
      :stat_params => {:sum_volume => "sum((description->>'volume')::float)", 
        :count_of_usage => "ceil((sum((description->>'volume')::float)) / min((price_formulas.formula->'params'->>'max_sum_volume')::float))"} } },
  :stat_params => {
    :day_sum_volume => {:formula => "sum((description->>'volume')::float)", :group_by => 'day'}
  } }

#Two Step Price Max Duration Minute
stf << { :id => Price::StandardFormula::Const::TwoStepPriceMaxDurationMinute, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'price_0 * duration_minute_1 + price_1 * duration_minute_2 with cap to max_duration_minute', :description => '',  
  :formula => {
   :window_condition => "((price_formulas.formula->'params'->>'max_duration_minute')::float >= sum_duration_minute)", 
   :stat_params => {
     :full_cost => "sum(case \ 
        when ceil(((description->>'duration')::float)/60.0) > ((price_formulas.formula->'params'->>'duration_minute_1')::float) \
        then (ceil(((description->>'duration')::float)/60.0) - ((price_formulas.formula->'params'->>'duration_minute_1')::float)) * (price_formulas.formula->'params'->>'price_1')::float \
        + ((price_formulas.formula->'params'->>'duration_minute_1')::float) * (price_formulas.formula->'params'->>'price_0')::float \
        else ceil(((description->>'duration')::float)/60.0) * (price_formulas.formula->'params'->>'price_0')::float end)",
     :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
   :method => "full_cost" },
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"},
    :sum_call_by_minutes => {:formula => Price::StandardFormula.sum_call_by_minutes_formula_constructor([10.0])}
  } } 


#Two Step Price Duration Minute
stf << { :id => Price::StandardFormula::Const::TwoStepPriceDurationMinute, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'price_0 * duration_minute_1 + price_1 * duration_minute_2 ', :description => '',  
  :formula => {
   :stat_params => {
     :full_cost => "sum(case \ 
        when ceil(((description->>'duration')::float)/60.0) > ((price_formulas.formula->'params'->>'duration_minute_1')::float) \
        then (ceil(((description->>'duration')::float)/60.0) - ((price_formulas.formula->'params'->>'duration_minute_1')::float)) * (price_formulas.formula->'params'->>'price_1')::float \
        + ((price_formulas.formula->'params'->>'duration_minute_1')::float) * (price_formulas.formula->'params'->>'price_0')::float \
        else ceil(((description->>'duration')::float)/60.0) * (price_formulas.formula->'params'->>'price_0')::float end)",
     :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
   :method => "full_cost" },
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"},
    :sum_call_by_minutes => {:formula => Price::StandardFormula.sum_call_by_minutes_formula_constructor([1.0])}
  } } 

#Three Step Price Duration Minute
stf << { :id => Price::StandardFormula::Const::ThreeStepPriceDurationMinute, :price_unit_id => _rur, :volume_id => _call_description_duration, :volume_unit_id => _minute, 
  :name => 'price_0 * duration_minute_1 + price_1 * duration_minute_between_1_and_2 + price_2 * duration_minute_2 ', :description => '',  
  :formula => {
   :stat_params => {
     :full_cost => "sum(case \ 
        when ceil(((description->>'duration')::float)/60.0) > ((price_formulas.formula->'params'->>'duration_minute_2')::float) \
        then (ceil(((description->>'duration')::float)/60.0) - ((price_formulas.formula->'params'->>'duration_minute_2')::float)) * (price_formulas.formula->'params'->>'price_2')::float \
        + (((price_formulas.formula->'params'->>'duration_minute_2')::float) - ((price_formulas.formula->'params'->>'duration_minute_1')::float)) * (price_formulas.formula->'params'->>'price_1')::float \
        + ((price_formulas.formula->'params'->>'duration_minute_1')::float) * (price_formulas.formula->'params'->>'price_0')::float \
        when ceil(((description->>'duration')::float)/60.0) \
        between ((price_formulas.formula->'params'->>'duration_minute_1')::float) and ((price_formulas.formula->'params'->>'duration_minute_2')::float) \
        then (ceil(((description->>'duration')::float)/60.0) - ((price_formulas.formula->'params'->>'duration_minute_1')::float)) * (price_formulas.formula->'params'->>'price_1')::float \ 
        + ((price_formulas.formula->'params'->>'duration_minute_1')::float) * (price_formulas.formula->'params'->>'price_0')::float \
        else ceil(((description->>'duration')::float)/60.0) * (price_formulas.formula->'params'->>'price_0')::float end)",
     :sum_duration_minute => "sum(ceil(((description->>'duration')::float)/60.0))"},
   :method => "full_cost" },
  :stat_params => {
    :sum_duration_minute => {:formula => "sum(ceil(((description->>'duration')::float)/60.0))"},
    :sum_call_by_minutes => {:formula => Price::StandardFormula.sum_call_by_minutes_formula_constructor([1.0, 2.0, 5.0, 10.0])}    
  } } 


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
  
