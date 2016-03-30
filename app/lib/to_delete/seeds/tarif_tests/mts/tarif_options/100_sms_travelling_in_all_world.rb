#100 SMS в поездках по всему миру
user = 2; 
own_phone_id = ''; own_operator_id = _mts; own_region_id = _moscow; own_country_id = _russia;

home_region_id = Relation.home_regions(own_operator_id, _moscow)[0]; 
rouming_region_id = _piter; 
europe_country_id = _great_britain; europe_country_operator_id = Relation.country_operator(europe_country_id); raise(StandardError) unless europe_country_operator_id 
sic_1_country_id = _ukraiun; sic_1_country_operator_id = Relation.country_operator(sic_1_country_id); raise(StandardError) unless sic_1_country_operator_id 
sic_2_country_id = _abkhazia; sic_2_country_operator_id = Relation.country_operator(sic_2_country_id); raise(StandardError) unless sic_2_country_operator_id 
sic_3_country_id = _south_ossetia; sic_3_country_operator_id = Relation.country_operator(sic_3_country_id); raise(StandardError) unless sic_3_country_operator_id 
other_country_id = _usa; other_country_operator_id = Relation.country_operator(other_country_id); raise(StandardError) unless other_country_operator_id 

p_phone = ''; service_to_operator_id = Category::Operator::Const::Beeline; fixed_line_id = _fixed_line_operator; russia_service_to_region_id = _piter; 
service_to_country_country_id = _ukraiun; service_to_country_operator_id = Relation.country_operator(service_to_country_country_id);

start_date = DateTime.civil_from_format(:local, 2014, 1, 1); total_steps = 100; 
call_duration = 60 * 11; sms_count = 1; internet_duration = 1;

own_phone = {:number => own_phone, :operator_id => own_operator_id, :region_id => own_region_id, :country_id => own_country_id }
p = {}; c = {};
p[:p_own_region_own_operator] = {:operator_id => own_operator_id, :region_id => own_region_id, :country_id =>  own_country_id, :operator_type_id => _mobile, :number => p_phone}

c[:c_europe_country] = {:operator_id => europe_country_operator_id, :region_id => nil, :country_id =>  europe_country_id}

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
total_steps =  (101 * 1 * 1 * p.size * c.size) + 1

101.times do |iii|
  [_sms].each do |service_id|
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

