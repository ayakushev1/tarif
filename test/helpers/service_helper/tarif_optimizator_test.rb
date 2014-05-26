require 'test_helper'

describe ServiceHelper::TarifOptimizator do
  before do
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({})
    @tarif_optimizator.calculate_one_operator_tarifs(0)
#    @tarif_results = @tarif_optimizator.tarif_option_stat_results
  end
  
#  it 'must exists' do
#    ServiceHelper::TarifOptimizator.must_be :==, ServiceHelper::TarifOptimizator
#  end
  
  describe 'calculate_all_operator_tarifs' do
    describe 'tarif_option_results' do
#      it 'must return' do
#        @tarif_optimizator.service_categories_cost_sql(80).first.must_be :==, true
#        @tarif_optimizator.calculate_tarif_option_for_service_category_groups_sql(83).first.must_be :==, true
#        @tarif_optimizator.tarif_option_results.must_be :==, true
#        @tarif_results.must_be :==, true
#      end

#      it 'must return' do
#        @tarif_optimizator.service_cost_sql(80).must_be :==, true
#        @tarif_optimizator.service_categories_cost_sql(83).first.must_be :==, true
#        @tarif_optimizator.calculate_tarif_option_for_service_category_groups_sql(83).first.must_be :==, true
#        @tarif_optimizator.tarif_option_results.must_be :==, true
#      end
    end
    
    describe 'calculate_tarif_results' do
      it 'must return' do
#        @tarif_optimizator.tarif_list_generator.all_services[0].must_be :==, true
#        @tarif_optimizator.calculate_tarif_results(0)
#        @tarif_optimizator.tarif_option_results.keys.must_be :==, true
        @tarif_optimizator.tarif_results.keys.must_be :==, true
      end
    end
  end

end

