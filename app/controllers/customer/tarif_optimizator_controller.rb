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
    ArrayOfHashable.new(self, arr)
  end
  
  def tarif_results
    tarifs = tarif_optimizator.tarif_results[session[:current_id]['service_sets_id']]
    arr = []
#    raise(StandardError, [session[:current_id]['service_sets_id'], tarif_optimizator.tarif_results.keys])
    tarifs.each {|key, value| arr << value if value.kind_of?(Hash) }
    ArrayOfHashable.new(self, arr )
  end
  
  def tarif_results_details
    null = nil
#    raise(StandardError, [tarif_optimizator.tarif_results_ord[session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id'].to_i]  ])
    details = []
    sctc_ids = []
    tarif_optimizator.tarif_results_ord[session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id'].to_i].each do |key, details_by_order|
      details_by_order['price_values'].each {|price_value| sctc_ids << eval(price_value['all_stat'].gsub(/:/, '=>') )['service_category_tarif_class_ids'] }
      details += details_by_order['price_values']
    end if tarif_optimizator.tarif_results_ord[session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id'].to_i]
#    raise(StandardError, sctc_ids)
    ArrayOfHashable.new(self, ( [{'sctc_ids' => sctc_ids.flatten.compact, 'sctc_ids_count' => sctc_ids.flatten.compact.size}] + details.sort_by{|d| d['service_category_name']}) || [])
  end
  
  def recalculate
    redirect_to :action => :index
  end
  
  def init_tarif_optimizator
    @operator_index = 2
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({})
    @tarif_optimizator.calculate_one_operator_tarifs(operator_index)
  end

end
