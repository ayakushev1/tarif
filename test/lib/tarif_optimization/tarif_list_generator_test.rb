require 'test_helper'

describe TarifOptimization::TarifListGenerator do
  it 'must exists' do
    TarifOptimization::TarifListGenerator.must_be :==, ServiceHelper::TarifListGenerator
  end
  
  before do
=begin
    @trg = TarifOptimization::TarifListGenerator.new({
      :operators => [_beeline, _megafon, _mts],
      :tarifs => {_beeline => [], _megafon => [], _mts => [_mts_red_energy, _mts_ultra, _mts_smart_plus, _mts_mts_connect_4]},      
      :common_services => {_beeline => [], _megafon => [], _mts => [_mts_own_country_rouming, _mts_international_rouming, _mts_own_country_rouming_internet]},
      :tarif_options => {_beeline => [], _megafon => [], _mts => [
        _mts_region, _mts_95_cop_in_moscow_region, _mts_unlimited_calls, _mts_call_free_to_mts_russia_100, _mts_zero_to_mts, #calls
        _mts_love_country, _mts_love_country_all_world, _mts_outcoming_calls_from_11_9_rur, #calls_abroad
        _mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart, _mts_incoming_travelling_in_russia, #country_rouming
        _mts_additional_minutes_150, _mts_additional_minutes_300, #country_rouming
        _mts_zero_without_limits, _mts_bit_abroad, _mts_maxi_bit_abroad, _mts_super_bit_abroad, _mts_100mb_in_latvia_and_litva, #international_rouming
        _mts_bit, _mts_super_bit, _mts_mini_bit, #internet
        _mts_additional_internet_500_mb, _mts_additional_internet_1_gb, #internet
        _mts_turbo_button_500_mb, _mts_turbo_button_2_gb, #internet
        _mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip,#internet
        _mts_mts_planshet, _mts_mts_planshet_online,#internet
        _mts_unlimited_internet_on_day,#internet
        _mts_mms_packet_10, _mts_mms_packet_20, _mts_mms_packet_50, _mts_mms_discount_50_percent, #mms
        _mts_rodnye_goroda, #service_to_country
        _mts_50_sms_travelling_in_russia, _mts_100_sms_travelling_in_russia,#sms
        _mts_50_sms_in_europe, _mts_100_sms_in_europe, _mts_50_sms_travelling_in_all_world, _mts_100_sms_travelling_in_all_world,#sms
        _mts_onetime_sms_packet_50, _mts_onetime_sms_packet_150, _mts_onetime_sms_packet_300,#sms
        _mts_monthly_sms_packet_100, _mts_monthly_sms_packet_300, _mts_monthly_sms_packet_500, _mts_monthly_sms_packet_1000,#sms        
      ]},
      })
=end
      @@service_helper_tarif_list_generator_for_test ||= TarifOptimization::TarifListGenerator.new({:use_short_tarif_set_name => 'true'})
      @empty_trg = @@service_helper_tarif_list_generator_for_test
      #raise(StandardError, [@empty_trg.final_tarif_sets[_mts], @empty_trg.final_tarif_sets[_mts].size])

  end
  
  describe 'calculate_all_services' do
    it 'must return' do
#      @trg.all_services_by_operator.must_be :==, {1025=>[], 1028=>[], 1030=>[200, 204, 203, 205, 328, 329, 330, 331, 332, 281, 309, 293, 294, 282, 283, 297, 321, 322, 288, 289, 290, 291, 292, 302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342, 323, 324, 325, 326, 280, 295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339, 276, 277, 312]}
#      @trg.all_services.must_be :==, [200, 204, 203, 205, 328, 329, 330, 331, 332, 281, 309, 293, 294, 282, 283, 297, 321, 322, 288, 289, 290, 291, 292, 302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342, 323, 324, 325, 326, 280, 295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339, 276, 277, 312]

      @empty_trg.all_services_by_operator.must_be :==, {1025=>[], 1028=>[], 1030=>[200, 281, 309]}  
      @empty_trg.all_services.must_be :==, [200, 281, 309]
    end
  end
  
  describe 'load_dependencies' do
    it 'must return' do
#      @trg.dependencies.must_be :==, true
#      @trg.dependencies[_mts_region].must_be :==, {"categories"=>[330], "incompatibility"=>{"home_region_rouming_calls"=>[328, 329]}, "general_priority"=>320, "other_tarif_priority"=>{"lower"=>[], "higher"=>[330]}, "forbidden_tarifs"=>{"to_switch_on"=>[], "to_serve"=>[]}, "prerequisites"=>[-1], "multiple_use"=>false, "parts"=>["own-country-rouming/calls", "periodic", "onetime"]}
#      @trg.dependencies[_mts_region]['parts'].must_be_kind_of(Array)

#      @trg.service_description[_mts_region][:operator_id].must_be :==, _mts

#      @empty_trg.dependencies.must_be :==, 1
    end
  end

  describe 'calculate_uniq_parts_by_operator' do
    it 'must return' do
