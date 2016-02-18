module Optimization::Global::StandardFormulas
    def self.test
#      tarif_class_id with 61, 70, 71 standard_function [673, 110, 803, 471, 624, 288, 553]
#      ["count_volume"], ["sum_call_by_minutes", "sum_duration", "sum_duration_minute"], ["day_sum_volume", "sum_volume"]

      calls = Customer::Call.where(:call_run_id => 553)            
      formula_id = Price::StandardFormula::Const::PriceBySumDurationSecond

      fields = [
        "service_category_groups.id", "service_category_groups.tarif_class_id", "formula, price_formulas.standard_formula_id", "price_formulas.formula->'params' as params"
        ]
      service_group = Service::CategoryGroup.joins(:service_category_tarif_classes, price_lists: :formulas).
        where(:price_formulas => {:standard_formula_id => formula_id}).
        where.not(:service_category_tarif_classes => {:filtr => nil}).
        select(fields).first
      service_categories = Service::CategoryTarifClass.where(:as_standard_category_group_id => service_group.id).all

      service_id = service_group.tarif_class_id
      params = service_group.formula['params']
      
      @global_stat = Optimization::Global::Stat.new.all_global_categories_stat(calls, [service_id])
      @current_stat = @global_stat.deep_dup# Marshal.load(Marshal.dump(@global_stat))#@global_stat.clone
      global_name = service_categories.first.uniq_service_category
      result_of_function = call_by_id(formula_id, @current_stat, params, service_categories)
#      @current_stat.extract!(global_name)
      stat_to_show_after = @current_stat[global_name]
      [service_id, service_categories.map(&:uniq_service_category), result_of_function, @global_stat[global_name], stat_to_show_after]      
    end
    
    def self.price_by_month(stat, params, service_categories); params['price']; end

    def self.price_by_item(stat, params, service_categories); params['price']; end

    def self.price_by_sum_duration_second(stat, params, service_categories) 
      stat_params, used_global_categories = stat_params_from_global(stat, ['sum_duration'], service_categories, -1)      
      clean_all(stat, used_global_categories)
      params['price'] * stat_params['sum_duration']
    end
    
    def self.stat_params_from_global(stat, stat_param_names, service_categories, period = -1)
      stat_params = {}; used_global_categories = {}
      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = 0.0}
      service_categories.each do |service_category|
        global_name = service_category.uniq_service_category
        next if !stat[global_name]
        used_global_categories[global_name] ||= {"with_filtr" => [], "without_filtr" => []}
        category_ids_key = stat[global_name]["with_filtr"].keys.find{|category_ids_with_filtr| category_ids_with_filtr.include?(service_category.id) }
        if category_ids_key
          used_global_categories[global_name]["with_filtr"] << category_ids_key
          stat_param_names.each{|stat_param_name| stat_params[stat_param_name] += stat[global_name]["with_filtr"][category_ids_key][period]['stat_params'][stat_param_name]} 
        else
          category_ids_key = stat[global_name]["without_filtr"].keys[0] if stat[global_name]["without_filtr"].keys[0].include?(service_category.id)
          if category_ids_key
            used_global_categories[global_name]["without_filtr"] << category_ids_key
#        raise(StandardError, [service_category.id, category_ids_key, stat[global_name]])
            stat_param_names.each{|stat_param_name| stat_params[stat_param_name] += stat[global_name]["without_filtr"][category_ids_key][period]['stat_params'][stat_param_name]}
          end 
        end
      end        
      [stat_params, used_global_categories]
    end
    
    def self.clean_all(stat, used_global_categories)
      used_global_categories.each do |global_name, used_global_category|
