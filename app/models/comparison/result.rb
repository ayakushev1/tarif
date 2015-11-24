# == Schema Information
#
# Table name: comparison_results
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  publication_status_id  :integer
#  publication_order      :integer
#  optimization_list_key  :string
#  optimization_list_item :jsonb
#  optimization_result    :jsonb
#

class Comparison::Result < ActiveRecord::Base
  
  def self.compare_best_tarifs_by_operator(optimization_list_key)
    result = []
    Comparison::Optimization.optimization_list[optimization_list_key][:result_runs].each do |call_type_key, result_runs_by_operator|
      best_results = best_results_by_operator(result_runs_by_operator)
      ordered_operators_by_price = best_results.keys.sort_by{|k| best_results[k][:price]}
      temp_result = {
        :call_type => Comparison::Call.init_list[call_type_key][:name],
        :first_place => (ordered_operators_by_price[0] ? best_results[ordered_operators_by_price[0]] : {}),
        :second_place => (ordered_operators_by_price[1] ? best_results[ordered_operators_by_price[1]] : {}),
        :third_place => (ordered_operators_by_price[2] ? best_results[ordered_operators_by_price[2]] : {}),
        :fourth_place => (ordered_operators_by_price[3] ? best_results[ordered_operators_by_price[3]] : {}),
      }
      result << temp_result
    end 
    result
  end
  
  def self.best_results_by_operator(result_runs_by_operator)
    result = {}
    result_runs_by_operator.each do |operator_id, result_run_id|
      result_by_operator = ::Result::ServiceSet.where(:run_id => result_run_id).order(:price).limit(1).first
      result[operator_id] = result_by_operator ? result_by_operator.attributes : {} 
    end    
    result
  end

=begin
  def self.optimization_list
    {
      :base_rank => {
        :name => "base_rank",
        :description => "description of base_rank",
        :optimization_type => :all_operators_tarifs_only_own_and_home_regions, 
        :result_runs => {
          :student => {1023 => 0, 1025 => 1, 1028 => 2, 1030 => 3}
        },
      },
    }
  end

  def self.optimization_type_list
    {
      :all_operators_tarifs_only_own_and_home_regions => {
        :for_service_categories => {
            :country_roming => false,
            :intern_roming => false,
            :mms => false,
            :internet => false,          
        },
        :for_services_by_operator => [],
      },
    }
  end
=end
end