#      @trg.uniq_parts_by_operator.must_be :==, {1025=>[], 1028=>[], 1030=>["all-world-rouming/sms", "own-country-rouming/sms", "own-country-rouming/mms", "mms", "own-country-rouming/mobile-connection", "own-country-rouming/calls", "periodic", "onetime", "all-world-rouming/calls", "all-world-rouming/mobile-connection"]}

      @empty_trg.uniq_parts_by_operator.must_be :==, {1025=>[], 1028=>[], 1030=>["all-world-rouming/sms", "own-country-rouming/sms", "own-country-rouming/mms", "all-world-rouming/mms", "own-country-rouming/calls", "own-country-rouming/mobile-connection", "periodic", "onetime"]} 
    end
  end

  describe 'calculate_all_services_by_parts' do
    it 'must return' do
#      @trg.all_services_by_parts.must_be :==, {1025=>{}, 1028=>{}, 1030=>{"all-world-rouming/sms"=>[200, 204, 203, 205, 305, 306, 307, 308, 277], "own-country-rouming/sms"=>[200, 204, 203, 205, 295, 296, 333, 334, 335, 336, 337, 338, 339, 276], "own-country-rouming/mms"=>[200, 203, 205, 326], "mms"=>[200, 204, 203, 205, 323, 324, 325], "own-country-rouming/mobile-connection"=>[200, 204, 203, 205, 283, 302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342, 312], "own-country-rouming/calls"=>[200, 204, 203, 205, 328, 329, 330, 331, 332, 281, 309, 294, 282, 283, 297, 321, 322, 280, 276], "periodic"=>[200, 204, 203, 205, 328, 329, 330, 281, 309, 294, 282, 283, 297, 321, 322, 288, 292, 302, 303, 304, 315, 316, 317, 318, 340, 341, 280], "onetime"=>[200, 204, 203, 205, 328, 329, 294, 282, 283, 297, 321, 322, 342, 280], "all-world-rouming/calls"=>[293, 288, 277], "all-world-rouming/mobile-connection"=>[289, 290, 291, 292, 277]}}

      @empty_trg.all_services_by_parts.must_be :==, {1025=>{}, 1028=>{}, 1030=>{"all-world-rouming/sms"=>[200], "own-country-rouming/calls"=>[200, 281, 309], "own-country-rouming/mms"=>[200], "own-country-rouming/sms"=>[200], "all-world-rouming/mms"=>[200], "periodic"=>[200, 281, 309], "onetime"=>[200], "own-country-rouming/mobile-connection"=>[200]}}
    end
  end

  describe 'calculate_common_services_by_parts' do
    it 'must return' do
#      @trg.all_services_by_parts.must_be :==, {1025=>{}, 1028=>{}, 1030=>{"all-world-rouming/sms"=>[200, 204, 203, 205, 305, 306, 307, 308, 277], "own-country-rouming/sms"=>[200, 204, 203, 205, 295, 296, 333, 334, 335, 336, 337, 338, 339, 276], "own-country-rouming/mms"=>[200, 203, 205, 326], "mms"=>[200, 204, 203, 205, 323, 324, 325], "own-country-rouming/mobile-connection"=>[200, 204, 203, 205, 283, 302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342, 312], "own-country-rouming/calls"=>[200, 204, 203, 205, 328, 329, 330, 331, 332, 281, 309, 294, 282, 283, 297, 321, 322, 280, 276], "periodic"=>[200, 204, 203, 205, 328, 329, 330, 281, 309, 294, 282, 283, 297, 321, 322, 288, 292, 302, 303, 304, 315, 316, 317, 318, 340, 341, 280], "onetime"=>[200, 204, 203, 205, 328, 329, 294, 282, 283, 297, 321, 322, 342, 280], "all-world-rouming/calls"=>[293, 288, 277], "all-world-rouming/mobile-connection"=>[289, 290, 291, 292, 277]}}

      @empty_trg.common_services_by_parts.must_be :==, 1
    end
  end

  describe 'calculate_service_packs' do
    it 'must return' do
#      @trg.service_packs.must_be :==, {200=>[200, 276, 277, 312, 329, 281, 309, 302, 303, 304, 315, 316, 317, 318, 340, 341, 295, 296, 336, 337, 338, 339], 204=>[204, 276, 277, 312, 281, 309, 282, 313, 314], 203=>[203, 276, 277, 312, 281, 309, 283, 321, 322, 310, 311, 313, 314, 341, 295, 296, 333, 334, 335, 336, 337, 338, 339], 205=>[205, 276, 277, 312, 330, 281, 309, 341, 342, 295, 296, 333, 334, 335, 336, 337, 338, 339]}
#      @trg.service_packs[_mts_smart_plus].include?(_mts_additional_minutes_300).must_be :==, true 
#      @trg.service_packs[_mts_red_energy].include?(_mts_additional_minutes_300).must_be :==, false 
#      @trg.service_packs[_mts_ultra].include?(_mts_monthly_sms_packet_500).must_be :==, false 

      @empty_trg.service_packs.must_be :==, {200=>[200, 281, 309]}
    end
  end

  describe 'calculate_service_packs_by_parts' do
    it 'must return' do
