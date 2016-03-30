require 'test_helper'
#tarif_file_name = 'mts/tarifs/posekundny.rb'
#Dir[Rails.root.join("db/seeds/tarifs/#{tarif_file_name}")].each { |f| require f }
#Dir[Rails.root.join("db/seeds/tarif_tests/#{tarif_file_name}")].each { |f| require f }

describe TarifSeedTester do
  before do
    @tc = TarifCreator.new(Category::Operator::Const::Mts)
    @tc.create_tarif_class({
      :id => _mts_posekundny, :name => 'Посекудный', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _tarif,
      :features => {:http => 'http://www.mts.ru/mob_connect/tariffs/tariffs/second/'},
      :dependency => {
        :categories => [_tcgsc_calls, _tcgsc_sms, _tcgsc_mms, _tcgsc_internet],
        :incompatibility => {}, #{group_name => [tarif_class_ids]}
        :general_priority => _gp_tarif_without_limits,
        :other_tarif_priority => {:lower => [], :higher => []},
        :prerequisites => [],
        :multiple_use => false,    
      } } )
  end

  it "dddd" do
    tarif_file_name = 'mts/tarifs/posekundny.rb'
  
    category = {:name => '_sctcg_own_home_regions_calls_to_own_home_regions_own_operator', :service_category_rouming_id => _own_and_home_regions_rouming, :service_category_calls_id => _calls_out, :service_category_geo_id => _service_to_own_and_home_regions, :service_category_partner_type_id => _service_to_own_operator}
    category = { :name => '_sctcg_all_russia_rouming_mms_to_own_country_own_operator', :service_category_rouming_id => _all_russia_rouming, :service_category_calls_id => _mms_out, :service_category_geo_id => _service_to_all_own_country_regions, :service_category_partner_type_id => _service_to_own_operator}

    service_category_full_paths = (@tc.service_category_full_paths(category))
    parts = []; parts_criteria = []
    service_category_full_paths.each do |service_category_full_path|
      classified_service_category = @tc.classify_service_category(service_category_full_path)
      parts << classified_service_category[0].compact.join('/')
      parts_criteria << classified_service_category[1].compact
    end
    
    parts.must_be :==, true
 
    service_category_full_path = classify_service_parts(service_category_full_paths)
    classified_service_category = classify_service_category(service_category_full_path[0])
    @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :price => 3.25},
      :tarif_set_must_include_tarif_options => [_mts_mms_discount_50_percent] )
  end
end

