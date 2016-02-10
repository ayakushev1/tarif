module Category::Country::Tel
  c = Category::Country::Const
  m = Category::Country::Mts
  o = Category::Country::Tel

  o::Service_to_tele_international_1 = m::Sic_countries
  o::Service_to_tele_international_2 = m::Europe_countries
  o::Service_to_tele_international_3 = [c::Ssha, c::Kanada].sort
  o::Service_to_tele_international_4 = c::World_countries_without_russia - m::Sic_countries - m::Europe_countries - o::Service_to_tele_international_3
  o::Service_to_tele_international_5 = (c::Asia_countries + c::Australia_countries + c::Africa_countries).sort
  o::Service_to_tele_international_6 = (c::Noth_america_countries + c::South_america_countries).sort
  
  o::Service_to_sic_1 = [c::Uzbekistan, c::Tadzhikistan].sort
  o::Service_to_sic_2 = [c::Azerbaidzhan, c::Belarus, c::Moldova].sort
  o::Service_to_sic_3 = m::Sic_countries - o::Service_to_sic_1 - o::Service_to_sic_2
  
  o::Service_to_uzbekistan = [c::Uzbekistan,]
  o::Service_to_sic_not_uzbekistan = m::Sic_countries - [c::Uzbekistan,]
  


end