#      @trg.service_packs_by_parts[_mts_smart_plus].must_be :==, {"all-world-rouming/sms"=>[203, 277], "own-country-rouming/mobile-connection"=>[203, 312, 283, 310, 311, 313, 314, 341], "own-country-rouming/mms"=>[203], "own-country-rouming/sms"=>[203, 276, 295, 296, 333, 334, 335, 336, 337, 338, 339], "mms"=>[203], "own-country-rouming/calls"=>[203, 276, 281, 309, 283, 321, 322], "periodic"=>[203, 281, 309, 283, 321, 322, 341], "onetime"=>[203, 283, 321, 322], "all-world-rouming/mobile-connection"=>[277], "all-world-rouming/calls"=>[277]}

      @empty_trg.service_packs_by_parts.must_be :==, {200=>{"all-world-rouming/sms"=>[200], "own-country-rouming/calls"=>[200, 281, 309], "own-country-rouming/mms"=>[200], "own-country-rouming/sms"=>[200], "all-world-rouming/mms"=>[200], "periodic"=>[200, 281, 309], "onetime"=>[200], "own-country-rouming/mobile-connection"=>[200]}}
    end
  end

  describe 'calculate_service_packs_by_general_priority' do
    it 'must return' do
#      @trg.service_packs_by_general_priority[_mts_smart_plus].must_be :==, {"all-world-rouming/sms"=>{322=>[203], 324=>[277]}, "own-country-rouming/mobile-connection"=>{322=>[203], 324=>[312], 320=>[283], 323=>[310, 311, 313, 314, 341]}, "own-country-rouming/mms"=>{322=>[203]}, "own-country-rouming/sms"=>{322=>[203], 324=>[276], 323=>[295, 296, 333, 334, 335, 336, 337, 338, 339]}, "mms"=>{322=>[203]}, "own-country-rouming/calls"=>{322=>[203], 324=>[276], 320=>[281, 309, 283, 321, 322]}, "periodic"=>{322=>[203], 320=>[281, 309, 283, 321, 322], 323=>[341]}, "onetime"=>{322=>[203], 320=>[283, 321, 322]}, "all-world-rouming/mobile-connection"=>{324=>[277]}, "all-world-rouming/calls"=>{324=>[277]}}

      @empty_trg.service_packs_by_general_priority.must_be :==, {200=>{"all-world-rouming/sms"=>{321=>[200]}, "own-country-rouming/calls"=>{321=>[200], 320=>[281, 309]}, "own-country-rouming/mms"=>{321=>[200]}, "own-country-rouming/sms"=>{321=>[200]}, "all-world-rouming/mms"=>{321=>[200]}, "periodic"=>{321=>[200], 320=>[281, 309]}, "onetime"=>{321=>[200]}, "own-country-rouming/mobile-connection"=>{321=>[200]}}}  
    end
  end

  describe 'calculate_tarif_option_by_compatibility' do
    it 'must return' do
#      @trg.tarif_option_by_compatibility[_mts_smart_plus].must_be :==, {"all-world-rouming/sms"=>{}, "own-country-rouming/mobile-connection"=>{283=>[283], "internet_smart"=>[310, 311], "internet_comp"=>[310, 311], 313=>[313], 314=>[314], 341=>[341]}, "own-country-rouming/mms"=>{}, "own-country-rouming/sms"=>{295=>[295], 296=>[296], 333=>[333], 334=>[334], 335=>[335], "monthly_sms_packet"=>[336, 337, 338, 339]}, "mms"=>{}, "own-country-rouming/calls"=>{"love_country"=>[281, 309], 283=>[283], 321=>[321], 322=>[322]}, "periodic"=>{"love_country"=>[281, 309], 283=>[283], 321=>[321], 322=>[322], 341=>[341]}, "onetime"=>{283=>[283], 321=>[321], 322=>[322]}, "all-world-rouming/mobile-connection"=>{}, "all-world-rouming/calls"=>{}}  

      @empty_trg.tarif_option_by_compatibility.must_be :==, {200=>{"all-world-rouming/sms"=>{""=>[]}, "own-country-rouming/calls"=>{"love_country"=>[281, 309]}, "own-country-rouming/mms"=>{""=>[]}, "own-country-rouming/sms"=>{""=>[]}, "all-world-rouming/mms"=>{""=>[]}, "periodic"=>{"love_country"=>[281, 309]}, "onetime"=>{""=>[]}, "own-country-rouming/mobile-connection"=>{""=>[]}}} 
    end
  end

  describe 'calculate_tarif_option_combinations' do
    it 'must return' do
#      @trg.tarif_option_combinations[_mts_smart_plus]['own-country-rouming/calls'].keys.sort.must_be :==, ["", "281", "281_283", "281_283_321", "281_283_321_322", "281_283_322", "281_321", "281_321_322", "281_322", "283", "283_309", "283_309_321", "283_309_321_322", "283_309_322", "283_321", "283_321_322", "283_322", "309", "309_321", "309_321_322", "309_322", "321", "321_322", "322"]  

      @empty_trg.tarif_option_combinations.must_be :==, {200=>{"all-world-rouming/sms"=>{""=>[]}, "own-country-rouming/calls"=>{"281"=>[281], "309"=>[309], ""=>[]}, "own-country-rouming/mms"=>{""=>[]}, "own-country-rouming/sms"=>{""=>[]}, "all-world-rouming/mms"=>{""=>[]}, "periodic"=>{"281"=>[281], "309"=>[309], ""=>[]}, "onetime"=>{""=>[]}, "own-country-rouming/mobile-connection"=>{""=>[]}}}
    end
  end

  describe 'reorder_tarif_option_combinations' do
    it 'must return' do
