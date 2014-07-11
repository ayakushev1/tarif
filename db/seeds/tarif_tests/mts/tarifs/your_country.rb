#Твоя страна
user = 2; 
own_phone_id = ''; own_operator_id = _mts; own_region_id = _moscow; own_country_id = _russia;

home_region_id = Relation.home_regions(own_operator_id, _moscow)[0]; 
rouming_region_id = _piter; 
europe_country_id = _great_britain; europe_country_operator_id = Relation.country_operator(europe_country_id); raise(StandardError) unless europe_country_operator_id 
your_country_1_id = _azerbaijan; your_country_1_operator_id = Relation.country_operator(your_country_1_id); raise(StandardError) unless your_country_1_operator_id 
your_country_2_id = _china; your_country_2_operator_id = Relation.country_operator(your_country_2_id); raise(StandardError) unless your_country_2_operator_id 
your_country_3_id = _moldova; your_country_3_operator_id = Relation.country_operator(your_country_3_id); raise(StandardError) unless your_country_3_operator_id 
your_country_4_id = _uzbekistan; your_country_4_operator_id = Relation.country_operator(your_country_4_id); raise(StandardError) unless your_country_4_operator_id 
your_country_5_id = _tajikistan; your_country_5_operator_id = Relation.country_operator(your_country_5_id); raise(StandardError) unless your_country_5_operator_id 
your_country_6_id = _armenia; your_country_6_operator_id = Relation.country_operator(your_country_6_id); raise(StandardError) unless your_country_6_operator_id 
your_country_7_id = _vietnam; your_country_7_operator_id = Relation.country_operator(your_country_7_id); raise(StandardError) unless your_country_7_operator_id 
your_country_8_id = _georgia; your_country_8_operator_id = Relation.country_operator(your_country_8_id); raise(StandardError) unless your_country_8_operator_id 
your_country_9_id = _tailand; your_country_9_operator_id = Relation.country_operator(your_country_9_id); raise(StandardError) unless your_country_9_operator_id 
other_country_id = _usa; other_country_operator_id = Relation.country_operator(other_country_id); raise(StandardError) unless other_country_operator_id 

p_phone = ''; service_to_operator_id = _beeline; fixed_line_id = _fixed_line_operator; russia_service_to_region_id = _piter; 
service_to_country_country_id = _ukraiun; service_to_country_operator_id = Relation.country_operator(service_to_country_country_id);

start_date = DateTime.civil_from_format(:local, 2014, 1, 1); total_steps = 100; 
call_duration = 60 * 11; sms_count = 1; internet_duration = 1;

own_phone = {:number => own_phone, :operator_id => own_operator_id, :region_id => own_region_id, :country_id => own_country_id }
p = {}; c = {};
c[:p_own_region_own_operator] = {:operator_id => own_operator_id, :region_id => own_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
c[:p_own_country_operator] = {:operator_id => own_operator_id, :region_id => rouming_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}

p[:c_europe_country] = {:operator_id => europe_country_operator_id, :region_id => nil, :country_id =>  europe_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_1] = {:operator_id => your_country_1_operator_id, :region_id => nil, :country_id =>  your_country_1_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_2] = {:operator_id => your_country_2_operator_id, :region_id => nil, :country_id =>  your_country_2_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_3] = {:operator_id => your_country_3_operator_id, :region_id => nil, :country_id =>  your_country_3_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_4] = {:operator_id => your_country_4_operator_id, :region_id => nil, :country_id =>  your_country_4_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_5] = {:operator_id => your_country_5_operator_id, :region_id => nil, :country_id =>  your_country_5_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_6] = {:operator_id => your_country_6_operator_id, :region_id => nil, :country_id =>  your_country_6_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_7] = {:operator_id => your_country_7_operator_id, :region_id => nil, :country_id =>  your_country_7_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_8] = {:operator_id => your_country_8_operator_id, :region_id => nil, :country_id =>  your_country_8_id, :operator_type_id => _mobile, :number => p_phone}
p[:c_your_country_9] = {:operator_id => your_country_9_operator_id, :region_id => nil, :country_id =>  your_country_9_id, :operator_type_id => _mobile, :number => p_phone}

def set_date_time(start_date, step, total_steps )
  i = step; n = total_steps
  day = (30.0*i/n).floor; hour = ((30.0*i/n - day)*24.0).floor; min = (((30.0*i/n - day)*24.0 - hour)*60.0).floor; sec = ((((30.0*i/n - day)*24.0 - hour)*60.0 - min)*60.0).floor
  begin
    start_date.change({:year=>2014, :month=>1, :day => day + 1, :hour => hour, :min => min, :sec => sec })
  rescue
    raise(StandardError, [day, hour, min, sec])  
  end
                  
end

call_duration = 60 * 1
Customer::Call.delete_all
calls = []; i = 0
total_steps =  (4 * 1 * 1 * p.size * c.size) + 1

1.times do |iii|
  [_calls].each do |service_id|
    [_inbound].each do |direction_id|
      p.each do |partner_key, partner|
        c.each do |connect_key, connect|
          calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => partner, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => sms_count}, :user_id => user, :own_phone => own_phone}
          i += 1; 
        end
      end
    end
  end
end
call_duration = 60 * 2
1.times do |iii|
  [_calls].each do |service_id|
    [_inbound].each do |direction_id|
      p.each do |partner_key, partner|
        c.each do |connect_key, connect|
          calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => partner, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => sms_count}, :user_id => user, :own_phone => own_phone}
          i += 1; 
        end
      end
    end
  end
end

call_duration = 60 * 10
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
call_duration = 60 * 15
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

