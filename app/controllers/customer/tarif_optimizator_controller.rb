class Customer::TarifOptimizatorController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action :init_tarif_optimizator, except: :recalculate
  attr_reader :tarif_optimizator, :operator_index

  def service_sets
    arr = []
    max_tarif_slice = tarif_optimizator.tarif_list_generator.max_tarif_slice[operator_index]
    tarif_optimizator.tarif_list_generator.tarif_slices[operator_index][max_tarif_slice - 1][:ids].each_index do |i|
      id = tarif_optimizator.tarif_list_generator.tarif_slices[operator_index][max_tarif_slice - 1][:ids][i] 
      prev_ids = tarif_optimizator.tarif_list_generator.tarif_slices[operator_index][max_tarif_slice - 1][:prev_ids][i] 
      arr << {'service_sets_id' => ([id] + prev_ids).compact.join('_'), 'set_service_ids' => ([id] + prev_ids).compact } 
    end
#    tarif_optimizator.tarif_results.each {|key, value| arr << {'service_sets_id' => key, 'set_service_ids' => key.split('_')} }
    ArrayOfHashable.new(self, arr)
  end
  
  def tarif_results
    tarifs = tarif_optimizator.tarif_results[session[:current_id]['service_sets_id']]
    arr = []
    tarifs.each {|key, value| arr << value if value.kind_of?(Hash) }
    ArrayOfHashable.new(self, arr )
  end
  
  def tarif_results_details
    @details = tarif_optimizator.tarif_results[session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id'].to_s]['price_values']
    @details = eval(@details.gsub(/:/,'=>').gsub(/null/,'nil') )
    ArrayOfHashable.new(self, @details || [])
  end
  
  def recalculate
    redirect_to :action => :index
  end
  
  def init_tarif_optimizator
    @operator_index = 0
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({})
    @tarif_optimizator.calculate_one_operator_tarifs(operator_index)
  end

end
