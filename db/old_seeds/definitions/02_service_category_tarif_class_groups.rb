def access_methods_to_constant_service_category_tarif_class_groups
#onetime services  
_sctcg_one_time_tarif_switch_on = {:name => 'one_time_tarif_switch_on', :service_category_one_time_id => _tarif_switch_on}

#periodic services
_sctcg_periodic_monthly_fee = {:name => 'periodic_monthly_fee', :service_category_periodic_id => _periodic_monthly_fee}
_sctcg_periodic_day_fee = {:name => 'periodic_day_fee', :service_category_periodic_id => _periodic_day_fee}

#any rouming 
_sctcg_mms_incoming = {:name => 'mms_incoming', :service_category_calls_id => _mms_in}
_sctcg_mms_outcoming = {:name => 'mms_outcoming',  :service_category_calls_id => _mms_out}

#own region rouming    
_sctcg_own_region_calls_incoming = {:name => 'own_region_calls_incoming', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_in}

_sctcg_own_region_calls_local_own_operator = {:name => 'own_region_calls_local_own_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_region_calls_local_other_operator = {:name => 'own_region_calls_local_other_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_region_calls_local_fixed_line = {:name => 'own_region_calls_local_fixed_line', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_region_calls_home_region_own_operator = {:name => 'own_region_calls_home_region_own_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_region_calls_home_region_other_operator = {:name => 'own_region_calls_home_region_other_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_region_calls_home_region_fixed_line = {:name => 'own_region_calls_home_region_fixed_line', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_region_calls_own_country_own_operator = {:name => 'own_region_calls_own_country_own_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_region_calls_own_country_other_operator = {:name => 'own_region_calls_own_country_other_operator', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_region_calls_own_country_fixed_line = {:name => 'own_region_calls_own_country_fixed_line', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_region_calls_sic_country = {:name => 'own_region_calls_sic_countries', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
_sctcg_own_region_calls_europe = {:name => 'own_region_calls_europe', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
_sctcg_own_region_calls_other_country = {:name => 'own_region_calls_other_countries', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}

_sctcg_own_region_sms_incoming = {:name => 'own_region_sms_incoming', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_in}
_sctcg_own_region_sms_local = {:name => 'own_region_sms_local', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_region}
_sctcg_own_region_sms_home_region = {:name => 'own_region_sms_home_region', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_home_region}
_sctcg_own_region_sms_own_country = {:name => 'own_region_sms_own_country', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
_sctcg_own_region_sms_not_own_country = {:name => 'own_region_sms_not_own_country', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}

_sctcg_own_region_gprs = {:name => 'own_region_gprs', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _gprs}
_sctcg_own_region_internet = {:name => 'own_region_internet', :service_category_rouming_id => _own_region_rouming, :service_category_calls_id => _internet}

#home region rouming
_sctcg_home_region_calls_incoming = {:name => 'home_region_calls_incoming', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_in}

_sctcg_home_region_calls_local_own_operator = {:name => 'home_region_calls_local_own_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_home_region_calls_local_other_operator = {:name => 'home_region_calls_local_other_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_home_region_calls_local_fixed_line = {:name => 'home_region_calls_local_fixed_line', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_home_region_calls_home_region_own_operator = {:name => 'home_region_calls_home_region_own_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_home_region_calls_home_region_other_operator = {:name => 'home_region_calls_home_region_other_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_home_region_calls_home_region_fixed_line = {:name => 'home_region_calls_home_region_fixed_line', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_home_region_calls_own_country_own_operator = {:name => 'home_region_calls_own_country_own_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_home_region_calls_own_country_other_operator = {:name => 'home_region_calls_own_country_other_operator', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_home_region_calls_own_country_fixed_line = {:name => 'home_region_calls_own_country_fixed_line', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_home_region_calls_sic_country = {:name => 'home_region_calls_sic_countries', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
_sctcg_home_region_calls_europe = {:name => 'home_region_calls_europe', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
_sctcg_home_region_calls_other_country = {:name => 'home_region_calls_other_countries', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}

_sctcg_home_region_sms_incoming = {:name => 'home_region_sms_incoming', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _sms_in}
_sctcg_home_region_sms_local = {:name => 'home_region_sms_local', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_region}
_sctcg_home_region_sms_home_region = {:name => 'home_region_sms_home_region', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_home_region}
_sctcg_home_region_sms_own_country = {:name => 'home_region_sms_own_country', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
_sctcg_home_region_sms_not_own_country = {:name => 'home_region_sms_not_own_country', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}

_sctcg_home_region_gprs = {:name => 'home_region_gprs', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _gprs}
_sctcg_home_region_internet = {:name => 'home_region_internet', :service_category_rouming_id => _home_region_rouming, :service_category_calls_id => _internet}

#own country rouming    
_sctcg_own_country_calls_incoming = {:name => 'own_country_calls_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_in}

_sctcg_own_country_calls_local_own_operator = {:name => 'own_country_calls_local_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_local_other_operator = {:name => 'own_country_calls_local_other_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_country_calls_local_fixed_line = {:name => 'own_country_calls_local_fixed_line', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_country_calls_home_region_own_operator = {:name => 'own_country_calls_home_region_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_home_region_other_operator = {:name => 'own_country_calls_home_region_other_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_country_calls_home_region_fixed_line = {:name => 'own_country_calls_home_region_fixed_line', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_home_region, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_country_calls_own_country_own_operator = {:name => 'own_country_calls_own_country_own_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_own_operator}
_sctcg_own_country_calls_own_country_other_operator = {:name => 'own_country_calls_own_country_other_operator', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_other_operator}
_sctcg_own_country_calls_own_country_fixed_line = {:name => 'own_country_calls_own_country_fixed_line', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_country, :service_category_partner_type_id => _service_to_fixed_line}

_sctcg_own_country_calls_sic_country = {:name => 'own_country_calls_sic_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_sic}
_sctcg_own_country_calls_europe = {:name => 'own_country_calls_europe', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_europe}
_sctcg_own_country_calls_other_country = {:name => 'own_country_calls_other_countries', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_mts_other_countries}

_sctcg_own_country_sms_incoming = {:name => 'own_country_sms_incoming', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_in}
_sctcg_own_country_sms_local = {:name => 'own_country_sms_local', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_region}
_sctcg_own_country_sms_home_region = {:name => 'own_country_sms_home_region', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_home_region}
_sctcg_own_country_sms_own_country = {:name => 'own_country_sms_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_own_country}
_sctcg_own_country_sms_not_own_country = {:name => 'own_country_sms_not_own_country', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _sms_out, :service_category_geo_id => _service_to_not_own_country}

_sctcg_own_country_gprs = {:name => 'own_country_gprs', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _gprs}
_sctcg_own_country_internet = {:name => 'own_country_internet', :service_category_rouming_id => _own_country_rouming, :service_category_calls_id => _internet}

#all world rouming    
_sctcg_all_world_sms_incoming = {:name => '_sctcg_all_world_sms_incoming', :service_category_rouming_id => _all_world_rouming, :service_category_calls_id => _sms_in}




  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_category_tarif_class_groups