#           raise(StandardError, used_global_category)
        if used_global_category["without_filtr"].blank?
          used_global_category["with_filtr"].each do |category_ids_key|
            without_filtr_key = stat[global_name]["without_filtr"].keys[0]
            stat[global_name]["without_filtr"][without_filtr_key].keys.each do |period|
              stat[global_name]["without_filtr"][without_filtr_key][period]['stat_params'].keys.each do |stat_param|
                stat[global_name]["without_filtr"][without_filtr_key][period]['stat_params'][stat_param] -= 
                  stat[global_name]["with_filtr"][category_ids_key][period]['stat_params'][stat_param] 
              end if stat[global_name]["with_filtr"][category_ids_key].try(:[], period).try(:[], 'stat_params').try(:[], stat_param)
            end if stat[global_name]["without_filtr"][without_filtr_key]
            stat[global_name]["aggregated"].keys.each do |period|
              stat[global_name]["aggregated"][period]['stat_params'].keys.each do |stat_param|
                stat[global_name]["aggregated"][period]['stat_params'][stat_param] -= 
                  stat[global_name]["with_filtr"][category_ids_key][period]['stat_params'][stat_param] 
              end if stat[global_name]["with_filtr"][category_ids_key].try(:[], period).try(:[], 'stat_params')
            end
            stat[global_name]["with_filtr"].extract!(category_ids_key)
          end          
        else
          stat.extract!(global_name)
        end
      end
    end
    
    def self.call_by_id(standard_formula_id, stat, params, service_categories)
      send(formula_name_from_formula_id(standard_formula_id), stat, params, service_categories)
    end
    
    def self.formula_name_from_formula_id(formula_id)
      constant_name = standard_formula_const_names.find{|name| Price::StandardFormula::Const.const_get(name) == formula_id}.to_s.underscore.to_sym
    end
    
    def self.standard_formula_const_names
      return Price::StandardFormula::Const.constants
=begin
      ["", "", "", "price_by_count_volume_item", "price_by_sum_volume_m_byte", "price_by_sum_volume_k_byte", 
        "price_by_sum_duration", "fixed_price_if_used_in_one_day_duration", "fixed_price_if_used_in_one_day_volume", "fixed_price_if_used_in_one_day_any", 
        "price_by_month_if_used", "price_by_item_if_used", "max_volumes_for_fixed_price_const", "max_duration_minute_for_fixed_price", "max_count_volume_for_fixed_price", 
        "max_sum_volume_m_byte_for_fixed_price", "max_volumes_for_fixed_price_if_used_const", "max_duration_minute_for_fixed_price_if_used", 
        "max_count_volume_for_fixed_price_if_used", "max_sum_volume_m_byte_for_fixed_price_if_used", "max_duration_minute_for_special_price", 
        "max_count_volume_for_special_price", "max_sum_volume_m_byte_for_special_price", "turbobuttons_const", "turbobutton_m_byte_for_fixed_price", 
        "turbobutton_m_byte_for_fixed_price_day", "max_count_volume_with_multiple_use_month", "max_count_volume_with_multiple_use_day", 
        "max_sum_volume_m_byte_with_multiple_use_month", "max_sum_volume_m_byte_with_multiple_use_day", "two_step_price_max_duration_minute", "two_step_price_duration_minute", 
        "three_step_price_duration_minute"]
        
      [
        :PriceByMonth, :PriceByItem, :PriceBySumDurationSecond, :PriceByCountVolumeItem, :PriceBySumVolumeMByte, :PriceBySumVolumeKByte, :PriceBySumDuration, 
        :FixedPriceIfUsedInOneDayDuration, :FixedPriceIfUsedInOneDayVolume, :FixedPriceIfUsedInOneDayAny, :PriceByMonthIfUsed, :PriceByItemIfUsed, 
        :MaxVolumesForFixedPriceConst, :MaxDurationMinuteForFixedPrice, :MaxCountVolumeForFixedPrice, :MaxSumVolumeMByteForFixedPrice, :MaxVolumesForFixedPriceIfUsedConst, 
        :MaxDurationMinuteForFixedPriceIfUsed, :MaxCountVolumeForFixedPriceIfUsed, :MaxSumVolumeMByteForFixedPriceIfUsed, :MaxDurationMinuteForSpecialPrice, 
        :MaxCountVolumeForSpecialPrice, :MaxSumVolumeMByteForSpecialPrice, :TurbobuttonsConst, :TurbobuttonMByteForFixedPrice, :TurbobuttonMByteForFixedPriceDay, 
        :MaxCountVolumeWithMultipleUseMonth, :MaxCountVolumeWithMultipleUseDay, :MaxSumVolumeMByteWithMultipleUseMonth, :MaxSumVolumeMByteWithMultipleUseDay, 
        :TwoStepPriceMaxDurationMinute, :TwoStepPriceDurationMinute, :ThreeStepPriceDurationMinute]
=end        
    end
end

=begin
#Fixed price
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

=end