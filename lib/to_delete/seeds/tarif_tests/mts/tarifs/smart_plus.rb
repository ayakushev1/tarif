#Smart
user = 2; 
own_phone_id = ''; own_operator_id = _mts; own_region_id = _moscow; own_country_id = _russia;

home_region_id = Relation.home_regions(own_operator_id, _moscow)[0]; 
rouming_region_id = _piter; rouming_country_id = _ukraiun; rouming_country_operator_id = Relation.country_operator(rouming_country_id); raise(StandardError) unless rouming_country_operator_id 

p_phone = ''; service_to_operator_id = _beeline; fixed_line_id = _fixed_line_operator; russia_service_to_region_id = _piter; 
service_to_country_country_id = _ukraiun; service_to_country_operator_id = Relation.country_operator(service_to_country_country_id);

start_date = DateTime.civil_from_format(:local, 2014, 1, 1);  
call_duration = 60 * 1000; sms_count = 1000; internet_duration = 3000;

own_phone = {:number => own_phone, :operator_id => own_operator_id, :region_id => own_region_id, :country_id => own_country_id }
p = {}; c = {};
p[:p_own_region_own_operator] = {:operator_id => own_operator_id, :region_id => own_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_own_region_other_operator] = {:operator_id => service_to_operator_id, :region_id => own_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_own_region_fixed_line] = {:operator_id => fixed_line_id, :region_id => own_region_id, :country_id =>  own_country_id, :operator_type_id => _fixed_line, :number => p_phone}
p[:p_home_region_own_operator] = {:operator_id => own_operator_id, :region_id => home_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_home_region_other_operator] = {:operator_id => service_to_operator_id, :region_id => home_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_home_region_fixed_line] = {:operator_id => fixed_line_id, :region_id => home_region_id, :country_id =>  own_country_id, :operator_type_id => _fixed_line, :number => p_phone}
p[:p_own_country_own_operator] = {:operator_id => own_operator_id, :region_id => russia_service_to_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_own_country_other_operator] = {:operator_id => service_to_operator_id, :region_id => russia_service_to_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}
p[:p_own_country_fixed_line] = {:operator_id => fixed_line_id, :region_id => russia_service_to_region_id, :country_id =>  own_country_id, :operator_type_id => _fixed_line, :number => p_phone}
p[:p_ukraine] = {:operator_id => Relation.country_operator(_ukraiun), :country_id =>  _ukraiun, :operator_type_id => _mobile, :number => p_phone}
p[:p_europe] = {:operator_id => Relation.country_operator(_germany), :country_id =>  _germany, :operator_type_id => _mobile, :number => p_phone}
p[:p_usa] = {:operator_id => Relation.country_operator(_usa), :country_id =>  _usa, :operator_type_id => _mobile, :number => p_phone}

c[:c_own_region_own_operator] = {:operator_id => own_operator_id, :region_id => own_region_id, :country_id =>  own_country_id}
c[:c_home_region_own_operator] = {:operator_id => own_operator_id, :region_id => home_region_id, :country_id =>  own_country_id}
c[:c_rouming_region_own_operator] = {:operator_id => own_operator_id, :region_id => rouming_region_id, :country_id =>  own_country_id}
c[:c_rouming_country] = {:operator_id => rouming_country_operator_id, :region_id => nil, :country_id =>  rouming_country_id}

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
total_steps = (1000 * 1 * 1 * 1 * 1 + 1) + (2 * 3 * 2 * p.size * c.size) + (2 * 1 * 1 * c.size) + 1

1000.times do |iii|
  [_sms].each do |service_id|
    [_outbound].each do |direction_id|
      partner = p[:p_own_region_own_operator]
      connect = c[:c_own_region_own_operator]
          calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => partner, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => sms_count}, :user_id => user, :own_phone => own_phone}
          i += 1; 
    end
  end
end

2.times do |iii|
  [_calls, _sms, _mms].each do |service_id|
    [_inbound, _outbound].each do |direction_id|
      p.each do |partner_key, partner|
        c.each do |connect_key, connect|
          calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => partner, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => sms_count}, :user_id => user, :own_phone => own_phone}
          i += 1; 
        end
      end
    end
  end
end

2.times do |iii|
  [_3g].each do |service_id|
    [_unspecified_direction].each do |direction_id|
      c.each do |connect_key, connect|
        calls << {:base_service_id => service_id, :base_subservice_id => direction_id, :partner_phone => nil, :connect => connect, :description => {:time => set_date_time(start_date, i, total_steps), :duration => call_duration, :volume => internet_duration}, :user_id => user, :own_phone => own_phone}
        i += 1; 
      end
    end
  end
end



Customer::Call.transaction do
  Customer::Call.create(calls)
end