#      @trg.tarif_option_combinations[_mts_smart_plus].must_be :==, {"all-world-rouming/sms"=>{}, "own-country-rouming/mobile-connection"=>{"283"=>[283], ""=>[], "310_283"=>[310, 283], "311_283"=>[311, 283], "310"=>[310], "311"=>[311], "310_311_283"=>[310, 311, 283], "310_311"=>[310, 311], "313_283"=>[313, 283], "313"=>[313], "310_313_283"=>[310, 313, 283], "311_313_283"=>[311, 313, 283], "310_313"=>[310, 313], "311_313"=>[311, 313], "310_311_313_283"=>[310, 311, 313, 283], "310_311_313"=>[310, 311, 313], "314_283"=>[314, 283], "314"=>[314], "310_314_283"=>[310, 314, 283], "311_314_283"=>[311, 314, 283], "310_314"=>[310, 314], "311_314"=>[311, 314], "310_311_314_283"=>[310, 311, 314, 283], "310_311_314"=>[310, 311, 314], "313_314_283"=>[313, 314, 283], "313_314"=>[313, 314], "310_313_314_283"=>[310, 313, 314, 283], "311_313_314_283"=>[311, 313, 314, 283], "310_313_314"=>[310, 313, 314], "311_313_314"=>[311, 313, 314], "310_311_313_314_283"=>[310, 311, 313, 314, 283], "310_311_313_314"=>[310, 311, 313, 314], "341_283"=>[341, 283], "341"=>[341], "310_341_283"=>[310, 341, 283], "311_341_283"=>[311, 341, 283], "310_341"=>[310, 341], "311_341"=>[311, 341], "310_311_341_283"=>[310, 311, 341, 283], "310_311_341"=>[310, 311, 341], "313_341_283"=>[313, 341, 283], "313_341"=>[313, 341], "310_313_341_283"=>[310, 313, 341, 283], "311_313_341_283"=>[311, 313, 341, 283], "310_313_341"=>[310, 313, 341], "311_313_341"=>[311, 313, 341], "310_311_313_341_283"=>[310, 311, 313, 341, 283], "310_311_313_341"=>[310, 311, 313, 341], "314_341_283"=>[314, 341, 283], "314_341"=>[314, 341], "310_314_341_283"=>[310, 314, 341, 283], "311_314_341_283"=>[311, 314, 341, 283], "310_314_341"=>[310, 314, 341], "311_314_341"=>[311, 314, 341], "310_311_314_341_283"=>[310, 311, 314, 341, 283], "310_311_314_341"=>[310, 311, 314, 341], "313_314_341_283"=>[313, 314, 341, 283], "313_314_341"=>[313, 314, 341], "310_313_314_341_283"=>[310, 313, 314, 341, 283], "311_313_314_341_283"=>[311, 313, 314, 341, 283], "310_313_314_341"=>[310, 313, 314, 341], "311_313_314_341"=>[311, 313, 314, 341], "310_311_313_314_341_283"=>[310, 311, 313, 314, 341, 283], "310_311_313_314_341"=>[310, 311, 313, 314, 341]}, "own-country-rouming/mms"=>{}, "own-country-rouming/sms"=>{"295"=>[295], ""=>[], "295_296"=>[295, 296], "296"=>[296], "295_333"=>[295, 333], "333"=>[333], "295_296_333"=>[295, 296, 333], "296_333"=>[296, 333], "295_334"=>[295, 334], "334"=>[334], "295_296_334"=>[295, 296, 334], "296_334"=>[296, 334], "295_333_334"=>[295, 333, 334], "333_334"=>[333, 334], "295_296_333_334"=>[295, 296, 333, 334], "296_333_334"=>[296, 333, 334], "295_335"=>[295, 335], "335"=>[335], "295_296_335"=>[295, 296, 335], "296_335"=>[296, 335], "295_333_335"=>[295, 333, 335], "333_335"=>[333, 335], "295_296_333_335"=>[295, 296, 333, 335], "296_333_335"=>[296, 333, 335], "295_334_335"=>[295, 334, 335], "334_335"=>[334, 335], "295_296_334_335"=>[295, 296, 334, 335], "296_334_335"=>[296, 334, 335], "295_333_334_335"=>[295, 333, 334, 335], "333_334_335"=>[333, 334, 335], "295_296_333_334_335"=>[295, 296, 333, 334, 335], "296_333_334_335"=>[296, 333, 334, 335], "295_336"=>[295, 336], "295_337"=>[295, 337], "295_338"=>[295, 338], "295_339"=>[295, 339], "336"=>[336], "337"=>[337], "338"=>[338], "339"=>[339], "295_296_336"=>[295, 296, 336], "295_296_337"=>[295, 296, 337], "295_296_338"=>[295, 296, 338], "295_296_339"=>[295, 296, 339], "296_336"=>[296, 336], "296_337"=>[296, 337], "296_338"=>[296, 338], "296_339"=>[296, 339], "295_333_336"=>[295, 333, 336], "295_333_337"=>[295, 333, 337], "295_333_338"=>[295, 333, 338], "295_333_339"=>[295, 333, 339], "333_336"=>[333, 336], "333_337"=>[333, 337], "333_338"=>[333, 338], "333_339"=>[333, 339], "295_296_333_336"=>[295, 296, 333, 336], "295_296_333_337"=>[295, 296, 333, 337], "295_296_333_338"=>[295, 296, 333, 338], "295_296_333_339"=>[295, 296, 333, 339], "296_333_336"=>[296, 333, 336], "296_333_337"=>[296, 333, 337], "296_333_338"=>[296, 333, 338], "296_333_339"=>[296, 333, 339], "295_334_336"=>[295, 334, 336], "295_334_337"=>[295, 334, 337], "295_334_338"=>[295, 334, 338], "295_334_339"=>[295, 334, 339], "334_336"=>[334, 336], "334_337"=>[334, 337], "334_338"=>[334, 338], "334_339"=>[334, 339], "295_296_334_336"=>[295, 296, 334, 336], "295_296_334_337"=>[295, 296, 334, 337], "295_296_334_338"=>[295, 296, 334, 338], "295_296_334_339"=>[295, 296, 334, 339], "296_334_336"=>[296, 334, 336], "296_334_337"=>[296, 334, 337], "296_334_338"=>[296, 334, 338], "296_334_339"=>[296, 334, 339], "295_333_334_336"=>[295, 333, 334, 336], "295_333_334_337"=>[295, 333, 334, 337], "295_333_334_338"=>[295, 333, 334, 338], "295_333_334_339"=>[295, 333, 334, 339], "333_334_336"=>[333, 334, 336], "333_334_337"=>[333, 334, 337], "333_334_338"=>[333, 334, 338], "333_334_339"=>[333, 334, 339], "295_296_333_334_336"=>[295, 296, 333, 334, 336], "295_296_333_334_337"=>[295, 296, 333, 334, 337], "295_296_333_334_338"=>[295, 296, 333, 334, 338], "295_296_333_334_339"=>[295, 296, 333, 334, 339], "296_333_334_336"=>[296, 333, 334, 336], "296_333_334_337"=>[296, 333, 334, 337], "296_333_334_338"=>[296, 333, 334, 338], "296_333_334_339"=>[296, 333, 334, 339], "295_335_336"=>[295, 335, 336], "295_335_337"=>[295, 335, 337], "295_335_338"=>[295, 335, 338], "295_335_339"=>[295, 335, 339], "335_336"=>[335, 336], "335_337"=>[335, 337], "335_338"=>[335, 338], "335_339"=>[335, 339], "295_296_335_336"=>[295, 296, 335, 336], "295_296_335_337"=>[295, 296, 335, 337], "295_296_335_338"=>[295, 296, 335, 338], "295_296_335_339"=>[295, 296, 335, 339], "296_335_336"=>[296, 335, 336], "296_335_337"=>[296, 335, 337], "296_335_338"=>[296, 335, 338], "296_335_339"=>[296, 335, 339], "295_333_335_336"=>[295, 333, 335, 336], "295_333_335_337"=>[295, 333, 335, 337], "295_333_335_338"=>[295, 333, 335, 338], "295_333_335_339"=>[295, 333, 335, 339], "333_335_336"=>[333, 335, 336], "333_335_337"=>[333, 335, 337], "333_335_338"=>[333, 335, 338], "333_335_339"=>[333, 335, 339], "295_296_333_335_336"=>[295, 296, 333, 335, 336], "295_296_333_335_337"=>[295, 296, 333, 335, 337], "295_296_333_335_338"=>[295, 296, 333, 335, 338], "295_296_333_335_339"=>[295, 296, 333, 335, 339], "296_333_335_336"=>[296, 333, 335, 336], "296_333_335_337"=>[296, 333, 335, 337], "296_333_335_338"=>[296, 333, 335, 338], "296_333_335_339"=>[296, 333, 335, 339], "295_334_335_336"=>[295, 334, 335, 336], "295_334_335_337"=>[295, 334, 335, 337], "295_334_335_338"=>[295, 334, 335, 338], "295_334_335_339"=>[295, 334, 335, 339], "334_335_336"=>[334, 335, 336], "334_335_337"=>[334, 335, 337], "334_335_338"=>[334, 335, 338], "334_335_339"=>[334, 335, 339], "295_296_334_335_336"=>[295, 296, 334, 335, 336], "295_296_334_335_337"=>[295, 296, 334, 335, 337], "295_296_334_335_338"=>[295, 296, 334, 335, 338], "295_296_334_335_339"=>[295, 296, 334, 335, 339], "296_334_335_336"=>[296, 334, 335, 336], "296_334_335_337"=>[296, 334, 335, 337], "296_334_335_338"=>[296, 334, 335, 338], "296_334_335_339"=>[296, 334, 335, 339], "295_333_334_335_336"=>[295, 333, 334, 335, 336], "295_333_334_335_337"=>[295, 333, 334, 335, 337], "295_333_334_335_338"=>[295, 333, 334, 335, 338], "295_333_334_335_339"=>[295, 333, 334, 335, 339], "333_334_335_336"=>[333, 334, 335, 336], "333_334_335_337"=>[333, 334, 335, 337], "333_334_335_338"=>[333, 334, 335, 338], "333_334_335_339"=>[333, 334, 335, 339], "295_296_333_334_335_336"=>[295, 296, 333, 334, 335, 336], "295_296_333_334_335_337"=>[295, 296, 333, 334, 335, 337], "295_296_333_334_335_338"=>[295, 296, 333, 334, 335, 338], "295_296_333_334_335_339"=>[295, 296, 333, 334, 335, 339], "296_333_334_335_336"=>[296, 333, 334, 335, 336], "296_333_334_335_337"=>[296, 333, 334, 335, 337], "296_333_334_335_338"=>[296, 333, 334, 335, 338], "296_333_334_335_339"=>[296, 333, 334, 335, 339]}, "mms"=>{}, "own-country-rouming/calls"=>{"281"=>[281], "309"=>[309], ""=>[], "281_283"=>[281, 283], "283_309"=>[283, 309], "283"=>[283], "281_321"=>[281, 321], "309_321"=>[309, 321], "321"=>[321], "281_283_321"=>[281, 283, 321], "283_309_321"=>[283, 309, 321], "283_321"=>[283, 321], "281_322"=>[281, 322], "309_322"=>[309, 322], "322"=>[322], "281_283_322"=>[281, 283, 322], "283_309_322"=>[283, 309, 322], "283_322"=>[283, 322], "281_321_322"=>[281, 321, 322], "309_321_322"=>[309, 321, 322], "321_322"=>[321, 322], "281_283_321_322"=>[281, 283, 321, 322], "283_309_321_322"=>[283, 309, 321, 322], "283_321_322"=>[283, 321, 322]}, "periodic"=>{"281"=>[281], "309"=>[309], ""=>[], "281_283"=>[281, 283], "283_309"=>[283, 309], "283"=>[283], "281_321"=>[281, 321], "309_321"=>[309, 321], "321"=>[321], "281_283_321"=>[281, 283, 321], "283_309_321"=>[283, 309, 321], "283_321"=>[283, 321], "281_322"=>[281, 322], "309_322"=>[309, 322], "322"=>[322], "281_283_322"=>[281, 283, 322], "283_309_322"=>[283, 309, 322], "283_322"=>[283, 322], "281_321_322"=>[281, 321, 322], "309_321_322"=>[309, 321, 322], "321_322"=>[321, 322], "281_283_321_322"=>[281, 283, 321, 322], "283_309_321_322"=>[283, 309, 321, 322], "283_321_322"=>[283, 321, 322], "341_281"=>[341, 281], "341_309"=>[341, 309], "341"=>[341], "341_281_283"=>[341, 281, 283], "341_283_309"=>[341, 283, 309], "341_283"=>[341, 283], "341_281_321"=>[341, 281, 321], "341_309_321"=>[341, 309, 321], "341_321"=>[341, 321], "341_281_283_321"=>[341, 281, 283, 321], "341_283_309_321"=>[341, 283, 309, 321], "341_283_321"=>[341, 283, 321], "341_281_322"=>[341, 281, 322], "341_309_322"=>[341, 309, 322], "341_322"=>[341, 322], "341_281_283_322"=>[341, 281, 283, 322], "341_283_309_322"=>[341, 283, 309, 322], "341_283_322"=>[341, 283, 322], "341_281_321_322"=>[341, 281, 321, 322], "341_309_321_322"=>[341, 309, 321, 322], "341_321_322"=>[341, 321, 322], "341_281_283_321_322"=>[341, 281, 283, 321, 322], "341_283_309_321_322"=>[341, 283, 309, 321, 322], "341_283_321_322"=>[341, 283, 321, 322]}, "onetime"=>{"283"=>[283], ""=>[], "283_321"=>[283, 321], "321"=>[321], "283_322"=>[283, 322], "322"=>[322], "283_321_322"=>[283, 321, 322], "321_322"=>[321, 322]}, "all-world-rouming/mobile-connection"=>{}, "all-world-rouming/calls"=>{}}  
#      @trg.tarif_option_combinations[_mts_red_energy]['own-country-rouming/mobile-connection'].keys.sort.must_be :==, ["", "302", "302_341", "303", "303_341", "304", "304_302", "304_303", "304_315", "304_316", "304_317", "304_318", "304_340", "304_340_341", "304_341", "304_341_302", "304_341_303", "304_341_315", "304_341_316", "304_341_317", "304_341_318", "315", "315_341", "316", "316_341", "317", "317_341", "318", "318_341", "340", "340_341", "341"]  

      @empty_trg.tarif_option_combinations.must_be :==, {200=>{"all-world-rouming/sms"=>{""=>[]}, "own-country-rouming/calls"=>{"281"=>[281], "309"=>[309], ""=>[]}, "own-country-rouming/mms"=>{""=>[]}, "own-country-rouming/sms"=>{""=>[]}, "all-world-rouming/mms"=>{""=>[]}, "periodic"=>{"281"=>[281], "309"=>[309], ""=>[]}, "onetime"=>{""=>[]}, "own-country-rouming/mobile-connection"=>{""=>[]}}} 
    end
  end

  describe 'calculate_tarif_option_combinations_with_multiple_use' do
    it 'must return' do
