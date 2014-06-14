class Customer::TarifOptimizatorController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action :init_tarif_optimizator, except: :recalculate
  attr_reader :stats, :stat, :operator_index

  def service_sets
    arr = []
    max_tarif_slice = stat['max_tarif_slice'][operator_index] if stat and stat['max_tarif_slice']

    stat['tarif_slices'][operator_index][max_tarif_slice - 1]['ids'].each_index do |i|
      id = stat['tarif_slices'][operator_index][max_tarif_slice - 1]['ids'][i] 
      prev_ids = stat['tarif_slices'][operator_index][max_tarif_slice - 1]['prev_ids'][i]
      service_sets_id = ([id] + prev_ids).compact.join('_')
      service_set_price = 0
      stat['tarif_results'][service_sets_id].each do |tarif_id, tarif_results |
        service_set_price += tarif_results['price_value']
      end 
      arr << {'service_sets_id' => service_sets_id, 'service_set_price' => service_set_price } 
    end if stat and stat['tarif_slices']

    ArrayOfHashable.new(self, arr)
  end
  
  def tarif_results
    arr = []

    stat['tarif_results'][session[:current_id]['service_sets_id']].each do |key, value| 
      arr << value if value.kind_of?(Hash) 
    end if stat and stat['tarif_results'] and stat['tarif_results'][session[:current_id]['service_sets_id']]
    ArrayOfHashable.new(self, arr )
  end
  
  def tarif_results_details
    details = []; sctc_ids = []
    stat['tarif_results_ord'][session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id']].each do |key, details_by_order|
      details_by_order['price_values'].each {|price_value| sctc_ids << price_value['all_stat']['service_category_tarif_class_ids'] }
      details += details_by_order['price_values']
      
    end if stat and stat['tarif_results_ord'] and session[:current_id]['tarif_results_id'] and
      stat['tarif_results_ord'][session[:current_id]['service_sets_id']][session[:current_id]['tarif_results_id']]

    ArrayOfHashable.new(self, ( [{'sctc_ids' => sctc_ids.flatten.compact, 'sctc_ids_count' => sctc_ids.flatten.compact.size}] + details.sort_by{|d| d['service_category_name']}) || [])
  end
  
  def recalculate
    @operator_index = 2
    @tarif_optimizator = ServiceHelper::TarifOptimizator.new({})
    @tarif_optimizator.calculate_one_operator_tarifs(@operator_index)
    redirect_to :action => :index
  end
  
  def init_tarif_optimizator
    @operator_index = 2
    @stats = []
    Customer::Stat.all.each do |r| 
      @stats << r.attributes['result']
      if r.attributes['result'] and r.attributes['result']['operator_index'] == operator_index
        @stat = r.attributes['result']
      end
       
    end
  end

end
