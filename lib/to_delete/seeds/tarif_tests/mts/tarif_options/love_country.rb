#Own_country_rouming
user = 2; 
own_phone_id = ''; own_operator_id = _mts; own_region_id = _moscow; own_country_id = _russia;

p_phone = ''; service_to_operator_id = _beeline; fixed_line_id = _fixed_line_operator; russia_service_to_region_id = _piter; 
service_to_country_country_id = _ukraiun; service_to_country_operator_id = Relation.country_operator(service_to_country_country_id);

start_date = DateTime.civil_from_format(:local, 2014, 1, 1); total_steps = 100; 
call_duration = 60 * 1; sms_count = 1; internet_duration = 1;

own_phone = {:number => own_phone, :operator_id => own_operator_id, :region_id => own_region_id, :country_id => own_country_id }

p = {}; c = {};
p[:p_own_country_own_operator] = {:operator_id => own_operator_id, :region_id => russia_service_to_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_own_country_not_own_operator] = {:operator_id => service_to_operator_id, :region_id => russia_service_to_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}

p[:p_to_mts_love_countries_4_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_4_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_5_5] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_5_5[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_5_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_5_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_6_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_6_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_7_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_7_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_8_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_8_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_9_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_9_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_11_5] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_11_5[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_12_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_12_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_14_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_14_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_19_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_19_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_29_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_29_9[0], :operator_type_id => _mobile, :number => p_phone}
p[:p_to_mts_love_countries_49_9] = {:operator_id => nil, :region_id => nil, :country_id => _mts_love_countries_49_9[0], :operator_type_id => _mobile, :number => p_phone}

c[:c_own_region_own_operator] = {:operator_id => own_operator_id, :region_id => own_region_id, :country_id =>  own_country_id}

def set_date_time(start_date, step, total_steps )
  i = step; n = total_steps
  day = (30.0*i/n).floor; hour = ((30.0*i/n - day)*24.0).floor; min = (((30.0*i/n - day)*24.0 - hour)*60.0).floor; sec = ((((30.0*i/n - day)*24.0 - hour)*60.0 - min)*60.0).floor
  begin
    start_date.change({:year=>2014, :month=>1, :day => day + 1, :hour => hour, :min => min, :sec => sec })
  rescue
    raise(StandardError, [day, hour, min, sec])  
  end
                  
end

Customer::Call.delete_all
calls = []; i = 0
total_steps =  (1 * 1 * 1 * p.size * c.size) + 1

1.times do |iii|
  [_calls].each do |service_id|
    [_outbound].each do |direction_id|
      p.each do |partner_key, partner|
        c.each do |connect_key, connect|
          calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => partner, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => sms_count}, :user_id => user, :own_phone => own_phone}
          i += 1; 
        end
      end
    end
  end
end


Customer::Call.transaction do
  Customer::Call.create(calls)
end