#      @trg.tarif_option_combinations[_mts_red_energy]['own-country-rouming/mobile-connection'].keys.sort.must_be :==, 1  
    end
  end

  describe 'calculate_tarif_sets' do
    it 'must return' do
#      @trg.tarif_sets[_mts_red_energy]['own-country-rouming/mobile-connection'].keys.sort.must_be :==, ["276_277_312_200", "276_277_312_200_302", "276_277_312_200_302_341", "276_277_312_200_303", "276_277_312_200_303_341", "276_277_312_200_304", "276_277_312_200_304_302", "276_277_312_200_304_303", "276_277_312_200_304_315", "276_277_312_200_304_316", "276_277_312_200_304_317", "276_277_312_200_304_318", "276_277_312_200_304_340", "276_277_312_200_304_340_341", "276_277_312_200_304_341", "276_277_312_200_304_341_302", "276_277_312_200_304_341_303", "276_277_312_200_304_341_315", "276_277_312_200_304_341_316", "276_277_312_200_304_341_317", "276_277_312_200_304_341_318", "276_277_312_200_315", "276_277_312_200_315_341", "276_277_312_200_316", "276_277_312_200_316_341", "276_277_312_200_317", "276_277_312_200_317_341", "276_277_312_200_318", "276_277_312_200_318_341", "276_277_312_200_340", "276_277_312_200_340_341", "276_277_312_200_341"]  
      @empty_trg.tarif_sets[200].must_be :==, 1
      @empty_trg.tarif_sets[200].must_be :==, {"all-world-rouming/sms"=>{"200"=>[200]}, "own-country-rouming/sms"=>{"200"=>[200]}, "own-country-rouming/mms"=>{"200"=>[200]}, "all-world-rouming/mms"=>{"200"=>[200]}, "own-country-rouming/calls"=>{"200_281"=>[200, 281], "200_309"=>[200, 309], "200"=>[200]}, "own-country-rouming/mobile-connection"=>{"200"=>[200]}, "periodic"=>{"200_281"=>[200, 281], "200_309"=>[200, 309], "200"=>[200]}, "onetime"=>{"200"=>[200]}}
      @empty_trg.tarif_sets.must_be :==, {200=>{"all-world-rouming/sms"=>{"200"=>[200]}, "own-country-rouming/sms"=>{"200"=>[200]}, "own-country-rouming/mms"=>{"200"=>[200]}, "all-world-rouming/mms"=>{"200"=>[200]}, "own-country-rouming/calls"=>{"200_281"=>[200, 281], "200_309"=>[200, 309], "200"=>[200]}, "own-country-rouming/mobile-connection"=>{"200"=>[200]}, "periodic"=>{"200_281"=>[200, 281], "200_309"=>[200, 309], "200"=>[200]}, "onetime"=>{"200"=>[200]}}} 
    end
  end

  describe 'calculate_final_tarif_sets' do
    it 'must return' do
      @empty_trg.final_tarif_sets.keys.must_be :==, 1, @empty_trg.final_tarif_sets.keys.size

      @empty_trg.final_tarif_sets.keys.must_be :==, ["200_281", "200_281_309", "200_309_281", "200_309", "200"] 
      @empty_trg.final_tarif_sets["200_281"][:tarif_sets_by_part].keys.must_be :==, ["200_281"]
      @empty_trg.final_tarif_sets["200_281"][:tarif_sets_by_part].must_be :==, {"200_281"=>[["all-world-rouming/sms", "200"], ["own-country-rouming/sms", "200"], ["own-country-rouming/mms", "200"], ["all-world-rouming/mms", "200"], ["own-country-rouming/calls", "200_281"], ["own-country-rouming/mobile-connection", "200"], ["periodic", "200_281"], ["onetime", "200"]]}  
      @empty_trg.final_tarif_sets["200_281"][:tarif_sets_by_part].include?(["own-country-rouming/calls", "200_309"]).must_be :==, false
