require 'test_helper'

describe ServiceHelper::TarifOptimizator do
  before do
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({})
#    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({:services_by_operator => {:operators => [1030], :tarifs => {1030 => []} } } )
#    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({:services_by_operator => {:operators => [1030], :tarifs => {1030 => [200]} } } )
    @tarif_optimizator.calculate_one_operator_tarifs(_mts)
#    @tarif_results = @tarif_optimizator.tarif_option_stat_results
  end
  
#  it 'must exists' do
#    ServiceHelper::TarifOptimizator.must_be :==, ServiceHelper::TarifOptimizator
#  end
  
  describe 'calculate_all_operator_tarifs' do
    
    describe 'calculate_tarif_results' do
      it 'must return' do
#        @tarif_optimizator.tarif_list_generator.tarif_options.must_be :==, true, @tarif_optimizator.tarif_list_generator.options
#        @tarif_optimizator.calculate_tarif_results(0)
        @tarif_optimizator.current_tarif_optimization_results.tarif_results.keys.must_be :==, true, 
#          @tarif_optimizator.current_tarif_optimization_results.tarif_results.count
#          @tarif_optimizator.current_tarif_optimization_results.tarif_results
          @tarif_optimizator.performance_checker.show_stat
      end
    end
  end

end

