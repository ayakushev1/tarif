# == Schema Information
#
# Table name: comparison_optimizations
#
#  id                    :integer          not null, primary key
#  name                  :string
#  description           :text
#  publication_status_id :integer
#  publication_order     :integer
#  optimization_type_id  :integer
#

class Comparison::Optimization < ActiveRecord::Base
  belongs_to :publication_status, :class_name =>'Content::Category', :foreign_key => :publication_status_id
  belongs_to :type, :class_name =>'Comparison::OptimizationType', :foreign_key => :optimization_type_id
  has_many :groups, :class_name =>'Comparison::Group', :foreign_key => :optimization_id
  
  scope :draft, -> {where(:publication_status_id => 100)}
  scope :reviewed, -> {where(:publication_status_id => 101)}
  scope :published, -> {where(:publication_status_id => 102)}
  scope :hidden, -> {where(:publication_status_id => 103)}

  def self.update_comparison_results
    all.collect{|optimization| optimization.update_comparison_results}
  end
  
  def update_comparison_results
    groups.collect{|group| group.update_comparison_results}
  end
  
  def self.generate_calls(only_new = true, test = false)    
    all.collect{|optimization| optimization.generate_calls(only_new, test)}   
  end
  
  def generate_calls(only_new = true, test = false)    
    groups.collect{|group| group.generate_calls(only_new, test) }   
  end
  
  def self.calculate_optimizations(only_new = true, test = false)    
    result = {}
    all.collect{|optimization| result[optimization.name] = optimization.calculate_optimizations(only_new, test)}
    result      
  end
  
  def calculate_optimizations(only_new = true, test = false)
    optimization_type = type.attributes.symbolize_keys #.deep_symbolize_keys
    result = []
    groups.each do |group|
      next if only_new and group.result and group.result[0] and !group.result[0].blank?
      if_clean_output_results = true
      group.call_runs.each do |call_run|        
        local_options = {
          :call_run_id => call_run.id,
          :accounting_period => accounting_period_by_call_run_id(call_run.id),
          :result_run_id => group.result_run.id,
          :operators => [call_run.operator_id],
          :for_service_categories => optimization_type[:for_service_categories],
          :for_services_by_operator => optimization_type[:for_services_by_operator],
          :comparison_group_id => group.id
        }
        optimization_type_options = optimization_type.deep_merge(local_options)
        options = Comparison::Optimization::Init.base_params(optimization_type_options).merge({:if_clean_output_results => if_clean_output_results})
        if_clean_output_results = false
#        raise(StandardError, [group.id, optimization_type[:comparison_group_id], options[:comparison_group_id]])
        
#        raise(StandardError, [group.inspect, group.result_run.comparison_group_id, options[:comparison_group_id]]) #if !group.result_run.comparison_group_id
        result << calculate_one_optimization(options, false)
        group.result_run.update_columns(result_run_update_options(options.merge(local_options))) 
      end
    end
    result
  end

  def calculate_one_optimization(options, test = false)    
    result = options[:calculation_choices].slice("result_run_id", "call_run_id")
    result.merge!(options[:services_by_operator].slice(:operators))
    return result if test
#    raise(StandardError, [options[:selected_service_categories]].join("\n"))
#    true ? 
#      TarifOptimization::TarifOptimizatorRunner.recalculate_with_delayed_job(options) :
#      TarifOptimization::TarifOptimizatorRunner.recalculate_direct(options)
          
    result
  end
  
  def result_run_update_options(options)
    {
      :name => name,
      :description => description,
      :user_id => nil,
      :run => 1,
      
      :call_run_id => nil, #options[:call_run_id],
      :accounting_period => options[:accounting_period],
      :optimization_type_id => 6,
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator =>  {}, #options[:services_by_operator],
      :temp_value => options[:temp_value],
      :service_choices => {},
      :services_select => {},
      :services_for_calculation_select => {},
      :service_categories_select => {},
      :comparison_group_id => options[:comparison_group_id]
    }
  end

  def accounting_period_by_call_run_id(call_run_id)
    '1_2015'
  end

end