#      @empty_trg.final_tarif_sets['200_281_309'][:tarif_sets_by_part]['200_281_309'].map{|a| a[1] if a[0] == "periodic"}.must_be :==, 1
#      @empty_trg.final_tarif_sets['200_281_309'][:tarif_sets_by_part]['200_281_309'].map{|a| a[1]}.must_be :==, 1
      @empty_trg.final_tarif_sets['200_281_309'][:tarif_sets_by_part].must_be :==, {"200_281_309"=>[["all-world-rouming/sms", "200"], ["own-country-rouming/sms", "200"], ["own-country-rouming/mms", "200"], ["all-world-rouming/mms", "200"], ["own-country-rouming/calls", "200_281"], ["own-country-rouming/mobile-connection", "200"], ["periodic", "200_309"], ["onetime", "200"]]}
    end
  end

  describe 'calculate_tarif_options_slices' do
    it 'must return' do
#      @trg.tarif_options_slices[_mts][0].must_be :==, {:ids=>[329, 281, 309, 329, 281, 309, 329, 282, 282, 282, 283, 283, 321, 322, 283, 321, 322, 283, 321, 322, 330, 330], :prev_ids=>[[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []], :set_ids=>["329", "281", "309", "329", "281", "309", "329", "282", "282", "282", "283", "283", "321", "322", "283", "321", "322", "283", "321", "322", "330", "330"], :prev_set_ids=>["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""], :uniq_set_ids=>{"329::own-country-rouming/calls"=>"329::own-country-rouming/calls", "281::own-country-rouming/calls"=>"281::own-country-rouming/calls", "309::own-country-rouming/calls"=>"309::own-country-rouming/calls", "329::periodic"=>"329::periodic", "281::periodic"=>"281::periodic", "309::periodic"=>"309::periodic", "329::onetime"=>"329::onetime", "282::own-country-rouming/calls"=>"282::own-country-rouming/calls", "282::periodic"=>"282::periodic", "282::onetime"=>"282::onetime", "283::own-country-rouming/mobile-connection"=>"283::own-country-rouming/mobile-connection", "283::own-country-rouming/calls"=>"283::own-country-rouming/calls", "321::own-country-rouming/calls"=>"321::own-country-rouming/calls", "322::own-country-rouming/calls"=>"322::own-country-rouming/calls", "283::periodic"=>"283::periodic", "321::periodic"=>"321::periodic", "322::periodic"=>"322::periodic", "283::onetime"=>"283::onetime", "321::onetime"=>"321::onetime", "322::onetime"=>"322::onetime", "330::own-country-rouming/calls"=>"330::own-country-rouming/calls", "330::periodic"=>"330::periodic"}, :parts=>["own-country-rouming/calls", "own-country-rouming/calls", "own-country-rouming/calls", "periodic", "periodic", "periodic", "onetime", "own-country-rouming/calls", "periodic", "onetime", "own-country-rouming/mobile-connection", "own-country-rouming/calls", "own-country-rouming/calls", "own-country-rouming/calls", "periodic", "periodic", "periodic", "onetime", "onetime", "onetime", "own-country-rouming/calls", "periodic"]}    
#      @trg.tarif_options_slices[_mts][1][:uniq_set_ids].keys.must_be :==, 1  
#      @trg.tarif_options_slices[_mts].must_be :==, 2  

      @empty_trg.tarif_options_slices[_mts].must_be :==, 1 
      @empty_trg.tarif_options_slices[_mts].must_be :==, [{:ids=>[281, 309, 281, 309], :prev_ids=>[[], [], [], []], :set_ids=>["281", "309", "281", "309"], :prev_set_ids=>["", "", "", ""], :uniq_set_ids=>{"281::own-country-rouming/calls"=>"281::own-country-rouming/calls", "309::own-country-rouming/calls"=>"309::own-country-rouming/calls", "281::periodic"=>"281::periodic", "309::periodic"=>"309::periodic"}, :parts=>["own-country-rouming/calls", "own-country-rouming/calls", "periodic", "periodic"]}] 
    end
  end

  describe 'calculate_max_tarif_options_slice' do
    it 'must return' do
