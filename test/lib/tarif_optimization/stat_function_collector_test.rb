require 'test_helper'

describe TarifOptimization::StatFunctionCollector do
  before do
    @tarif_list_generator = TarifOptimization::TarifListGenerator.new
    @sfc = TarifOptimization::StatFunctionCollector.new(@tarif_list_generator.all_services[2])
  end
  
  it 'must exists' do
    TarifOptimization::StatFunctionCollector.must_be :==, ServiceHelper::StatFunctionCollector
  end
  
  describe 'collect_stat_for_service_category_groups' do
    it 'must produce array' do
      @sfc.service_stat.must_be :==, true
    end
  end

  describe 'price_formula_string' do
    it 'must produce string' do
#      @sfc.price_formula_string(price_formula_id).must_be :==, true
    end
  end

  describe 'price_formula_string' do
    it 'must produce string' do
#      @sfc.price_formulas_string_for_price_list(price_formula_ids).must_be :==, true
    end
  end

end

