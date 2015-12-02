# == Schema Information
#
# Table name: comparison_groups
#
#  id              :integer          not null, primary key
#  name            :string
#  optimization_id :integer
#  result          :jsonb
#

class Comparison::Group < ActiveRecord::Base
  belongs_to :optimization, :class_name =>'Comparison::Optimization', :foreign_key => :optimization_id
  has_one :result_run, :class_name =>'Result::Run', :foreign_key => :comparison_group_id
  has_many :group_call_runs, :class_name =>'Comparison::GroupCallRun', :foreign_key => :comparison_group_id
  has_many :call_runs, through: :group_call_runs
  
  def generate_calls(only_new = true, test = false)    
    call_runs.generate_group_calls(only_new, test) 
  end
  
  def update_comparison_results
    update({:result => compare})
  end
  
  def compare
    return {:result => false} if !result_run
    operator_ids = call_runs.map(&:operator_id)
    best_results = Result::ServiceSet.best_results_by_operator(result_run.id, operator_ids)
#    raise(StandardError, best_results[1023]) if self.id == 10
    ordered_operators_by_price = best_results.keys.sort_by{|k| (best_results[k]['price'] || 100000.0)}
    service_set_ids = {}
    i = 0
    ordered_operators_by_price.map{|o_r| service_set_ids[i] = best_results[o_r]['service_set_id']; i += 1}
    
    temp_result = {
      :result_run_id => result_run.id,
      :service_set_ids => service_set_ids,
      :place => {
        0 => (ordered_operators_by_price[0] ? best_results[ordered_operators_by_price[0]] : {}),
        1 => (ordered_operators_by_price[1] ? best_results[ordered_operators_by_price[1]] : {}),
        2 => (ordered_operators_by_price[2] ? best_results[ordered_operators_by_price[2]] : {}),
        3 => (ordered_operators_by_price[3] ? best_results[ordered_operators_by_price[3]] : {}),
      } 
    }    
    temp_result
  end
  
end