#      @trg.max_tarif_options_slice.must_be :==, {1025=>0, 1028=>0, 1030=>6} 
#      @trg.tarif_options_count.must_be :==, {1025=>0, 1028=>0, 1030=>104}

      @empty_trg.max_tarif_options_slice.must_be :==, {1025=>0, 1028=>0, 1030=>1}
      @empty_trg.tarif_options_count.must_be :==, {1025=>0, 1028=>0, 1030=>4} 
    end
  end

  describe 'calculate_tarifs_slices' do
    it 'must return' do
      @empty_trg.tarifs_slices[_mts].must_be :==, 1   
#      @trg.tarifs_slices[_mts][1][:uniq_set_ids].keys.must_be :==, 1  
      result = []
      @empty_trg.tarifs_slices[_mts].each do |s|
        temp = {} 
        s[:parts].each_index do |i|
          s.keys.each do |key|
            temp[key] ||= []
            temp[key] << s[key][i]
          end if s[:set_ids][i] == '203'
        end 
        result << temp
      end
      result.must_be :==, 1 
      @empty_trg.tarifs_slices[_mts].must_be :==, [{:ids=>[200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200], :prev_ids=>[[], [], [], [], [281], [309], [], [], [281], [309], [], []], :set_ids=>["200", "200", "200", "200", "200_281", "200_309", "200", "200", "200_281", "200_309", "200", "200"], :prev_set_ids=>["", "", "", "", "281", "309", "", "", "281", "309", "", ""], :uniq_set_ids=>{"200::all-world-rouming/sms"=>"200::all-world-rouming/sms", "200::own-country-rouming/sms"=>"200::own-country-rouming/sms", "200::own-country-rouming/mms"=>"200::own-country-rouming/mms", "200::all-world-rouming/mms"=>"200::all-world-rouming/mms", "200::own-country-rouming/calls_281::own-country-rouming/calls"=>"200::own-country-rouming/calls_281::own-country-rouming/calls", "200::own-country-rouming/calls_309::own-country-rouming/calls"=>"200::own-country-rouming/calls_309::own-country-rouming/calls", "200::own-country-rouming/calls"=>"200::own-country-rouming/calls", "200::own-country-rouming/mobile-connection"=>"200::own-country-rouming/mobile-connection", "200::periodic_281::periodic"=>"200::periodic_281::periodic", "200::periodic_309::periodic"=>"200::periodic_309::periodic", "200::periodic"=>"200::periodic", "200::onetime"=>"200::onetime"}, :parts=>["all-world-rouming/sms", "own-country-rouming/sms", "own-country-rouming/mms", "all-world-rouming/mms", "own-country-rouming/calls", "own-country-rouming/calls", "own-country-rouming/calls", "own-country-rouming/mobile-connection", "periodic", "periodic", "periodic", "onetime"]}]
    end
  end

  describe 'calculate_max_tarifs_slice' do
    it 'must return' do
#      @trg.max_tarifs_slice.must_be :==, {1025=>0, 1028=>0, 1030=>10} 
#      @trg.tarifs_count.must_be :==, {1025=>0, 1028=>0, 1030=>3248}

      @empty_trg.max_tarifs_slice.must_be :==, {1025=>0, 1028=>0, 1030=>1}, @empty_trg.tarifs_count
      @empty_trg.tarifs_count.must_be :==, {1025=>0, 1028=>0, 1030=>12}
    end
  end

  describe 'tarif_set_id' do
    it 'must return' do
#      @trg.tarif_set_id([0, 75, 93, nil, 77, nil, nil, nil]).must_be :==, '0_75_93_77' 
    end
  end

end

