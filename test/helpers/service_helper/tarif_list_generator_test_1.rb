require 'test_helper'

describe ServiceHelper::TarifListGenerator do
  before do
#=begin    
    @trg = ServiceHelper::TarifListGenerator.new({
      :use_short_tarif_set_name => 'true',
      :operators => [_beeline, _megafon, _mts],
      :tarifs => {_beeline => [], _megafon => [], _mts => [
        200, 203,#_mts_red_energy, #_mts_ultra, _mts_smart_plus, _mts_mts_connect_4
        ]},      
      :common_services => {_beeline => [], _megafon => [], _mts => [
        _mts_own_country_rouming, _mts_international_rouming, _mts_own_country_rouming_internet
        ]},
      :tarif_options => {_beeline => [], _megafon => [], _mts => [
        _mts_region, _mts_95_cop_in_moscow_region, _mts_unlimited_calls, _mts_call_free_to_mts_russia_100, _mts_zero_to_mts, #calls
        _mts_love_country, _mts_love_country_all_world, _mts_outcoming_calls_from_11_9_rur, #calls_abroad
        _mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart, _mts_incoming_travelling_in_russia, #country_rouming
        #_mts_additional_minutes_150, _mts_additional_minutes_300, #country_rouming
        #_mts_zero_without_limits, _mts_bit_abroad, _mts_maxi_bit_abroad, _mts_super_bit_abroad, _mts_100mb_in_latvia_and_litva, #international_rouming
        #_mts_bit, _mts_super_bit, _mts_mini_bit, #internet
        #_mts_additional_internet_500_mb, _mts_additional_internet_1_gb, #internet
        #_mts_turbo_button_500_mb, _mts_turbo_button_2_gb, #internet
        #_mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip,#internet
        #_mts_mts_planshet, _mts_mts_planshet_online,#internet
        #_mts_unlimited_internet_on_day,#internet
        #_mts_mms_packet_10, _mts_mms_packet_20, _mts_mms_packet_50, _mts_mms_discount_50_percent, #mms
        #_mts_rodnye_goroda, #service_to_country
        #_mts_50_sms_travelling_in_russia, _mts_100_sms_travelling_in_russia,#sms
        #_mts_50_sms_in_europe, _mts_100_sms_in_europe, _mts_50_sms_travelling_in_all_world, _mts_100_sms_travelling_in_all_world,#sms
        #_mts_onetime_sms_packet_50, _mts_onetime_sms_packet_150, _mts_onetime_sms_packet_300,#sms
        #_mts_monthly_sms_packet_100, _mts_monthly_sms_packet_300, _mts_monthly_sms_packet_500, _mts_monthly_sms_packet_1000,#sms        
      ]},
      })
#=end      
#    @trg = ServiceHelper::TarifListGenerator.new({})
     @tarif = 200
     @trg.calculate_tarif_sets_and_slices(1030, @tarif)
     @trg.calculate_final_tarif_sets
  end
  
  it 'must return' do
    tarif = 200
#    @trg.tarif_options_slices[1030].map{|s| s[:ids].size}.sum.must_be :==, [@trg.tarif_sets.keys]
#    @trg.tarif_sets[@tarif].map{|c| {c[0] => c[1].keys.size}}.must_be :==, 1, @trg.tarif_option_combinations[@tarif].map{|c| {c[0] => c[1].keys.size}}.join("\n")
     @trg.final_tarif_sets.keys.must_be :==, 11, @trg.tarif_sets[200]#@trg.final_tarif_sets.size
    @trg.final_tarif_sets.keys[0..10].must_be :==, @trg.final_tarif_sets.size
#      @trg.final_tarif_sets.keys.count.must_be :==, 11, @trg.final_tarif_sets.size
  end

end

