def access_methods_to_constant_service_category_tarif_class_groups
#onetime services  
_sctcg_one_time_tarif_switch_on = {:name => 'one_time_tarif_switch_on', :service_category_one_time_id => _tarif_switch_on}

#periodic services
_sctcg_periodic_monthly_fee = {:name => 'periodic_monthly_fee', :service_category_periodic_id => _periodic_monthly_fee}
_sctcg_periodic_day_fee = {:name => 'periodic_day_fee', :service_category_periodic_id => _periodic_day_fee}

#any rouming 
_sctcg_mms_incoming = {:name => 'mms_incoming', :service_category_calls_id => _mms_in}
_sctcg_mms_outcoming = {:name => 'mms_outcoming',  :service_category_calls_id => _mms_out}


  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_service_category_tarif_class_groups