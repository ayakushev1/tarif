require 'test_helper'

describe ServiceHelper::TarifOptimizator do
  before do
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new()
    @tarif_optimizator.calculate_one_operator_tarifs(_mts)
#    @tarif_results = @tarif_optimizator.tarif_option_stat_results
  end
  
#  it 'must exists' do
#    ServiceHelper::TarifOptimizator.must_be :==, ServiceHelper::TarifOptimizator
#  end
  
  describe 'calculate_all_operator_tarifs' do
    
    describe 'calculate_tarif_results' do
      it 'must return' do
#        @tarif_optimizator.tarif_list_generator.all_services[0].must_be :==, true
#        @tarif_optimizator.calculate_tarif_results(0)
        @tarif_optimizator.tarif_results.keys.count.must_be :==, true, @tarif_optimizator.performance_checker.show_stat #@tarif_optimizator.tarif_results.keys.count
      end
    end
  end

end

