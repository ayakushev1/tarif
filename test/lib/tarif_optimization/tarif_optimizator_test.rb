require 'test_helper'

describe TarifOptimization::TarifOptimizator do
  before do
    @tarif_optimizator = TarifOptimization::TarifOptimizator.new({:services_by_operator => 
      {:use_short_tarif_set_name => 'true',
       :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results => 'true',
       :tarifs => {Category::Operator::Const::Beeline => [], Category::Operator::Const::Megafon => [], Category::Operator::Const::Mts => []},
        }})
#    @tarif_optimizator = TarifOptimization::TarifOptimizator.new({:services_by_operator => {:operators => [1030], :tarifs => {1030 => []} } } )
#    @tarif_optimizator = TarifOptimization::TarifOptimizator.new({:services_by_operator => {:operators => [1030], :tarifs => {1030 => [200]} } } )
    @tarif_optimizator.calculate_all_operator_tarifs #calculate_one_operator_tarifs(Category::Operator::Const::Mts)
#    @tarif_results = @tarif_optimizator.tarif_option_stat_results
  end
  
#  it 'must exists' do
#    TarifOptimization::TarifOptimizator.must_be :==, TarifOptimization::TarifOptimizator
#  end
  
  describe 'calculate_all_operator_tarifs' do
    
    describe 'calculate_tarif_results' do
      it 'must return' do
#        @tarif_optimizator.tarif_list_generator.tarif_options.must_be :==, true, @tarif_optimizator.tarif_list_generator.options
#        @tarif_optimizator.calculate_tarif_results(0)
        @tarif_optimizator.final_tarif_set_generator.final_tarif_sets.keys[0..10].must_be :==, @tarif_optimizator.final_tarif_set_generator.final_tarif_sets.keys.size, 
#          @tarif_optimizator.current_tarif_optimization_results.tarif_results.count
#          @tarif_optimizator.current_tarif_optimization_results.tarif_results
          @tarif_optimizator.performance_checker.show_stat
      end
    end
  end

end

