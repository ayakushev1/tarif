def access_methods_to_constant_content_categories
#content_type  
  _cntt_demo_results = 1;
  
#content_status
  _cnts_draft = 100; _cnts_reviewed = 101; _cnts_published = 102; _cnts_hidden = 103;

#content_key_rouming
  _cntkr_own_region = 110; _cntkr_home_region = 111; _cntkr_own_country = 112; _cntkr_abroad = 113;

#content_key_service
  _cntks_calls = 120; _cntks_sms = 121; _cntks_mms = 122; _cntks_internet = 123; 

#content_key_destination
  _cntkd_to_own_home_regions = 140; _cntkd_to_russia = 141; _cntkd_to_abroad = 142;
  
#content_key_usage_intensity
  _cntkui_zero = 160; _cntkui_low = 161; _cntkui_medium = 162; _cntkui_high = 163; _cntkui_very_high = 164; 
  

  

  local_variables.each do |symbol|
    send(:define_method, symbol) do
      eval(symbol.to_s)
    end
  end
end

access_methods_to_constant_content_categories