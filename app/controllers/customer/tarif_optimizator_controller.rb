class Customer::TarifOptimizatorController < ApplicationController
  include Crudable
  crudable_actions :index
  before_action :init_tarif_optimizator, except: [:recalculate, :calculation_status]
  before_action :init_background_process_informer, only: [:tarif_optimization_progress_bar, :calculation_status, :recalculate]
  attr_reader :stat, :operator, :background_process_informer

  def service_sets
    arr = []
    max_tarifs_slice = stat['max_tarifs_slice'][operator.to_s] if stat and stat['max_tarifs_slice']
    raise(StandardError, [ServiceHelper::OptimizationResultSaver.new().results ]) if false

    service_set_price = {}
    stat['tarifs_slices'][operator.to_s][max_tarifs_slice - 1]['set_ids'].each do |service_sets_id|
      service_set_price[service_sets_id] ||= 0
      stat['tarif_results'][service_sets_id].each do |part_key, part_result|
        part_result.each do |tarif_id, tarif_results |
          service_set_price[service_sets_id] += (tarif_results['price_value'] || 0.0).to_f
        end
      end if stat['tarif_results'][service_sets_id]
    end if stat and stat['tarifs_slices']
    
    service_set_price.each do |service_sets_id, result|
      arr << {'service_sets_id' => service_sets_id, 'service_set_price' => result } 
    end

    raise(StandardError, [tarif_results ]) if false

    ArrayOfHashable.new(self, arr)
  end
  
  def tarif_results
    arr = []

#   raise(StandardError, [stat['tarif_results'], session[:current_id]['service_sets_id'] ] )# if stat
    
    stat['tarif_results'][session[:current_id]['service_sets_id']].each do |part_key, part|
      part.each {|key, value| arr << value if value.kind_of?(Hash) }          
    end if stat and stat['tarif_results'] and stat['tarif_results'][session[:current_id]['service_sets_id']]
#    raise(StandardError, arr)
    ArrayOfHashable.new(self, arr )
  end
  
  def tarif_results_details
    details = []; sctc_ids = []
    stat['tarif_results_ord'][session[:current_id]['service_sets_id']].each do |part_key, part|
      part[session[:current_id]['tarif_results_id']].each do |key, details_by_order|
        details_by_order['price_values'].each {|price_value| sctc_ids << price_value['all_stat']['service_category_tarif_class_ids'] }
        details += details_by_order['price_values']
      end if part[session[:current_id]['tarif_results_id']]
    end if stat and stat['tarif_results_ord'] and session[:current_id]['tarif_results_id']      
      
    details_group_by_month = {}
    details.sort_by{|d| [d['service_category_name'], d['month'] ] }.each do |detail|
      details_group_by_month[detail['service_category_name']] ||= detail.merge('period count price' => [], 'call_id_count' => 0, 'price_value' => 0).keep_if{|k, v| !(k == 'month' )}
      details_group_by_month[detail['service_category_name']]['period count price'] << [detail['month'], detail['call_id_count'],  detail['price_value'] ]
      details_group_by_month[detail['service_category_name']]['call_id_count'] += detail['call_id_count']
      details_group_by_month[detail['service_category_name']]['price_value'] += (detail['price_value'] || 0.0).to_f
    end  
    
    details = []
    details_group_by_month.each {|key, detail_group_by_month| details << detail_group_by_month}

    ArrayOfHashable.new(self, ( [{'sctc_ids' => sctc_ids.flatten.compact, 'sctc_ids_count' => sctc_ids.flatten.compact.size}] + 
      details.sort_by{|d| [d['service_category_name'], d['month'] ] } ) || []  )
  end
  
  def tarif_optimization_progress_bar
    ProgressBarable.new(self, 'tarif_optimization', background_process_informer.current_values)
  end
  
  def calculation_status
    if !background_process_informer.calculating?
      redirect_to(:action => :index)
    end     
  end
  
  def recalculate    
#    background_process_informer.clear_completed_process_info_model
    background_process_informer.init
#    Spawnling.new(:argv => 'tarif_optimization') do
      @operator = 1030 #mts
      @tarif_optimizator = ServiceHelper::TarifOptimizator.new({:background_process_informer => background_process_informer})
      @tarif_optimizator.calculate_one_operator_tarifs(@operator)
#    end     
    redirect_to(:action => :calculation_status)
  end
  
  def init_background_process_informer
    @background_process_informer = ServiceHelper::BackgroundProcessInformer.new('tarif_optimization')
  end
  
  def init_tarif_optimizator
    @operator = 1030    
    results = ServiceHelper::OptimizationResultSaver.new().results
    @stat = results[operator.to_s] if results
  end
  
end
